-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg.
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg).
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- start transaction
BEGIN;
-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
-- Commit the transaction.
COMMIT;
-- Verify that change was made and persists after commit.
SELECT * FROM animals;

-- start transaction
BEGIN;
-- delete all records in the animals table, then roll back the transaction
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
-- after rollback verify if all records in the animals table still exists. 
SELECT * FROM animals;

-- start transaction
BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
-- create savepoint
SAVEPOINT SP1;
-- update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = (weight_kg * -1);
-- Rollback to the savepoint
ROLLBACK TO SP1;
-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0;
-- commit transaction
COMMIT;
SELECT * FROM animals;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts > 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) AS escapes FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS minimum_weight, MAX(weight_kg) AS maximum_weight 
FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) 
FROM animals 
WHERE EXTRACT(YEAR FROM date_of_birth) 
BETWEEN 1990 AND 2000 
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT name FROM animals A 
  JOIN owners O ON A.owner_id = O.id 
  WHERE full_name = 'Melody Pond';
  
-- List of all animals that are pokemon (their type is Pokemon).
SELECT A.name FROM animals A 
  JOIN species S ON A.species_id = S.id 
  WHERE S.name = 'Pokemon';
  
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name AS owner, A.name AS animal FROM owners O
  LEFT JOIN animals A ON O.id = A.owner_id;
  
-- How many animals are there per species?
SELECT S.name, COUNT(A.name) FROM species S 
  JOIN animals A ON S.id = A.species_id
  GROUP BY S.name;
  
-- List all Digimon owned by Jennifer Orwell.
SELECT A.name FROM animals A 
  JOIN owners O ON A.owner_id = O.id 
  JOIN species S ON A.species_id = S.id 
  WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';
  
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT name FROM animals
  JOIN owners ON animals.owner_id = owners.id 
  WHERE full_name = 'Dean Winchester' AND escape_attempts = 0;
  
-- Who owns the most animals?
SELECT full_name, COUNT(name) AS counts FROM owners
  LEFT JOIN animals ON animals.owner_id = owners.id
  GROUP BY full_name
  ORDER BY counts desc LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal FROM visits v
  JOIN animals a ON  v.animals = a.id
  JOIN vets t ON v.vets = t.id
  WHERE t.name = 'William Tatcher'
  ORDER BY date_of_visit DESC
  LIMIT 1;
  
-- How many different animals did Stephanie Mendez see?
SELECT a.name, COUNT(*) FROM visits v
  JOIN animals a ON  v.animals = a.id
  JOIN vets t ON v.vets = t.id
  WHERE t.name = 'Stephanie Mendez'
  GROUP BY a.name;
  
-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, s.name FROM vets v
  LEFT JOIN specializations z ON z.vets = v.id
  LEFT JOIN species s ON z.species = s.id;
  
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animals FROM visits v
  JOIN animals a ON  v.animals = a.id
  JOIN vets t ON v.vets = t.id
  WHERE t.name = 'Stephanie Mendez' AND (v.date_of_visit BETWEEN 'April 1, 2020' AND 'August 30, 2020');
  
-- What animal has the most visits to vets?
SELECT a.name, COUNT(*) AS visits FROM visits v
  JOIN animals a ON  v.animals = a.id
  GROUP BY a.name
  ORDER BY visits DESC
  LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name, date_of_visit FROM visits v
  JOIN animals a ON  v.animals = a.id
  JOIN vets t ON v.vets = t.id
  WHERE t.name = 'Maisy Smith'
  ORDER BY date_of_visit
  LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal, vt.name AS vet, v.date_of_visit
FROM animals a
JOIN visits v ON a.id = v.animals
JOIN vets vt ON vt.id = v.vets
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits v
JOIN vets vt ON v.vets = vt.id
JOIN animals a ON v.animals = a.id
LEFT JOIN specializations sp ON vt.id = sp.vets AND a.species_id = sp.species
WHERE sp.id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name, COUNT(*) AS specialty FROM visits v
  JOIN animals a ON  v.animals = a.id
  JOIN vets t ON v.vets = t.id
  JOIN species s ON a.species_id = s.id
  WHERE t.name = 'Maisy Smith'
  GROUP BY s.name
  ORDER BY specialty DESC
  LIMIT 1;