create schema Project4;
use Project4;

--	FUNCTIONS EXPLORED - COUNT,GROUPBY,ORDERBY,SUM,LIKE,AFTER TRIGGERS,DELIMITER,TIME,DATE,DISTINCT,CHARLENGTH,MID	--

create table HOSPITAL_ANALYSIS (AGE INT, DATE DATE, GENDER VARCHAR (255), DIAGNOSIS VARCHAR (255), DRUG VARCHAR(255), DOSAGE INT, 
ROUTE VARCHAR (255), FREQUENCY VARCHAR (255), DURATION INT, INDICATION VARCHAR (255), TIME time);

create table AGE_PRIORITY (AGE INT, DETAILS VARCHAR(255));

DELIMITER //
CREATE TRIGGER AGE_ANALYSIS AFTER INSERT ON HOSPITAL_ANALYSIS for each row
BEGIN 
IF NEW.AGE >= 85 THEN
INSERT INTO AGE_PRIORITY ( AGE,DETAILS) VALUES
(NEW.AGE,"PLEASE GIVE EXTRA CARE");
END IF ;
END //
DELIMITER ;

CREATE TABLE ROUTE_PRIORITY (AGE INT,GENDER VARCHAR (255), COMMENTS VARCHAR (255));

DELIMITER //
CREATE TRIGGER ROUTE_DETAILS AFTER INSERT ON HOSPITAL_ANALYSIS for each row
begin
if new.age >= 60 and new.route = 'oral' then
insert into route_priority (age,gender,comments) values
(new.age,new.gender,"medications should be supervised");
end if ;
end //
delimiter ;

CREATE TABLE ROUTE_PRIORITY2 (AGE INT,GENDER VARCHAR (255), COMMENTS VARCHAR (255));

DELIMITER //
CREATE TRIGGER ROUTE_DETAILS2 AFTER INSERT ON HOSPITAL_ANALYSIS for each row
begin
if new.age <= 20 and new.route = 'oral' then
insert into route_priority2 (age,gender,comments) values
(new.age,new.gender,"medications should be supervised");
end if ;
end //
delimiter ;

#CHECKING MY PATIENTS AGE DETAILS#
SELECT * FROM AGE_PRIORITY;

#CHECKING MY ABOVE 60 AGE PATIENTS ROUTE WAYS#
SELECT * FROM ROUTE_PRIORITY;

#CHECKING MY BELOW 20 AGE PATIENTS ROUTE WAYS#
SELECT * FROM ROUTE_PRIORITY2;

#CHECKING ALL MY PATIENTS DETAILS#
SELECT * FROM HOSPITAL_ANALYSIS;

#CHECKING MY PATIENTS WITH GENDER#
SELECT gender, count(gender) as GENDERS from hospital_analysis 
GROUP BY gender;

#MY PATIENTS WITH ACUTE DISEASE#
select indication,gender, count(indication) as symptoms from hospital_analysis where indication like '%acute%'  
group by indication,gender;

#MY PATIENTS WHO ARE TAKING IV HAS MEDICINE ROUTES BY AGE#
select gender,age, count(gender) as iv_route_type from hospital_analysis where route like 'IV%' 
group by gender,age 
order by age;

#MY PATIENTS TOP 3 DRUG#
select drug, count(drug) as COMMON_DRUGS from hospital_analysis 
group by drug 
order by common_drugs desc limit 3;

#MY PATIENTS TAKING MEDICINES FOR ALCOHOL ISSUES#
select gender,age,diagnosis from hospital_analysis where diagnosis like '%alcohol%' 
order by age;

#HOW MANY PATIENTS ARE TAKING DOSAGE THRICE PER DAY#
select gender,frequency, count(frequency) as TDS_ALONE from hospital_analysis where frequency like '%tds%'
 group by gender,frequency;

#PATIENTS WHO WHERE ADMITTED AFTER 14:00 HRS#
select * from hospital_analysis where time(time) > 14;

#HOW MANY PATIENTS ARE TAKING DOSAGE MORE THAN 800GRAMS FOR DURATON MORE THAN 3 DAYS#
select dosage,duration, count(dosage) as AMOUNT from hospital_analysis where (dosage > 800) and duration >3 
group by dosage,duration;

#MAXIMUM DISEASES AMONG MY PATIENTS#
select diagnosis, count(diagnosis) as MAXIMUM from hospital_analysis 
group by diagnosis 
order by MAXIMUM desc limit 2;

#MY PATIENTS WITH CHEST INFECTION ABOVE 60 YEARS OF AGE#
select gender, count(indication) as CHEST_ISSUES from hospital_analysis where (indication like '%chest%') and age > 60 
group by gender,indication 
order by chest_issues desc;

#MY PATIENTS WHO HAS SNAKE BITE#
select age,gender,diagnosis,indication from hospital_analysis where diagnosis like '%snake%';

#MY PATIENTS WITH LIVER ISSUES#
select indication,gender, count(indication) as LIVER_ISSUES from hospital_analysis where indication like '%liver%' 
group by indication,gender 
order by LIVER_ISSUES desc;

#MY PATIENTS TAKING MEDICATIONS TWICE A DAY ABOVE 50 YEARS OF AGE#
select drug,frequency,age from hospital_analysis where (frequency = 'bd') and age > 50;

#MY PATIENTS ACCORDIING TO ANXIETY#
select indication,gender, count(indication) as ANXIETY from hospital_analysis where indication like '%anxiety%' 
group by gender,indication;

#MY PATIENTS WHO WHERE ADMITTED AFTER 16:00 HRS AND ARE FEMALE WITH PNEUMONIA AND ALSO INFECTION#
select gender,indication,diagnosis,TIME  from hospital_analysis where (indication like '%pneumonia%' or indication like '%infection%')
and hour(time) > 16 and gender = 'female';

#MY PATIENTS WITHOUT DUPLICATES  IN TIME#
select count(distinct time) from hospital_analysis;

#MY DIAGNOSED PATIENTS ACCORDING TO GENDER WITHOUT REPEATING ISSUES IN DIAGNOSIS# 
select gender, count(distinct diagnosis) as TOTAL from hospital_analysis 
group by gender;

#MY PATIENTS DRUG SORTINGS ACCORDING TO 10 LETTER DRUGS#
select drug,indication from hospital_analysis where char_length(drug) = 10;

#SPLITTING MY PATIENTS DRUGS FOR MY EASY UNDERSTANDING AND SPACE ISSUES#
select drug,gender, mid(drug,1,5) as EASY_DRUGS from hospital_analysis;

#MY PATIENTS TOTAL DRUGS WITHOUT DUPLICATES ACCORDING TO GENDER#
select gender, count(distinct drug) from hospital_analysis 
group by gender;

#MY PATIENTS TOTAL DRUG CONSUMPTION ACCORDING TO GENDER#
select gender, sum(dosage) as TOTAL_CONSUMPTION from hospital_analysis
group by gender;

#MY PATIENTS WHO ARE GETTING MEDICATIONS THROUGH IV#
select drug, count(if(ROUTE = 'IV', '1', null )) as IV_PATIENTS from hospital_analysis
group by drug order by iv_patients desc;

#MY PATIENTS WHO SUFFERING WITH H1N1 VIRUS#
select age,gender,diagnosis,indication from hospital_analysis where diagnosis like '%H1N1%'
order by age;

#MY PATIENTS WHO ARE TAKING MEDICATIONS FOR MORE THAN 10 DAYS AND ALSO ABOVE 60 YEARS OF AGE#
select age,gender,duration from hospital_analysis where (duration >=10) and age >=60;  

#MY PATIENTS WHO UNDER IM ROUTES WITH GENDER#
select gender, count(route) IM_PATIENTS from hospital_analysis where route like '%IM%' 
group by gender order by IM_PATIENTS;