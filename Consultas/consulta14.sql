-- 14
-- Simulação de pagamento
BEGIN TRANSACTION;
SAVEPOINT pagamento_teste;

SELECT id_reserva, valor_final_estadia, total_pago, saldo_pendente FROM vw_resumo_financeiro_reserva WHERE id_reserva = 1;

INSERT INTO pagamento (id_reserva, id_tutor, valor_pago, forma_pagamento, status, pago_em)
VALUES (1, '98765000153', 100.00, 'Pix', 'Confirmado', datetime('now'));

-- Consultar o saldo após pagamento
SELECT id_reserva, valor_final_estadia, total_pago, saldo_pendente FROM vw_resumo_financeiro_reserva
WHERE id_reserva = 1;

ROLLBACK TO SAVEPOINT pagamento_teste;

-- Consultar novamente 
SELECT id_reserva, valor_final_estadia, total_pago, saldo_pendente FROM vw_resumo_financeiro_reserva
WHERE id_reserva = 1;

RELEASE SAVEPOINT pagamento_teste;
COMMIT;