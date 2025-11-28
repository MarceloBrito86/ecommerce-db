-- Criação do Banco 
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela Cliente (PF ou PJ)
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tipo ENUM('PF','PJ') NOT NULL,
    cpf CHAR(11) UNIQUE,
    cnpj CHAR(14) UNIQUE,
    CHECK ((tipo = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
          (tipo = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL))
);

-- Tabela Vendedor
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL
);
   
-- Tabela Fornecedor   
CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL
);

-- Tabela Produto
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco >0),
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela ItemPedido
CREATE TABLE ItemPedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade >0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >0),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    tipo_pagamento ENUM('Cartão','Pix','Boleto') NOT NULL,
    status ENUM('Pendente','Pago','Cancelado') NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- Tabela Entrega
CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    status ENUM('Pendente','Em transporte','Entregue') NOT NULL,
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- Clientes
INSERT INTO Cliente (nome, email, tipo, cpf, cnpj) VALUES
('João Silva', 'joao@email.com', 'PF', '12345678901', NULL),
('Empresa X', 'contato@empresax.com', 'PJ', NULL, '12345678000199'), -- CNPJ é obrigatório para PJ!
('Maria Oliveira', 'maria@email.com', 'PF', '98765432100', NULL);

-- Vendedores
INSERT INTO Vendedor (nome, cpf) VALUES
('Carlos Mendes', '11122233344'),
('Fernanda Lima', '55566677788');

-- Fornecedores
INSERT INTO Fornecedor (nome, cnpj) VALUES
('Fornecedor A', '11111111000111'),
('Fornecedor B', '22222222000122');

-- Produtos
INSERT INTO Produto (nome, descricao, preco, id_fornecedor) VALUES
('Notebook Dell', 'Notebook com processador i7', 3500.00, 1),
('Mouse Logitech', 'Mouse sem fio', 120.00, 2),
('Teclado Gamer', 'Teclado mecânico RGB', 250.00, 1);

-- Pedidos
INSERT INTO Pedido (id_cliente, data_pedido, valor_total) VALUES
(19, '2025-11-20', 3620.00), -- Pedido do João Silva (ID 19)
(20, '2025-11-21', 120.00),  -- Pedido da Empresa X (ID 20)
(21, '2025-11-22', 250.00);  -- Pedido da Maria Oliveira (ID 21)

-- Itens dos pedidos
INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(7, 1, 1, 3500.00), -- Item do Pedido 7 (Cliente João Silva)
(7, 2, 1, 120.00),  -- Segundo Item do Pedido 7
(8, 2, 1, 120.00),  -- Item do Pedido 8 (Cliente Empresa X)
(9, 3, 1, 250.00);  -- Item do Pedido 9 (Cliente Maria Oliveira)

-- Pagamentos
INSERT INTO Pagamento (id_pedido, tipo_pagamento, status) VALUES
(7, 'Cartão', 'Pago'),
(8, 'Pix', 'Pendente'),
(9, 'Boleto', 'Pago');

-- Entregas
INSERT INTO Entrega (id_pedido, status, codigo_rastreio) VALUES
(7, 'Em transporte', 'BR123456789'),
(8, 'Pendente', 'BR987654321'),
(9, 'Entregue', 'BR456789123');

-- 1-Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.nome;

-- 2-Algum Vendedor também é Fornecedor?
SELECT v.nome AS vendedor
FROM Vendedor v
JOIN Fornecedor f ON v.cpf = f.cnpj;
-- Exemplo: Listar Clientes PJ que também são Fornecedores
SELECT c.nome, c.cnpj
FROM Cliente c
JOIN Fornecedor f ON c.cnpj = f.cnpj
WHERE c.tipo = 'PJ';

-- 3-Relação de Produtos, Fornecedores e Estoques?
SELECT pr.nome AS produto, pr.preco, f.nome AS fornecedor
FROM Produto pr
JOIN Fornecedor f ON pr.id_fornecedor = f.id_fornecedor;

-- 4-Relação de nomes do Fornecedores e nomes dos Produtos?
SELECT f.nome AS fornecedor, pr.nome AS produto
FROM Fornecedor f
JOIN Produto pr ON f.id_fornecedor = pr.id_fornecedor
ORDER BY f.nome;

-- 5- Clientes que gastaram mais de R$1000?
SELECT c.nome, SUM(p.valor_total) AS total_gasto
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.nome
HAVING SUM(p.valor_total) > 1000;

-- 6-Produtos ordenados por Preços?
SELECT nome, preco FROM Produto ORDER BY preco DESC;

-- 7-Total de items por Pedidos?
SELECT p.id_pedido, COUNT(i.id_item) AS total_itens
FROM Pedido p
JOIN ItemPedido i ON p.id_pedido = i.id_pedido
GROUP BY p.id_pedido;