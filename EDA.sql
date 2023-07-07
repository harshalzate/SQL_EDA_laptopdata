select * from laptopdata;

select * from laptopdata
limit 5;

select * from laptopdata
order by id desc
limit 5;

select * from laptopdata
order by rand()
limit 5;

-- 1. numerical 
-- 1.1 Price
SELECT count(price),
min(price),
max(price),
avg(price),
std(price)
FROM laptopdata;

SELECT PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY PRICE) over () AS Q1,
PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY PRICE) over () AS Q2,
PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY PRICE) over () AS Q3
FROM laptopdata;

-- null
select count(*) from laptopdata where price is null;

-- --outliers --  

select * from (select *,
percentile_cont(0.25) within group (order by price ) over () as 'Q1',
percentile_cont(0.50) within group (order by price ) over () as 'Q2' ,
percentile_cont(0.75) within group (order by price ) over () as 'Q3'  
from laptopdata ) t
where t.price < t.Q1-(1.5*(t.Q3-t.Q1)) OR t.price > t.Q3+(1.5*(t.Q3-t.Q1));

-- 2. Company
select Company,count(Company) from laptopdata
group by Company
order by count(Company) desc;

select Company from laptopdata where Company is null or Company='';

-- 3.TypeName
select TypeName,count(TypeName) from laptopdata
group by TypeName 
order by count(TypeName) desc;
select typename from laptopdata where typename is null or typename='';
select * from laptopdata;

-- 4. inches

delete from laptopdata where id in (select id from laptopdata
where inches >18
);

select id from laptopdata where inches is null or inches='';
select * from laptopdata where id=476;

update laptopdata 
set inches=15
where id=476;

SELECT count(inches),
min(inches),
max(inches),
avg(inches),
std(inches)
FROM laptopdata;

-- histogram from inches
select case 
		when inches between 10 and 12 then '10-12'
        when inches between 13 and 15 then '13-15'
        else '16-18'
        end as buckets,count(inches)
        from laptopdata
        group by buckets;

select * from (select*,
percentile_cont(0.25) within group (order by inches ) over () as 'Q1',
percentile_cont(0.50) within group (order by inches ) over () as 'Q2' ,
percentile_cont(0.75) within group (order by inches ) over () as 'Q3'  
from laptopdata ) t
where t.price < t.Q1-(1.5*(t.Q3-t.Q1)) OR t.price > t.Q3+(1.5*(t.Q3-t.Q1));

-- Touch_screen

select Touch_screen,count(Touch_screen) from laptopdata
group by Touch_screen;

-- CPU_brand
select * from laptopdata;
select CPU_brand,count(CPU_brand) from laptopdata
group by cpu_brand;

-- CPU_Name
select CPU_Name,count(CPU_Name) from laptopdata
group by CPU_Name
order by count(CPU_Name) desc;

-- Ram-- 
select ram,count(ram) from laptopdata
group by ram
order by count(ram) desc;

-- Memory Type
select id from laptopdata
where memory_type is null;
select * from laptopdata where id = 770;
delete from laptopdata 
where id = 770;
select memory_type,count(memory_type) from laptopdata
group by memory_type
order by count(memory_type) desc;

-- Primary storage

select primary_storage,count(primary_storage) from laptopdata
group by primary_storage
order by count(primary_storage)  desc;

-- Secondry_storage-- 

SELECT Secondry_storage, COUNT(CASE
        WHEN Secondry_storage > 0 THEN 'Secondry_storage_available'
        ELSE 'No_Secondry_storage'
    END) AS count_availability
FROM laptopdata
GROUP BY Secondry_storage
ORDER BY count_availability DESC;

select Secondry_storage,count(Secondry_storage) from laptopdata
group by Secondry_storage
order by count(Secondry_storage) desc;

-- Gpu Brnad

select Gpu_brand,count(Gpu_brand) from laptopdata
group by Gpu_brand
order by count(Gpu_brand) desc;

-- OpSys
select OpSys,count(OpSys) from laptopdata
group by OpSys order by count(OpSys) desc;

-- weight
select id from laptopdata
where weight =0;

delete from laptopdata 
where id = 349;

SELECT count(weight),
min(weight),
max(weight),
avg(weight),
std(weight)
FROM laptopdata;

select * from (select*,
percentile_cont(0.25) within group (order by weight ) over () as 'Q1',
percentile_cont(0.50) within group (order by weight ) over () as 'Q2' ,
percentile_cont(0.75) within group (order by weight ) over () as 'Q3'  
from laptopdata ) t
where t.weight < t.Q1-(1.5*(t.Q3-t.Q1)) OR t.weight > t.Q3+(1.5*(t.Q3-t.Q1));

delete from laptopdata
where weight>5;

-- Bivrieate Analysis
-- 1. price vs company
select company,avg(price) from laptopdata
group by company
order by avg(price) desc;

-- 2. price vs Typename
select Typename,avg(price) from laptopdata
group by Typename
order by avg(price) desc;

-- 3.price vs inches
select price,inches from laptopdata;

-- 4. price vs TouchScreen
select Touch_screen,avg(price) from laptopdata
group by Touch_screen
order by avg(price) desc;

-- 4. price vs CPU_BRAND
select CPU_brand,avg(price) from laptopdata
group by CPU_brand
order by avg(price) desc
;
-- PRICE VS RAM
select RAM,avg(price) from laptopdata
group by RAM
order by avg(price) desc;

-- PRICE VS MEMORY TYPE
select Memory_Type,avg(price) from laptopdata
group by Memory_Type
order by avg(price) desc;

-- . price vs GPU_BRAND
select GPU_brand,avg(price) from laptopdata
group by GPU_brand
order by avg(price) desc;

-- . price vs OPSYS
select OPSYS,avg(price) from laptopdata
group by OPSYS
order by avg(price) desc;

-- 3. CPU SPEED
-- PRICE VS CPU SPEED

DELETE FROM LAPTOPDATA WHERE ID=208;
select CPU_speed,PRICE from laptopdata;
--  CPU SPEED vs type
select  TYPENAME, AVG(cpu_speed) 
FROM LAPTOPDATA
group by TYPENAME 
order by AVG(cpu_speed) desc;

-- CPU SPEED vs Ram
select  ram, AVG(cpu_speed) 
FROM LAPTOPDATA
group by ram 
order by AVG(cpu_speed) desc;

-- CPU SPEED vs MEMORY TYPE
select  MEMORY_TYPE, AVG(cpu_speed) 
FROM LAPTOPDATA
group by MEMORY_TYPE
order by AVG(cpu_speed) desc;

-- CPU SPEED vs GPU_Brand
select  GPU_Brand, AVG(cpu_speed) 
FROM LAPTOPDATA
group by GPU_Brand
order by AVG(cpu_speed) desc;

-- CPU SPEED vs OpSys
select  OpSys, AVG(cpu_speed) 
FROM LAPTOPDATA
group by OpSys
order by AVG(cpu_speed) desc;

-- 3.inches
-- 3.1 inches vs company
select company, avg(inches) from laptopdata 
group by company
order by avg(inches) desc;
-- select percentile_cont(0.5) within group (order by inches ) over (partition by company) as t from laptopdata
-- 3.2 inches vs TypeName
select TypeName, avg(inches) from laptopdata 
group by TypeName
order by avg(inches) desc;

-- 3.3 inches vs touchscreen
select distinct Touch_screen,percentile_cont(0.5) within group (order by inches) over (partition by Touch_screen) as t from laptopdata 
;
-- 3.4 inches vs cpu_speed
select inches, CPU_SPEED from laptopdata;

select ram, avg(inches) from laptopdata 
group by ram
order by avg(inches) desc;

-- --3.5 inches vs GPU_Brand 

select distinct GPU_Brand,percentile_cont(0.5) within group (order by inches) over (partition by GPU_Brand) as t from laptopdata;

-- 3.6inches vs os 
select distinct OpSys,percentile_cont(0.5) within group (order by inches) over (partition by OpSys) as t from laptopdata;
select distinct OpSys,percentile_cont(0.5) within group (order by inches) over () as t from laptopdata where opsys !='Macos';

-- --3.7 inches vs weight
select inches,weight from laptopdata;

-- 4.CPU_BRNAD
-- 4.1 CPU_BRAND VS COMPANY
SELECT TypeName,CPU_BRAND,COUNT(*) FROM laptopdata
GROUP BY TypeName,CPU_brand;
-- 4.2 CPU_BRAND VS GPU_BRAND
SELECT CPU_BRAND,GPU_BRAND,COUNT(*) FROM laptopdata
GROUP BY CPU_brand,GPU_BRAND;
select * from laptopdata

-- select * from laptopdata_new where company = 'apple'
-- select count(company) from laptopdata_new where company= 'hp' and touch_screen=0
-- select company ,count(one), count(zero) from (select company,case when touch_screen=1 then 1 else null end as 'one',case when touch_screen=0 then 1 else null end as 'zero'from laptopdata_new) t1
-- group by company
