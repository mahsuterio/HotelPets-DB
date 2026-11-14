-- 12
-- Mostra quais pets são dessas raças específicas
SELECT pet.id_pet, pet.nome as nome_pet, tutor.id_tutor, tutor.nome as nome_tutor, especie.nome_especie, 
raca.nome_raca FROM pet 
join tutor_pet on tutor_pet.id_pet = pet.id_pet
JOIN tutor on tutor.id_tutor = tutor_pet.id_tutor
JOIN especie on especie.id_especie = pet.id_especie
JOIN raca on raca.id_raca = pet.id_raca
WHERE tutor_pet.responsavel_principal = 1
and raca.nome_raca in ('Mini Lop','Poodle','Golden Retriever')
ORDER by pet.nome asc;