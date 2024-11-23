# 📈 E-Commerce Database Queries
<p style="text-align: justify;">
Este repositório contém um conjunto de queries SQL para um sistema de E-commerce, aplicando diversos conceitos e cláusulas SQL para gerar relatórios e analisar dados do banco. Abaixo estão as cláusula implementada nas consultas.
</p>

## 1. Atributo Derivado - Status de Rastreamento
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Gerar um relatório com o status de rastreio de cada pedido, classificando-os conforme o status de entrega, baseado nas informações da tabela **Rastreio**.
</p>

```sql
SELECT 
    Pedido.idPedido,
    CASE
        WHEN Rastreamento.numero_rastreio IS NOT NULL AND Rastreamento.status = 'Em Transito' THEN 'Em Transito'
        WHEN Rastreamento.numero_rastreio IS NOT NULL AND Rastreamento.status = 'Entregue' THEN 'Entregue'
        ELSE 'Não Iniciado'
    END AS Status_Rastreio
FROM Pedido
LEFT JOIN Rastreamento ON Pedido.idPedido = Rastreamento.idPedido;
```

## 2. Cálculo do Valor Total de Pedidos
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Calcular o valor total de cada pedido realizado pelos clientes, multiplicando a quantidade de cada item pelo seu preço e somando esses valores para cada pedido.
</p>

```sql
SELECT Pedido.idPedido, Cliente.nome, SUM(Pedido_Produto.quantidade * Pedido_Produto.preco) AS Valor Total Calculado FROM Pedido_Produto
INNER JOIN Pedido ON Pedido_Produto.idPedido = Pedido.idPedido
INNER JOIN Cliente ON Pedido.idCliente = Cliente.idCliente
GROUP BY Pedido.idPedido, Cliente.nome;
```
## 3. Total de Pedidos por Cliente
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Exibir cada cliente e o total de pedidos feitos por ele, ordenando em ordem decrescente pelo número de pedidos realizados.
</p>

```sql
SELECT Cliente.idCliente, Cliente.nome AS Nome Cliente, COUNT(Pedido.idPedido) AS Total Pedidos
FROM Cliente INNER JOIN Pedido ON Cliente.idCliente = Pedido.idCliente
GROUP BY Cliente.idCliente, Cliente.nome ORDER BY TotalPedidos DESC;
```
## 4. Fornecedores e Produtos
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Listar os fornecedores e os produtos que eles fornecem, considerando a relação entre as tabelas Fornecedor e Produto.
</p>

```sql
SELECT Fornecedor.nome_empresa AS Nome Fornecedor, Produto.Nome AS Nome Produto
FROM Fornecedor
INNER JOIN Fornecimento ON Fornecedor.idFornecedor = Fornecimento.idFornecedor
INNER JOIN Produto ON Fornecimento.idProduto = Produto.idProduto
LIMIT 0, 1000;
```
## 5. Produtos, Fornecedores e Estoque
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Relacionar fornecedores, produtos e o estoque, exibindo informações sobre o produto, quantidade em estoque e sua localização.
</p>

```sql
SELECT Fornecedor.nome_empresa AS Nome Fornecedor, 
       Produto.Nome AS Nome Produto, 
       Estoque.quantidade AS Quantidade Em Estoque, 
       Estoque.localizacao AS Localizacao Estoque
FROM Fornecedor
INNER JOIN Fornecimento ON Fornecedor.idFornecedor = Fornecimento.idFornecedor
INNER JOIN Produto ON Fornecimento.idProduto = Produto.idProduto
INNER JOIN Estoque ON Produto.idProduto = Estoque.idProduto;
```
## 6. Clientes com Mais de 1 Pedido
<strong style="color: #FFA500;">Objetivo : </strong> Retornar os clientes que realizaram mais de 1 pedido.

```sql
SELECT Cliente.idCliente, Cliente.nome, COUNT(Pedido.idPedido) AS Total Pedidos
FROM Cliente
INNER JOIN Pedido ON Cliente.idCliente = Pedido.idCliente
GROUP BY Cliente.idCliente, Cliente.nome
HAVING COUNT(Pedido.idPedido) > 1;
```
## 7. Fornecedores com Valor Total Superior a R$ 200.000,00
<strong style="color: #FFA500;">Objetivo : </strong> Retornar os fornecedores cujos produtos fornecidos tenham um valor total superior a R$ 200.000,00.

```sql
SELECT Fornecedor.nome_empresa AS Nome Fornecedor, 
       SUM(Pedido_Produto.quantidade * Pedido_Produto.preco) AS Valor Total Fornecido
FROM Fornecedor
INNER JOIN Fornecimento ON Fornecedor.idFornecedor = Fornecimento.idFornecedor
INNER JOIN Produto ON Fornecimento.idProduto = Produto.idProduto
INNER JOIN Pedido_Produto ON Produto.idProduto = Pedido_Produto.idProduto
GROUP BY Fornecedor.idFornecedor, Fornecedor.nome_empresa
HAVING SUM(Pedido_Produto.quantidade * Pedido_Produto.preco) > 200000;
```
## 8. Desempenho dos Vendedores
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo : </strong> Relacionar vendedores com os pedidos que processaram, calculando o valor total dos pedidos e listando os produtos vendidos.
</p>

```sql
SELECT 
    Vendedor.idVendedor,
    Vendedor.nome AS Nome Vendedor,
    Pedido.idPedido,
    SUM(Pedido_Produto.quantidade * Pedido_Produto.preco) AS Valor Total Pedido,
    GROUP_CONCAT(DISTINCT Produto.Nome ORDER BY Produto.Nome) AS Produtos Vendidos
FROM Pedido
INNER JOIN Vendedor ON Pedido.idVendedor = Vendedor.idVendedor
INNER JOIN Pedido_Produto ON Pedido.idPedido = Pedido_Produto.idPedido
INNER JOIN Produto ON Pedido_Produto.idProduto = Produto.idProduto
GROUP BY Vendedor.idVendedor, Pedido.idPedido
ORDER BY ValorTotalPedido DESC;
```
## Conclusão
<p style="text-align: justify;">
As queries implementadas no banco de dados do E-commerce abordam uma variedade de operações SQL, incluindo junções entre múltiplas tabelas, funções de agregação, e filtros condicionais. Elas fornecem uma visão abrangente sobre o comportamento dos clientes, fornecedores, produtos, e vendedores, e são essenciais para análise e relatórios em sistemas de E-commerce.
</p>



