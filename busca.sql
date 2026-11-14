-- 01
-- Exibe o nome do pet, espécie, raça e nome do tutor por ordem alfabetica do nome do pet
SELECT pet.nome as nome_pet, especie.nome_especie, raca.nome_raca, tutor.nome as nome_tutor from pet 
JOIN especie on pet.id_especie = especie.id_especie
JOIN raca on pet.id_raca = raca.id_raca
JOIN tutor_pet on tutor_pet.id_pet = pet.id_pet
JOIN tutor on tutor_pet.id_tutor = tutor.id_tutor ORDER BY pet.nome ASC;

-- 02
-- Contar quantas reservas cada pet possui
SELECT pet.nome as nome_pet, COUNT(reserva.id_reserva) as qtd_reservas FROM pet left JOIN reserva on pet.id_pet = reserva.id_pet GROUP BY pet.id_pet
ORDER by COUNT(reserva.id_reserva) DESC;

-- 03
-- Calcular a média de diárias por reserva
SELECT reserva.id_reserva, AVG(julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) AS media_diarias 
FROM reserva GROUP BY reserva.id_reserva ORDER by media_diarias DESC;

-- 04
-- Identificar a hospedagem mais cara e a mais barata
SELECT max((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio))*reserva.valor_diaria_contratada) as hosp_cara,
min((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio))*reserva.valor_diaria_contratada) as hosp_barata 
FROM reserva;

-- 05
-- Mostrar pets sem ou com restrições alimentares cadastradas
-- UPDATE caderneta SET restricoes_alimentares = 'Não pode comer cenoura.' WHERE id_caderneta > 13;
-- UPDATE caderneta SET restricoes_alimentares = 'Não pode comer banana.' WHERE id_caderneta = 10;
-- UPDATE caderneta SET restricoes_alimentares = 'Petiscos em pouca quantidade.' WHERE id_caderneta = 2;

select pet.nome, COALESCE(caderneta.restricoes_alimentares, 'Não informado.') AS restricoes_alimentares FROM caderneta 
left join pet on pet.id_pet = caderneta.id_pet ORDER by pet.nome ASC; 

-- 06
-- Encontrar reservas com valor acima da média geral
SELECT id_reserva, (julianday(data_fim_prevista) - julianday(data_inicio))*valor_diaria_contratada AS valor_total
FROM reserva WHERE ((julianday(data_fim_prevista) - julianday(data_inicio)) * valor_diaria_contratada) 
> (SELECT AVG((julianday(data_fim_prevista) - julianday(data_inicio)) * valor_diaria_contratada) FROM reserva) 
ORDER by valor_total DESC;

-- 07
-- Identificar categorias de quarto com faturamento médio superior a R$ 400
SELECT quarto.tipo, AVG((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) 
* reserva.valor_diaria_contratada)as media from quarto JOIN reserva on reserva.id_quarto = quarto.id_quarto
GROUP by quarto.tipo HAVING AVG((julianday(reserva.data_fim_prevista) - julianday(reserva.data_inicio)) 
* reserva.valor_diaria_contratada) > 400;

-- 08 
-- Calcular o valor final e o saldo pendente de cada reserva
SELECT pet.nome as nome_pet, tutor.nome as nome_tutor, id_reserva, total_hospedagem, total_servicos, 
valor_final_estadia, total_pago, saldo_pendente FROM vw_resumo_financeiro_reserva
join pet on vw_resumo_financeiro_reserva.id_pet = pet.id_pet
JOIN tutor_pet on tutor_pet.id_pet = vw_resumo_financeiro_reserva.id_pet
JOIN tutor on tutor_pet.id_tutor = tutor.id_tutor
WHERE tutor_pet.responsavel_principal = 1 
ORDER BY vw_resumo_financeiro_reserva.valor_final_estadia desc;

-- 09
-- Pets que já tomaram alguma medicação
SELECT pet.nome, especie.nome_especie, raca.nome_raca FROM pet
JOIN especie ON pet.id_especie = especie.id_especie
JOIN raca ON pet.id_raca = raca.id_raca
WHERE EXISTS (SELECT 1 FROM medicacao_pet WHERE medicacao_pet.id_pet = pet.id_pet)
ORDER BY pet.nome ASC;

-- 10
-- Lista os funcionários, incluindo aqueles que ainda não realizaram nenhuma atividade
SELECT funcionario.nome, funcionario.cargo, COUNT(execucao_servico.id_execucao) AS total_atividades,
COALESCE(max(execucao_servico.data_servico), 'Sem atividades.') as data_ultima_atividade 
FROM funcionario LEFT JOIN execucao_servico ON funcionario.id_funcionario = execucao_servico.id_funcionario
GROUP BY funcionario.id_funcionario;

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

-- 13
-- Quais pets fazem aniversário hoje e a idade que estão fazendo
SELECT pet.nome, pet.nascimento, idade 
FROM vw_pet_idade JOIN pet ON pet.id_pet = vw_pet_idade.id_pet
WHERE strftime('%m-%d', pet.nascimento) = strftime('%m-%d', '2023-02-20');

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