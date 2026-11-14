-- 01
-- Exibe o nome do pet, espécie, raça e nome do tutor por ordem alfabetica do nome do pet
SELECT pet.nome as nome_pet, especie.nome_especie, raca.nome_raca, tutor.nome as nome_tutor from pet 
JOIN especie on pet.id_especie = especie.id_especie
JOIN raca on pet.id_raca = raca.id_raca
JOIN tutor_pet on tutor_pet.id_pet = pet.id_pet
JOIN tutor on tutor_pet.id_tutor = tutor.id_tutor ORDER BY pet.nome ASC;