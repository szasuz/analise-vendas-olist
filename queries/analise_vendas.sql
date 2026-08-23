--Análise de Vendas E-commerce Brasileiro (Olist)

--pergunta 1: faturamento mês a mês

select
	year(o.order_purchase_timestamp) as ano,
	month(o.order_purchase_timestamp) as mes,
	sum(oi.price) as faturamento_total,
	count(distinct o.order_id) as qtd_pedidos
from orders o
join order_items oi 
	on o.order_id = oi.order_id
group by year(o.order_purchase_timestamp), month(o.order_purchase_timestamp)
order by ano, mes

--pergunta 2: categorias mais e menos vendidas.

select
	isnull(ct.product_category_name_english, p.product_category_name) as categoria,
	COUNT(oi.order_item_id) as qtd_itens_vendidos,
	sum(oi.price) as faturamento_total
from order_items oi
join products p on oi.product_id = p.product_id
left join category_translation ct on p.product_category_name = ct.product_category_name
group by ISNULL(ct.product_category_name_english, p.product_category_name)
order by faturamento_total desc

--pergunta 3: distribuição geográfica dos clientes.

select
	c.customer_state,
	count(distinct o.order_id) as qtd_pedidos,
	sum(oi.price) as faturamento_total
from orders o
join customers c on o.customer_id = c.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_state
order by qtd_pedidos desc

--pergunta 4: impacto do atraso na avaliação
select
	case
		when o.order_delivered_customer_date > o.order_estimated_delivery_date then 'atrasado'
		else 'no prazo'
	end as situacao_entrega,
	avg(cast(r.review_score as float)) as media_avaliacao,
	count(*) as qtd_pedidos
from orders o
join order_reviews r 
	on o.order_id = r.order_id
where o.order_delivered_customer_date is not null
group by
	case
		when o.order_delivered_customer_date > o.order_estimated_delivery_date then 'atrasado'
		else 'no prazo'
	end

--pergunta 5: formas de pagamento preferidas.

select
	payment_type,
	count(*) as qtd_transacoes,
	sum(payment_value) as valor_total,
	avg(payment_value) as ticket_medio
from order_payments
group by payment_type
order by qtd_transacoes desc