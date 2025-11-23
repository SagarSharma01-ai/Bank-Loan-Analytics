use bank_loan_db;
select count(*) from `bank_loan_data`;
select * from `bank_loan_data`;
describe bank_loan_data;



#SET SQL_SAFE_UPDATES = 0; # remove safe mode

UPDATE bank_loan_data
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan_data MODIFY issue_date DATE;

update bank_loan_data
set 
last_credit_pull_date = str_to_date(last_credit_pull_date,'%d-%m-%Y'),
last_payment_date = str_to_date(last_payment_date, '%d-%m-%Y');

alter table bank_loan_data
modify last_credit_pull_date date,
modify last_payment_date date;


update bank_loan_data set next_payment_date = str_to_date(next_payment_date, '%d-%m-%Y');
alter table bank_loan_data modify next_payment_date date;

select * from `bank_loan_data`;
describe bank_loan_data;


-- Total_Loan_Applications
select count(id) as Total_Loan_Applications from bank_loan_data;

-- MTD (Month to Date) Loan Application
select count(id) as MTD_Loan_Applications from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021;

-- PMTD (Previous Month to Date) Loan Application
select count(id) as PMTD_Loan_Applications from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021;

-- Month on Month sale = (MTD- PMTD)/ PMTD

-- Total_Funded_Amount
select sum(loan_amount) as Total_Funded_Amount from bank_loan_data;

-- MTD_Funded_Amount
select sum(loan_amount) as MTD_Funded_Amount from bank_loan_data
where month(issue_date) =12 and Year(issue_date) = 2021;

-- PMTD_Funded_Amount
select sum(loan_amount) as PMTD_Funded_Amount from bank_loan_data
where month(issue_date) =11 and Year(issue_date) = 2021;


-- Total_Amount_Received
select sum(total_payment) as Total_Amount_Received from bank_loan_data;

-- MTD_Amount_Received
select sum(total_payment) as MTD_Amount_Received from bank_loan_data
where month(issue_date) =12 and Year(issue_date) = 2021;

-- PMTD_Amount_Received
select sum(total_payment) as PMTD_Amount_Received from bank_loan_data
where month(issue_date) =11 and Year(issue_date) = 2021;

-- Average Interest Rate
SELECT CAST(AVG(int_rate) * 100 AS DECIMAL(10,2)) AS Avg_interest_rate
FROM bank_loan_data;

-- MTD Average Interest Rate
SELECT CAST(AVG(int_rate) * 100 AS DECIMAL(10,2)) AS MTD_Avg_interest_rate
FROM bank_loan_data
where month(issue_date) =12 and Year(issue_date) = 2021;

-- PMTD Average Interest Rate
SELECT CAST(AVG(int_rate) * 100 AS DECIMAL(10,2)) AS PMTD_Avg_interest_rate
FROM bank_loan_data
where month(issue_date) =11 and Year(issue_date) = 2021;

-- Avg_DTI
select cast(avg(dti) *100 as decimal(10,2)) as Avg_DTI from bank_loan_data;

-- MTD_Avg_DTI
select cast(avg(dti) *100 as decimal(10,2)) as MTD_Avg_DTI from bank_loan_data
where month(issue_date) =12 and Year(issue_date) = 2021;

 -- PMTD_Avg_DTI
select cast(avg(dti) *100 as decimal(10,2)) as PMTD_Avg_DTI from bank_loan_data
where month(issue_date) =11 and Year(issue_date) = 2021;


-- Good Loan Receved Amount
select sum(total_payment) as Good_Loan_Received_Amount from bank_loan_data
where loan_status = "Fully Paid" or loan_status = "Current";


-- Bad Loan Received Percentage
select (count(case when loan_status = 'Charged Off' then id end)*100)/ 
count(id) as Bad_Loan_Perc from bank_loan_data;

-- Bad Loan Applications
select count(id) as Bad_Loan_Applications from bank_loan_data
where loan_Status = 'Charged Off';
 
 -- Bad Loan Funded Amount
select sum(loan_amount) as Bad_Loan_Funded_Amount from bank_loan_data
where loan_Status = 'Charged Off';

-- Bad Loan Receved Amount
select sum(total_payment) as Bad_Loan_Received_Amount from bank_loan_data
where loan_status = "Charged Off";

-- Loan Status Grade View
select loan_status, count(id) as Loan_Count, sum(total_payment) as Total_Amount_Received,
sum(loan_amount) as Total_Funded_Amount,avg(int_rate * 100) as Interest_Rate, avg(dti * 100) as DTI from bank_loan_data
group by loan_status
order by Loan_Count desc;

select loan_status, sum(total_payment) as MTD_Total_Amount_Received,
sum(loan_amount) as MTD_Total_Funded_Amount from bank_loan_data
where month(issue_date) =12
group by loan_status
order by MTD_Total_Amount_Received desc;

select loan_status, sum(total_payment) as PMTD_Total_Amount_Received,
sum(loan_amount) as PMTD_Total_Funded_Amount from bank_loan_data
where month(issue_date) =11
group by loan_status
order by PMTD_Total_Amount_Received desc;

select * from bank_loan_data;

select month(issue_date) AS Month_Number,
date_format(issue_date, '%M') as Month_Name,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by month(issue_date), date_format(issue_date, '%M')
order by month(issue_date);


select address_state,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by address_state
order by count(id) desc;

select term,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by term
order by term; 

select emp_length,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by emp_length
order by Total_Loan_Applicants desc;

select purpose,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by purpose
order by Total_Loan_Applicants desc;

select home_ownership,
count(id) as Total_Loan_Applicants,
sum(total_payment) as Total_Received_Amount,
sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by home_ownership
order by Total_Loan_Applicants desc;