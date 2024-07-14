-- Isabel Arvelo
-- isabel.c.arvelo@vanderbilt.edu 
-- Project 1 Part 2 (Functional Dependency Tests)


-- -----------------------------------------------------
-- CHECKING FOR BAD DATA 
-- -----------------------------------------------------

-- 1: Checking if each unique individual has one registration number 
SELECT precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, 
       pct_portion, first_name, middle_name, last_name, name_suffix_lbl, 
       full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, 
       house_num, street_dir, street_name, street_type_cd, street_sufx_cd, 
       res_city_desc, state_cd, zip_code, registr_dt, nc_senate_desc, 
       nc_house_desc, e1, e1_date, e1_votingmethod, e1_partycd, e2, 
       e2_date, e2_votingmethod, e2_partycd, e3, e3_date, e3_votingmethod, 
       e3_partycd, e4, e4_date, e4_votingmethod, e4_partycd
FROM meckcountyvoters
GROUP BY precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, 
         pct_portion, first_name, middle_name, last_name, name_suffix_lbl, 
         full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, 
         house_num, street_dir, street_name, street_type_cd, street_sufx_cd, 
         res_city_desc, state_cd, zip_code, registr_dt, nc_senate_desc, 
         nc_house_desc, e1, e1_date, e1_votingmethod, e1_partycd, e2, 
         e2_date, e2_votingmethod, e2_partycd, e3, e3_date, e3_votingmethod, 
         e3_partycd, e4, e4_date, e4_votingmethod, e4_partycd
HAVING COUNT(DISTINCT voter_reg_num) > 1;
         

/* 
Result of the query: 4 rows

This indicates that all of attributes in the meckcountyvoters table except voter_reg_num do not uniquely identify 
voter_reg_num. This is an issue because each unique individual should only be assigned to one registration number. 
 */
 
 -- 2: Checking if each row is assigned to a precinct, house district, senate district, and portion of a precinct 
 SELECT COUNT(*)
 FROM meckcountyvoters
 WHERE pct_portion IS NULL;

/* 
Result of the query: 258

This indicates that there are 258 rows of data missing data for all of the precinct portion attribute. 
 */
 
 
 -- 2: 
 
SELECT full_name_mail, age, house_num, street_dir, street_name, street_type_cd, street_sufx_cd, zip_code
FROM meckcountyvoters
GROUP BY full_name_mail, age, house_num, street_dir, street_name, street_type_cd, street_sufx_cd, zip_code
HAVING COUNT(DISTINCT voter_reg_num) > 1;

/* 
Result of the query: 21

This indicates that there are 21 duplicate rows where someone with the same exact full_name_mail, age, and home address appears twice
in the database. 
 */
 
 -- 3:
SELECT full_name_mail
FROM meckcountyvoters
GROUP BY full_name_mail
HAVING COUNT(DISTINCT first_name, middle_name, last_name, name_suffix_lbl) > 1;

/* 
Result of the query: 13

This indicates that there are 13 rows where first_name, middle_name, last_name, name_suffix_lbl do not 
depend on full_name_mail
 */


-- -----------------------------------------------------
-- CHECKING THE PRIMARY KEY 
-- -----------------------------------------------------

 -- 4: Checking that voter_reg_num is uniquely identified by the remaining attributes
SELECT precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, 
       pct_portion, first_name, middle_name, last_name, name_suffix_lbl, 
       full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, 
       house_num, street_dir, street_name, street_type_cd, street_sufx_cd, 
       res_city_desc, state_cd, zip_code, registr_dt, nc_senate_desc, 
       nc_house_desc, e1, e1_date, e1_votingmethod, e1_partycd, e2, 
       e2_date, e2_votingmethod, e2_partycd, e3, e3_date, e3_votingmethod, 
       e3_partycd, e4, e4_date, e4_votingmethod, e4_partycd
FROM meckcountyvoters_unique
GROUP BY precinct_desc, party_cd, race_code, ethnic_code, sex_code, age, 
         pct_portion, first_name, middle_name, last_name, name_suffix_lbl, 
         full_name_mail, mail_addr1, mail_addr2, mail_city_state_zip, 
         house_num, street_dir, street_name, street_type_cd, street_sufx_cd, 
         res_city_desc, state_cd, zip_code, registr_dt, nc_senate_desc, 
         nc_house_desc, e1, e1_date, e1_votingmethod, e1_partycd, e2, 
         e2_date, e2_votingmethod, e2_partycd, e3, e3_date, e3_votingmethod, 
         e3_partycd, e4, e4_date, e4_votingmethod, e4_partycd
HAVING COUNT(DISTINCT voter_reg_num) > 1;

/* 
Result of the query: empty set 

This indicates that all of attributes in the table except voter_reg_num uniquely identify voter_reg_num. 
This is important because each unique individual should only be assigned to one registrationnumber. 
 */



-- -----------------------------------------------------
-- CHECKING DEPENDENCIES FOR VOTER TABLE 
-- -----------------------------------------------------

-- 5:  race_code -> ethnic_code
SELECT race_code
FROM voter
GROUP BY race_code
HAVING COUNT(DISTINCT ethnic_code) > 1;

/* 
Result of the query: 7 rows 

This indicates that zip_code does not uniquely determine mail_city_state_zip so there is not a partial 
dependency between these attributes in the voter_address table 
 */


-- 6: full name --> sex code
SELECT full_name_mail
FROM meckcountyvoters_unique
GROUP BY full_name_mail
HAVING COUNT(DISTINCT sex_code) > 1;

/* 
Result of the query: 127 rows 

This indicates that sex_code does not depend on full_name
Records with the same exact full_name_mail could have different sex codes 
 */
 
-- 7: race_code, ethnic_code, sex_code --> party_cd
SELECT race_code, 
	ethnic_code, 
	sex_code
FROM meckcountyvoters_unique
GROUP BY race_code, 
	ethnic_code, 
    sex_code
HAVING COUNT(DISTINCT party_cd) > 1;

/* 
Result of the query: 60 rows 

This indicates indicating that the combined attributes (race_code, ethnic_code, sex_code) do not uniquely 
determine party_cd. Records with the same values for (race_code, ethnic_code, sex_code) may have different 
party_cd, confirming that there is not a partial dependency between these columns in voter. 
 */
 

 
 -- -----------------------------------------------------
 -- CHECKING DEPENDENCIES FOR ELECTION TABLES:
 -- -----------------------------------------------------
 
-- 8: eX --> eX_date 
SELECT 'e1' AS election, e1 AS vote_status
FROM meckcountyvoters_unique
WHERE e1 IS NOT NULL
GROUP BY e1
HAVING COUNT(DISTINCT e1_date) > 1

UNION ALL

SELECT 'e2', e2
FROM meckcountyvoters
WHERE e2 IS NOT NULL
GROUP BY e2
HAVING COUNT(DISTINCT e2_date) > 1

UNION ALL

SELECT 'e3', e3
FROM meckcountyvoters
WHERE e3 IS NOT NULL
GROUP BY e3
HAVING COUNT(DISTINCT e3_date) > 1

UNION ALL

SELECT 'e4', e4
FROM meckcountyvoters
WHERE e4 IS NOT NULL
GROUP BY e4
HAVING COUNT(DISTINCT e4_date) > 1;

/* 
Result of the query: empty set 

This indicates that e1 -> e1_date, e2 -> e2_date, e3 -> e3_date, e4 -> e4_date
All records with the same election number have the same election date, confirming the functional dependency of 
e[election number] -> e[election number]_date.
 */
 
 -- 9: e1_partycd -> e2_partycd, e3_partycd , e4_partycd 
SELECT e1_partycd
FROM meckcountyvoters_unique
GROUP BY (e1_partycd)
HAVING COUNT(DISTINCT e2_partycd) > 1 OR
		COUNT(DISTINCT e3_partycd) > 1 OR 
		COUNT(DISTINCT e4_partycd) > 1;
/* 
Result of the query: 7 rows

This indicates that e2_partycd, e3_partycd , e4_partycd are not uniquely determined by e1_partycd. In other words, 
records with same e1_partycd may have different values for e2_partycd, e3_partycd , e4_partycd which indicates 
that party code is not consistent across elections and not all voters vote in all elections. 
 */
 

-- 10:  e1_date --> e1_votingmethod
SELECT e1_date
FROM meckcountyvoters_unique
GROUP BY e1_date
HAVING COUNT(DISTINCT e1_votingmethod) > 1;
  
  /* 
Result of the query: 1 row

This indicates that the election date does not uniquely determine voting method so there is not a partial 
dependency between these e1_date, e1_votingmethod in the election1 table and it is fair to assume the same follows
for election2, election3, and election4. 
 */


-- ----------------------------------------------------------------------
-- CHECKING DEPENDENCIES WITHIN FOR THE HOUSE AND SENATE TABLES
-- ----------------------------------------------------------------------

-- 11: precint_desc --> nc_senate_desc
SELECT precinct_desc
FROM meckcountyvoters_unique
GROUP BY (precinct_desc)
HAVING COUNT(DISTINCT nc_senate_desc) > 1;

/* 
Result of the query: empty set 

This indicates indicating that precinct_desc uniquely determines nc_senate_desc 
for each record in the database. No two records with the same precinct_desc have different nc_senate_desc values, 
confirming the functional dependency of nc_senate_desc on these attributes.
 */
 
 -- 12: precint_desc --> nc_house_desc
SELECT precinct_desc
FROM meckcountyvoters_unique
GROUP BY (precinct_desc)
HAVING COUNT(DISTINCT nc_house_desc) > 1;

/* 
Result of the query: 2 rows

This indicates indicating that precinct_desc does not uniquely determine nc_house_desc 
for each record in the database. Two records with the same precinct_desc could have different nc_house_desc values, 
confirming there is no functional dependency of nc_house_desc on this attribute.
 */

-- 13:  pct_portion --> nc_house_desc
SELECT pct_portion
FROM meckcountyvoters_unique
GROUP BY pct_portion
HAVING COUNT(DISTINCT nc_house_desc) > 1;

/* 
Result of the query: empty set 

This indicates indicating that pct_portion uniquely determines nc_house_desc
for each record in the database. No two records with the same pct_portion have different nc_house_desc values, 
confirming the functional dependency of nc_house_desc on this attributes.
 */


 -- 14: pct_portion --> precinct_desc
SELECT pct_portion
FROM meckcountyvoters_unique
GROUP BY pct_portion 
HAVING COUNT(DISTINCT precinct_desc) > 1;

/* 
Result of the query: empty set 

This indicates indicating that pct_portion uniquely determines precinct_desc for each record in the database. 
No two records with the same pct_portion have different precinct_desc, confirming the functional dependency of 
nc_senate_desc on these attributes.
 */
 
 
 -- 15: nc_senate_desc -> nc_senate_desc
SELECT nc_house_desc
FROM meckcountyvoters_unique
GROUP BY nc_house_desc
HAVING COUNT(DISTINCT nc_senate_desc) > 1;

  /* 
Result of the query: 8 rows

This indicates that nc_house_desc does not uniquely determine nc_senate_desc 
 */
 
 
 -- ----------------------------------------------------------------------
 -- CHECKING DEPENDENCIES FOR ADDRESS ATTRIBUTES
 -- ----------------------------------------------------------------------
 
-- 16: mail_city_state_zip -> zip_code 
SELECT mail_city_state_zip
FROM meckcountyvoters_unique
GROUP BY mail_city_state_zip
HAVING COUNT(DISTINCT zip_code) > 1;

/*
Result of the query: 419 rows

This query checks if mail_city_state_zip uniquely determines zip_code and it does not. Two records 
can have the same mail_city_state_zip, but different zip_codes. 
*/

-- VOTER MAILING ADDRESS

-- 17: mail_addr1 -> mail_addr2 
SELECT mail_addr1
FROM meckcountyvoters_unique
GROUP BY mail_addr1
HAVING COUNT(DISTINCT mail_addr2) > 1;

/*
Result of the query: 248 rows 

This query checks if  mail_addr1 uniquely determines mail_addr2. 
It indicates that there is no partial dependency between the combination of mail_addr1 and mail_addr2. 
*/

-- VOTER RESIDENTIAL ADDRESS ATTRIBUTE DEPENDENCIES 

-- 18:  street_name, street_type_cd, street_sufx_cd -> house_num
SELECT street_name, street_type_cd, street_sufx_cd
FROM meckcountyvoters_unique
GROUP BY street_name, street_type_cd, street_sufx_cd
HAVING COUNT(DISTINCT house_num) > 1;

/*
Result of the query: > 1000 rows 

This query checks if the combination of street_name, street_type_cd, and street_sufx_cd uniquely determines house_num in the voter_residential_address table.
It indicates that there is no partial dependency between the combination of street_name, street_type_cd, street_sufx_cd, and house_num.
*/


-- 19:  house_num, street_dir, street_name, street_type_cd, street_sufx_cd --> zip_code
SELECT house_num, street_dir, street_name, street_type_cd, street_sufx_cd
FROM meckcountyvoters_unique
GROUP BY house_num, street_dir, street_name, street_type_cd, street_sufx_cd
HAVING COUNT(DISTINCT zip_code) > 1;

/*
Result of the query: empty

This query checks if the combination of house_num, street_dir, street_name, street_type_cd, and street_sufx_cd uniquely 
determines zip_code in the voter_residential_address table.
There is a dependency between the combination of house_num, street_dir, street_name, street_type_cd, street_sufx_cd, and zip_code.
Although this FD holds, I will not use it for my decomposition because from domain knowledge, I know 
that the same address can exist in two zip codes. 
*/
 
 
 -- ----------------------------------------------------------------------
 -- CHECKING DEPENDENCIES BETWEEN TABLES 
 -- ----------------------------------------------------------------------
 

 -- 20:  zip_code -> city, state 
SELECT zip_code
FROM meckcountyvoters_unique
GROUP BY zip_code
HAVING COUNT(DISTINCT res_city_desc) > 1 OR COUNT(DISTINCT state_cd) > 1;

/* 
Result of the query: empty set

This indicates indicating that zip_code uniquely determines res_city_desc and state_cd. By the Union Armstrong Axiom, 
this implies that zip_code -> res_city_desc, state_cd. No two records with the same value for zip_code have different 
pairs of res_city_desc, state_cd values, confirming the functional dependency of res_city_desc, state_cd on zip_code. 
 */
 
  -- 21:  city, state --> zip_code
SELECT res_city_desc, state_cd 
FROM meckcountyvoters
GROUP BY  res_city_desc, state_cd
HAVING COUNT(DISTINCT zip_code ) > 1;

/* 
Result of the query: 3 rows

This indicates indicating that res_city_desc, state_cd do not uniquely determine zip_code. Records with the same value
for city and state may have different zip_code values 
 */

-- 22: full_name_mail, mail_addr1, registr_dt, age --> voter_reg_num 
SELECT full_name_mail, mail_addr1, registr_dt, age
FROM meckcountyvoters_unique
GROUP BY full_name_mail, mail_addr1, registr_dt, age
HAVING COUNT(DISTINCT voter_reg_num) > 1;


/* 
Result of the query: empty set

This indicates indicating that the combined attributes (full_name_mail, mail_addr1, registr_dt, age) uniquely determine
voter_reg_num and by the Transitivity Armstrong Axiom, this implies that (full_name_mail, mail_addr1, registr_dt, age)
determine all other attributes in the table. No two records with the same value for (full_name_mail, mail_addr1, 
registr_dt, age) have different voter regsistration numbers, confirming the functional dependency of the rest of 
the attributes on full_name_mail, mail_addr1, registr_dt, age.
 */
 

-- 23: mail_addr1 -> mail_city_state_zip
SELECT mail_addr1
FROM meckcountyvoters_unique
GROUP BY mail_addr1
HAVING COUNT(DISTINCT mail_city_state_zip) > 1;

/* 
Result of the query: 927

This indicates that mail_addr1 does not uniquely determine mail_city_state_zip for each record in the database. 
Two records with the same mail_addr1 could have different mail_city_state_zip values. 
 */


-- 24: house_num, street_name, street_dir, street_type_cd, street_sufx_cd, zip_code --> pct_portion
SELECT house_num, street_name,street_dir, street_type_cd, street_sufx_cd, zip_code
FROM meckcountyvoters_unique
GROUP BY house_num, street_name, house_num, street_dir, street_type_cd, street_sufx_cd, zip_code
HAVING COUNT(DISTINCT pct_portion) > 1;
  /* 
Result of the query: empty set 

This indicates that the combined atttributes house_num, street_dir, street_name, street_type_cd, street_sufx_cd, zip_code 
uniquely determine precinct_desc. Records with the same values for these address fields will have the same value for
precinct_desc, confirming that precinct_desc depends on these attributes. 
 */
 
 -- 25: first_name, middle_name, last_name, name_suffix_lbl --> full_name_mail
SELECT first_name, middle_name, last_name, name_suffix_lbl
FROM meckcountyvoters_unique
GROUP BY first_name, middle_name, last_name, name_suffix_lbl
HAVING COUNT(DISTINCT full_name_mail ) > 1;

/* 
Result of the query: empty set 

This indicates that these combined attributes (first_name, middle_name, last_name, 
name_suffix_lbl) together uniquely determine the full_name_mail attribute for each record in the database. 
No two records with the same set of these four attributes have different full_name_mail values, 
confirming the functional dependency of full_name_mail on these attributes.
 */

 
-- 26: full_name_mail -> first_name, middle_name, last_name, name_suffix_lbl
SELECT full_name_mail
FROM meckcountyvoters_unique 
GROUP BY full_name_mail
HAVING COUNT(DISTINCT  first_name, middle_name, last_name, name_suffix_lbl) > 1;

/* 
Result of the query: empty set 

This indicates that full_name_mail uniquely determines thee combined attributes (first_name, middle_name, last_name, 
name_suffix_lbl) for each record in the database. 
 */
 

 -- 27: full_name_mail, mail_addr1-> mail_addr2, mail_city_state_zip
SELECT full_name_mail, mail_addr1
FROM meckcountyvoters_unique
GROUP BY full_name_mail, mail_addr1
HAVING COUNT(DISTINCT  mail_addr2) > 1 OR COUNT(DISTINCT mail_city_state_zip) > 1;
 /* 
Result of the query: empty set

This indicates that these combined attributes (full_name_mail, mail_addr1  together uniquely determine 
the mail_addr2, mail_city_state_zip  attribute for each record in the database. 
 */
 
 

 

 











 