-- Rename column name
ALTER TABLE aapl_2015_2024_master
RENAME COLUMN ï»¿Date TO Date;

ALTER TABLE amzn_2015_2024_master
RENAME COLUMN ï»¿Date TO Date;

ALTER TABLE msft_2015_2024_master
RENAME COLUMN ï»¿Date TO Date;

ALTER TABLE spx_2015_2024_master
RENAME COLUMN ï»¿Date TO Date;

ALTER TABLE tsla_2015_2024_master
RENAME COLUMN ï»¿Date TO Date;

-- Convert Date Column
ALTER TABLE tsla_2015_2024_master
ADD COLUMN trade_date DATE;

UPDATE tsla_2015_2024_master
SET trade_date = STR_TO_DATE(Date, '%m/%d/%Y');

ALTER TABLE tsla_2015_2024_master
DROP COLUMN Date;

ALTER TABLE tsla_2015_2024_master
CHANGE COLUMN trade_date Date DATE;

-- Reorder New Column
ALTER TABLE tsla_2015_2024_master
MODIFY COLUMN Date DATE FIRST;



SELECT * FROM tsla_2015_2024_master;


