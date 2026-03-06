#calculating delivery delay hours in shipments table,
select Shipment_ID,Delay_Hours,Delivery_Date,Pickup_Date,timestampdiff(hour,pickup_date,delivery_date) as Delivery_Delay_Hours from fedex_shipments;

#Top 10 delayed routes based on average delay hours
select Route_ID,round(avg(delay_hours),2) as Average_Delay_Hours from fedex_shipments group by Route_ID order by average_delay_hours desc limit 10;

# Ranking shipments by delay within each Warehouse_ID:
select Shipment_ID,Warehouse_ID,Delay_Hours,rank() over(partition by warehouse_id order by delay_hours desc) as Shipment_Rank from fedex_shipments;

#Average delay per delivery type:
select o.Delivery_Type,round(avg(s.delay_hours),2) as Average_Delay from fedex_orders o join fedex_shipments s on o.Order_ID=s.Order_ID 
group by Delivery_Type order by Average_delay desc;

