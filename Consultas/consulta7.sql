-- 07
-- Identificar categorias de quarto com faturamento médio superior a R$ 400
SELECT quarto.tipo, AVG((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) 
* reserva.valor_diaria_contratada)as media from quarto JOIN reserva on reserva.id_quarto = quarto.id_quarto
GROUP by quarto.tipo HAVING AVG((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) 
* reserva.valor_diaria_contratada) > 400;