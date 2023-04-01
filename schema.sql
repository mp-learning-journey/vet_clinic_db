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
);

-- create table species
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR NOT NULL,
);
