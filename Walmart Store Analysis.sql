SELECT * FROM walmartsales.`walmartsalesdata.csv`;

-- Changing column names and removing spaces between them and introducing underscore

ALTER TABLE walmartsales.`walmartsalesdata.csv`
CHANGE `Customer type` Customer_Type TEXT,
CHANGE `Unit price` Unit_Price DECIMAL,
CHANGE `Tax 5%` Tax_5_Percent DECIMAL,
CHANGE `gross margin percentage` Gross_Margin_Percentage DECIMAL,
CHANGE `gross income` Gross_Income DECIMAL;


#1. -- How many unique product lines does the data have?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;

	SELECT count(DISTINCT Product_Line) FROM walmartsales.`walmartsalesdata.csv` ;
    
    -- We have 6 unique product lines in the Data


#2. -- What is the most selling product line
	
    -- Most selling product line is meant by the product line which is sold in the most quantity
    
    SELECT Product_Line, sum(quantity) AS Quantity_Purchased 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Product_Line
    ORDER BY Quantity_Purchased DESC
    LIMIT 1;

#3. -- What is the total revenue by month
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    -- Altering the Date column from text data type to date data type.
    
    ALTER TABLE `walmartsalesdata.csv`
    CHANGE Date Date DATE;
    
    SELECT MONTHNAME(Date),Date FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT MONTHNAME(Date) AS Month, SUM(total) AS Revenue 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Month
    ORDER BY Revenue DESC;


#4. -- What month had the largest COGS?

	SELECT MONTHNAME(Date) AS MONTH, SUM(cogs) AS Total_Cogs 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY MONTH 
    ORDER BY Total_Cogs DESC;


#5. -- What product line had the largest revenue?

	SELECT Product_Line, SUM(Total) AS Total_Revenue 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Product_Line
    ORDER BY Total_Revenue DESC;


#6. -- What is the city with the largest revenue?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT City, SUM(Total) AS Total_Revenue 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY City
    ORDER BY Total_Revenue DESC;


#7. -- What product line had the largest VAT?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;

	-- Understanding that largest VAT means the largest tax 5 percent
    
    	SELECT Product_Line, SUM(Tax_5_Percent) 
        FROM walmartsales.`walmartsalesdata.csv`
        GROUP BY Product_Line
        ORDER BY SUM(Tax_5_Percent) DESC;

#8. Fetch each product line and add a column to those product 
--  line showing "Good", "Bad". Good if its greater than average sales

	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    ALTER TABLE `walmartsalesdata.csv`
    ADD COLUMN GoodOrBad TEXT(5);
    
    UPDATE `walmartsalesdata.csv`
    SET GoodOrBad = (
		CASE
			WHEN Total >= avg(Total) THEN 'Good'
            ELSE 'Bad'
		END
        );
        
	-- The above code is throwing an error . Therfore we are writing a different query where the value can be returned instead of avg(total)
    
    UPDATE `walmartsalesdata.csv`
    SET GoodOrBad = (
		CASE
			WHEN Total >= (SELECT avg(Total) FROM `walmartsalesdata.csv`) THEN 'Good'
            ELSE 'Bad'
		END
        );
        
	-- Error in above code as well
    
    SELECT avg(Total) AS Avg_Total FROM `walmartsalesdata.csv`;
    
	SET SESSION SQL_SAFE_UPDATES = 0;
	-- The above statement is used so that updates can be done without using the where clause for this session
    
     UPDATE `walmartsalesdata.csv`
	 SET GoodOrBad = (
		CASE
			WHEN Total >= 322.97 THEN 'Good'
            ELSE 'Bad'
		END
        );
        
	 SELECT * FROM walmartsales.`walmartsalesdata.csv`;

#9. -- Which branch sold more products than average product sold?

	SELECT * FROM walmartsales.`walmartsalesdata.csv`;

	SELECT Branch, SUM(Total) AS TotalSalesByBranch 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Branch
	HAVING TotalSalesByBranch > AVG(Total)
	ORDER BY TotalSalesByBranch;
    


#10. -- What is the most common product line by gender
	-- Most common product line by gender means that which product line was selling in the highest number
    
	SELECT Gender, Product_Line, SUM(Quantity) AS Qty
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Gender, Product_Line
    ORDER BY 1,3 DESC;
    
    -- If we want only the most common product for each gender then we will need to use rank function
    
    WITH CTE1 AS (
		SELECT Gender, Product_Line, SUM(Quantity) AS Qty,
		RANK () OVER (PARTITION BY Gender ORDER BY SUM(Quantity) DESC) AS Rank1
		FROM walmartsales.`walmartsalesdata.csv`
		GROUP BY Gender, Product_Line
		ORDER BY 1,3 DESC
        )
        
	SELECT * 
    FROM CTE1
    WHERE Rank1 = 1;

#11. -- What is the average rating of each product line
	SELECT Product_Line, AVG(Rating) AS Avg_Rating 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Product_Line;


#12. -- How many unique customer types does the data have?
	SELECT DISTINCT Customer_Type FROM walmartsales.`walmartsalesdata.csv`;


#13. -- How many unique payment methods does the data have?
	SELECT DISTINCT Payment FROM walmartsales.`walmartsalesdata.csv`;


#14. -- What is the most common customer type?

	-- This means that which type of customer has bought the maximum quantity of products
    
	SELECT Customer_Type,SUM(quantity) AS Qty
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Customer_Type
    ORDER BY Qty DESC;
    


#15. -- Which customer type buys the most?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT Customer_Type,SUM(Total) AS Totals
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Customer_Type
    ORDER BY Totals DESC;


#16. -- What is the gender of most of the customers?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT Gender,count(Gender) AS Num
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Gender;

#17. -- What is the gender distribution per branch?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT DISTINCT Branch,Gender,Count(Gender) AS Num 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Branch,Gender
    ORDER BY 1;


#20. -- Which day fo the week has the best avg ratings?

	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
	SELECT DAYNAME(Date),Date,Rating 
    FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT DAYNAME(Date) AS DayName, avg(Rating) AS Ratings 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY DayName
    ORDER BY Ratings DESC;

    


#21. -- Which day of the week has the best average ratings per branch?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    WITH CTEE AS (
		SELECT Branch,DAYNAME(Date) AS DayName, avg(Rating) AS Ratings,
		RANK () OVER (PARTITION BY Branch ORDER BY avg(Rating) DESC) AS RankOff
		FROM walmartsales.`walmartsalesdata.csv`
		GROUP BY 1,2
        )
        
	SELECT * FROM CTEE
    WHERE RankOff = 1;

#23. -- Which of the customer types brings the most revenue?
	SELECT * FROM walmartsales.`walmartsalesdata.csv`;
    
    SELECT Customer_Type,SUM(Total) 
    FROM walmartsales.`walmartsalesdata.csv`
    GROUP BY Customer_Type;
