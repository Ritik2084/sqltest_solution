# sqltest_solution
SQL Test Solutions
Approach

All queries were written and executed using MySQL 8.0. Window functions were used for ranking operations, and TIMESTAMPDIFF was used for interval calculations between purchase and refund timestamps. Each question is answered separately and organized within the solution.sql file for easy readability.

Files Included

solution.sql – Complete SQL queries for Q1 to Q8 with comments and proper formatting.

screenshots/ – Output screenshots for each question executed on MySQL Workbench, showing both the query and result grid.

Assumptions

Purchases are considered valid only when refund_time IS NULL (refunds excluded).

Refund eligibility in Q6 is determined by comparing the time difference between purchase and refund timestamps using TIMESTAMPDIFF(HOUR) with a limit of 72 hours.



Notes

No external datasets were used. Only the provided transactions and items tables were referenced.

Date filtering in Q2 considers inclusive start date '2020-10-01' and exclusive end date '2020-11-01'.
