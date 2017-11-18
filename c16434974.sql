--Student Number: c16434974
--Student Name: Michael Lenghel
--Program Code: DT228/2

DROP TABLE SpecProd;

DROP TABLE Product;

DROP TABLE Specification;

DROP TABLE ProdType;

DROP TABLE Designer;

DROP TABLE Client;

--Create tables

CREATE TABLE Client
(
	clientID             NUMBER(6) NOT NULL ,
	fullNameC             VARCHAR2(50) NOT NULL ,
	emailAdr             VARCHAR2(30) NOT NULL ,
--Ensure that clientID is a primary key
CONSTRAINT  clientID_PK PRIMARY KEY (clientID),
--Ensure that emails are unique
CONSTRAINT unique_emailC UNIQUE(emailAdr),
--ensure @ and . symbols are entered at least once and that the . symbol and the @ symbol are not the first entries
CONSTRAINT ensureSymbol_CHK CHECK (emailAdr like '%@%' AND emailAdr like '%.%' AND emailAdr NOT LIKE '.%' AND emailAdr NOT LIKE '@%')
);

CREATE TABLE Designer
(
	designerID           NUMBER(6) NOT NULL ,
	fullNameD             VARCHAR2(50) NOT NULL ,
	emailAdr             VARCHAR2(30) NULL ,
	dRateofPay           NUMBER(4,2) NULL ,
CONSTRAINT  designerID_PK PRIMARY KEY (designerID),
CONSTRAINT unique_emailD UNIQUE(emailAdr),
--ensure @ and . symbols are entered at least once and that the . symbol and the @ symbol are not the first entries
CONSTRAINT ensureSymbolD_CHK CHECK (emailAdr like '%@%' AND emailAdr like '%.%' AND emailAdr NOT LIKE '.%' AND emailAdr NOT LIKE '@%'),
--Prevents the rate of pay from being greater than 75.99
CONSTRAINT ratePay_CHK CHECK (dRateofPay <  75.99)
);

CREATE TABLE Specification
(
	specID               NUMBER(6) NOT NULL ,
	specDesc             VARCHAR2(50) NULL ,
	specCommission       NUMBER(7,2) NULL ,
	clientID             NUMBER(6) NULL ,
	designerID           NUMBER(6) NULL ,
	designHrsWorked      NUMBER(4) NULL ,
	specDate             DATE NULL ,
CONSTRAINT  specID_PK PRIMARY KEY (specID),
CONSTRAINT Client_Specification_FK FOREIGN KEY (clientID) REFERENCES Client (clientID) ON DELETE SET NULL,
CONSTRAINT Designer_Specification_FK FOREIGN KEY (designerID) REFERENCES Designer (designerID) ON DELETE SET NULL,
--Ensures hours worked does nto exceed 150
CONSTRAINT HrsWorked_CHK CHECK (designHrsWorked <  150),
--Ensures the specificaiton commission doesn ot exceed 16,000
CONSTRAINT commision_price_CHK CHECK (specCommission < 16000)
);

CREATE TABLE ProdType
(
	prodCat              CHAR(1) NOT NULL ,
	catDesc              varchar2(50) NULL ,
CONSTRAINT  prodCat_PK PRIMARY KEY (prodCat),
--Ensures that the only letters that can be entered for the prodCat are G, L, C, S and X
CONSTRAINT val_prod_cat_CHK CHECK (prodCat IN 'G'
                                    OR (prodCat IN 'L') OR (prodCat IN 'C')
                                    OR (prodCat IN 'S') OR (prodCat IN 'X'))
);

CREATE TABLE Product
(
	prodID               NUMBER(4) NOT NULL ,
	prodDescription      varchar2(50) NULL ,
	prodUnitPrice        NUMBER(4,2) NULL ,
	prodQtyInStock       NUMBER(3) NULL ,
	prodCat              CHAR(1) NOT NULL ,
CONSTRAINT  prodID_prodCat_PK PRIMARY KEY (prodID,prodCat),
CONSTRAINT ProdType_Product_FK FOREIGN KEY (prodCat) REFERENCES ProdType (prodCat),
--Ensures that the price per unit is between the range of 5 and 45.
CONSTRAINT chkPrice_CHK CHECK (prodUnitPrice BETWEEN 5.00 AND 45.0)
);

CREATE TABLE SpecProd
(
	specID               NUMBER(6) NOT NULL ,
	prodID               NUMBER(4) NOT NULL ,
	qtyUsed              Number(2) NULL ,
	prodCat              CHAR(1) NOT NULL ,
CONSTRAINT  specID_prodID_prodCat_PK PRIMARY KEY (specID,prodID,prodCat),
CONSTRAINT Specification_SpecProd_FK FOREIGN KEY (specID) REFERENCES Specification (specID),
CONSTRAINT Product_SpecProd_FK FOREIGN KEY (prodID, prodCat) REFERENCES Product (prodID, prodCat)
);

--Insert data into the relevant tables

insert into CLIENT (clientID, fullNameC, emailAdr) values (101, 'J.J. Abrams', 'jjab@sw.com');
insert into CLIENT (clientID, fullNameC, emailAdr) values (201, 'Lawrence Kasdan', 'lkas@sw.com');
insert into CLIENT (clientID, fullNameC, emailAdr) values (301, 'Daisy Ridley', 'drid@sw.com');
insert into CLIENT (clientID, fullNameC, emailAdr) values (401, 'John Boyega', 'jboy@sw.com');

insert into DESIGNER (designerID, fullNameD, emailAdr, dRateofPay) values (101, 'Kelly Hoppen', 'khop@gmail.com.uk', 65.00);
insert into DESIGNER (designerID, fullNameD, emailAdr, dRateofPay) values (201, 'Philippe Starck', 'jpstark@stark.com', 72.50);
insert into DESIGNER (designerID, fullNameD, emailAdr, dRateofPay) values (301, 'Victoria Hagan', 'vichag@gmail.com', 75.00);
insert into DESIGNER (designerID, fullNameD, emailAdr, dRateofPay) values (401, 'Marmol Radziner', 'marmrad@gmail.com', 45.50);

insert into SPECIFICATION (specID, clientID, designerID, specDate, specDesc, specCommission, designHrsWorked) values (101, 101, 101, '12 JUN 2017', 'Full house', 10000, 10);
insert into SPECIFICATION (specID, clientID, designerID, specDate, specDesc, specCommission, designHrsWorked) values (102, 101, 101, '14 JUN 2017', 'Garden Patio', 12000, 20);
insert into SPECIFICATION (specID, clientID, designerID, specDate, specDesc, specCommission, designHrsWorked) values (103, 201, 301, '15 AUG 2017', 'Summerhouse', 8000, 5);
insert into SPECIFICATION (specID, clientID, designerID, specDate, specDesc, specCommission, designHrsWorked) values (104, 301, 201, '12 SEP 2017', 'Christmas decorations', 5000, 5);

INSERT INTO PRODTYPE(prodCat, catDesc) VALUES ('G', 'Garden Lighting');
INSERT INTO PRODTYPE(prodCat, catDesc) VALUES ('L', 'Lamps and Bulbs');
INSERT INTO PRODTYPE(prodCat, catDesc) VALUES ('C', 'Cables');
INSERT INTO PRODTYPE(prodCat, catDesc) VALUES ('X', 'Christmas');
INSERT INTO PRODTYPE(prodCat, catDesc) VALUES ('S', 'Shades');

insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('G', 101, 'Outdoor Wall Light', 40.00, 26);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('G', 102, 'Patio Lights', 41.00, 27);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('L', 101, 'E14 Engery Saving Bulb', 6.00, 28);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('L', 102, 'E27 Led Bulb', 9.00, 30);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('C', 101, '2-Core Black Braided Flexible Rubber Cable', 10.00, 50);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('C', 102, 'Southwire 250-Ft 2- Conductor Landscape Lighting', 11.00, 78);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('X', 101, 'LED string lights German Christmas 10-light', 15.50, 55);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('X', 102, 'LED heart string lights', 20.00, 12);
insert into PRODUCT (prodCat, prodID, prodDescription, prodUnitPrice, prodQtyInStock) values ('S', 101, 'Fabric Cylinder Shade Red', 30.00, 100);

insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (101, 'L', 101, 20);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (101, 'L', 102, 30);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (101, 'C', 101, 10);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (102, 'G', 101, 20);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (102, 'G', 102, 25);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (103, 'C', 101, 10);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (103, 'C', 102, 3);
insert into SPECPROD (specID, prodCat, prodID, qtyUsed) values (104, 'X', 101, 20);

------------------Report 1------------------
SELECT designerID, fullNameD, emailAdr, UPPER(specDesc) AS "Spec Description"
--I used a natural join since designerID is common to both tables
FROM DESIGNER NATURAL JOIN SPECIFICATION
--Orders designerID and specification description by descending order.
ORDER BY DESIGNERID DESC, specDesc DESC;

------------------Report 2------------------
SELECT CONCAT(prodCat, prodID) as prodIDAndProdCat, 
--UPPER function prints the strings in upper case and TO_CHAR formats the output in a specified order.
--'L99G999D99MI', 'NLS_CURRENCY = ''€'' ' was used to add the euro symbol in front of the prodUnitPrice as FML format did not work for the euro symbol
UPPER(prodDescription) AS "Product Description", UPPER(catDesc),TO_CHAR(prodUnitPrice, 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ') AS "Product Price"
--I used a natural join since as prodCat is common to both
FROM PRODUCT NATURAL JOIN PRODTYPE
--Orders prodCat in ascending order and prodUnitPrice in descending order
ORDER BY prodCat ASC, prodUnitPrice DESC;

------------------Report 3------------------
SELECT specID, clientID, fullNameC, specDesc,
--FML did not work for the euro symbol, and I used the L99G999D99MI', 'NLS_CURRENCY = ''€'' instead.
TO_DATE(specDate, 'DD/MM/YYYY') AS "Specification Date", TO_CHAR(specCommission, 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ') AS "Spec Copmission"
--I used a natural join since as clientID is common to both
FROM SPECIFICATION NATURAL JOIN CLIENT
--Orders specCommision into descending order
ORDER BY specCommission DESC;

------------------Report 4------------------
SELECT specID AS "SPECIFICATION ID", clientID, fullNameC AS "CLIENT NAME", DESIGNER.designerID, fullNameD AS "DESIGNER NAME", specDesc AS "DESCRIPTION COMMISSION",
--TO_DATE formatted the date to have the days first, then the months as digits and then the year
TO_DATE(specDate, 'DD/MM/YYYY') AS "DATE COMMISSION", TO_CHAR(specCommission, 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ') AS "AMT"
--Natural join was used as they share clientID as a column
FROM SPECIFICATION 
NATURAL JOIN CLIENT
--Used inner join to join the third table as designerID was in both the specification and the designer table
INNER JOIN DESIGNER ON DESIGNER.designerID = SPECIFICATION.designerID
--Orders by specCommission in descending order
ORDER BY specCommission DESC;

------------------Report 5------------------
--NATURAL JOIN look at whats common
SELECT specID AS "SPECIFICATION ID", specDesc AS "SPECIFICATION DESCRIPTION",
prodDescription AS "Product Name", prodUnitPrice AS "Product Price", qtyUsed,
--TO_char formatted out to have the euro symbol
TO_CHAR(prodUnitPrice * qtyUsed, 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ') AS "Total Price per Product"
--Joins all three columns since the columns are shared for specification and specprod adn then specprod and product
FROM SPECIFICATION
NATURAL JOIN SPECPROD
NATURAL JOIN PRODUCT;

------------------Report 6------------------
SELECT specID, specDesc AS "Specification Description",
--The sum lets it work since group by doesn't work on aggregated values
--SUM Was used as an aggreate function since Group By would not work otherwise
TO_CHAR(SUM(specCommission + (qtyUsed * prodUnitPrice)), 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ')  AS "Total Cost"
--Joins all three columns since the columns are shared for specification and specprod adn then specprod and product
FROM SPECIFICATION
NATURAL JOIN SPECPROD
NATURAL JOIN PRODUCT
--Groups all the specIDs with specDesc to allow the sum functiuon above to work and effectively find the total cost for each product
GROUP BY specID, specDesc;

------------------Report 7------------------
SELECT specID, specDesc AS "Specification Description",
--The sum lets it work since group by doesn't work on aggregated values
TO_CHAR(SUM(specCommission + (qtyUsed * prodUnitPrice)), 'L99G999D99MI', 'NLS_CURRENCY = ''€'' ')  AS "Total Cost",
    --Case, when, else is the equivalent and if else in SQL
    (CASE
        -- When (Condition evalues to true) THEN (return an operation to be performed)
        WHEN (SUM(specCommission + (qtyUsed * prodUnitPrice)) > 10000) THEN 'High Value'
        WHEN (SUM(specCommission + (qtyUsed * prodUnitPrice)) BETWEEN 10000 AND 8000) THEN 'Medium Cost'
        ELSE 'Low Cost'
    END) AS "Cost Range" --Column name will be Cost Range
 --Joins all three columns since the columns are shared for specification and specprod adn then specprod and product
FROM SPECIFICATION
NATURAL JOIN SPECPROD
NATURAL JOIN PRODUCT
GROUP BY specID, specDesc;

------------------Report 8------------------
--Combine all parts of the desired string
SELECT CONCAT('Specification ', 
CONCAT(specID, 
CONCAT(' ', 
CONCAT(specDesc, 
CONCAT(' used a total of ',
CONCAT(SUM(qtyUsed), 
CONCAT(' products at a cost of ',
CONCAT(SUM(qtyUsed * prodUnitPrice),
CONCAT(' and the total cost including commission was',
--Trim removes all the spaces from the start of the string
CONCAT(' ', LTRIM(TO_CHAR(SUM(specCommission + (qtyUsed * prodUnitPrice)), 'L99G999D99MI', 'NLS_CURRENCY = ''€'' '))
)))))))))) AS "High Value Specifications"
 --Joins all three columns since the columns are shared for specification and specprod adn then specprod and product
FROM SPECIFICATION
NATURAL JOIN SPECPROD
NATURAL JOIN PRODUCT
GROUP BY specID, specDesc
--Having is the equivalent of the where clause, but for the group by statement
HAVING SUM(specCommission + (qtyUsed * prodUnitPrice)) > 10000;
