#Each shipments with latest status with the latest Delivery_Date,
select Shipment_ID,Delivery_Status,Delivery_Date from fedex_shipments;

#Top Routes where majority of shipments are still “In Transit” or “Returned”,
select Route_ID,count(*) as Total_Shipment,sum(case when Delivery_Status in ('In Transit','Returned') then 1 else 0 end) as Pending_Returned,
round((sum(case when Delivery_Status in ('In Transit','Returned') then 1 else 0 end)/count(*)),2)*100 as Pending_Returned_Percent from fedex_shipments 
group by Route_ID order by Pending_Returned desc limit 5;

#Most frequent delay reasons,
select Delay_Reason,count(*) as Reason_count from fedex_shipments group by Delay_Reason order by reason_count desc;

#Orders with exceptionally high delay (>120 hours)
select Shipment_ID,Route_ID,Warehouse_ID,pickup_date,delivery_date,Delay_Hours from fedex_shipments where Delay_Hours>120 order by Delay_Hours desc;





