--Run the following against the DYNAMICS database

DELETE DYNAMICS..DB_Upgrade WHERE PRODID=414
DELETE DYNAMICS..DU000030 WHERE PRODID=414
DELETE DYNAMICS..DU000020 WHERE PRODID=414
DROP TABLE SUSPREF
DROP TABLE HR2APP06
DROP TABLE AAX10130

--Run the following against EACH company database
DROP TABLE HR2NJ01
DROP TABLE EX010130
DROP TABLE AHRTS022