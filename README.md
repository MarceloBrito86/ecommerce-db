Projeto de Banco de Dados – E-commerce
Introdução
Este projeto implementa a modelagem lógica de um banco de dados para um sistema de e-commerce, contemplando clientes PF e PJ, múltiplas formas de pagamento, controle de entregas com status e rastreio, além de relacionamentos entre fornecedores, produtos e pedidos.
O objetivo é aplicar conceitos de modelagem conceitual e lógica (EER), criar o script SQL de criação do esquema, inserir dados para testes e elaborar consultas complexas que demonstrem o uso de diferentes cláusulas SQL.

-Modelagem Lógica
Entidades e Relacionamentos
•Cliente: pode ser PF ou PJ (restrição de exclusividade entre CPF e CNPJ).
•Produto: associado a um fornecedor.
•Fornecedor: fornece produtos.
•Vendedor: pode ser analisado se também é fornecedor.
•Pedido: vinculado a um cliente.
•ItemPedido: detalha os produtos de cada pedido.
•Pagamento: múltiplas formas possíveis por pedido.
•Entrega: status e código de rastreio

-Scripts
•schema.sql → Criação do banco de dados e tabelas com constraints.
•insert.sql → Inserção de dados de teste (clientes, produtos, pedidos, pagamentos e entregas).
•queries.sql → Consultas SQL complexas para análise dos dados.

-Consultas SQL
As queries de exemplo demonstram:
•Recuperações simples com SELECT
•Filtros com WHERE
•Atributos derivados com SUM
•Ordenações com ORDER BY
•Filtros em grupos com HAVING
•Junções complexas com JOIN

Exemplos de perguntas respondidas:
•Quantos pedidos foram feitos por cada cliente?
•Algum vendedor também é fornecedor?
•Relação de produtos, fornecedores e estoques.
•Relação de nomes dos fornecedores e nomes dos produtos.
•Clientes que gastaram mais de R$ 1000.
