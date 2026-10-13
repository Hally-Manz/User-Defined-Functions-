Use World;

-- 1. 
DELIMITER //
CREATE FUNCTION GetPopulationCategory(Population INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN CASE
    WHEN Population > 100000000 THEN 'Huge'
	WHEN Population >= 50000000 THEN 'Large'
	WHEN Population >= 10000000 THEN 'Medium'
    ELSE 'Small'
END;
END //

DELIMITER ;

-- Query the function:
SELECT
Name AS Country,
Population AS Population,
GetPopulationCategory(Population) AS Category
FROM Country;

-- 2.
DELIMITER //

CREATE FUNCTION GetLifeExpectancyCategory(Expectancy DECIMAL (4, 1))
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
	RETURN CASE
		WHEN Expectancy >= 75 THEN 'Excellent'
		WHEN Expectancy >= 65 THEN 'Good'
		WHEN Expectancy >= 50 THEN 'Average'
		ELSE 'Poor'
	END;
END //

DELIMITER ;

-- Query the function
SELECT
Name AS Country,
LifeExpectancy,
GetLifeExpectancyCategory(LifeExpectancy) AS Expectancy_category
FROM Country;

-- Combinine the two functions for more insight
SELECT
Name AS Country,
Population,
LifeExpectancy,
GetLifeExpectancyCategory(LifeExpectancy) AS Expectancy_category,
GetPopulationCategory(Population) AS Population_category

FROM Country;

/* ASSIGNMENT

Task: Business Question:

How can we automatically classify countries based on their GNP?
Create a function called GetIncomeCategory that accepts a country's GNP and returns:

GNP ≥ 500,000 → High Income
GNP ≥ 100,000 → Middle Income
Below 100,000 → Low Income

Then use the function to display:

Country | GNP | Income Category
*/

DELIMITER //

CREATE FUNCTION GetIncomeCategory(GNP FLOAT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
	RETURN CASE
		WHEN GNP >= 500000 THEN 'High Income'
		WHEN GNP >= 100000 THEN 'Middle Income'
		ELSE 'Low Income'
	END;
END //

DELIMITER ;

SELECT
Name AS Country,
GNP,
GetIncomeCategory(GNP) AS Income_Category
FROM Country
ORDER BY GNP DESC;

DROP FUNCTION IF EXISTS GetIncomeCategory;
