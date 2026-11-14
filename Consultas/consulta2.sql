-- 02
-- Contar quantas reservas cada pet possui
SELECT pet.nome as nome_pet, COUNT(reserva.id_reserva) as qtd_reservas FROM pet left JOIN reserva on pet.id_pet = reserva.id_pet GROUP BY pet.id_pet
ORDER by COUNT(reserva.id_reserva) DESC;
