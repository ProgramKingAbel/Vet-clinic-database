/* Populate database with sample data. */

INSERT INTO animals (
    name, 
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg ) VALUES (
        'Agumon',
        '2020-02-03',
        0,
        TRUE,
        10.23
    );

INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
) VALUES (
    'Gabumon',
    '2018-11-15',
    2,
    TRUE,
    8
);

INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
) VALUES (
    'Pikachu',
    '2021-01-07',
    1,
    FALSE,
    15.04
);

INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
) VALUES (
    'Devimon',
    '2017-05-12',
    5,
    TRUE,
    11
);

INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
) VALUES 
('Charmander', '2020-02-08', 0, FALSE, -11),
('Plantmon', '2021-11-15', 2, TRUE, -5.7),
('Squirtle', '1993-04-02', 3, FALSE, -12.13),
('Angemon', '2005-06-12', 1, TRUE, -45),
('Boarmon', '2005-06-07', 7, TRUE, 20.4),
('Blossom', '1998-10-13', 3, TRUE, 17),
('Ditto', '2022-05-14', 4, TRUE, 22);

--ADD data to species table 

INSERT INTO species (
    name
) VALUES 
( 'Pokemon'),
('Digimon');

--POPULATE OWNERS TABLE 
INSERT INTO owners (
    full_name,
    age
) VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodey Whittaker', 38);

-- Update species_id in table animals
UPDATE animals 
SET species_id = CASE 
WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
ELSE 
(SELECT id FROM species WHERE name = 'Pokemon')
END;

--update ownership 

UPDATE animals
SET owners_id = 
    CASE
        WHEN name IN ('Agumon') THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
        WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
        WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
        WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
        WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
        ELSE NULL
    END;

-- Populate vets table 
INSERT INTO vets (
    name,
    age,
    date_of_graduation
) VALUES 
('William Tatcher', 45, '2000-04-23'),
('Maisy Smith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harkness', 38, '2008-06-08');

-- Insert specializations for multiple vets and species
INSERT INTO specializations (vet_id, species_id)
SELECT v.id, s.id
FROM vets v
JOIN species s ON (v.name = 'William Tatcher' AND s.name = 'Pokemon')
              OR (v.name = 'Stephanie Mendez' AND s.name IN ('Digimon', 'Pokemon'))
              OR (v.name = 'Jack Harkness' AND s.name = 'Digimon');
