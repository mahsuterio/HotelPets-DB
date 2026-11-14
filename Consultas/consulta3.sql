-- 03
-- Calcular a média de diárias por reserva
SELECT reserva.id_reserva, AVG(julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) AS media_diarias 
FROM reserva GROUP BY reserva.id_reserva ORDER by media_diarias DESC;