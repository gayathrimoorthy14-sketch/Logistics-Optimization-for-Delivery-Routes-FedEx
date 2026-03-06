#Average Delivery Delay per Source_Country,
select Source_Country,round (avg(s.delay_hours)) as Average_Delay from fedex_routes r join fedex_shipments s on s.Route_ID=r.Route_ID 
group by r.Source_Country order by Average_delay desc;

#On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100,
select r.Route_ID,(sum(case when s.actual_transit_time<=r.avg_transit_time_hours then 1 else 0 end)/count(*)*100) as On_time_Delivery_Percent
 from fedex_shipments s join fedex_routes r on s.Route_ID=r.Route_ID group by r.route_id order by route_id;

#Average Delay (in hours) per Route_ID,
select Route_ID,round(avg(delay_hours),1) as Average_Delay from fedex_shipments group by Route_ID order by Average_Delay desc;

#Warehouse Utilization % = (Shipments_Handled / Capacity_per_day) * 100,
select w.Warehouse_id,count(shipment_id) as Shipment_Handled,round((count(s.shipment_id)*1.0/w.capacity_per_day)* 100, 2) as Warehouse_utilization_Percent 
from fedex_warehouses w join fedex_shipments s on w.Warehouse_ID=s.Warehouse_ID group by s.Warehouse_ID,w.Capacity_per_day 
order by s.Warehouse_ID;