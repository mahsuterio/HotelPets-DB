-- 10
-- Lista os funcionários, incluindo aqueles que ainda não realizaram nenhuma atividade
SELECT funcionario.nome, funcionario.cargo, COUNT(execucao_servico.id_execucao) AS total_atividades,
COALESCE(max(execucao_servico.data_servico), 'Sem atividades.') as data_ultima_atividade 
FROM funcionario LEFT JOIN execucao_servico ON funcionario.id_funcionario = execucao_servico.id_funcionario
GROUP BY funcionario.id_funcionario;