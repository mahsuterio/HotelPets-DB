PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- ESPECIE, RACA, CEP E TUTOR
CREATE TABLE especie (
    id_especie INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_especie TEXT NOT NULL UNIQUE CHECK (length(trim(nome_especie)) > 0)
);

CREATE TABLE raca (
    id_raca INTEGER PRIMARY KEY AUTOINCREMENT,
    id_especie INTEGER NOT NULL REFERENCES especie(id_especie) ON DELETE RESTRICT,
    nome_raca TEXT NOT NULL CHECK (length(trim(nome_raca)) > 0),
    UNIQUE (id_especie, nome_raca),
    UNIQUE (id_raca, id_especie)
);

CREATE TABLE cep (
    cep TEXT PRIMARY KEY NOT NULL
        CHECK (length(cep) = 8 AND cep NOT GLOB '*[^0-9]*')
);

CREATE TABLE tutor (
    id_tutor TEXT PRIMARY KEY NOT NULL CHECK (length(id_tutor) = 11 AND id_tutor NOT GLOB '*[^0-9]*'),
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    telefone TEXT NOT NULL CHECK (length(trim(telefone)) > 0),
    email TEXT UNIQUE CHECK (email IS NULL OR (instr(email, '@') > 1 AND length(trim(email)) > 3)),
    cep TEXT REFERENCES cep(cep) ON DELETE RESTRICT,
    endereco TEXT NOT NULL CHECK (length(trim(endereco)) > 0)
);

CREATE TABLE pet (
    id_pet INTEGER PRIMARY KEY AUTOINCREMENT,
    id_especie INTEGER NOT NULL REFERENCES especie(id_especie) ON DELETE RESTRICT,
    id_raca INTEGER,
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    nascimento TEXT CHECK (nascimento IS NULL OR
        (nascimento GLOB '????-??-??' AND date(nascimento) = nascimento)),
    FOREIGN KEY (id_raca, id_especie)
        REFERENCES raca(id_raca, id_especie) ON DELETE RESTRICT
);

-- calcula a idade do pet para estar disponivel para consulta
CREATE VIEW vw_pet_idade AS
SELECT p.*,
       CASE WHEN p.nascimento IS NULL THEN NULL ELSE
           CAST(strftime('%Y', 'now') AS INTEGER) - CAST(strftime('%Y', p.nascimento) AS INTEGER)
           - (strftime('%m-%d', 'now') < strftime('%m-%d', p.nascimento))
       END AS idade
FROM pet AS p;

CREATE TABLE tutor_pet (
    id_tutor TEXT NOT NULL REFERENCES tutor(id_tutor) ON DELETE RESTRICT,
    id_pet INTEGER NOT NULL REFERENCES pet(id_pet) ON DELETE RESTRICT,
    responsavel_principal INTEGER NOT NULL DEFAULT 0 CHECK (responsavel_principal IN (0,1)),
    data_vinculo TEXT NOT NULL DEFAULT (date('now')) CHECK (date(data_vinculo) = data_vinculo),
    PRIMARY KEY (id_tutor, id_pet)
);

-- o pet so pode ter um unico responsavel principal
CREATE UNIQUE INDEX uq_um_tutor_principal_por_pet
ON tutor_pet(id_pet) WHERE responsavel_principal = 1;

-- OPERACAO, SERVICOS E SAUDE
CREATE TABLE quarto (
    id_quarto INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo TEXT NOT NULL CHECK (length(trim(tipo)) > 0),
    preco_diaria NUMERIC NOT NULL CHECK (preco_diaria >= 0),
    capacidade_maxima INTEGER NOT NULL DEFAULT 1 CHECK (capacidade_maxima = 1)
);

CREATE TABLE funcionario (
    id_funcionario TEXT PRIMARY KEY NOT NULL
        CHECK (length(id_funcionario) = 11 AND id_funcionario NOT GLOB '*[^0-9]*'),
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    telefone TEXT,
    email TEXT UNIQUE,
    cargo TEXT NOT NULL CHECK (cargo IN ('recepcionista','cuidador','veterinario'))
);

CREATE TABLE servico (
    id_servico INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL UNIQUE CHECK (length(trim(titulo)) > 0),
    preco NUMERIC NOT NULL CHECK (preco >= 0),
    tipo TEXT NOT NULL CHECK (length(trim(tipo)) > 0)
);

CREATE TABLE medicamento (
    id_medicamento INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    tipo TEXT NOT NULL CHECK (length(trim(tipo)) > 0),
    descricao TEXT,
    estoque_qtd INTEGER NOT NULL DEFAULT 0 CHECK (estoque_qtd >= 0)
);

CREATE TABLE tipo_vacina (
    id_tipo_vacina INTEGER PRIMARY KEY AUTOINCREMENT,
    id_especie INTEGER NOT NULL REFERENCES especie(id_especie) ON DELETE RESTRICT,
    titulo TEXT NOT NULL CHECK (length(trim(titulo)) > 0),
    obrigatoria_hospedagem INTEGER NOT NULL DEFAULT 0 CHECK (obrigatoria_hospedagem IN (0,1)),
    UNIQUE (id_especie, titulo)
);

CREATE TABLE lote_vacina (
    id_lote_vacina INTEGER PRIMARY KEY AUTOINCREMENT,
    id_tipo_vacina INTEGER NOT NULL REFERENCES tipo_vacina(id_tipo_vacina) ON DELETE RESTRICT,
    lote TEXT NOT NULL CHECK (length(trim(lote)) > 0),
    data_fabricacao TEXT CHECK (data_fabricacao IS NULL OR date(data_fabricacao) = data_fabricacao),
    estoque_qtd INTEGER NOT NULL DEFAULT 0 CHECK (estoque_qtd >= 0),
    UNIQUE (id_tipo_vacina, lote)
);

CREATE TABLE caderneta (
    id_caderneta INTEGER PRIMARY KEY AUTOINCREMENT,
    id_pet INTEGER NOT NULL UNIQUE REFERENCES pet(id_pet) ON DELETE RESTRICT,
    restricoes_alimentares TEXT,
    observacoes TEXT
);

CREATE TABLE vacinacao (
    id_vacinacao INTEGER PRIMARY KEY AUTOINCREMENT,
    id_caderneta INTEGER NOT NULL REFERENCES caderneta(id_caderneta) ON DELETE RESTRICT,
    id_lote_vacina INTEGER NOT NULL REFERENCES lote_vacina(id_lote_vacina) ON DELETE RESTRICT,
    id_funcionario TEXT NOT NULL REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
    data_aplicacao TEXT NOT NULL CHECK (data_aplicacao GLOB '????-??-??' AND date(data_aplicacao) = data_aplicacao),
    validade_ate TEXT NOT NULL CHECK (validade_ate GLOB '????-??-??' AND date(validade_ate) = validade_ate AND validade_ate >= data_aplicacao)
);

CREATE TABLE medicacao_pet (
    id_medicacao_pet INTEGER PRIMARY KEY AUTOINCREMENT,
    id_pet INTEGER NOT NULL REFERENCES pet(id_pet) ON DELETE RESTRICT,
    id_medicamento INTEGER NOT NULL REFERENCES medicamento(id_medicamento) ON DELETE RESTRICT,
    dose_prescrita TEXT NOT NULL CHECK (length(trim(dose_prescrita)) > 0),
    frequencia TEXT NOT NULL CHECK (length(trim(frequencia)) > 0),
    inicio TEXT NOT NULL CHECK (inicio GLOB '????-??-??' AND date(inicio) = inicio),
    fim TEXT CHECK (fim IS NULL OR (fim GLOB '????-??-??' AND date(fim) = fim AND fim >= inicio))
);

-- HOSPEDAGEM, COBRANCA E REGISTROS
CREATE TABLE reserva (
    id_reserva INTEGER PRIMARY KEY AUTOINCREMENT,
    id_pet INTEGER NOT NULL REFERENCES pet(id_pet) ON DELETE RESTRICT,
    id_quarto INTEGER NOT NULL REFERENCES quarto(id_quarto) ON DELETE RESTRICT,
    data_inicio TEXT NOT NULL CHECK (data_inicio GLOB '????-??-??' AND date(data_inicio) = data_inicio),
    data_fim_prevista TEXT NOT NULL CHECK (data_fim_prevista GLOB '????-??-??' AND
        date(data_fim_prevista) = data_fim_prevista AND data_fim_prevista > data_inicio),
    checkin_em TEXT,
    checkout_em TEXT,
    status TEXT NOT NULL DEFAULT 'Em aberto'
        CHECK (status IN ('Em aberto','Confirmada','Em andamento','Finalizada','Cancelada')),
    valor_diaria_contratada NUMERIC NOT NULL CHECK (valor_diaria_contratada >= 0),
    CHECK (checkout_em IS NULL OR
        (checkin_em IS NOT NULL AND datetime(checkout_em) >= datetime(checkin_em))),
    CHECK (status != 'Em andamento' OR checkin_em IS NOT NULL),
    CHECK (status != 'Finalizada' OR (checkin_em IS NOT NULL AND checkout_em IS NOT NULL))
);

CREATE TABLE pagamento (
    id_pagamento INTEGER PRIMARY KEY AUTOINCREMENT,
    id_reserva INTEGER NOT NULL REFERENCES reserva(id_reserva) ON DELETE RESTRICT,
    id_tutor TEXT NOT NULL REFERENCES tutor(id_tutor) ON DELETE RESTRICT,
    valor_pago NUMERIC NOT NULL CHECK (valor_pago > 0),
    forma_pagamento TEXT NOT NULL CHECK (forma_pagamento IN
        ('Pix','Dinheiro','Debito','Credito','Transferencia','Outro')),
    status TEXT NOT NULL DEFAULT 'Pendente'
        CHECK (status IN ('Pendente','Confirmado','Estornado','Cancelado')),
    pago_em TEXT
);

CREATE TABLE servico_reserva (
    id_servico_reserva INTEGER PRIMARY KEY AUTOINCREMENT,
    id_servico INTEGER NOT NULL REFERENCES servico(id_servico) ON DELETE RESTRICT,
    id_reserva INTEGER NOT NULL REFERENCES reserva(id_reserva) ON DELETE RESTRICT,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    preco_unitario NUMERIC NOT NULL CHECK (preco_unitario >= 0),
    status TEXT NOT NULL DEFAULT 'Contratado'
        CHECK (status IN ('Contratado','Executado','Cancelado'))
);

CREATE TABLE execucao_servico (
    id_execucao INTEGER PRIMARY KEY AUTOINCREMENT,
    id_servico_reserva INTEGER NOT NULL REFERENCES servico_reserva(id_servico_reserva) ON DELETE RESTRICT,
    id_funcionario TEXT NOT NULL REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
    data_servico TEXT NOT NULL,
    descricao TEXT
);

CREATE TABLE administracao_medicamento (
    id_administracao INTEGER PRIMARY KEY AUTOINCREMENT,
    id_medicacao_pet INTEGER NOT NULL REFERENCES medicacao_pet(id_medicacao_pet) ON DELETE RESTRICT,
    id_reserva INTEGER NOT NULL REFERENCES reserva(id_reserva) ON DELETE RESTRICT,
    id_funcionario TEXT NOT NULL REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
    administrada_em TEXT NOT NULL,
    dose_aplicada TEXT NOT NULL CHECK (length(trim(dose_aplicada)) > 0)
);

CREATE TABLE atividade (
    id_atividade INTEGER PRIMARY KEY AUTOINCREMENT,
    id_reserva INTEGER NOT NULL REFERENCES reserva(id_reserva) ON DELETE RESTRICT,
    id_funcionario TEXT NOT NULL REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
    descricao TEXT NOT NULL CHECK (length(trim(descricao)) > 0),
    realizada_em TEXT NOT NULL
);

CREATE TABLE ocorrencia (
    id_ocorrencia INTEGER PRIMARY KEY AUTOINCREMENT,
    id_reserva INTEGER NOT NULL REFERENCES reserva(id_reserva) ON DELETE RESTRICT,
    id_funcionario TEXT NOT NULL REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
    tipo TEXT NOT NULL CHECK (length(trim(tipo)) > 0),
    descricao TEXT NOT NULL CHECK (length(trim(descricao)) > 0),
    registrada_em TEXT NOT NULL
);

-- VERIFICAÇÕES -----------------------------------------------------------------------------------------------------------------------------

-- verifica CPF tutor na insercao
CREATE TRIGGER trg_cpf_tutor_insert
BEFORE INSERT ON tutor
WHEN NOT (
        length(NEW.id_tutor) = 11
        AND NEW.id_tutor NOT GLOB '*[^0-9]*'
        AND NEW.id_tutor != replace('00000000000', '0', substr(NEW.id_tutor, 1, 1)) -- se nao é uma sequencia de numeros iguais
        AND CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) = -- faz a verificacao dos digitos
            CASE WHEN (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 2))) % 11 END
        AND CAST(substr(NEW.id_tutor, 11, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) * 2))) % 11 END
    )
BEGIN
    SELECT RAISE(ABORT, 'CPF invalido em tutor');
END;

-- verifica CPF tutor na atualizacao
CREATE TRIGGER trg_cpf_tutor_update
BEFORE UPDATE OF id_tutor ON tutor
WHEN NOT (
        length(NEW.id_tutor) = 11
        AND NEW.id_tutor NOT GLOB '*[^0-9]*'
        AND NEW.id_tutor != replace('00000000000', '0', substr(NEW.id_tutor, 1, 1))
        AND CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 2))) % 11 END
        AND CAST(substr(NEW.id_tutor, 11, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_tutor, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_tutor, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_tutor, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_tutor, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_tutor, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_tutor, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_tutor, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_tutor, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_tutor, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_tutor, 10, 1) AS INTEGER) * 2))) % 11 END
    )
BEGIN
    SELECT RAISE(ABORT, 'CPF invalido em tutor');
END;

-- verifica CPF funcionario na insercao
CREATE TRIGGER trg_cpf_funcionario_insert
BEFORE INSERT ON funcionario
WHEN NOT (
        length(NEW.id_funcionario) = 11
        AND NEW.id_funcionario NOT GLOB '*[^0-9]*'
        AND NEW.id_funcionario != replace('00000000000', '0', substr(NEW.id_funcionario, 1, 1))
        AND CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 2))) % 11 END
        AND CAST(substr(NEW.id_funcionario, 11, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) * 2))) % 11 END
    )
BEGIN
    SELECT RAISE(ABORT, 'CPF invalido em funcionario');
END;

-- verifica CPF funcionario na atualizacao
CREATE TRIGGER trg_cpf_funcionario_update
BEFORE UPDATE OF id_funcionario ON funcionario
WHEN NOT (
        length(NEW.id_funcionario) = 11
        AND NEW.id_funcionario NOT GLOB '*[^0-9]*'
        AND NEW.id_funcionario != replace('00000000000', '0', substr(NEW.id_funcionario, 1, 1))
        AND CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 2))) % 11 END
        AND CAST(substr(NEW.id_funcionario, 11, 1) AS INTEGER) =
            CASE WHEN (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) * 2))) % 11 < 2 THEN 0 ELSE 11 - (((CAST(substr(NEW.id_funcionario, 1, 1) AS INTEGER) * 11) + (CAST(substr(NEW.id_funcionario, 2, 1) AS INTEGER) * 10) + (CAST(substr(NEW.id_funcionario, 3, 1) AS INTEGER) * 9) + (CAST(substr(NEW.id_funcionario, 4, 1) AS INTEGER) * 8) + (CAST(substr(NEW.id_funcionario, 5, 1) AS INTEGER) * 7) + (CAST(substr(NEW.id_funcionario, 6, 1) AS INTEGER) * 6) + (CAST(substr(NEW.id_funcionario, 7, 1) AS INTEGER) * 5) + (CAST(substr(NEW.id_funcionario, 8, 1) AS INTEGER) * 4) + (CAST(substr(NEW.id_funcionario, 9, 1) AS INTEGER) * 3) + (CAST(substr(NEW.id_funcionario, 10, 1) AS INTEGER) * 2))) % 11 END
    )
BEGIN
    SELECT RAISE(ABORT, 'CPF invalido em funcionario');
END;


-- quem aplica a vacina deve ser um veterinario
-- a vacina tem que estar correta para a especie
-- a caderneta deve existir
CREATE TRIGGER trg_vacinacao_validar_insert
BEFORE INSERT ON vacinacao
WHEN NOT EXISTS (
    SELECT 1 FROM funcionario f
    WHERE f.id_funcionario = NEW.id_funcionario AND f.cargo = 'veterinario'
) OR NOT EXISTS (
    SELECT 1 FROM caderneta c
    JOIN pet p ON p.id_pet = c.id_pet
    JOIN lote_vacina lv ON lv.id_lote_vacina = NEW.id_lote_vacina
    JOIN tipo_vacina tv ON tv.id_tipo_vacina = lv.id_tipo_vacina
    WHERE c.id_caderneta = NEW.id_caderneta AND tv.id_especie = p.id_especie -- se a caderneta existe e se a vacina é compatiel com a especie
)
BEGIN
    SELECT RAISE(ABORT, 'Vacinacao exige veterinario e vacina compativel com especie');
END;

-- mesma coisa, mas para atualizacao
CREATE TRIGGER trg_vacinacao_validar_update
BEFORE UPDATE OF id_funcionario, id_caderneta, id_lote_vacina ON vacinacao
WHEN NOT EXISTS (
    SELECT 1 FROM funcionario f
    WHERE f.id_funcionario = NEW.id_funcionario AND f.cargo = 'veterinario'
) OR NOT EXISTS (
    SELECT 1 FROM caderneta c
    JOIN pet p ON p.id_pet = c.id_pet
    JOIN lote_vacina lv ON lv.id_lote_vacina = NEW.id_lote_vacina
    JOIN tipo_vacina tv ON tv.id_tipo_vacina = lv.id_tipo_vacina
    WHERE c.id_caderneta = NEW.id_caderneta AND tv.id_especie = p.id_especie
)
BEGIN
    SELECT RAISE(ABORT, 'Vacinacao exige veterinario e vacina compativel com especie');
END;


-- todos os quartos sao individuais, os intervalos: [inicio, fim)
CREATE TRIGGER trg_reserva_sem_sobreposicao_insert BEFORE INSERT ON reserva
WHEN NEW.status != 'Cancelada' AND EXISTS (
    SELECT 1 FROM reserva r WHERE r.id_quarto = NEW.id_quarto
      AND r.status != 'Cancelada'
      AND NEW.data_inicio < r.data_fim_prevista
      AND r.data_inicio < NEW.data_fim_prevista
)
BEGIN SELECT RAISE(ABORT, 'Quarto ocupado'); END;

CREATE TRIGGER trg_reserva_sem_sobreposicao_update
BEFORE UPDATE OF id_quarto,data_inicio,data_fim_prevista,status ON reserva
WHEN NEW.status != 'Cancelada' AND EXISTS (
    SELECT 1 FROM reserva r WHERE r.id_reserva != OLD.id_reserva
      AND r.id_quarto = NEW.id_quarto AND r.status != 'Cancelada'
      AND NEW.data_inicio < r.data_fim_prevista
      AND r.data_inicio < NEW.data_fim_prevista
)
BEGIN SELECT RAISE(ABORT, 'Quarto ocupado'); END;


-- nao deixa o pet ter 2 reservas ao mesmo tempo
CREATE TRIGGER trg_reserva_pet_sem_sobreposicao_insert BEFORE INSERT ON reserva
WHEN NEW.status != 'Cancelada' AND EXISTS (
    SELECT 1 FROM reserva r WHERE r.id_pet=NEW.id_pet AND r.status!='Cancelada'
      AND NEW.data_inicio<r.data_fim_prevista AND r.data_inicio<NEW.data_fim_prevista
)
BEGIN SELECT RAISE(ABORT, 'Pet ja possui reserva no periodo'); END;

CREATE TRIGGER trg_reserva_pet_sem_sobreposicao_update
BEFORE UPDATE OF data_inicio,data_fim_prevista,status ON reserva
WHEN NEW.status != 'Cancelada' AND EXISTS (
    SELECT 1 FROM reserva r WHERE r.id_reserva!=OLD.id_reserva AND r.id_pet=NEW.id_pet
      AND r.status!='Cancelada' AND NEW.data_inicio<r.data_fim_prevista
      AND r.data_inicio<NEW.data_fim_prevista
)
BEGIN SELECT RAISE(ABORT, 'Pet ja possui reserva no periodo'); END;


-- proibe adicionar servicos em reservas canceladas ou finalizadas.
CREATE TRIGGER trg_servico_reserva_valida_insert BEFORE INSERT ON servico_reserva
WHEN EXISTS (SELECT 1 FROM reserva WHERE id_reserva=NEW.id_reserva
             AND status IN ('Cancelada','Finalizada'))
BEGIN SELECT RAISE(ABORT, 'Reserva cancelada ou finalizada nao admite servicos'); END;

CREATE TRIGGER trg_servico_reserva_valida_update
BEFORE UPDATE OF id_reserva,status ON servico_reserva
WHEN EXISTS (SELECT 1 FROM reserva WHERE id_reserva=NEW.id_reserva
             AND status IN ('Cancelada','Finalizada'))
BEGIN SELECT RAISE(ABORT, 'Reserva encerrada nao admite alteracao de servicos'); END;

CREATE TRIGGER trg_execucao_valida_insert BEFORE INSERT ON execucao_servico
WHEN EXISTS (
    SELECT 1 FROM servico_reserva sr JOIN reserva r ON r.id_reserva=sr.id_reserva
    WHERE sr.id_servico_reserva=NEW.id_servico_reserva
      AND (r.status IN ('Cancelada','Finalizada') OR sr.status='Cancelado')
)
BEGIN SELECT RAISE(ABORT, 'Nao executar servico cancelado ou de reserva encerrada'); END;


-- compara as vacinas obrigatorias antes do checkin. se o pet nao tem as vacinas, ele nao pode se hospedar.
CREATE TRIGGER trg_checkin_vacinas_insert BEFORE INSERT ON reserva
WHEN NEW.checkin_em IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM pet p
    JOIN tipo_vacina tv ON tv.id_especie=p.id_especie
    WHERE p.id_pet=NEW.id_pet AND tv.obrigatoria_hospedagem=1
      AND NOT EXISTS (
        SELECT 1 FROM caderneta c
        JOIN vacinacao v ON v.id_caderneta=c.id_caderneta
        JOIN lote_vacina lv ON lv.id_lote_vacina=v.id_lote_vacina
        WHERE c.id_pet=p.id_pet AND lv.id_tipo_vacina=tv.id_tipo_vacina
          AND v.data_aplicacao <= date(NEW.checkin_em)
          AND v.validade_ate >= date(NEW.checkin_em)
      )
  )
BEGIN SELECT RAISE(ABORT, 'Vacinas obrigatorias faltando'); END;

CREATE TRIGGER trg_checkin_vacinas_update BEFORE UPDATE OF checkin_em ON reserva
WHEN NEW.checkin_em IS NOT NULL
  AND EXISTS (
    SELECT 1 FROM pet p
    JOIN tipo_vacina tv ON tv.id_especie=p.id_especie
    WHERE p.id_pet=NEW.id_pet AND tv.obrigatoria_hospedagem=1
      AND NOT EXISTS (
        SELECT 1 FROM caderneta c
        JOIN vacinacao v ON v.id_caderneta=c.id_caderneta
        JOIN lote_vacina lv ON lv.id_lote_vacina=v.id_lote_vacina
        WHERE c.id_pet=p.id_pet AND lv.id_tipo_vacina=tv.id_tipo_vacina
          AND v.data_aplicacao <= date(NEW.checkin_em)
          AND v.validade_ate >= date(NEW.checkin_em)
      )
  )
BEGIN SELECT RAISE(ABORT, 'Vacinas obrigatorias ausentes ou vencidas'); END;


-- proibe a alteracao do pet na reserva
CREATE TRIGGER trg_reserva_pet_inalteravel BEFORE UPDATE OF id_pet ON reserva
WHEN NEW.id_pet != OLD.id_pet
BEGIN SELECT RAISE(ABORT, 'Proibido alterar o pet da reserva'); END;


-- cuida para que o pet certo receba a medicacao correta
CREATE TRIGGER trg_administracao_mesmo_pet_insert
BEFORE INSERT ON administracao_medicamento
WHEN NOT EXISTS (
    SELECT 1
    FROM medicacao_pet m
    JOIN reserva r ON r.id_pet = m.id_pet
    WHERE m.id_medicacao_pet = NEW.id_medicacao_pet
      AND r.id_reserva = NEW.id_reserva
      AND date(NEW.administrada_em) >= m.inicio
      AND (
          m.fim IS NULL
          OR date(NEW.administrada_em) <= m.fim
      )
)
BEGIN
    SELECT RAISE(
        ABORT,
        'Medicacao invalida para o pet ou periodo'
    );
END;


-- valores com os servicos
CREATE VIEW vw_resumo_financeiro_reserva AS
WITH totais AS (
    SELECT r.id_reserva, r.id_pet, r.id_quarto, r.status,
           CAST(julianday(r.data_fim_prevista)-julianday(r.data_inicio) AS INTEGER) AS quantidade_diarias,
           r.valor_diaria_contratada,
           ROUND((julianday(r.data_fim_prevista)-julianday(r.data_inicio)) * r.valor_diaria_contratada, 2) AS total_hospedagem,
           ROUND(COALESCE((SELECT SUM(sr.quantidade*sr.preco_unitario)
                           FROM servico_reserva sr WHERE sr.id_reserva=r.id_reserva
                             AND sr.status != 'Cancelado'), 0), 2) AS total_servicos,
           ROUND(COALESCE((SELECT SUM(p.valor_pago)
                           FROM pagamento p WHERE p.id_reserva=r.id_reserva
                             AND p.status='Confirmado'), 0), 2) AS total_pago
    FROM reserva r
)
SELECT t.*,
       ROUND(t.total_hospedagem + t.total_servicos, 2) AS valor_final_estadia,
       ROUND(t.total_hospedagem + t.total_servicos - t.total_pago, 2) AS saldo_pendente
FROM totais t;

COMMIT;