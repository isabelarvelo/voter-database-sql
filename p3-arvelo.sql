-- Isabel Arvelo
-- isabel.c.arvelo@vanderbilt.edu 
-- Project 1 


################################################################################################
################################################################################################
################################################################################################

-- PART 2 -- 
-- Scrolls down to the next set of three lines of hashtags to view Part 3 Code 


/* CREATE the DATABASE */
DROP DATABASE IF EXISTS voterdb;
CREATE DATABASE voterdb;

/* Select the DATABASE */
USE voterdb;

/* Delete the TABLEs if they already exist */
DROP TABLE IF EXISTS meckcountyvoters;

/* CREATE the schema for our TABLE
Each column in the table is defined with a default value of NULL.
This ensures that if no value is provided for a column during data insertion,
it will default to NULL, indicating missing or unspecified information.
*/

CREATE TABLE meckcountyvoters (
	  precinct_desc 		VARCHAR(25)		DEFAULT NULL,
	  party_cd      		VARCHAR(10)		DEFAULT NULL,
	  race_code     		VARCHAR(5)		DEFAULT NULL,
	  ethnic_code   		VARCHAR(5)		DEFAULT NULL,
	  sex_code      		VARCHAR(5)		DEFAULT NULL,
	  age 				  	MEDIUMINT		DEFAULT NULL,
	  pct_portion         	VARCHAR(30)		DEFAULT NULL,
	  first_name          	VARCHAR(30) 	DEFAULT NULL,
	  middle_name         	VARCHAR(30) 	DEFAULT NULL,
	  last_name           	VARCHAR(30) 	DEFAULT NULL,
	  name_suffix_lbl     	VARCHAR(10) 	DEFAULT NULL,
	  full_name_mail      	VARCHAR(100)	DEFAULT NULL,
	  mail_addr1          	VARCHAR(100) 	DEFAULT NULL,
	  mail_addr2          	VARCHAR(100) 	DEFAULT NULL,
	  mail_city_state_zip 	VARCHAR(40) 	DEFAULT NULL,
	  house_num 			MEDIUMINT 		DEFAULT NULL,
	  street_dir     		VARCHAR(1) 		DEFAULT NULL,
	  street_name    		VARCHAR(30) 	DEFAULT NULL,
	  street_type_cd 		VARCHAR(10) 	DEFAULT NULL,
	  street_sufx_cd 		VARCHAR(10) 	DEFAULT NULL,
	  res_city_desc  		VARCHAR(30) 	DEFAULT NULL,
	  state_cd       		VARCHAR(5) 		DEFAULT NULL,
	  zip_code 				MEDIUMINT 		DEFAULT NULL,
	  registr_dt     		DATETIME 		DEFAULT NULL,
	  voter_reg_num   		VARCHAR(20) 	NOT NULL,
	  nc_senate_desc  		VARCHAR(50) 	DEFAULT NULL,
	  nc_house_desc   		VARCHAR(50) 	DEFAULT NULL,
	  e1              		TINYINT 		DEFAULT NULL,
	  e1_date         		DATE 			DEFAULT NULL,
	  e1_votingmethod 		VARCHAR(10) 	DEFAULT NULL,
	  e1_partycd      		VARCHAR(5) 		DEFAULT NULL,
	  e2              		TINYINT 		DEFAULT NULL,
	  e2_date         		DATE 			DEFAULT NULL,
	  e2_votingmethod 		VARCHAR(10) 	DEFAULT NULL,
	  e2_partycd      		VARCHAR(5) 		DEFAULT NULL,
	  e3              		TINYINT 		DEFAULT NULL,
	  e3_date         		DATE 			DEFAULT NULL,
	  e3_votingmethod 		VARCHAR(10) 	DEFAULT NULL,
	  e3_partycd      		VARCHAR(5) 		DEFAULT NULL,
	  e4              		TINYINT 		DEFAULT NULL,
	  e4_date         		DATE 			DEFAULT NULL,
	  e4_votingmethod 		VARCHAR(10) 	DEFAULT NULL,
	  e4_partycd      		VARCHAR(30) 	DEFAULT NULL
 );

/* 
	LOAD data from csv
	For each row in the CSV file, data is mapped to corresponding columns in the table. Each column name listed within the parentheses represents a column in the database table.
    @var_pct_portion, @var_e1_date, @var_e2_date, @var_e3_date, and @var_e4_date are variables used to temporarily store values from the CSV file before they are processed and inserted into the table
	I used this webite as a resource to understand proper usage of local variables: https://www.guru99.com/sql-server-variable.html
    
	The SET section handles specific data transformations and assignments:
	- It converts the local date variables to DATE format using STR_TO_DATE function. This is necessary because the DATE data type 
      requires data in a specific format to be stored correctly in the database
	- It handles NULL values and empty strings and sets them to NULL to ensure consistent data representation 
    - It also handles whitespace and empty strings in the @var_pct_portion variable before assigning it to the pct_portion column
    
    More specific and in depth processing on the data can be done at a later point in time where further context can informd ecisions about how to handle empty strings and missing values across all of 
    the attributes as well as other constraints, but the main goal here is to simply read in the csv data without errors. 
   
*/
LOAD DATA INFILE '/Users/isabelarvelo/Library/Mobile Documents/com~apple~CloudDocs/Desktop/vanderbilt/2024-spring/data-mgmt-systems/voter_data_23.csv'
INTO TABLE meckcountyvoters
FIELDS TERMINATED BY ';' 
ENCLOSED BY '$' 
LINES TERMINATED BY '\r\n'
(precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, @var_pct_portion, first_name, middle_name, last_name, name_suffix_lbl, 
full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, house_num, street_dir, street_name, street_type_cd, street_sufx_cd, 
res_city_desc, state_cd, zip_code, registr_dt, voter_reg_num, nc_senate_desc, nc_house_desc, E1, @var_e1_date, E1_VotingMethod, 
E1_PartyCd, E2, @var_e2_date, E2_VotingMethod, E2_PartyCd, E3, @var_e3_date, E3_VotingMethod, E3_PartyCd, E4, @var_e4_date, E4_VotingMethod, E4_PartyCd)


/* Checks if the value stored in any of the date variables is an empty string ("").
If they is empty, it assigns NULL to the E1_date column.
If @var_e1_date is not empty, it converts the value stored in @var_e1_date to a DATE format */
SET E1_date = IF(@var_e1_date = "", NULL, STR_TO_DATE(@var_e1_date, '%m/%d/%Y')),
	E2_date = IF(@var_e2_date = "", NULL, STR_TO_DATE(@var_e2_date, '%m/%d/%Y')),
    E3_date = IF(@var_e3_date = "", NULL, STR_TO_DATE(@var_e3_date, '%m/%d/%Y')),
    E4_date = IF(@var_e4_date = "", NULL, STR_TO_DATE(@var_e4_date, '%m/%d/%Y')),
    -- If the result of TRIM(@var_pct_portion) is an empty string after trimming whitespace, NULLIF() will return NULL. Otherwise, it will return the trimmed value.
    pct_portion = NULLIF(TRIM(@var_pct_portion), ''),
    precinct_desc = NULLIF(TRIM(precinct_desc), ''),
	party_cd = NULLIF(TRIM(party_cd), ''),
	age = NULLIF(TRIM(age), ''), 
	first_name = NULLIF(TRIM(first_name), ''),
	last_name = NULLIF(TRIM(last_name), ''),
	full_name_mail = NULLIF(TRIM(full_name_mail), ''),
	mail_addr1 = NULLIF(TRIM(mail_addr1), ''),
	mail_city_state_zip = NULLIF(TRIM(mail_city_state_zip), ''),
	house_num = NULLIF(TRIM(house_num), ''),
	street_name = NULLIF(TRIM(street_name), ''),
	res_city_desc = NULLIF(TRIM(res_city_desc), ''),
	state_cd = NULLIF(TRIM(state_cd), ''),
	zip_code = NULLIF(TRIM(zip_code), ''),
	registr_dt = NULLIF(TRIM(registr_dt), ''),
    voter_reg_num = CAST(LTRIM(voter_reg_num) AS UNSIGNED),
--    voter_reg_num = NULLIF(LTRIM(voter_reg_num), ''),
	voter_reg_num = NULLIF(TRIM(voter_reg_num), ''),
	nc_senate_desc = NULLIF(TRIM(nc_senate_desc), ''),
	nc_house_desc = NULLIF(TRIM(nc_house_desc), ''),
	E1 = NULLIF(TRIM(E1), ''),
	E1_VotingMethod = NULLIF(TRIM(E1_VotingMethod), ''),
	E1_PartyCd = NULLIF(TRIM(E1_PartyCd), ''),
	E2 = NULLIF(TRIM(E2), ''),
	E2_VotingMethod = NULLIF(TRIM(E2_VotingMethod), ''),
	E2_PartyCd = NULLIF(TRIM(E2_PartyCd), ''),
	E3 = NULLIF(TRIM(E3), ''),
	E3_VotingMethod = NULLIF(TRIM(E3_VotingMethod), ''),
	E3_PartyCd = NULLIF(TRIM(E3_PartyCd), ''),
	E4 = NULLIF(TRIM(E4), ''),
	E4_VotingMethod = NULLIF(TRIM(E4_VotingMethod), ''),
	E4_PartyCd = NULLIF(TRIM(E4_PartyCd), '');
		
-- Values are automatically made NULL if them missing is meaningful, but for attributes like middle_name, it is valid for
-- a record to not have one so we will allow empty string values for these fields. 

-- Creating miscellaneous table to store bad data that doesn't conform to valid FDs
DROP TABLE IF EXISTS meckcountyvoters_unique;
DROP TABLE IF EXISTS misc_table;
CREATE TABLE meckcountyvoters_unique AS
SELECT *
FROM meckcountyvoters
WHERE voter_reg_num IN (
	SELECT MAX(voter_reg_num)
	FROM meckcountyvoters
	GROUP BY precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, pct_portion, first_name, middle_name, last_name, name_suffix_lbl,
			full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, house_num, street_dir, street_name, street_type_cd, street_sufx_cd,
			res_city_desc, state_cd, zip_code, registr_dt, nc_senate_desc, nc_house_desc, E1, e1_date, E1_VotingMethod,
			E1_PartyCd, E2, e2_date, E2_VotingMethod, E2_PartyCd, E3, e3_date, E3_VotingMethod, E3_PartyCd, E4, e4_date, E4_VotingMethod, E4_PartyCd
) AND voter_reg_num IN (
    SELECT MAX(voter_reg_num)
    FROM meckcountyvoters
	GROUP BY full_name_mail, age, house_num, street_dir, street_name, street_type_cd, street_sufx_cd, zip_code
);

/* INSERTING FIVE FAKE VOTERS TO DEMONSTRATE FUNCTIONALITY*/

INSERT INTO `meckcountyvoters_unique`
(`precinct_desc`, `party_cd`, `race_code`, `ethnic_code`, `sex_code`, `age`, `pct_portion`, `first_name`, `middle_name`, `last_name`, `name_suffix_lbl`, `full_name_mail`, `mail_addr1`, `mail_addr2`, `mail_city_state_zip`, `house_num`, `street_dir`, `street_name`, `street_type_cd`, `street_sufx_cd`, `res_city_desc`, `state_cd`, `zip_code`, `registr_dt`, `voter_reg_num`, `nc_senate_desc`, `nc_house_desc`, `e1`, `e1_date`, `e1_votingmethod`, `e1_partycd`, `e2`, `e2_date`, `e2_votingmethod`, `e2_partycd`, `e3`, `e3_date`, `e3_votingmethod`, `e3_partycd`, `e4`, `e4_date`, `e4_votingmethod`, `e4_partycd`)
VALUES
('PCT 146', 'DEM', 'W', 'HL', 'M', 35, '146.120784', 'JANE', 'FAKE', 'DOE', '', 'JANE FAKE DOE', '123 MAIN ST', 'APT 1B', 'CHARLOTTE NC 28262', 123, 'N', 'FAKESTREET', 'ST', '', 'CHARLOTTE', 'NC', 28262, '2015-01-01 00:00:00', 11, 'NC SENATE DISTRICT 38', 'NC HOUSE DISTRICT 107', 115, '2018-11-06', 'V', 'DEM', 123, '2018-05-08', 'V', 'DEM', 121, '2017-11-07', 'V', 'DEM', 117, '2017-09-12', 'V', 'DEM'),

('PCT 146', 'REP', 'B', 'NL', 'F', 42, '146.120784', 'JOHN', 'FAKE', 'DOE', '', 'JOHN FAKE DOE', '456 ELM ST', 'APT 2B', 'CHARLOTTE NC 28262', 456, 'N', 'FAKESTREET', 'ST', '', 'CHARLOTTE', 'NC', 28262, '2018-03-15 00:00:00', 22, 'NC SENATE DISTRICT 38', 'NC HOUSE DISTRICT 107', 115, '2018-11-06', 'V', 'REP', 123, '2018-05-08', 'V', 'REP', 121, '2017-11-07', 'V', 'REP', 117, '2017-09-12', 'V', 'REP'),

('PCT 146', 'UNA', 'U', 'NL', 'M', 27, '146.120784', 'JULIE', 'FAKE', 'DOE', 'JR', 'JULIE FAKE DOE JR.', '789 OAK RD', 'APT 3B', 'CHARLOTTE NC 28262', 789, 'N', 'FAKESTREET', 'RD', '', 'CHARLOTTE', 'NC', 28262, '2020-09-30 00:00:00', 33, 'NC SENATE DISTRICT 38', 'NC HOUSE DISTRICT 107', 115, '2018-11-06', NULL, NULL, 123, '2018-05-08', NULL, NULL, 121, '2017-11-07', NULL, NULL, 117, '2017-09-12', NULL, NULL),

('PCT 146', 'LIB', 'A', 'NL', 'F', 51, '146.120784', 'JOSEPH', 'FAKE', 'DOE', '', 'JOSEPH FAKE DOE', '321 PINE LN', 'APT 4B', 'CHARLOTTE NC 28262', 321, 'N', 'FAKESTREET', 'LN', '', 'CHARLOTTE', 'NC', 28262, '2012-11-06 00:00:00', 44, 'NC SENATE DISTRICT 38', 'NC HOUSE DISTRICT 107', 115, '2018-11-06', 'V', 'LIB', 123, '2018-05-08', 'V', 'LIB', 121, '2017-11-07', 'V', 'LIB', 117, '2017-09-12', 'V', 'LIB'),

('PCT 146', 'GRE', 'M', 'HL', 'M', 63, '146.120784', 'JESS', 'FAKE', 'DOE', 'SR', 'JESS FAKE DOE', '654 MAPLE AVE', 'UNIT 10', 'CHARLOTTE NC 28262', 654, 'N', 'FAKESTREET', 'AVE', '', 'CHARLOTTE', 'NC', 28262, '2008-07-22 00:00:00', 99, 'NC SENATE DISTRICT 38', 'NC HOUSE DISTRICT 107', 115, '2018-11-06', 'V', 'GRE', 123, '2018-05-08', 'V', 'GRE', 121, '2017-11-07', 'V', 'GRE', 117, '2017-09-12', 'V', 'GRE');



-- Only want to use unique rows from the original table
DROP TABLE IF EXISTS misc_table;
CREATE TABLE misc_table AS
SELECT *
FROM meckcountyvoters
WHERE voter_reg_num NOT IN (
    SELECT voter_reg_num
    FROM meckcountyvoters_unique
);

-- Inserting rows that are missing values for precinct_desc, nc_house_desc, nc_senate_desc, and pct_portion 
-- into the misc table to make sure we are able to uphold referential intergrity in the database 
INSERT INTO misc_table
SELECT *
FROM meckcountyvoters
WHERE (pct_portion IS NULL)
	OR voter_reg_num IN (
		SELECT MIN(voter_reg_num)
		FROM meckcountyvoters_unique
		GROUP BY full_name_mail
		HAVING COUNT(DISTINCT  first_name, middle_name, last_name, name_suffix_lbl) = 2 AND COUNT(DISTINCT age) = 1
    ) OR full_name_mail IN (
		SELECT full_name_mail
		FROM meckcountyvoters_unique
		GROUP BY full_name_mail
		HAVING COUNT(DISTINCT  first_name, middle_name, last_name, name_suffix_lbl) = 2 AND COUNT(DISTINCT age) > 1
    );



SET SQL_SAFE_UPDATES = 0;
DELETE FROM meckcountyvoters_unique
WHERE voter_reg_num IN (
		SELECT voter_reg_num
        FROM misc_table
    );
SET SQL_SAFE_UPDATES = 1;



-- ----------------------------------------------------------------------
-- voter_name 
-- ----------------------------------------------------------------------
CREATE TABLE `voter_name` (
  `first_name` 		VARCHAR(30) ,
  `middle_name` 	VARCHAR(30) ,
  `last_name` 		VARCHAR(30) ,
  `name_suffix_lbl` VARCHAR(30) ,
  `full_name_mail` VARCHAR(100),
  PRIMARY KEY(`full_name_mail`)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------
-- Table `city_state`
-- ----------------------------------------------------------------------
CREATE TABLE `city_state` (
    `zip_code` MEDIUMINT NOT NULL,
    `city` VARCHAR(30),
    `state_cd` VARCHAR(5) ,
    PRIMARY KEY (`zip_code`)
)  ENGINE=INNODB;



-- ----------------------------------------------------------------------
-- Table `precinct_senate`
-- ----------------------------------------------------------------------
CREATE TABLE `nc_senate_desc` (
  `precinct_desc` 	VARCHAR(30) NOT NULL,
  `nc_senate_desc` 	VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`precinct_desc`)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------
-- Table `precinct_senate`
-- ----------------------------------------------------------------------
CREATE TABLE `nc_house_desc` (
  `pct_portion` 	VARCHAR(30) NOT NULL,
  `precinct_desc` 	VARCHAR(25) NOT NULL,
  `nc_house_desc` 	VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`pct_portion`),
  CONSTRAINT `fk_precinct_desc`
	FOREIGN KEY (`precinct_desc`)
	REFERENCES `nc_senate_desc` (`precinct_desc`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------
-- Table `voter_mailing_address`
-- ----------------------------------------------------------------------
CREATE TABLE `voter_mailing_address` (
  `full_name_mail` VARCHAR(100) NOT NULL,
  `mail_addr1` VARCHAR(100) NOT NULL,
  `mail_addr2` VARCHAR(100) DEFAULT NULL,
  `mail_city_state_zip` VARCHAR(40) DEFAULT NULL,
  PRIMARY KEY (`full_name_mail`, `mail_addr1`)
) ENGINE=InnoDB;


-- ----------------------------------------------------------------------
-- Table `address_pct_portion`
-- ----------------------------------------------------------------------
CREATE TABLE `address_pct_portion` (
    `house_num` MEDIUMINT,
	`street_dir` VARCHAR(1) ,
	`street_name` VARCHAR(30) ,
	`street_type_cd` VARCHAR(10) ,
	`street_sufx_cd` VARCHAR(10) ,
	`zip_code` MEDIUMINT ,
    `pct_portion` 	VARCHAR(30) NOT NULL,
  PRIMARY KEY (`house_num`,`street_dir`,`street_name`, `street_type_cd`,`street_sufx_cd`,`zip_code`),
  CONSTRAINT `fk_pct_portion`
	FOREIGN KEY (`pct_portion`)
	REFERENCES `nc_house_desc` (`pct_portion`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
) ENGINE=InnoDB;



-- ----------------------------------------------------------------------
-- Table `voter` 
-- ----------------------------------------------------------------------
CREATE TABLE `voter` (
    `voter_reg_num` VARCHAR(20) NOT NULL,
    `age` MEDIUMINT DEFAULT NULL,
    `registr_dt` DATETIME NOT NULL,
    `party_cd` VARCHAR(10) ,
    `race_code` VARCHAR(5) ,
    `ethnic_code` VARCHAR(5) ,
    `sex_code` VARCHAR(5) ,
    `house_num` MEDIUMINT ,
    `street_dir` VARCHAR(1) ,
    `street_name` VARCHAR(30) ,
    `street_type_cd` VARCHAR(10) ,
    `street_sufx_cd` VARCHAR(10) ,
    `zip_code` MEDIUMINT ,
    `mail_addr1` VARCHAR(100) ,
	`full_name_mail` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`voter_reg_num`),
    CONSTRAINT `fk_full_name`
        FOREIGN KEY (`full_name_mail`)
        REFERENCES `voter_name` (`full_name_mail`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_voter_mailing`
        FOREIGN KEY (`full_name_mail`, `mail_addr1`)
        REFERENCES `voter_mailing_address` (`full_name_mail`, `mail_addr1`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT `fk_address_portion`
        FOREIGN KEY (`house_num`, `street_dir`,`street_name`, `street_type_cd`,`street_sufx_cd`,`zip_code`)
        REFERENCES `address_pct_portion` (`house_num`, `street_dir`,`street_name`, `street_type_cd`,`street_sufx_cd`,`zip_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_zip_code`
        FOREIGN KEY (`zip_code`)
        REFERENCES `city_state` (`zip_code`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=INNODB;


-- ----------------------------------------------------------------------
-- Table `election_info`
-- ----------------------------------------------------------------------
CREATE TABLE `election_info` (
  `election_number` TINYINT NOT NULL, 
  `election_date` DATE DEFAULT NULL,
  PRIMARY KEY (`election_number`)
) ENGINE=InnoDB;

  -- ----------------------------------------------------------------------
-- Table `election_votes`
-- ----------------------------------------------------------------------
CREATE TABLE `election_votes` (
  `voter_reg_num` VARCHAR(20) NOT NULL,
  `election_number` TINYINT NOT NULL,
  `voting_method` VARCHAR(10) DEFAULT NULL,
  `party_cd` VARCHAR(5) DEFAULT NULL,
  PRIMARY KEY (`voter_reg_num`, `election_number`),
  CONSTRAINT `fk_voter`
    FOREIGN KEY (`voter_reg_num`)
    REFERENCES `voter` (`voter_reg_num`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_election_info`
    FOREIGN KEY (`election_number`)
    REFERENCES `election_info` (`election_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;


-- CREATING INDEXES ON FOREIGN KEYS OF VOTER TO MAKE INSERT STATEMENTS FASTER

CREATE INDEX idx_voter_full_name_mail_address ON voter (full_name_mail, mail_addr1);
CREATE INDEX idx_voter_zip ON voter (zip_code);


-- INSERTING DATA INTO TABLES

INSERT INTO `voter_name` (`first_name`, `middle_name`, `last_name`, `name_suffix_lbl`, `full_name_mail`)
SELECT DISTINCT `first_name`, `middle_name`, `last_name`, `name_suffix_lbl`, `full_name_mail`
FROM `meckcountyvoters_unique`;

-- Populate the `city_state` table
INSERT INTO `city_state` (`zip_code`, `city`, `state_cd`)
SELECT DISTINCT `zip_code`, `res_city_desc`, `state_cd`
FROM `meckcountyvoters_unique`
WHERE `zip_code` IS NOT NULL;


-- Populate the `voter_mailing_address` table
INSERT INTO `voter_mailing_address` (`full_name_mail`, `mail_addr1`, `mail_addr2`, `mail_city_state_zip`)
SELECT DISTINCT `full_name_mail`, `mail_addr1`, `mail_addr2`, `mail_city_state_zip`
FROM `meckcountyvoters_unique`
WHERE `full_name_mail` IN (SELECT `full_name_mail` FROM `voter_name`);

-- Populate the `nc_senate_desc` table
INSERT INTO `nc_senate_desc` (`precinct_desc`, `nc_senate_desc`)
SELECT DISTINCT `precinct_desc`, `nc_senate_desc`
FROM `meckcountyvoters_unique`
WHERE `precinct_desc` IS NOT NULL AND `nc_senate_desc` IS NOT NULL;


-- Populate the `nc_house_desc` table
INSERT INTO `nc_house_desc` (`pct_portion`, `precinct_desc`, `nc_house_desc`)
SELECT DISTINCT `pct_portion`, `precinct_desc`, `nc_house_desc`
FROM `meckcountyvoters_unique`
WHERE `pct_portion` IS NOT NULL AND `precinct_desc` IS NOT NULL AND `nc_house_desc` IS NOT NULL;

-- Populate the `address_pct_portion` table
INSERT INTO `address_pct_portion` (`house_num`, `street_dir`, `street_name`, `street_type_cd`, `street_sufx_cd`, `zip_code`, `pct_portion`)
SELECT DISTINCT `house_num`, `street_dir`, `street_name`, `street_type_cd`, `street_sufx_cd`, `zip_code`, `pct_portion`
FROM `meckcountyvoters_unique`;

-- Populate the `voter` table
INSERT INTO `voter` (`voter_reg_num`, `age`, `registr_dt`, `party_cd`,  `race_code`, `ethnic_code`, `sex_code`, `house_num`, `street_dir`, `street_name`, `street_type_cd`, `street_sufx_cd`, `zip_code`, `mail_addr1`, `full_name_mail`)
SELECT DISTINCT `voter_reg_num`, `age`, `registr_dt`, `party_cd`,  `race_code`, `ethnic_code`, `sex_code`, `house_num`, `street_dir`, `street_name`, `street_type_cd`, `street_sufx_cd`, `zip_code`, `mail_addr1`, `full_name_mail`
FROM `meckcountyvoters_unique`;

-- Populate the `election_info` table
INSERT INTO `election_info` (`election_number`, `election_date`)
SELECT DISTINCT `e1`, `e1_date`
FROM `meckcountyvoters_unique` 
WHERE `e1_date` IS NOT NULL
UNION ALL
SELECT DISTINCT `e2`, `e2_date`
FROM `meckcountyvoters_unique`
WHERE `e2_date` IS NOT NULL
UNION ALL
SELECT DISTINCT `e3`, `e3_date`
FROM `meckcountyvoters_unique`
WHERE `e3_date` IS NOT NULL
UNION ALL
SELECT DISTINCT `e4`, `e4_date`
FROM `meckcountyvoters_unique`
WHERE `e4_date` IS NOT NULL;

SELECT DISTINCT `e4`, `e4_date`
FROM `meckcountyvoters_unique`
WHERE `e4_date` IS NOT NULL;

-- Populate the `election_votes` table for election 1
INSERT INTO `election_votes` (`voter_reg_num`, `election_number`, `voting_method`, `party_cd`)
SELECT `voter_reg_num`, `e1`, `e1_votingmethod`, `e1_partycd`
FROM `meckcountyvoters_unique`
WHERE `e1_votingmethod` IS NOT NULL AND `e1_partycd` IS NOT NULL;

-- Populate the `election_votes` table for election 2
INSERT INTO `election_votes` (`voter_reg_num`, `election_number`, `voting_method`, `party_cd`)
SELECT `voter_reg_num`, `e2`, `e2_votingmethod`, `e2_partycd`
FROM `meckcountyvoters_unique`
WHERE `e2_votingmethod` IS NOT NULL AND `e2_partycd` IS NOT NULL;

-- Populate the `election_votes` table for election 3
INSERT INTO `election_votes` (`voter_reg_num`, `election_number`, `voting_method`, `party_cd`)
SELECT `voter_reg_num`, `e3`, `e3_votingmethod`, `e3_partycd`
FROM `meckcountyvoters_unique`
WHERE `e3_votingmethod` IS NOT NULL AND `e3_partycd` IS NOT NULL;

-- Populate the `election_votes` table for election 4
INSERT INTO `election_votes` (`voter_reg_num`, `election_number`, `voting_method`, `party_cd`)
SELECT `voter_reg_num`, `e4`, `e4_votingmethod`, `e4_partycd`
FROM `meckcountyvoters_unique`
WHERE `e4_votingmethod` IS NOT NULL AND `e4_partycd` IS NOT NULL;

-- ----------------------------------------------------------------------
-- COUNT STATEMENTS
-- ----------------------------------------------------------------------

SELECT COUNT(*)
FROM voter;

SELECT COUNT(*)
FROM voter_name;

SELECT COUNT(*)
FROM voter_mailing_address;

SELECT COUNT(*)
FROM city_state;

SELECT COUNT(*)
FROM nc_house_desc;

SELECT COUNT(*)
FROM nc_senate_desc;

SELECT COUNT(*)
FROM address_pct_portion;

SELECT COUNT(*)
FROM election_votes;

SELECT COUNT(*)
FROM election_info;

-- Excluded Data Count: 290
SELECT COUNT(*)
FROM misc_table;

-- Cleaned Data Count: 383107
SELECT COUNT(*)
FROM meckcountyvoters_unique;

-- ----------------------------------------------------------------------
-- JOIN STATEMENT TO RECONSTRUCT ORIGINAL TABLE 
-- ----------------------------------------------------------------------

-- Original Table (Not including Data Irregularities)
SELECT 
    v.voter_reg_num,
    v.age,
    v.registr_dt,
    v.party_cd,
    v.race_code,
    v.ethnic_code,
    v.sex_code,
    ap.pct_portion,
    vn.first_name,
    vn.middle_name,
    vn.last_name,
    vn.name_suffix_lbl,
    v.full_name_mail,
    v.mail_addr1,
    vma.mail_addr2,
    vma.mail_city_state_zip,
    v.house_num,
    v.street_dir,
    v.street_name,
    v.street_type_cd,
    v.street_sufx_cd,
    cs.city AS res_city_desc,
    cs.state_cd,
    v.zip_code,
    v.registr_dt,
    nss.nc_senate_desc,
    nhs.nc_house_desc,
    ev1.election_number AS e1,
    e1.election_date AS e1_date,
    ev1.voting_method AS e1_votingmethod,
    ev1.party_cd AS e1_partycd,
    ev2.election_number AS e2,
    e2.election_date AS e2_date,
    ev2.voting_method AS e2_votingmethod,
    ev2.party_cd AS e2_partycd,
    ev3.election_number AS e3,
    e3.election_date AS e3_date,
    ev3.voting_method AS e3_votingmethod,
    ev3.party_cd AS e3_partycd,
    ev4.election_number AS e4,
    e4.election_date AS e4_date,
    ev4.voting_method AS e4_votingmethod,
    ev4.party_cd AS e4_partycd
FROM 
    voter v
    JOIN voter_name vn ON v.full_name_mail = vn.full_name_mail
    JOIN city_state cs ON v.zip_code = cs.zip_code
    JOIN voter_mailing_address vma ON v.full_name_mail = vma.full_name_mail AND v.mail_addr1 = vma.mail_addr1
    JOIN address_pct_portion ap ON v.house_num = ap.house_num AND v.street_dir = ap.street_dir AND v.street_name = ap.street_name AND v.street_type_cd = ap.street_type_cd AND v.street_sufx_cd = ap.street_sufx_cd AND v.zip_code = ap.zip_code
    JOIN nc_house_desc nhs ON ap.pct_portion = nhs.pct_portion
    JOIN nc_senate_desc nss ON nhs.precinct_desc = nss.precinct_desc
    LEFT JOIN election_votes ev1 ON v.voter_reg_num = ev1.voter_reg_num AND ev1.election_number = (SELECT election_number FROM election_info WHERE election_number = 115)
    LEFT JOIN election_info e1 ON ev1.election_number = e1.election_number
    LEFT JOIN election_votes ev2 ON v.voter_reg_num = ev2.voter_reg_num AND ev2.election_number = (SELECT election_number FROM election_info WHERE election_number = 123)
    LEFT JOIN election_info e2 ON ev2.election_number = e2.election_number
    LEFT JOIN election_votes ev3 ON v.voter_reg_num = ev3.voter_reg_num AND ev3.election_number = (SELECT election_number FROM election_info WHERE election_number = 121)
    LEFT JOIN election_info e3 ON ev3.election_number = e3.election_number
    LEFT JOIN election_votes ev4 ON v.voter_reg_num = ev4.voter_reg_num AND ev4.election_number = (SELECT election_number FROM election_info WHERE election_number = 117)
    LEFT JOIN election_info e4 ON ev4.election_number = e4.election_number; 
 
 -- Count Statement to Verify
SELECT COUNT(*)
FROM 
    voter v
    JOIN voter_name vn ON v.full_name_mail = vn.full_name_mail
    JOIN city_state cs ON v.zip_code = cs.zip_code
    JOIN voter_mailing_address vma ON v.full_name_mail = vma.full_name_mail AND v.mail_addr1 = vma.mail_addr1
    JOIN address_pct_portion ap ON v.house_num = ap.house_num AND v.street_dir = ap.street_dir AND v.street_name = ap.street_name AND v.street_type_cd = ap.street_type_cd AND v.street_sufx_cd = ap.street_sufx_cd AND v.zip_code = ap.zip_code
    JOIN nc_house_desc nhs ON ap.pct_portion = nhs.pct_portion
    JOIN nc_senate_desc nss ON nhs.precinct_desc = nss.precinct_desc
    LEFT JOIN election_votes ev1 ON v.voter_reg_num = ev1.voter_reg_num AND ev1.election_number = (SELECT election_number FROM election_info WHERE election_number = 115)
    LEFT JOIN election_info e1 ON ev1.election_number = e1.election_number
    LEFT JOIN election_votes ev2 ON v.voter_reg_num = ev2.voter_reg_num AND ev2.election_number = (SELECT election_number FROM election_info WHERE election_number = 123)
    LEFT JOIN election_info e2 ON ev2.election_number = e2.election_number
    LEFT JOIN election_votes ev3 ON v.voter_reg_num = ev3.voter_reg_num AND ev3.election_number = (SELECT election_number FROM election_info WHERE election_number = 121)
    LEFT JOIN election_info e3 ON ev3.election_number = e3.election_number
    LEFT JOIN election_votes ev4 ON v.voter_reg_num = ev4.voter_reg_num AND ev4.election_number = (SELECT election_number FROM election_info WHERE election_number = 117)
    LEFT JOIN election_info e4 ON ev4.election_number = e4.election_number; 
  
-- Output is: 383107 which matches the total number of records after exclusions in misc_table (matches count for number of rows 
-- in meckcountyvoter_unique 


-- In order to add back the bad data/data with irregularities from the misc table tor econstruct the table in the csv, 
-- we can use a union. 

SELECT COUNT(*)
FROM (
	SELECT 
    v.voter_reg_num,
    v.age,
    v.registr_dt,
    v.party_cd,
    v.race_code,
    v.ethnic_code,
    v.sex_code,
    v.house_num,
    v.street_dir,
    v.street_name,
    v.street_type_cd,
    v.street_sufx_cd,
    v.zip_code,
    v.mail_addr1,
    v.full_name_mail,
    vn.first_name,
    vn.middle_name,
    vn.last_name,
    vn.name_suffix_lbl,
    cs.city AS res_city_desc,
    cs.state_cd,
    vma.mail_addr2,
    vma.mail_city_state_zip,
    nhs.precinct_desc,
    nhs.nc_house_desc,
    nss.nc_senate_desc,
    ap.pct_portion,
    e1.election_number AS e1,
    e1.election_date AS e1_date,
    ev1.voting_method AS e1_votingmethod,
    ev1.party_cd AS e1_partycd,
	e2.election_number AS e2,
    e2.election_date AS e2_date,
    ev2.voting_method AS e2_votingmethod,
    ev2.party_cd AS e2_partycd,
	e3.election_number AS e3,
    e3.election_date AS e3_date,
    ev3.voting_method AS e3_votingmethod,
    ev3.party_cd AS e3_partycd,
	e4.election_number AS e4,
    e4.election_date AS e4_date,
    ev4.voting_method AS e4_votingmethod,
    ev4.party_cd AS e4_partycd
FROM 
    voter v
    JOIN voter_name vn ON v.full_name_mail = vn.full_name_mail
    JOIN city_state cs ON v.zip_code = cs.zip_code
    JOIN voter_mailing_address vma ON v.full_name_mail = vma.full_name_mail AND v.mail_addr1 = vma.mail_addr1
    JOIN address_pct_portion ap ON v.house_num = ap.house_num AND v.street_dir = ap.street_dir AND v.street_name = ap.street_name AND v.street_type_cd = ap.street_type_cd AND v.street_sufx_cd = ap.street_sufx_cd AND v.zip_code = ap.zip_code
    JOIN nc_house_desc nhs ON ap.pct_portion = nhs.pct_portion
    JOIN nc_senate_desc nss ON nhs.precinct_desc = nss.precinct_desc
    LEFT JOIN election_votes ev1 ON v.voter_reg_num = ev1.voter_reg_num AND ev1.election_number = 115
    LEFT JOIN election_info e1 ON ev1.election_number = e1.election_number
    LEFT JOIN election_votes ev2 ON v.voter_reg_num = ev2.voter_reg_num AND ev2.election_number = 123
    LEFT JOIN election_info e2 ON ev2.election_number = e2.election_number
    LEFT JOIN election_votes ev3 ON v.voter_reg_num = ev3.voter_reg_num AND ev3.election_number = 121
    LEFT JOIN election_info e3 ON ev3.election_number = e3.election_number
    LEFT JOIN election_votes ev4 ON v.voter_reg_num = ev4.voter_reg_num AND ev4.election_number = 117
    LEFT JOIN election_info e4 ON ev4.election_number = e4.election_number
	UNION
	SELECT *
	FROM misc_table 
) combined;

-- Output is: 383397 which is the same number of rows in the original data from the csv

################################################################################################
################################################################################################
################################################################################################

-- PART 3 

-- ----------------------------------------------------------------------
-- Search Voter History
-- ----------------------------------------------------------------------

DROP procedure IF EXISTS get_voting_record;

-- We need to specify a delimiter to separates individual statements within the larger so
-- that MySQL can interpret and execute the stored procedure correctly

DELIMITER // 

CREATE PROCEDURE get_voting_record(
	IN query_voter_reg_num INT)

BEGIN 

SELECT election_number AS "election_ID", 
	voting_method, 
    party_cd
FROM election_votes
-- matching the voter_reg_num passed in by the user to the voting record
WHERE voter_reg_num = query_voter_reg_num; 

END //

DELIMITER ;

-- Call Statment to Make Sure Stored Procedure Returns Expected Output: 
-- CALL get_voting_record(131);



-- ----------------------------------------------------------------------
-- Insert Voter
-- ----------------------------------------------------------------------

-- Insert Voter Stored Procedure 

DROP PROCEDURE IF EXISTS insert_record;
DELIMITER //

CREATE PROCEDURE insert_record(
    IN query_voter_reg_num INT,
    IN query_election_id VARCHAR(25),
    IN query_voting_method VARCHAR(10),
    IN query_election_party_cd VARCHAR(10),
    OUT msg VARCHAR(100)
)
BEGIN
    -- Declare a variable to track SQL errors
    DECLARE sql_error INT DEFAULT 0;
    
    DECLARE record_exists INT;
    DECLARE actual_election_num TINYINT DEFAULT 0;
    DECLARE voter_exists INT;

    -- Convert election identifier to election number to match its value in the data 
    CASE query_election_id
        WHEN 'E1' THEN SET actual_election_num = 115;
        WHEN 'E2' THEN SET actual_election_num = 123;
        WHEN 'E3' THEN SET actual_election_num = 121;
        WHEN 'E4' THEN SET actual_election_num = 117;
    END CASE;

    START TRANSACTION;

    -- Check if the voter exists in the voter table
    SELECT COUNT(*) INTO voter_exists
    FROM voter
    WHERE voter_reg_num = query_voter_reg_num;

    IF voter_exists = 0 THEN
        SET msg = 'Insert Failed. There is no voter registered under that number.';
    ELSE
        -- Check if a record already exists for the given voter and election
        SELECT COUNT(*) INTO record_exists
        FROM election_votes
        WHERE voter_reg_num = query_voter_reg_num
        AND election_number = actual_election_num;

        -- Conditionally insert or update data based on existence of the record
        IF record_exists = 0 THEN
            INSERT INTO election_votes (voter_reg_num, election_number, voting_method, party_cd)
            VALUES (query_voter_reg_num, actual_election_num, query_voting_method, query_election_party_cd);
            SET msg = 'New record inserted successfully.';
        ELSE
            UPDATE election_votes
            SET voting_method = query_voting_method,
                party_cd = query_election_party_cd
            WHERE voter_reg_num = query_voter_reg_num
            AND election_number = actual_election_num;
            SET msg = 'Existing record updated successfully.';
        END IF;
    END IF;

    -- Check if there were any SQL errors and commit or rollback accordingly
    IF sql_error = 0 THEN
        COMMIT;
    ELSE
        ROLLBACK;
        SET msg = CONCAT(msg, ' Transaction rolled back.');
    END IF;
END //

DELIMITER ;



-- Audit Insert Table to store	all	the	inserted values	with a timestamp of insertion

DROP TABLE IF EXISTS audit_insert;

CREATE TABLE audit_insert (
  audit_id 				INT    	NOT NULL  AUTO_INCREMENT, 
  voter_reg_num			INT  	NOT NULL,
  election_number 		TINYINT NOT NULL,
  voting_method 		VARCHAR(10),
  party_cd 				VARCHAR(10) ,
  insertion_date       	DATETIME DEFAULT NULL,
  PRIMARY KEY (audit_id)
); 


-- Trigger for BEFORE Insert: Changes the Party	code to	'N/A' if the passed value from	
-- the	web	form doesn’t match	with any of	the	party codes ('DEM', 'REP', 'UNA', 'LIB', 'GRE', 'CST')

DROP TRIGGER IF EXISTS insert_person;

DELIMITER //
CREATE TRIGGER insert_person
BEFORE INSERT ON election_votes
FOR EACH ROW 
BEGIN
    IF NEW.party_cd NOT IN ('DEM', 'REP', 'UNA', 'LIB', 'GRE', 'CST') THEN
        SET NEW.party_cd = 'N/A';
    END IF;
END;

//
DELIMITER ;



-- Trigger for BEFORE Update: Changes the Party	code to	'N/A' if the passed value from	
-- the	web	form doesn’t match	with any of	the	party codes ('DEM', 'REP', 'UNA', 'LIB', 'GRE', 'CST')

DROP TRIGGER IF EXISTS update_person;
DELIMITER //
CREATE TRIGGER update_person
BEFORE UPDATE ON election_votes
FOR EACH ROW 
BEGIN
    IF NEW.party_cd NOT IN ('DEM', 'REP', 'UNA', 'LIB', 'GRE', 'CST') THEN
        SET NEW.party_cd = 'N/A';
    END IF;
END;
//
DELIMITER ;



-- Trigger to Populate Audit Insert Table After Update 

DROP TRIGGER IF EXISTS election_votes_after_update;

DELIMITER //
CREATE TRIGGER election_votes_after_update
AFTER UPDATE ON election_votes
FOR EACH ROW 
BEGIN
    INSERT INTO audit_insert (
        voter_reg_num,
        election_number,
        voting_method,
        party_cd,
        insertion_date
    ) VALUES (
        NEW.voter_reg_num, 
        NEW.election_number, 
        NEW.voting_method, 
        NEW.party_cd,
        NOW()
    );
END;
//
DELIMITER ;


-- Trigger to Populate Audit Insert Table After Insert 

DROP TRIGGER IF EXISTS election_votes_after_insert;
DELIMITER //
CREATE TRIGGER election_votes_after_insert
AFTER INSERT ON election_votes
FOR EACH ROW 
BEGIN
    INSERT INTO audit_insert (
        voter_reg_num,
        election_number,
        voting_method,
        party_cd,
        insertion_date
    ) VALUES (
        NEW.voter_reg_num, 
        NEW.election_number, 
        NEW.voting_method, 
        NEW.party_cd,
        NOW()
    );
END;

//
DELIMITER ;


-- ----------------------------------------------------------------------
-- Delete Voter 
-- ----------------------------------------------------------------------

-- Delete Voter Stored Procedure

DROP PROCEDURE IF EXISTS delete_voter;

DELIMITER //

CREATE PROCEDURE delete_voter(
    IN query_voter_reg_num VARCHAR(20)
)
BEGIN
	-- Declare variables to store voter information
	DECLARE voter_full_name VARCHAR(255);
	DECLARE voter_mail_addr1 VARCHAR(255);
    DECLARE voter_count INT;
    
    -- Declare a variable to track SQL errors
    DECLARE sql_error INT DEFAULT 0;
    
    -- Declare an exit handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        GET DIAGNOSTICS CONDITION 1 @sql_state = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SET sql_error = 1;
        ROLLBACK;
        SELECT @sql_state AS sql_state, @errno AS errno, @text AS error_text;
    END;
    
    -- Retrieve voter's full name and mailing address
    SELECT full_name_mail, mail_addr1
    INTO voter_full_name, voter_mail_addr1
    FROM voter
    WHERE voter_reg_num = query_voter_reg_num;
    
    -- Count the number of voters with the same full name
	SELECT COUNT(*)
	INTO voter_count
	FROM voter
	WHERE full_name_mail = voter_full_name;

	-- Start a transaction to ensure atomicity of the delete operations
    START TRANSACTION;
    
    -- Delete the voter record
    DELETE FROM voter WHERE voter_reg_num = query_voter_reg_num;
    
    -- Delete the voter's election votes
	DELETE FROM election_votes WHERE voter_reg_num = query_voter_reg_num;
    
    -- Delete the voter's mailing address
    DELETE FROM voter_mailing_address WHERE full_name_mail = voter_full_name AND mail_addr1 = voter_mail_addr1;
    
    -- If the voter is the only one with the given full name, delete the voter name record
    IF voter_count = 1 THEN
		DELETE FROM voter_name
		WHERE full_name_mail = voter_full_name;
    END IF;
    
    -- Check if any SQL errors occurred during the delete operations
    IF sql_error = 0 THEN
        COMMIT;
        SELECT 'Delete committed, check audit_delete table.';
    ELSE
        SELECT 'Rollback occurred, delete not committed.';
    END IF;

END //

DELIMITER ;

-- Call statement to ensure the stored procedure works correctly
-- CALL delete_voter_records(1000195395);

-- DELETE VOTER AUDIT TABLE

DROP TABLE IF EXISTS audit_delete;

CREATE TABLE audit_delete (
    audit_id INT NOT NULL AUTO_INCREMENT,
    voter_reg_num VARCHAR(20) NOT NULL,
    full_name_mail VARCHAR(100),
	party_cd VARCHAR(10),
    registr_dt DATETIME,
    sex_code VARCHAR(5),
    delete_timestamp DATETIME DEFAULT NULL,
    PRIMARY KEY (audit_id)
);



-- Trigger BEFORE Delete Voter 
DELIMITER //

DROP TRIGGER IF EXISTS voter_before_delete //

CREATE TRIGGER voter_before_delete
BEFORE DELETE ON voter
FOR EACH ROW
BEGIN
    INSERT INTO audit_delete (
        voter_reg_num,
        full_name_mail,
        party_cd,
        registr_dt,
        sex_code,
        delete_timestamp
    )
    VALUES (
        OLD.voter_reg_num,
        OLD.full_name_mail,
        OLD.party_cd,
        OLD.registr_dt,
        OLD.sex_code,
        NOW()
    );
END //

DELIMITER ;


-- ----------------------------------------------------------------------
-- Analytics
-- ----------------------------------------------------------------------

-- constituents_stats
CREATE OR REPLACE VIEW constituent_stats AS
SELECT 	party_cd,
		COUNT(*),
		ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM voter), 4) AS percentage
FROM voter
GROUP BY party_cd
ORDER BY COUNT(*) DESC;

SELECT * FROM constituent_stats;
    
-- dem_region_stats
CREATE OR REPLACE VIEW dem_region_stats_1 AS
SELECT  cs.city AS res_city_desc,
		COUNT(*),
		ROUND(COUNT(*) * 100.0 / (SELECT COUNT(voter_reg_num) FROM voter WHERE party_cd = 'DEM'), 4) AS percentage
FROM election_votes ev
    LEFT JOIN voter v ON v.voter_reg_num = ev.voter_reg_num
    LEFT JOIN city_state cs ON cs.zip_code = v.zip_code
WHERE v.voter_reg_num IN (
        SELECT voter_reg_num
        FROM voter
        WHERE party_cd = 'DEM'
    )
GROUP BY cs.city
ORDER BY COUNT(*) DESC;



-- dem gender_stats 
CREATE OR REPLACE VIEW dem_gender_stats AS
SELECT  v.sex_code AS sex_code,
		COUNT(sex_code),
		ROUND(COUNT(*) * 100.0 / (SELECT COUNT(voter_reg_num) FROM voter WHERE party_cd = 'DEM'), 4) AS percentage
FROM voter v
WHERE v.voter_reg_num IN (
        SELECT voter_reg_num
        FROM voter
        WHERE party_cd = 'DEM'
    )
GROUP BY v.sex_code
ORDER BY COUNT(sex_code) DESC;


-- Switched Election Stored Procedure 

DROP PROCEDURE IF EXISTS switched_election;

DELIMITER //

CREATE PROCEDURE switched_election(
    IN query_election_id INT,
    IN query_election_party_cd VARCHAR(10)
)
BEGIN
	-- Declare a variable to track SQL errors
    DECLARE sql_error INT DEFAULT 0;
    DECLARE actual_election_num TINYINT DEFAULT 0;

    -- Convert election identifier to number
    CASE query_election_id
        WHEN 1 THEN SET actual_election_num = 115;
        WHEN 2 THEN SET actual_election_num = 123;
        WHEN 3 THEN SET actual_election_num = 121;
        WHEN 4 THEN SET actual_election_num = 117;
    END CASE;

    START TRANSACTION;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET sql_error = 1;
            ROLLBACK;
        END;

		-- Count the number of voters who switched parties in the specified election
        SELECT COUNT(*)
        FROM election_votes
        WHERE election_number = actual_election_num
          AND party_cd <> query_election_party_cd
          AND voter_reg_num IN (
            SELECT voter_reg_num
            FROM voter
            WHERE party_cd = query_election_party_cd
        );
		
        -- If no SQL errors occurred, commit the transaction
		IF sql_error = 0 THEN
			COMMIT;
			SELECT 'Election Switches Analyzed.';
		ELSE
			SELECT 'Rollback occurred';
		END IF;
    END;
END //

DELIMITER ;


-- ----------------------------------------------------------------------
-- Custom Analytics
-- ----------------------------------------------------------------------

-- Distribution of Party Code by Zip Code 

-- This view calculates the percentage distribution of party codes (DEM, REP, UNA, LIB, GRE, CST) for each zip code.
-- It uses conditional counting to determine the count of each party code within a zip code and divides it by the 
-- total count of voters in that zip code.

CREATE OR REPLACE VIEW party_by_zip_stats AS
SELECT zip_code,
    ROUND(COUNT(CASE WHEN party_cd = 'DEM' THEN 1 END) * 100.0 / COUNT(*), 2) AS DEM,
    ROUND(COUNT(CASE WHEN party_cd = 'REP' THEN 1 END) * 100.0 / COUNT(*), 2) AS REP,
    ROUND(COUNT(CASE WHEN party_cd = 'UNA' THEN 1 END) * 100.0 / COUNT(*), 2) AS UNA,
    ROUND(COUNT(CASE WHEN party_cd = 'LIB' THEN 1 END) * 100.0 / COUNT(*), 2) AS LIB,
    ROUND(COUNT(CASE WHEN party_cd = 'GRE' THEN 1 END) * 100.0 / COUNT(*), 2) AS GRE,
    ROUND(COUNT(CASE WHEN party_cd = 'CST' THEN 1 END) * 100.0 / COUNT(*), 2) AS CST,
	ROUND(COUNT(CASE WHEN party_cd = 'N/A' THEN 1 END) * 100.0 / COUNT(*), 2) AS 'N/A'
FROM voter
GROUP BY zip_code;
    

-- Distribution of Age By Race 

-- This view calculates the percentage distribution of age groups (18-24, 25-34, 35-44, 45-54, 55-64, 65+) for each
--  race code.
-- It uses conditional counting to determine the count of voters within each age group for a given race code and divides
-- it by the total count of voters of that race code.

CREATE OR REPLACE VIEW age_by_race_stats AS
SELECT race_code,
    ROUND(COUNT(CASE WHEN age BETWEEN 18 AND 24 THEN 1 END) * 100.0 / COUNT(*), 2) AS '18-24',
    ROUND(COUNT(CASE WHEN age BETWEEN 25 AND 34 THEN 1 END) * 100.0 / COUNT(*), 2) AS '25-34',
    ROUND(COUNT(CASE WHEN age BETWEEN 35 AND 44 THEN 1 END) * 100.0 / COUNT(*), 2) AS '35-44',
    ROUND(COUNT(CASE WHEN age BETWEEN 45 AND 54 THEN 1 END) * 100.0 / COUNT(*), 2) AS '45-54',
    ROUND(COUNT(CASE WHEN age BETWEEN 55 AND 64 THEN 1 END) * 100.0 / COUNT(*), 2) AS '55-64',
    ROUND(COUNT(CASE WHEN age >= 65 THEN 1 END) * 100.0 / COUNT(*), 2) AS '65+'
FROM voter
GROUP BY race_code;
