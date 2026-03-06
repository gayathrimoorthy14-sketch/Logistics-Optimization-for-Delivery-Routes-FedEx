#Average transit time (in hours) across all shipments
select r.Route_ID,count(s.Shipment_ID) as Shipment_Count,r.Avg_Transit_Time_Hours from fedex_routes r left join fedex_shipments s on s.Route_ID=r.Route_ID 
group by r.Route_ID,Avg_Transit_Time_Hours;

#Average delay hours per route;
select Route_ID,avg(delay_hours) as Average_Delay from fedex_shipments group by Route_ID order by Average_delay desc;

#Distance-to-time efficiency ratio = Distance_KM / Avg_Transit_Time_Hours,
select Route_ID,Distance_KM,Avg_Transit_Time_Hours,round(Distance_KM/Avg_Transit_Time_Hours,2) as Distance_time_efficiency_ratio from fedex_routes;

#3 routes with the worst efficiency ratio,
select Route_ID,Avg_Transit_Time_Hours,Distance_KM,round(Distance_KM/avg_Transit_time_hours,2) as Distance_time_efficiency_ratio 
from fedex_routes order by Distance_time_efficiency_ratio asc limit 3;

#since we need Actual transit time in hours for upcoming calculation, Created a new column as Actual transit time hours

alter table fedex_shipments add column Actual_Transit_time int;
update fedex_shipments set Actual_Transit_time=timestampdiff(hour,pickup_date,delivery_date);

#Routes with >20% of shipments delayed beyond expected transit time,
select r.Route_ID,count(*) as Total_shipment,
sum(case when s.actual_transit_time>r.avg_transit_time_hours then 1 else 0 end) as Delayed_Shipment,
round(sum(case when s.actual_transit_time>r.avg_transit_time_hours then 1 else 0 end)*100/count(*),2) as Delay_Percentage
from fedex_shipments s join fedex_routes r on s.Route_ID=r.Route_ID group by r.Route_ID having Delay_percentage>20;