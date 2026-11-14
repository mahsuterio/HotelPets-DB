-- 06
-- Encontrar reservas com valor acima da média geral
SELECT id_reserva, (julianday(data_fim_prevista) - julianday(data_inicio))*valor_diaria_contratada AS valor_total
FROM reserva WHERE ((julianday(data_fim_prevista) - julianday(data_inicio)) * valor_diaria_contratada) 
> (SELECT AVG((julianday(data_fim_prevista) - julianday(data_inicio)) * valor_diaria_contratada) FROM reserva) 
ORDER by valor_total DESC;