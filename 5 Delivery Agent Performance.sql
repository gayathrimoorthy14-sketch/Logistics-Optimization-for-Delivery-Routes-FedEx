#Rank delivery agents (per route) by on-time delivery percentage
select s.Route_ID,s.Agent_ID,round(sum(case when s.actual_transit_time<=r.avg_transit_time_hours then 1 else 0 end)*100/count(*),2) as On_Time_Percentage,
rank()over(partition by s.route_id order by round(sum(case when s.actual_transit_time<= r.avg_transit_time_hours then 1 else 0 end )*100/count(*),2) desc)as Agent_Rank
from fedex_shipments s join fedex_routes r on s.Route_ID=r.route_id group by s.Route_ID, s.Agent_ID order by s.Route_ID,Agent_Rank;

#Find agents whose on-time % is below 85%,
select s.Agent_ID,
round(sum(case when s.actual_transit_time<=r.avg_transit_time_hours then 1 else 0 end)*100/count(*),2) as On_Time_Percentage from fedex_shipments s 
join fedex_routes r on s.Route_ID=r.Route_ID  group by s.Agent_ID having On_Time_Percentage<85;

 #Average rating and experience (in years) of the top 5 vs bottom 5 agents,
select 'Top 5 Agents' as Category ,round((select avg(Avg_Rating) from (select Avg_Rating from fedex_delivery_agents order by Avg_Rating desc limit 5) as A),2) as Average_Rating,
(select avg(experience_years) from (select Experience_Years from fedex_delivery_agents order by experience_years desc limit 5) as B) as Average_Experience
Union all
select 'Bottom 5 Agents' as Category ,(select avg(Avg_Rating) from (select Avg_Rating from fedex_delivery_agents order by Avg_Rating limit 5) as C) as Average_Rating,
round((select avg(experience_years) from (select Experience_Years from fedex_delivery_agents order by experience_years limit 5) as D),2) as Average_Experience;

