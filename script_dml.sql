PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

INSERT INTO especie (id_especie, nome_especie) VALUES
(1, 'Cachorro'),
(2, 'Gato'),
(3, 'Coelho');

INSERT INTO raca (id_raca, id_especie, nome_raca) VALUES
(1, 1, 'SRD'),
(2, 1, 'Golden Retriever'),
(3, 1, 'Labrador'),
(4, 1, 'Salsicha'),
(5, 1, 'Poodle'),
(6, 1, 'Bulldog Francês'),
(7, 2, 'Siamês'),
(8, 2, 'Persa'),
(9, 2, 'Maine Coon'),
(10, 3, 'Mini Lop'),
(11, 3, 'Angorá');

INSERT INTO cep (cep) VALUES
('88010000'),
('88015000'),
('88020000'),
('88025000'),
('88030000'),
('88035000'),
('88040000'),
('88045000'),
('88050000'),
('88055000'),
('88060000'),
('88065000'),
('88070000'),
('88075000'),
('88080000');

INSERT INTO tutor (id_tutor, nome, telefone, email, cep, endereco) VALUES
('98765000153', 'Ana Silva', '48999990001', 'ana@email.com', '88010000', 'Rua Exemplo, 101'),
('98765000234', 'Carlos Oliveira', '48999990002', 'carlos@email.com', '88015000', 'Rua Exemplo, 102'),
('98765000315', 'Mariana Costa', '48999990003', 'mariana@email.com', '88020000', 'Rua Exemplo, 103'),
('98765000404', 'Pedro Almeida', '48999990004', 'pedro@email.com', '88025000', 'Rua Exemplo, 104'),
('98765000587', 'Juliana Martins', '48999990005', 'juliana@email.com', '88030000', 'Rua Exemplo, 105'),
('98765000668', 'Rafael Souza', '48999990006', 'rafael@email.com', '88035000', 'Rua Exemplo, 106'),
('98765000749', 'Fernanda Lima', '48999990007', 'fernanda@email.com', '88040000', 'Rua Exemplo, 107'),
('98765000820', 'Lucas Pereira', '48999990008', 'lucas@email.com', '88045000', 'Rua Exemplo, 108'),
('98765000900', 'Beatriz Rocha', '48999990009', 'beatriz@email.com', '88050000', 'Rua Exemplo, 109'),
('98765001044', 'Gabriel Mendes', '48999990010', 'gabriel@email.com', '88055000', 'Rua Exemplo, 110'),
('98765001125', 'Camila Ribeiro', '48999990011', 'camila@email.com', '88060000', 'Rua Exemplo, 111'),
('98765001206', 'Bruno Fernandes', '48999990012', 'bruno@email.com', '88065000', 'Rua Exemplo, 112'),
('98765001397', 'Larissa Gomes', '48999990013', 'larissa@email.com', '88070000', 'Rua Exemplo, 113'),
('98765001478', 'Thiago Barbosa', '48999990014', 'thiago@email.com', '88075000', 'Rua Exemplo, 114'),
('98765001559', 'Patricia Nunes', '48999990015', 'patricia@email.com', '88080000', 'Rua Exemplo, 115');

INSERT INTO pet (id_pet, id_especie, id_raca, nome, nascimento) VALUES
(1, 1, 2, 'Max', '2022-03-10'),
(2, 1, 3, 'Thor', '2021-06-15'),
(3, 2, 7, 'Luna', '2023-02-20'),
(4, 1, 4, 'Mel', '2020-08-12'),
(5, 2, 8, 'Mia', '2022-11-05'),
(6, 1, 1, 'Bob', '2021-04-18'),
(7, 1, 5, 'Belinha', '2023-07-22'),
(8, 2, 9, 'Simba', '2020-01-30'),
(9, 1, 6, 'Bento', '2022-09-14'),
(10, 3, 11, 'Pipoca', '2024-03-03'),
(11, 1, 2, 'Nina', '2021-12-09'),
(12, 2, 1, 'Oliver', '2023-05-17'),
(13, 1, 3, 'Toby', '2020-10-25'),
(14, 3, 12, 'Floquinho', '2024-01-11'),
(15, 1, 1, 'Amora', '2022-06-28');

INSERT INTO tutor_pet (id_tutor, id_pet, responsavel_principal) VALUES
('98765000153', 1, 1),
('98765000234', 2, 1),
('98765000315', 3, 1),
('98765000404', 4, 1),
('98765000587', 5, 1),
('98765000668', 6, 1),
('98765000749', 7, 1),
('98765000820', 8, 1),
('98765000900', 9, 1),
('98765001044', 10, 1),
('98765001125', 11, 1),
('98765001206', 12, 1),
('98765001397', 13, 1),
('98765001478', 14, 1),
('98765001559', 15, 1);

INSERT INTO quarto (id_quarto, tipo, preco_diaria) VALUES
(1, 'Individual Padrão', 90.0),
(2, 'Individual Padrão', 90.0),
(3, 'Individual Padrão', 90.0),
(4, 'Individual Padrão', 90.0),
(5, 'Individual Conforto', 110.0),
(6, 'Individual Conforto', 110.0),
(7, 'Individual Conforto', 110.0),
(8, 'Individual Premium', 150.0),
(9, 'Individual Premium', 150.0),
(10, 'Individual Luxo', 200.0),
(11, 'Individual Luxo', 200.0);

INSERT INTO funcionario (id_funcionario, nome, telefone, email, cargo) VALUES
('87654000111', 'Paula Martins', '48989990001', 'paula@hotel.test', 'cuidador'),
('87654000200', 'Roberto Mendes', '48989990002', 'roberto@hotel.test', 'veterinario'),
('87654000383', 'Fernanda Duarte', '48989990003', 'fernanda@hotel.test', 'recepcionista'),
('87654000464', 'Luciana Pires', '48989990004', 'luciana@hotel.test', 'veterinario');

INSERT INTO caderneta (id_caderneta, id_pet, observacoes) VALUES
(1, 1, 'Caderneta de Max'),
(2, 2, 'Caderneta de Thor'),
(3, 3, 'Caderneta de Luna'),
(4, 4, 'Caderneta de Mel'),
(5, 5, 'Caderneta de Mia'),
(6, 6, 'Caderneta de Bob'),
(7, 7, 'Caderneta de Belinha'),
(8, 8, 'Caderneta de Simba'),
(9, 9, 'Caderneta de Bento'),
(10, 10, 'Caderneta de Pipoca'),
(11, 11, 'Caderneta de Nina'),
(12, 12, 'Caderneta de Oliver'),
(13, 13, 'Caderneta de Toby'),
(14, 14, 'Caderneta de Floquinho'),
(15, 15, 'Caderneta de Amora');

INSERT INTO tipo_vacina (id_tipo_vacina, id_especie, titulo, obrigatoria_hospedagem) VALUES
(1, 1, 'Polivalente canina (exemplo)', 1),
(2, 2, 'Polivalente felina (exemplo)', 1),
(3, 3, 'Vacina de coelho (exemplo)', 1);

INSERT INTO lote_vacina (id_lote_vacina, id_tipo_vacina, lote, data_fabricacao, estoque_qtd) VALUES
(1, 1, 'C-2026-A', '2026-01-10', 30),
(2, 2, 'G-2026-B', '2026-01-10', 30),
(3, 3, 'R-2026-C', '2026-01-10', 30);

INSERT INTO vacinacao (id_vacinacao, id_caderneta, id_lote_vacina, id_funcionario, data_aplicacao, validade_ate) VALUES
(1, 1, 1, '87654000200', '2026-08-01', '2027-08-01'),
(2, 2, 1, '87654000200', '2026-08-01', '2027-08-01'),
(3, 3, 2, '87654000200', '2026-08-01', '2027-08-01'),
(4, 4, 1, '87654000200', '2026-08-01', '2027-08-01'),
(5, 5, 2, '87654000200', '2026-08-01', '2027-08-01'),
(6, 6, 1, '87654000200', '2026-08-01', '2027-08-01'),
(7, 7, 1, '87654000200', '2026-08-01', '2027-08-01'),
(8, 8, 2, '87654000200', '2026-08-01', '2027-08-01'),
(9, 9, 1, '87654000200', '2026-08-01', '2027-08-01'),
(10, 10, 3, '87654000200', '2026-08-01', '2027-08-01'),
(11, 11, 1, '87654000200', '2026-08-01', '2027-08-01'),
(12, 12, 2, '87654000200', '2026-08-01', '2027-08-01'),
(13, 13, 1, '87654000200', '2026-08-01', '2027-08-01'),
(14, 14, 3, '87654000200', '2026-08-01', '2027-08-01'),
(15, 15, 1, '87654000200', '2026-08-01', '2027-08-01');

-- O quarto e a diaria devem ser coerentes. Reatribui alguns quartos
-- em relacao ao exemplo anterior para manter os precos de 90/110/150/200.
-- Nao ha sobreposicao de ocupacao nem do mesmo pet.
INSERT INTO reserva (id_reserva, id_pet, id_quarto, data_inicio, data_fim_prevista, status, valor_diaria_contratada) VALUES
(1, 1, 1, '2026-11-05', '2026-11-08', 'Confirmada', 90.0),
(2, 2, 5, '2026-11-06', '2026-11-11', 'Confirmada', 110.0),
(3, 3, 8, '2026-11-07', '2026-11-11', 'Confirmada', 150.0),
(4, 4, 10, '2026-11-09', '2026-11-11', 'Confirmada', 200.0),
(5, 5, 2, '2026-11-10', '2026-11-16', 'Confirmada', 90.0),
(6, 6, 1, '2026-11-15', '2026-11-18', 'Confirmada', 90.0),
(7, 7, 6, '2026-11-17', '2026-11-21', 'Confirmada', 110.0),
(8, 8, 9, '2026-11-20', '2026-11-22', 'Confirmada', 150.0),
(9, 9, 11, '2026-12-01', '2026-12-06', 'Confirmada', 200.0),
(10, 10, 3, '2026-12-02', '2026-12-05', 'Confirmada', 90.0),
(11, 11, 1, '2026-12-10', '2026-12-17', 'Confirmada', 90.0),
(12, 12, 7, '2026-12-11', '2026-12-15', 'Confirmada', 110.0),
(13, 13, 8, '2026-12-18', '2026-12-23', 'Confirmada', 150.0),
(14, 14, 10, '2026-12-20', '2026-12-23', 'Confirmada', 200.0),
(15, 15, 4, '2026-12-24', '2026-12-30', 'Confirmada', 90.0),
(16, 1, 1, '2027-01-05', '2027-01-10', 'Confirmada', 90.0),
(17, 3, 8, '2027-01-08', '2027-01-12', 'Confirmada', 150.0),
(18, 2, 5, '2027-01-12', '2027-01-16', 'Confirmada', 110.0),
(19, 7, 11, '2027-01-15', '2027-01-19', 'Confirmada', 200.0),
(20, 5, 2, '2027-01-20', '2027-01-25', 'Confirmada', 90.0);

-- Exemplos de servicos e pagamento (sem criar reservas extras).
INSERT INTO servico (id_servico, titulo, preco, tipo) VALUES
(1, 'Banho', 50.0, 'Higiene'),
(2, 'Passeio', 30.0, 'Recreacao');

INSERT INTO servico_reserva (id_servico, id_reserva, quantidade, preco_unitario) VALUES
(1, 1, 1, 50.0),
(2, 2, 2, 30.0);

INSERT INTO pagamento (id_reserva, id_tutor, valor_pago, forma_pagamento, status, pago_em) VALUES
(1, '98765000153', 100.0, 'Pix', 'Confirmado', '2026-11-01 12:00:00');

-- --------------------------------------------------------------------------------------------------------

INSERT INTO medicamento
(id_medicamento, nome, tipo, descricao, estoque_qtd)
VALUES
(1, 'Medicamento A', 'Comprimido',
 'Medicamento ficticio para testes', 40),

(2, 'Medicamento B', 'Solucao oral',
 'Medicamento ficticio para testes', 25),

(3, 'Medicamento C', 'Uso topico',
 'Medicamento ficticio para testes', 15),

(4, 'Medicamento D', 'Comprimido',
 'Medicamento ficticio para testes', 30);

INSERT INTO medicacao_pet
(id_medicacao_pet, id_pet, id_medicamento,
 dose_prescrita, frequencia, inicio, fim)
VALUES

(1, 1, 1, '1 unidade', 'A cada 12 horas',
 '2026-11-05', '2026-11-08'),

(2, 2, 2, '2 mL', 'Uma vez ao dia',
 '2026-11-06', '2026-11-11'),

(3, 3, 3, '1 aplicacao', 'Uma vez ao dia',
 '2026-11-07', '2026-11-11'),

(4, 5, 4, '1 unidade', 'A cada 24 horas',
 '2026-11-10', '2026-11-16'),

(5, 7, 1, '1 unidade', 'A cada 12 horas',
 '2026-11-17', '2026-11-21');
 
 INSERT INTO execucao_servico
(id_execucao, id_servico_reserva, id_funcionario,
 data_servico, descricao)
VALUES

(1, 1, '87654000111',
 '2026-11-06 10:00:00',
 'Banho realizado no pet Max, sem ocorrencias'),

(2, 2, '87654000111',
 '2026-11-07 09:00:00',
 'Primeiro passeio realizado com Thor'),

(3, 2, '87654000111',
 '2026-11-09 09:30:00',
 'Segundo passeio realizado com Thor');
 
 INSERT INTO ocorrencia
(id_ocorrencia, id_reserva, id_funcionario,
 tipo, descricao, registrada_em)
VALUES

(1, 1, '87654000111',
 'Comportamento',
 'Max apresentou comportamento tranquilo durante a hospedagem',
 '2026-11-06 14:00:00'),

(2, 2, '87654000111',
 'Alimentacao',
 'Thor apresentou pouco interesse pela primeira refeicao',
 '2026-11-07 12:30:00'),

(3, 3, '87654000200',
 'Saude',
 'Luna passou por avaliacao veterinaria de rotina',
 '2026-11-08 15:00:00'),

(4, 5, '87654000111',
 'Comportamento',
 'Mia demonstrou timidez durante a adaptacao ao ambiente',
 '2026-11-11 10:00:00'),

(5, 7, '87654000111',
 'Alimentacao',
 'Belinha se alimentou normalmente durante a hospedagem',
 '2026-11-18 13:00:00');
 
 INSERT INTO atividade
(id_atividade, id_reserva, id_funcionario,
 descricao, realizada_em)
VALUES

(1, 1, '87654000111',
 'Recreacao supervisionada no espaco interno',
 '2026-11-06 15:00:00'),

(2, 2, '87654000111',
 'Momento de socializacao supervisionada',
 '2026-11-08 16:00:00'),

(3, 3, '87654000111',
 'Atividade de enriquecimento ambiental',
 '2026-11-09 11:00:00'),

(4, 5, '87654000111',
 'Brincadeira individual com brinquedos',
 '2026-11-12 14:00:00'),

(5, 7, '87654000111',
 'Atividade recreativa individual',
 '2026-11-19 15:00:00');
 
 INSERT INTO administracao_medicamento
(id_administracao, id_medicacao_pet, id_reserva,
 id_funcionario, administrada_em, dose_aplicada)
VALUES

(1, 1, 1, '87654000111',
 '2026-11-06 08:00:00', '1 unidade'),

(2, 1, 1, '87654000111',
 '2026-11-06 20:00:00', '1 unidade'),

(3, 2, 2, '87654000200',
 '2026-11-07 09:00:00', '2 mL'),

(4, 3, 3, '87654000200',
 '2026-11-08 10:00:00', '1 aplicacao'),

(5, 4, 5, '87654000111',
 '2026-11-12 08:00:00', '1 unidade');
 

COMMIT;