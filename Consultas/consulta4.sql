-- 04
-- Identificar a hospedagem mais cara e a mais barata
SELECT max((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio))*reserva.valor_diaria_contratada) as hosp_cara,
min((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio))*reserva.valor_diaria_contratada) as hosp_barata 
FROM reserva;