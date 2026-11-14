-- 09
-- Pets que já tomaram alguma medicação
SELECT pet.nome, especie.nome_especie, raca.nome_raca FROM pet
JOIN especie ON pet.id_especie = especie.id_especie
JOIN raca ON pet.id_raca = raca.id_raca
WHERE EXISTS (SELECT 1 FROM medicacao_pet WHERE medicacao_pet.id_pet = pet.id_pet)
ORDER BY pet.nome ASC;