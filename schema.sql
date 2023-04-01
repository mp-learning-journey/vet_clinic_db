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