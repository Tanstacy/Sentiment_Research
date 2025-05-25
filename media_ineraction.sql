create database media_interaction_db;
use media_interaction_db;

DROP TABLE media_interaction;
DROP table media_interaction_set;
DROP table media_interaction_tab;
DROP table media_interactions;
DROP table retweet_by_senti;

CREATE TABLE media_interaction_data (
    TEXT VARCHAR(100),
    SENTIMENT VARCHAR(50),
    PLATFORM VARCHAR(50),
    HASHTAGS VARCHAR(50),
    RETWEETS INT UNSIGNED,  -- Use unsigned to ensure non-negative values
    LIKES INT UNSIGNED,     -- Use unsigned to ensure non-negative values
    COUNTRY VARCHAR(20),
    year INT
);


DESCRIBE media_interaction_data;
-- Modify columns
ALTER TABLE media_interaction_data
    MODIFY COLUMN TEXT VARCHAR(500),
    MODIFY COLUMN RETWEETS INT UNSIGNED,
    MODIFY COLUMN LIKES INT UNSIGNED;



LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\the_pro.csv'
INTO TABLE media_interaction_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(TEXT, SENTIMENT, PLATFORM, HASHTAGS, RETWEETS, LIKES, COUNTRY, year);


#------------------------------AVERAGE RETWEETS BY SENTIMENT----------------------------------------------
select SENTIMENT, AVG(RETWEETS) as AVG_RETWEETS
from media_interaction_data
group by SENTIMENT
order by AVG_RETWEETS desc
limit 20;



#------------------------------RETWEETS BY PLATFORM AND YEAR-------------------------------
SELECT PLATFORM, YEAR ,AVG(RETWEETS) as AVG_RETWEETS
from media_interaction_data
group by YEAR, PLATFORM
order by year DESC , AVG_RETWEETS desc, PLATFORM
limit 20;



#-----------------TOP HASHTAGS BY RETWEETS--------------------------------------
select HASHTAGS , AVG(RETWEETS) as AVG_RETWEETS
from media_interaction_data
group by HASHTAGS
order by AVG_RETWEETS desc
limit 10;

#-----------------------------CONTENT TYPE, SENTIMENT BY COUNTRY-------------------------
select TEXT,SENTIMENT,COUNTRY,COUNT(*) as COUNT
from media_interaction_data
group by COUNTRY, TEXT, SENTIMENT
order by TEXT, SENTIMENT
limit 10;

#---------------------SENTIMENT TRENDS OVERTIME-----------------------------
select SENTIMENT,year,COUNT(*) as COUNT
from media_interaction_data
group by year,SENTIMENT
order by year DESC,SENTIMENT;

#-------------------------SENTIMENT WITH HIGHEST RETWEET OVERTIME-------------------
select SENTIMENT, year ,AVG(RETWEETS) as AVG_RETWEETS
from media_interaction_data
group by year, SENTIMENT
order BY year desc, AVG_RETWEETS desc, SENTIMENT;



#-----------------------------EFFECT OF CONTENT TYPE ON SENTIMENT---------------
select TEXT,SENTIMENT, AVG(RETWEETS) as AVG_RETWEETS
 from media_interaction_data
 group by TEXT,SENTIMENT
 order by AVG_RETWEETS desc, TEXT, SENTIMENT;


#-----------------------------MAXIMUM RETWEETS ON COUNTRY BY YEAR-------------
select year, COUNTRY, AVG(RETWEETS) as AVG_RETWEETS
from media_interaction_data
group by year, COUNTRY
order by year desc,AVG_RETWEETS desc, COUNTRY;


#-----------------------LIKES FOR SENTIMENTS-------------------------
select SENTIMENT, AVG(LIKES) as AVG_LIKES
from media_interaction_data
group by SENTIMENT
order by AVG_LIKES desc;

#------------------------------LIKES FOR SENTIMENTS BY COUNTRY------------
insert into FIL_LIKE_SENTI_COUNTRY
select SENTIMENT, COUNTRY, AVG(LIKES) as AVG_LIKES
from media_interaction_data
group by COUNTRY,SENTIMENT
order by AVG_LIKES desc, COUNTRY, SENTIMENT;

















