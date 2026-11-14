-- 11
-- Mostra o faturamento das reservas + serviços por mês e tipo de quarto
WITH valor_reserva AS (SELECT reserva.id_reserva, reserva.id_quarto, reserva.data_inicio,
(julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) * reserva.valor_diaria_contratada
 + COALESCE((SELECT SUM(preco_unitario) FROM servico_reserva WHERE servico_reserva.id_reserva = reserva.id_reserva
AND servico_reserva.status != 'Cancelado'), 0) -- se for nulo, substitui por 0 e faz a soma normalmente                       
AS total
FROM reserva WHERE reserva.status != 'Cancelada')

SELECT strftime('%Y-%m', valor_reserva.data_inicio) AS mes, quarto.tipo,
COUNT(valor_reserva.id_reserva) AS quantidade_reservas, SUM(valor_reserva.total) AS faturamento
FROM valor_reserva
JOIN quarto ON quarto.id_quarto = valor_reserva.id_quarto
GROUP BY strftime('%Y-%m', valor_reserva.data_inicio), quarto.tipo
HAVING faturamento > 500
ORDER BY faturamento DESC;