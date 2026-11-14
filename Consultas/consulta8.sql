-- 08 
-- Calcular o valor final e o saldo pendente de cada reserva
SELECT pet.nome as nome_pet, tutor.nome as nome_tutor, id_reserva, total_hospedagem, total_servicos, 
valor_final_estadia, total_pago, saldo_pendente FROM vw_resumo_financeiro_reserva
join pet on vw_resumo_financeiro_reserva.id_pet = pet.id_pet
JOIN tutor_pet on tutor_pet.id_pet = vw_resumo_financeiro_reserva.id_pet
JOIN tutor on tutor_pet.id_tutor = tutor.id_tutor
WHERE tutor_pet.responsavel_principal = 1 
ORDER BY vw_resumo_financeiro_reserva.valor_final_estadia desc;