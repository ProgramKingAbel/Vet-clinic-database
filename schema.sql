/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR (250) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg NUMERIC (4, 2) NOT NULL
);

--Add PK to animals table 

ALTER TABLE animals ADD PRIMARY KEY(id);

-- Add species column
ALTER TABLE animals ADD species VARCHAR (250);

-- Adjust NUMERIC VALUE TO ACCOMODATE NEGATIVE VALUES
ALTER TABLE animals 
ALTER COLUMN weight_kg TYPE NUMERIC (5, 2);

--TABLE OWNERS 

CREATE TABLE owners (
    id SERIAL,
    full_name VARCHAR (250) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY (id)
);

-- drop NOT NULL constraint
ALTER TABLE owners ALTER COLUMN age DROP NOT NULL;

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- TABLE SPECIES
CREATE TABLE species (
    id SERIAL,
    name VARCHAR (250) NOT NULL,
    PRIMARY KEY (id)
);

-- Modify animals table 

--rm column species
ALTER TABLE animals DROP species;

--add fk 
ALTER TABLE animals 
ADD species_id INT REFERENCES species(id);

ALTER TABLE animals ADD owners_id INT REFERENCES owners(id);

-- TABLE VETS
CREATE TABLE vets (
    id SERIAL,
    name VARCHAR (250) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL,
    PRIMARY KEY(id)
);

-- Create join table specialization
CREATE TABLE specializations (
    id SERIAL,
    vet_id INT REFERENCES vets(id),
    species_id INT REFERENCES species(id),
    PRIMARY KEY(id)
);

CREATE TABLE visits (
    id SERIAL,
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
    visit_date DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX idx_visits_animal_id ON visits (animal_id);
CREATE INDEX idx_visits_vet_id ON visits (vet_id);
CREATE INDEX idx_owners_email ON owners (email);
