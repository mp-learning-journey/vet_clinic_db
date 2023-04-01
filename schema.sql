/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts INT DEFAULT 0,
    neutered BOOLEAN,
    weight_kg DECIMAL DEFAULT 0
);

ALTER TABLE animals
  ADD species VARCHAR;

-- create table owners
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR NOT NULL,
    age INT DEFAULT 0,
    PRIMARY KEY(id)
);

-- create table species
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR NOT NULL,
    PRIMARY KEY(id)
);

--  Remove column species, Add column species_id which is a foreign key referencing species table Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals
  DROP species,
  ADD species_id INT REFERENCES species(id),
  ADD owner_id INT REFERENCES owners(id);

-- create vets table
CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name varchar NOT NULL,
    date_of_graduation date NOT NULL,
    age INT DEFAULT 0,
    PRIMARY KEY(id)
);

-- create specializations table with many-to-many relationship between species and vets
CREATE TABLE specializations(
  id INT GENERATED ALWAYS AS IDENTITY,
  species INT REFERENCES species (id),
  vets INT REFERENCES vets (id)
);

-- Add primary key to animals table
ALTER TABLE animals
  ADD PRIMARY KEY (id);

-- create visits table with many-to-many relationship between animals and vets
CREATE TABLE visits(
  id INT GENERATED ALWAYS AS IDENTITY,
  animals INT REFERENCES animals(id),
  vets INT REFERENCES vets (id),
  date_of_visit date
);