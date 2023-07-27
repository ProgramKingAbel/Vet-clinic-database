/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth <= '2019-12-31' AND date_of_birth >= '2016-01-01';
SELECT * FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- set species col to unspecified
UPDATE animals SET species = 'unspecified';

-- perform rollback to set species to initial state of null
UPDATE animals SET species = NULL;

-- transaction 2
BEGIN; 
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

--transaction 3
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- transaction 4
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT point1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT point1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) AS total_animals FROM animals;

SELECT COUNT(*) AS loyal_animals 
FROM animals 
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS average_weight FROM animals;

SELECT neutered, SUM(escape_attempts) AS total_esc_attempts
FROM animals
GROUP BY neutered
ORDER BY total_esc_attempts DESC;

SELECT species, MAX(weight_kg) AS max_weight, 
MIN(weight_kg) AS min_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS avg_escapes
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

--Queries with Join 
SELECT a.name  AS animal_name, o.full_name AS OWNER_Name
FROM animals a
JOIN owners o ON a.owners_id = o.id
WHERE o.full_name = 'Melody Pond';

SELECT a.name, s.name AS species, a.species_id
FROM animals a 
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT o.full_name AS owner_name, a.name AS animal_name
FROM owners o
LEFT JOIN animals a ON o.id = a.owners_id
ORDER BY o.full_name;

SELECT s.name AS species_name, COUNT(a.id) AS total_animals_per_species
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.id, s.name
ORDER BY s.name;

SELECT a.name AS animal_name, o.full_name
FROM animals a
JOIN owners o ON a.owners_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

SELECT a.name AS animal_name, o.full_name, a.escape_attempts
FROM animals a
JOIN owners o ON a.owners_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

SELECT o.full_name AS owner_name, COUNT(a.id) AS num_of_animals
FROM owners o
LEFT JOIN animals a ON o.id = a.owners_id
GROUP BY o.id, o.full_name
ORDER BY num_of_animals DESC
LIMIT 1;


--Queries based on many-many relationships 

SELECT a.name AS last_animal_seen, vt.name as vet_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

SELECT COUNT(DISTINCT v.animal_id) AS num_different_animals_seen_by_Stephanie
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

SELECT v.name AS vet_name, COALESCE(s.name, 'No specialty') AS specialty_name
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

SELECT a.name AS animal_name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';


SELECT a.name AS animal_name, COUNT(v.id) AS num_visits
FROM animals a
LEFT JOIN visits v ON a.id = v.animal_id
GROUP BY a.id, a.name
ORDER BY num_visits DESC
LIMIT 1;

SELECT a.name AS animal_name, o.full_name AS owner_name, v.visit_date
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
JOIN owners o ON a.owners_id = o.id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;


SELECT a.name AS animal_name, vt.name AS vet_name, v.visit_date AS visit_date
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
ORDER BY v.visit_date DESC
LIMIT 1;

SELECT COUNT(*) AS num_visits_without_specialization, vt.name
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
WHERE NOT EXISTS (
    SELECT 1
    FROM specializations s
    WHERE s.vet_id = vt.id AND s.species_id = a.species_id
);

SELECT COUNT(*) AS num_visits_without_specialization
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
JOIN animals a ON v.animal_id = a.id
WHERE NOT EXISTS (
    SELECT 1
    FROM specializations s
    WHERE s.vet_id = vt.id AND s.species_id = a.species_id
);

SELECT s.name AS specialty, COUNT(*) AS total_visits_for_specialty
FROM species s
JOIN animals a ON s.id = a.species_id
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY total_visits_for_specialty DESC;
