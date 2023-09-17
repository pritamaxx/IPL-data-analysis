create table deliveries (
id bigint,
inning int,
over int,
ball int,
batsman	varchar,
non_striker	varchar,
bowler varchar,
batsman_runs int,	
extra_runs int,
total_runs int,	
is_wicket int,
dismissal_kind varchar,
player_dismissed varchar,	
fielder	varchar,
extras_type	varchar,
batting_team varchar,
bowling_team varchar)

create table matches (
id bigint primary key,
city varchar,
date date,
player_of_match varchar,
venue varchar,
neutral_venue int,
team1 varchar,
team2 varchar,
toss_winner varchar,
toss_decision varchar,
winner varchar,
result varchar,
result_margin bigint,
eliminator varchar,
method varchar,
umpire1 varchar,
umpire2 varchar)

copy deliveries from 'D:\SQL\Training Videos\M6_ Final Project\Data_For_Final_ProjectIPLMatches_IPLBall\IPLMatches+IPLBall\IPL_Ball.csv' csv header;
copy matches from 'D:\SQL\Training Videos\M6_ Final Project\Data_For_Final_ProjectIPLMatches_IPLBall\IPLMatches+IPLBall\IPL_matches.csv' csv header;

select * from deliveries;
select * from matches;

select * from deliveries    --5
order by id,inning,over,ball asc
limit 20;

select * from matches     --6
order by id asc
limit 20;

select*from matches    --7      
where date='2-5-2013';

select*from matches    --8     
where result='runs' and result_margin>100;

select*from matches    --9     
where result='tie'
order by date desc;

select count (distinct city) from matches;    --10

create table deliveries_v02 as       --11
select*,
 case when total_runs>=4 then 'boundary'
      when total_runs=0 then 'dot'
      else 'other'
	  end
	   as ball_result
from deliveries;
select*from deliveries_v02;

select count(ball_result) as boundaries    --12
       from deliveries_v02
       where ball_result= 'boundary';
select count(ball_result) as dots
	   from deliveries_v02
	   where ball_result='dot';
	   
select batting_team, count(ball_result) as boundaries  --13
from deliveries_v02
where ball_result='boundary'
group by batting_team
order by boundaries desc;

select bowling_team, count(ball_result) as dots  --14
from deliveries_v02
where ball_result='dot'
group by bowling_team
order by dots desc;

select count(dismissal_kind) from deliveries_v02 --15
where dismissal_kind!='run out';

select bowler, extra_runs     --16
from deliveries_v02
order by extra_runs desc
limit 5;

create table deliveries_v03 as      --17
select
a.*,
b.venue,
b.date as match_date
from deliveries_v02 as a
left join matches as b
on a.id=b.id;
select*from deliveries_v03;

select venue, sum(total_runs) as total_runs  --18
from deliveries_v03
group by venue
order by total_runs desc;

select extract(year from match_date) as year,  --19
       sum(total_runs) as EG_total_runs
from deliveries_v03
where venue='Eden Gardens'
group by year
order by EG_total_runs desc;

select distinct team1 from matches;    --20
create table matches_corrected as
select*, 
replace(team1,'Rising Pune Supergiants','Rising Pune Supergiant') as team1_corr,
replace(team2,'Rising Pune Supergiants','Rising Pune Supergiant') as team2_corr
from matches;
select * from matches_corrected;

create table deliveries_v04 as    --21
select*,
id||'-'||inning||'-'||over||'-'||ball as ball_id
from deliveries_v03;
select * from deliveries_v04;

select count(*) as total_rows,      --22
count (distinct ball_id) as unique_deliveries
from deliveries_v04;

create table deliveries_v05 as       --23
select*,
row_number() over (partition by ball_id) as r_num
from deliveries_v04;

select * from deliveries_v05       --24
where r_num=2;

SELECT * FROM deliveries_v05        --25
WHERE ball_id in 
(select ball_id from deliveries_v05 WHERE r_num=2);

