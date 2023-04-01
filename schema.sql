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
