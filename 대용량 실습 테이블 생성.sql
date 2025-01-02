
조인 튜닝시 사용할 대용량 테이블 생성 방법



1. 먼저 아래의 첨부 파일을 다운로드 받습니다.



https://drive.google.com/file/d/1v4lzFULDwBIL1jeBe8HTWMPN0L8B4lk2/view?usp=drive_link





2.  압축을 풀고 sales.csv, times.csv, prodcuts.csv, customers.csv 를 sqldeleoper 를 이용해서 테이블에 입력 할 수 있도록

      미리 테이블 4개를 생성합니다.

create table products
( prod_id number(6,0) not null enable, 
prod_name varchar2(50 byte) not null enable, 
prod_desc varchar2(4000 byte) not null enable, 
prod_subcategory varchar2(50 byte) not null enable, 
prod_subcategory_id number not null enable, 
prod_subcategory_desc varchar2(2000 byte) not null enable, 
prod_category varchar2(50 byte) not null enable, 
prod_category_id number not null enable, 
prod_category_desc varchar2(2000 byte) not null enable, 
prod_weight_class number(3,0) not null enable, 
prod_unit_of_measure varchar2(20 byte), 
prod_pack_size varchar2(30 byte) not null enable, 
supplier_id number(6,0) not null enable, 
prod_status varchar2(20 byte) not null enable, 
prod_list_price number(8,2) not null enable, 
prod_min_price number(8,2) not null enable, 
prod_total varchar2(13 byte) not null enable, 
prod_total_id number not null enable, 
prod_src_id number, 
prod_eff_from date, 
prod_eff_to date, 
prod_valid varchar2(1 byte)  );


create table sales
( prod_id number not null enable, 
cust_id number not null enable, 
time_id date not null enable, 
channel_id number not null enable, 
promo_id number not null enable, 
quantity_sold number(10,2) not null enable, 
amount_sold number(10,2) not null enable, 
prod_name varchar2(50 byte)  ) ;


create table times
( time_id date not null enable, 
day_name varchar2(9 byte) not null enable, 
day_number_in_week number(1,0) not null enable, 
day_number_in_month number(2,0) not null enable, 
calendar_week_number number(2,0) not null enable, 
fiscal_week_number number(2,0) not null enable, 
week_ending_day date not null enable, 
week_ending_day_id number not null enable, 
calendar_month_number number(2,0) not null enable, 
fiscal_month_number number(2,0) not null enable, 
calendar_month_desc varchar2(8 byte) not null enable, 
calendar_month_id number not null enable, 
fiscal_month_desc varchar2(8 byte) not null enable, 
fiscal_month_id number not null enable, 
days_in_cal_month number not null enable, 
days_in_fis_month number not null enable, 
end_of_cal_month date not null enable, 
end_of_fis_month date not null enable, 
calendar_month_name varchar2(9 byte) not null enable, 
fiscal_month_name varchar2(9 byte) not null enable, 
calendar_quarter_desc char(7 byte) not null enable, 
calendar_quarter_id number not null enable, 
fiscal_quarter_desc char(7 byte) not null enable, 
fiscal_quarter_id number not null enable, 
days_in_cal_quarter number not null enable, 
days_in_fis_quarter number not null enable, 
end_of_cal_quarter date not null enable, 
end_of_fis_quarter date not null enable, 
calendar_quarter_number number(1,0) not null enable, 
fiscal_quarter_number number(1,0) not null enable, 
calendar_year number(4,0) not null enable, 
calendar_year_id number not null enable, 
fiscal_year number(4,0) not null enable, 
fiscal_year_id number not null enable, 
days_in_cal_year number not null enable, 
days_in_fis_year number not null enable, 
end_of_cal_year date not null enable, 
end_of_fis_year date not null enable  ); 

 create table customers 
   ( cust_id number not null enable, 
cust_first_name varchar2(20 byte) not null enable, 
cust_last_name varchar2(40 byte) not null enable, 
cust_gender char(1 byte) not null enable, 
cust_year_of_birth number(4,0) not null enable, 
cust_marital_status varchar2(20 byte), 
cust_street_address varchar2(40 byte) not null enable, 
cust_postal_code varchar2(10 byte) not null enable, 
cust_city varchar2(30 byte) not null enable, 
cust_city_id number not null enable, 
cust_state_province varchar2(40 byte) not null enable, 
cust_state_province_id number not null enable, 
country_id number not null enable, 
cust_main_phone_number varchar2(25 byte) not null enable, 
cust_income_level varchar2(30 byte), 
cust_credit_limit number, 
cust_email varchar2(50 byte), 
cust_total varchar2(14 byte) not null enable, 
cust_total_id number not null enable, 
cust_src_id number, 
cust_eff_from date, 
cust_eff_to date, 
cust_valid varchar2(1 byte) );

3. sqldeveloper 를 이용하여 csv 데이터를 입력합니다.





