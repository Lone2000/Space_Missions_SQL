SELECT * FROM space_mission_data.space_missions;

                                                             --- Cleaning & Updating Table ---

--- DROP Price Column [Showcase ALTER/DROP Statements]
ALTER TABLE space_mission_data.space_missions
DROP COLUMN Price;

--- Adding Row Number [Showcase Row_Number Window Function]
SELECT ROW_NUMBER() OVER() as `Row ID`, space_mission_data.space_missions.*
FROM space_mission_data.space_missions;

--- Creating Temporary Table View [Showcasing View Function]
CREATE VIEW Temp_Table AS
SELECT ROW_NUMBER() OVER() as `Row ID`, space_mission_data.space_missions.*,EXTRACT(DAY FROM Date) as DAY, EXTRACT(MONTH FROM Date) AS Month, EXTRACT(Year FROM Date) AS Year
FROM space_mission_data.space_missions;


													--- Exploratary Data Analysis STATEMENTS ---

--- HOW MANY LAUNCHES PER COMPANY   [Showcases Group by Aggregation]
SELECT Company, COUNT(*)
FROM Temp_Table
GROUP By 1
ORDER By 2 DESC;

--- HOW MANY SUCCESSFULL LAUNCHES PER COMPANY [Showcase Group by Aggregation with Conditions]
SELECT Company, COUNT(*) AS successes
FROM Temp_table
WHERE MissionStatus = 'Success'
GROUP BY 1
ORDER BY 2 DESC;

--- USSR BASED Space Missions [Showcasing Wild Card Pattern Matching]
SELECT *
FROM Temp_table
WHERE Company LIKE "%USSR%";

--- RANK TOP 5 Space Companies [Showcaseing CTE / Rank Window Function]
WITH missions_success AS(
SELECT Company, COUNT(*) as successes
FROM Temp_table
WHERE MissionStatus = 'Success'
GROUP BY 1),
mission_rank AS(
SELECT  RANK() OVER(ORDER BY successes DESC) AS Ranks, Company, successes
FROM missions_success as m_s
)
SELECT *
FROM mission_rank;

--- Calculate Last Launch Date For USSR [Showcasing Lag Window Function]
WITH ussr_data AS(
SELECT `Row ID`,Company, Date as `Launch date`
FROM Temp_table
WHERE Company = 'RVSN USSR'
ORDER BY 3 ASC
)
SELECT *,LAG(`Launch Date`,1) OVER(ORDER BY `Launch date` ASC) as `Last Launch Date`
FROM ussr_data;

