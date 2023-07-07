-- create database laptopslaptopdata;

select count(*) FROM laptops.laptopdata;
SELECT * FROM laptops.laptopdata;

-- --1. create backup
create table laptopdata_backup like laptopdata;

INSERT INTO laptopdata_backup
select * from laptopdata;

-- 2. Check number of rows
SELECT count(*) FROM laptops.laptopdata;

-- 3. check memeory consumption

select * from information_schema.tables
where table_schema='laptops'
and table_name='laptopdata';

select DATA_LENGTH/1024 from information_schema.tables
where table_schema='laptops'
and table_name='laptopdata';

-- 5. drop all the rows which have null values;

delete from laptopdata t1
where id in 
(select id from 
		(select id from laptopdata) t2
where company is NULL and TypeName is NULL and Inches is null and 
screenResolution is null and Cpu is null and Ram is NULL and 
memory is NULL and  GPU is NULL and opsys is NULL and  Weight is NULL and Price is NULL 
and t2.id=t1.id
);

-- 6. 'Duplicate'

delete from laptopdata where id not in (
select id from (select min(id) from laptopdata
group by Id,Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight,Price
) temp
);

-- 7. column values one by one 
select distinct(Company) from laptopdata;
select distinct (typename) from laptopdata;

-- 1. inches to int
SELECT inches FROM laptops.laptopdata;
 alter table laptopdata 
 modify column inches int;
 
--  2. Ram
SELECT ram FROM laptops.laptopdata;

update laptopdata t1
set ram = (select replace(ram,'GB','') from laptopdata) where t1.id=t2.id

update laptopdata t1
set ram = (select replace (ram,'GB','') from (select id,ram from laptopdata)t2
			where t1.id=t2.id);
            
alter table laptopdata 
modify column Ram int;

select * from laptopdata;

-- 3. WEIGHT column Remvoving kg 
 update laptopdata t1
 set weight = (select replace(weight,"kg","") from 
								(select id,weight from laptopdata) t2
                                where t2.id=t1.id
                                );

-- '?' IN ONE OF THE WEIGHT VALUES
 
UPDATE LAPTOPDATA
SET WEIGHT=NULL WHERE WEIGHT='?';

ALTER TABLE laptopdata
MODIFY COLUMN weight DECIMAL(4,2);

-- 4. Price
update laptopdata t1
set price=(select round(price) from 
									(select id,price from laptopdata ) t2 where t1.id=t2.id);
alter table laptopdata
modify column price int;

select Data_length/1024 from information_schema.tables
where table_schema='laptops'
and table_name='laptopdata_new';

-- 5. OpSys
select * from laptopdata;
select distinct(opsys) from laptopdata;
-- 1.mac
-- 2.windows
-- 3.linux
-- 4.adnriod,chrome,no os into (other)

update laptopdata t1 
set OpSys = (select 
			case
			when OpSys like '%mac%' then 'Macos'
			when opsys = 'No os' then 'N/A'
			when opsys like '%linux%' then 'Linux'
			when opsys like '%windows%' then 'windows'
			else 'other'
			end  
			from (select id,opsys from laptopdata )t2  
            where t2.id=t1.id
            );
            
-- 6. GPU  
-- Making two columns for the GPU brand and GPU name

alter table laptopdata
add column GPU_Brand varchar (255) after gpu,
add column GPU_name varchar (255) after GPU_Brand;

select * from laptopdata;

-- four Graphic Cards
-- 1. Intel
-- 2. AMD
-- 3. Nvidia
-- 4.ARM

update laptopdata t1
set GPU_Brand = (
				select substring_index(gpu," ",1) 
                from (select Gpu,id from laptopdata )t2
                where t1.id=t2.id);

update laptopdata t1
set GPU_name = (
				select replace(gpu,GPU_brand,'') from 		
                (select gpu,id from laptopdata) t2
                where t1.id=t2.id
                );
alter table laptopdata
drop column gpu;

-- 7.CPU		
select * from laptopdata;																									#####3CPU 
-- making 3 column containg CPU company,Cpu name,speed

alter table laptopdata
add column CPU_brand Varchar(255) after CPU,
add column CPU_Name varchar (255) after CPU_Brand,
Add column CPU_speed varchar(255) after CPU_Name;

select * from laptopdata;

update laptopdata t1
set CPU_brand=(
				select substring_index(cpu," ",1) from
                (select cpu,id from laptopdata) t2
                where t2.id=t1.id
                );

update laptopdata t1
set cpu_name=(
				select replace(replace (Cpu,concat(cpu_brand," "),""),substring_index(cpu," ",-1),"") from 
                (select cpu,id from laptopdata) t2 
                where t1.id=t2.id
                );
-- --update cpu speed
update laptopdata t1
set cpu_speed=(
				select substring_index(cpu," ",-1) from 
                (select cpu,id from laptopdata) t2
                where t1.id=t2.id
                );
SELECT * FROM laptops.laptopdata;
SELECT distinct(CPU_Name) FROM laptops.laptopdata;
update laptopdata										
set cpu_name= substring_index(cpu_name,' ',2);
alter table laptopdata
drop column Cpu;

-- 8.Screen Resolution: 
-- Create Three column 
-- 1. Screen resolution width 
-- 2. screen resolution height 
-- 3. TouchScreen(0/1)

select * from laptopdata;
alter table laptopdata
add column Resolution_width int after ScreenResolution,
add column Resolution_height int after Resolution_width,
add column Touch_screen int after Resolution_height;

update laptopdata t1
set Resolution_height=  (
						select substring_index(substring_index(screenResolution,' ',-1),'x',-1) from 
                        (select screenResolution,id from laptopdata) t2 
                        where t1.id=t2.id
                        );
update laptopdata t1
set Resolution_width=(
						select substring_index(substring_index(screenresolution,' ',-1),'x',1) from 
                        (select screenresolution,id from laptopdata) t2
                        where t1.id=t2.id
                        );
update laptopdata t2
set Touch_Screen = (select 
					case
						when ScreenResolution like"%Touchscreen%" then  1
                        else 0
                        end
                        from 
                        (select screenResolution,id from laptopdata )
                         t1
                        where t1.id=t2.id
                        );
 alter table laptopdata
 drop screenresolution;
 
-- 9. MEMORY	--- three columns 1. memory type(SSD/HDD/FLASH_TORAGE/HYBRID) 2. Primary 3. Secondary		
-- 1. memory type(SSD/HDD/FLASH_TORAGE/HYBRID)

select * from laptopdata;
alter table laptopdata
add column Memory_Type varchar(255) after memory,
add column Primary_storage int after memory_type,
add column Secondry_storage int after primary_storage;

select distinct(memory) from laptopdata;

update laptopdata t1
set memory_type=(SELECT 
			case	
			when memory like '%ssd%' and memory like '%hdd%' then 'Hybrid'
            when memory like '%hybrid%' then 'Hybrid'
            when memory like '%hdd%' and memory like '%flash storage%' then 'Hybrid'
            when memory like '%ssd%' then 'SSD'
            when memory like '%hdd%' then 'HDD'
            when memory like '%flash storage%' then 'Flash Storage'
            else NULL
            end as storage_type
            from (SELECT ID,MEMORY FROM laptopdata) t2 where t1.id=t2.id
            );
             
-- 2. Primary
select MEMORY, regexp_substr(SUBSTRING_INDEX(MEMORY,"+",1),'[0-9]+') as first,
			CASE
				WHEN MEMORY LIKE '%+%' THEN regexp_substr(TRIM(SUBSTRING_INDEX(MEMORY,"+",-1)),'[0-9]+')
                ELSE 0
                END as second
                FROM LAPTOPDATA;
SELECT * FROM laptops.laptopdata;

update laptopdata t1
set primary_storage =(select regexp_substr(SUBSTRING_INDEX(MEMORY,"+",1),'[0-9]+') from 
						(select id,memory from laptopdata ) t2 	
							where t1.id=t2.id
					),
	secondry_storage=(select 
					CASE
					WHEN MEMORY LIKE '%+%' THEN regexp_substr(TRIM(SUBSTRING_INDEX(MEMORY,"+",-1)),'[0-9]+')
					ELSE 0
					END from (select id,memory from laptopdata)t2 where t1.id=t2.id) ;
-- TB to GB
select case
			when primary_storage<=2 then primary_storage*1024
            end,
		case
             when secondry_storage <=2 then secondry_storage*1024
             end
            from laptopdata;
            
update laptopdata t1
set primary_storage = (select case
							when primary_storage<=2 then primary_storage*1024
                            else primary_storage
							end 
                            from(select id,primary_storage from laptopdata) t2 where t1.id=t2.id), 

	secondry_storage=(select case
							 when secondry_storage <=2 then secondry_storage*1024
                             else secondry_storage
							 end from 
                             (select id,secondry_storage from laptopdata) t2 where t1.id=t2.id
                             );
 alter table laptopdata
 drop column memory;
 SELECT * FROM laptops.laptopdata;
            
