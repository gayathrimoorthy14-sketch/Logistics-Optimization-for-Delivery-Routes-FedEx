create database fedex;

use fedex;
select * from fedex_delivery_agents;
select * from fedex_orders;
select * from fedex_routes;
select * from fedex_shipments;
select * from fedex_warehouses;

#Finding the duplicate values in order_id and shipment_id using group by and having clause, and there are no duplicate values in both order_id and shipment_id columns
select shipment_id,count(*) as duplicate_row from fedex_shipments group by shipment_id having count(*)>1;
select order_id,count(*) as duplicate_row from fedex_orders group by order_id having count(*)>1;

#updating the delay hours from null to avreage delay hours, there is no null or missing value in that column
select * from fedex_shipments where delay_hours is null ;


#Changing the data type of order_date,pickup_date,delivery_date into datetime type,
describe fedex_orders;
update fedex_orders set order_date = str_to_date(order_date,'%Y-%m-%d %H:%i:%s') limit 300;
alter table fedex_orders modify order_date datetime;

update fedex_shipments set pickup_date= str_to_date(pickup_date,'%Y-%m-%d %H:%i:%s') limit 1000;
alter table fedex_shipments modify pickup_date datetime;
describe fedex_shipments;

update fedex_shipments set delivery_date= str_to_date(delivery_date,'%Y-%m-%d %H:%i:%s') limit 1000; 
alter table fedex_shipments modify delivery_date datetime;

#Ensuring that no Delivery_Date occurs before Pickup_Date using below query,
select count(*) from fedex_shipments where delivery_date<pickup_date;

#finding referential integrity between shipment table(parent table)  and child tables(orders,routes,deliver agents and warehouse),
select s.order_id from fedex_shipments s left join fedex_orders o on s.Order_id=o.order_id where o.order_id is null;
select s.route_id from fedex_shipments s left join fedex_routes r on s.route_id=r.route_id where r.route_id is null;
select s.warehouse_id from fedex_shipments s left join fedex_warehouses w on s.warehouse_id=w.warehouse_id where w.warehouse_id is null;
select s.agent_id from fedex_shipments s left join fedex_delivery_agents d on s.agent_id=d.agent_id where d.agent_id is null;
