-- 13
-- Quais pets fazem aniversário hoje e a idade que estão fazendo
SELECT pet.nome, pet.nascimento, idade 
FROM vw_pet_idade JOIN pet ON pet.id_pet = vw_pet_idade.id_pet
WHERE strftime('%m-%d', pet.nascimento) = strftime('%m-%d', '2023-02-20');