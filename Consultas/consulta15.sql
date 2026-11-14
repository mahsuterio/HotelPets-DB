-- 15
-- Simulação de contratação de serviço
BEGIN TRANSACTION;
SAVEPOINT servico_teste;

SELECT id_reserva, total_hospedagem, total_servicos, valor_final_estadia 
FROM vw_resumo_financeiro_reserva WHERE id_reserva = 2;

INSERT INTO servico_reserva (id_servico, id_reserva, quantidade, preco_unitario, status)
VALUES (1, 2, 2, 50, 'Contratado'); -- 2 banhos pra reserva 2

-- Consultar o saldo após contratacao
SELECT id_reserva, total_hospedagem, total_servicos, valor_final_estadia 
FROM vw_resumo_financeiro_reserva WHERE id_reserva = 2;

ROLLBACK TO SAVEPOINT servico_teste;

-- Consultar novamente
SELECT id_reserva, total_hospedagem, total_servicos, valor_final_estadia 
FROM vw_resumo_financeiro_reserva WHERE id_reserva = 2;

RELEASE SAVEPOINT servico_teste;
COMMIT;