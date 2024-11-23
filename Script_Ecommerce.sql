CREATE DATABASE Ecommerce;
USE Ecommerce;

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT NOT NULL AUTO_INCREMENT,
    nome_empresa VARCHAR(50) NOT NULL,
    cnpj VARCHAR(14) NOT NULL,
    PRIMARY KEY (idFornecedor),
    CONSTRAINT chk_cnpj CHECK (LENGTH(cnpj) = 14 AND cnpj REGEXP '^[0-9]+$')
);

-- Tabela Produto
CREATE TABLE Produto (
    idProduto INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Descricao VARCHAR(100),
    Preco DECIMAL(10, 2) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (idProduto),
    CONSTRAINT chk_preco_produto CHECK (Preco > 0)
);

-- Tabela de Fornecimento
CREATE TABLE Fornecimento (
    idFornecedor INT NOT NULL,
    idProduto INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (idFornecedor, idProduto),
    CONSTRAINT chk_preco_fornecimento CHECK (preco > 0),
    CONSTRAINT chk_quantidade_fornecimento CHECK (quantidade >= 0),
    CONSTRAINT fk_fornecimento_fornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fornecimento_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela Estoque
CREATE TABLE Estoque (
    idProduto INT NOT NULL,
    quantidade INT NOT NULL,
    localizacao VARCHAR(50),
    dataUltimaEntrada DATE,
    dataUltimaSaida DATE,
    nivelMinimo INT NOT NULL,
    custoUnitario DECIMAL(10, 2) NOT NULL,
    observacoes TEXT,
    PRIMARY KEY (idProduto),
    CONSTRAINT chk_quantidade_estoque CHECK (quantidade >= 0),
    CONSTRAINT chk_nivel_minimo CHECK (nivelMinimo >= 0),
    CONSTRAINT fk_estoque_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela TipoCliente
CREATE TABLE TipoCliente (
    idTipoCliente INT NOT NULL AUTO_INCREMENT,
    descricao_cliente ENUM('PF', 'PJ') NOT NULL,
    PRIMARY KEY (idTipoCliente)
);

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(100),
    cpf VARCHAR(11),
    cnpj VARCHAR(14),
    idTipoCliente INT NULL,
    PRIMARY KEY (idCliente),
    CONSTRAINT chk_cpf_cliente CHECK (cpf IS NULL OR LENGTH(cpf) = 11 AND cpf REGEXP '^[0-9]+$'),
    CONSTRAINT chk_cnpj_cliente CHECK (cnpj IS NULL OR LENGTH(cnpj) = 14 AND cnpj REGEXP '^[0-9]+$'),
    CONSTRAINT fk_cliente_tipocliente FOREIGN KEY (idTipoCliente) REFERENCES TipoCliente(idTipoCliente) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabela StatusPedido
CREATE TABLE StatusPedido (
    idStatusPedido INT NOT NULL AUTO_INCREMENT,
    descricao ENUM('pendente', 'enviado', 'entregue', 'cancelado') NOT NULL,
    PRIMARY KEY (idStatusPedido)
);

-- Tabela Rastreamento
CREATE TABLE Rastreamento(
    idPedido INT,
    numero_rastreio VARCHAR(100),
    status VARCHAR(50),
    PRIMARY KEY (idPedido),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);
-- Tabela Vendedor
CREATE TABLE Vendedor (
    idVendedor INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,  
    telefone VARCHAR(20),
    PRIMARY KEY (idVendedor)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    idPedido INT NOT NULL AUTO_INCREMENT,  
    idCliente INT NULL, 
    idStatusPedido INT NOT NULL,
    idVendedor INT NOT NULL,
    dataPedido DATE NOT NULL,
    valorTotal DECIMAL(10, 2) NOT NULL,
    codigoRastreio VARCHAR(50),
    dataRastreio DATE,
    ativo TINYINT DEFAULT 1, 
    PRIMARY KEY (idPedido),
    CONSTRAINT chk_valor_total CHECK (valorTotal > 0),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_status FOREIGN KEY (idStatusPedido) REFERENCES StatusPedido(idStatusPedido),
    CONSTRAINT fk_pedido_vendedor FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor)
);

-- Tabela TipoPagamento
CREATE TABLE TipoPagamento (
    idTipoPagamento INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(50) NOT NULL,
    PRIMARY KEY (idTipoPagamento)
);

-- Tabela StatusPagamento
CREATE TABLE StatusPagamento (
    idStatusPagamento INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(50) NOT NULL,
    PRIMARY KEY (idStatusPagamento)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    idPagamento INT NOT NULL AUTO_INCREMENT,
    idPedido INT NULL,  
    idTipoPagamento INT NOT NULL,
    idStatusPagamento INT NOT NULL,
    valorPago DECIMAL(10, 2) NOT NULL,
    dataPagamento DATE NOT NULL,
    ativo TINYINT DEFAULT 1, 
    PRIMARY KEY (idPagamento),
    CONSTRAINT chk_valor_pago CHECK (valorPago > 0),
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_pagamento_tipopagamento FOREIGN KEY (idTipoPagamento) REFERENCES TipoPagamento(idTipoPagamento),
    CONSTRAINT fk_pagamento_statuspagamento FOREIGN KEY (idStatusPagamento) REFERENCES StatusPagamento(idStatusPagamento)
);

-- Tabela Pedido_Produto (mapeamento entre Pedido e Produto)
CREATE TABLE Pedido_Produto (
    idPedido INT NOT NULL, 
    idProduto INT NOT NULL, 
    quantidade INT NOT NULL, 
    preco DECIMAL(10, 2) NOT NULL, 
    PRIMARY KEY (idPedido, idProduto), 
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido) ON DELETE CASCADE,
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE
);

-- Índices adicionais
CREATE INDEX idx_cliente_email ON Cliente(email);
CREATE INDEX idx_produto_nome ON Produto(Nome);
CREATE INDEX idx_pedido_cliente ON Pedido(idCliente);
CREATE INDEX idx_pagamento_pedido ON Pagamento(idPedido);





