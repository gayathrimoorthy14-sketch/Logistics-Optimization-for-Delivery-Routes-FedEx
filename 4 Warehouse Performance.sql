#Top 3 warehouses with the highest average delay in shipments dispatched,
select Warehouse_ID,round(avg(Delay_Hours),2) as Average_delay from fedex_shipments group by Warehouse_ID order by Average_delay desc limit 3;

#Total shipments vs delayed shipments for each warehouse,
select Warehouse_ID,count(*) as Total_Shipment,sum(case when delay_hours>0 then 1 else 0 end) as Delayed_Shipment,
round(sum(case when delay_hours>0 then 1 else 0 end)*100/count(*),2) as Delay_Percentage from fedex_shipments where pickup_date is not null 
group by Warehouse_ID order by delay_percentage desc;

#CTEs to identify warehouses where average delay exceeds the global average delay,
with Warehouse_Avg as(
select Warehouse_ID,avg(Delay_Hours) as Average_Delay from fedex_shipments group by Warehouse_ID),
Global_Avg as(
select avg(Delay_Hours) as Global_Average_Delay from fedex_shipments)
select w.Warehouse_ID,w.Average_Delay,g.Global_Average_delay from warehouse_avg w cross join global_avg g where w.average_delay>g.global_average_delay 
order by w.Average_delay desc;


#Ranking all warehouses based on on-time delivery percentage,
select s.warehouse_id,count(*) as Total_shipment,sum(case when s.Actual_transit_time<=r.Avg_Transit_Time_Hours then 1 else 0 end) as On_time_delivery,
round(sum(case when s.Actual_transit_time<=r.avg_transit_time_hours then 1 else 0 end)*100/count(*),2) as On_time_delivery_percent,
rank() over(order by round(sum(case when s.Actual_transit_time<=r.avg_transit_time_hours then 1 else 0 end)*100/count(*),2) desc) as Rank_shipment
from fedex_shipments s join fedex_routes r on s.Route_ID=r.Route_ID group by Warehouse_ID order by rank_shipment;