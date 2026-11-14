-- 05
-- Mostrar pets sem ou com restrições alimentares cadastradas
-- UPDATE caderneta SET restricoes_alimentares = 'Não pode comer cenoura.' WHERE id_caderneta > 13;
-- UPDATE caderneta SET restricoes_alimentares = 'Não pode comer banana.' WHERE id_caderneta = 10;
-- UPDATE caderneta SET restricoes_alimentares = 'Petiscos em pouca quantidade.' WHERE id_caderneta = 2;

select pet.nome, COALESCE(caderneta.restricoes_alimentares, 'Não informado.') AS restricoes_alimentares FROM caderneta 
left join pet on pet.id_pet = caderneta.id_pet ORDER by pet.nome ASC; 