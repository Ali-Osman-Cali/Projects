-- Cleaning the address column with REGEX function

SELECT * FROM people;

SELECT address FROM people WHERE address REGEXP '^[0-9a-zA-Z\. ]+;[a-zA-Z ]+;[A-Z ]+;[0-9 ]+$';

SELECT COUNT(address) FROM people WHERE address REGEXP '^[0-9a-zA-Z\. ]+;[a-zA-Z ]+;[A-Z ]+;[0-9 ]+$';

SELECT COUNT(*) FROM people;

SELECT address FROM people WHERE address NOT REGEXP '^[0-9a-zA-Z\. ]+;[a-zA-Z ]+;[A-Z ]+;[0-9 ]+$';

-- Editing the 3 addresses to be able to use REGEX function on them

 SELECT address FROM people WHERE address NOT REGEXP '^[0-9a-zA-Z\. ]+;[a-zA-Z ]+;[A-Z ]+;[0-9 ]+$';

-- Displaying the atomic values within the address field

SELECT substring_index(address, ';', 1) FROM people;

SELECT substring_index(substring_index(address, ';', 1), ';', -1) FROM people;

SELECT substring_index(substring_index(address, ';', 2), ';', -1) FROM people;

SELECT substring_index(substring_index(address, ';', 3), ';', -1) FROM people;

SELECT substring_index(substring_index(address, ';', 1), ';', -1) AS street,
substring_index(substring_index(address, ';', 2), ';', -1) AS city,
substring_index(substring_index(address, ';', 3), ';', -1) AS state,
substring_index(substring_index(address, ';', 4), ';', -1) AS zip FROM people;

-- Using the existing address field to form an address table

CREATE TABLE address (
id INT NOT NULL auto_increment,
street VARCHAR(255) NOT NULL,
city VARCHAR(255) NOT NULL,
state VARCHAR(10) NOT NULL,
postcode VARCHAR(10) NOT NULL,
pfk INT,
primary key(id)
)

-- Inserting the data into the address table using existing data
SELECT * FROM people;

INSERT INTO address(street, city, state, zip, pfk)
SELECT trim(substring_index(substring_index(address, ';', 1), ';', -1)) AS street,
trim(substring_index(substring_index(address, ';', 2), ';', -1)) AS city,
trim(substring_index(substring_index(address, ';', 3), ';', -1)) AS state,
trim(substring_index(substring_index(address, ';', 4), ';', -1)) AS zip,
id FROM people;

SELECT * FROM company.people, company.address WHERE
people.id = address.pfk;




