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