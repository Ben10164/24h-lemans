-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS process_drivers;

-- Hey! This is a monster of a procedure, and yes, I spent a VERY long time on this.
-- I used a few outside sources (including my sister, the SQL queen), but everything 
-- was written by me. 

DELIMITER // -- Create the procedure
CREATE PROCEDURE process_drivers()
BEGIN
    -- Variables related to results_in table
    DECLARE res_id INT;
    DECLARE res_race_yr INT;
    DECLARE res_pos VARCHAR(3);
    DECLARE res_car_class VARCHAR(50);
    DECLARE res_car_nbr VARCHAR(3);
    DECLARE res_team_cntry VARCHAR(50);
    DECLARE res_team_name VARCHAR(100);
    DECLARE res_drivers_cntry VARCHAR(50);
    DECLARE res_drivers_name VARCHAR(200);
    DECLARE res_car_chassis VARCHAR(100);
    DECLARE res_car_engine VARCHAR(100);
    DECLARE res_car_tyres VARCHAR(50);
    DECLARE res_laps INT;
    DECLARE res_distance DECIMAL(8, 3);
    DECLARE res_racing_time TIME(3);
    DECLARE res_reason VARCHAR(200);

    -- Variables related to Driver table
    DECLARE new_driver_id INT;
    DECLARE new_drv_name VARCHAR(100);
    DECLARE new_drv_cntry CHAR(4);
    DECLARE new_drv_ord INT;
    DECLARE tmp_drv_name VARCHAR(100);
    DECLARE fst_qt_idx INTEGER;
    DECLARE snd_qt_idx INTEGER;

    -- Variables related to Car and CarNumber tables
    DECLARE new_car_id INTEGER;
    DECLARE new_carnb_id INTEGER;

    -- Variables related to Team, TeamResult, and results_in tables
    DECLARE new_team_id INTEGER;
    DECLARE new_res_id INT;
    DECLARE new_team_name VARCHAR(100);
    DECLARE new_team_cntry CHAR(4);
    DECLARE new_team_ord INT;

    -- Control variable
    DECLARE done INT DEFAULT FALSE;


    -- Declare the cursor outside of the BEGIN...END block
    DECLARE cur_results CURSOR FOR
        SELECT id,
            race_yr,
            pos,
            car_class,
            car_nbr,
            team_cntry,
            team_name,
            drivers_cntry,
            drivers_name,
            car_chassis,
            car_engine,
            car_tyres,
            laps,
            distance,
            racing_time,
            reason
        FROM results_in
        WHERE processed IS FALSE;

    -- Declare CONTINUE HANDLER inside the BEGIN...END block
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    -- Open the cursor
    OPEN cur_results;

   -- Begin processing results in a loop
    BEGIN res_loop: LOOP
        -- Initialize variables for the current iteration
        SET new_car_id = NULL;
        SET new_carnb_id = NULL;
        SET new_team_id = NULL;
        SET new_driver_id = NULL;

        -- Fetch data for the current result
        FETCH cur_results INTO res_id,
            res_race_yr,
            res_pos,
            res_car_class,
            res_car_nbr,
            res_team_cntry,
            res_team_name,
            res_drivers_cntry,
            res_drivers_name,
            res_car_chassis,
            res_car_engine,
            res_car_tyres,
            res_laps,
            res_distance,
            res_racing_time,
            res_reason;
        -- Check if there are no more results to process
        IF done THEN
            -- Exit the loop if no more results
            LEAVE res_loop; 
        END IF;
        -- Initialize driver order for the current result
        SET new_drv_ord = 0;
        
        -- Start a database transaction
        START TRANSACTION;
        -- Process each driver associated with the result
        WHILE res_drivers_name IS NOT NULL DO
            -- Extract driver name and country
            SET new_drv_name = SUBSTRING_INDEX(res_drivers_name, '|', 1);
            SET new_drv_cntry = SUBSTRING_INDEX(res_drivers_cntry, '|', 1);
            SET new_drv_ord = new_drv_ord + 1;
            -- Check if driver name and country are not empty
            IF new_drv_name != '' AND new_drv_cntry != '' THEN
                -- Prepare driver name for insertion, handling special characters
                SET tmp_drv_name = new_drv_name;
                -- Process name with two single quotes
                IF new_drv_name LIKE '%''%''%' THEN
                    SET fst_qt_idx = INSTR(new_drv_name, '''');
                    SET snd_qt_idx = LOCATE('''', new_drv_name, fst_qt_idx + 1);
                    SET tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);
                    SET tmp_drv_name = CONCAT(tmp_drv_name, TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1)));
                END IF;
                -- Clean braces in name and trim
                SET tmp_drv_name = REPLACE(tmp_drv_name, '(', '');
                SET tmp_drv_name = REPLACE(tmp_drv_name, ')', '');
                SET new_drv_name = TRIM(tmp_drv_name);
                -- Begin handling database exceptions
                BEGIN
                    DECLARE CONTINUE HANDLER FOR NOT FOUND
                        SET new_driver_id = NULL;
                    -- Lookup driver in the database based on unique or non-unique index
                    SELECT id INTO new_driver_id
                    FROM Driver
                    WHERE ((driver_name IS NULL) OR driver_name = new_drv_name)
                        AND driver_name = new_drv_name
                        AND country = new_drv_cntry;
                    -- If driver not found, insert into the Driver table
                    IF new_driver_id IS NULL THEN
                        INSERT INTO Driver (driver_name, country)
                        VALUES (new_drv_name, new_drv_cntry);
                        SET new_driver_id = LAST_INSERT_ID();
                    END IF;
                END;
            END IF;
            -- Process car information
            IF res_car_chassis != '' OR res_car_engine != '' THEN
                BEGIN
                    DECLARE CONTINUE HANDLER FOR NOT FOUND
                        SET new_car_id = NULL;
                    SET res_car_class = NULLIF(res_car_class, '');
                    SET res_car_engine = NULLIF(res_car_engine, '');
                    -- Check if car exists in the database
                    SELECT id INTO new_car_id
                    FROM Car
                    WHERE car_chassis = res_car_chassis
                        AND ((car_engine IS NULL AND res_car_engine IS NULL) OR car_engine = res_car_engine);
                    -- If car not found, insert into the Car table
                    IF new_car_id IS NULL THEN
                        INSERT INTO Car (car_class_id, car_chassis, car_engine)
                        VALUES (res_car_class, res_car_chassis, res_car_engine);
                        SET new_car_id = LAST_INSERT_ID();
                    END IF;
                END;
            ELSE
                -- Car not defined
                SET new_car_id = NULL;
            END IF;
            -- Insert CarNumber association
            INSERT IGNORE INTO CarNumber (race_id, car_number, car_id)
            VALUES (res_race_yr, res_car_nbr, new_car_id);
            -- Retrieve the last inserted CarNumber ID
            SET new_carnb_id = LAST_INSERT_ID();
            -- Insert CarTyre association
            IF res_car_tyres IS NOT NULL THEN
                INSERT IGNORE INTO CarTyre (car_id, tyre_id)
                SELECT new_carnb_id, id
                FROM Tyre
                WHERE tyre_name = res_car_tyres;
            END IF;
            -- Insert result information
            INSERT IGNORE INTO Result (
                race_id,
                car_number,
                pos,
                laps,
                distance,
                racing_time,
                retirement_reason
            )
            VALUES (
                res_race_yr,
                res_car_nbr,
                res_pos,
                res_laps,
                res_distance,
                res_racing_time,
                res_reason
            );
            -- Strip double quotes from team name
            IF res_team_name LIKE '%"' THEN
                SET res_team_name = REPLACE(SUBSTR(res_team_name, 1, CHAR_LENGTH(res_team_name) - 1), '""', '"');
            END IF;
            -- Initialize team order for the current result
            SET new_team_ord = 0;
            -- Process each team associated with the result
            WHILE res_team_name IS NOT NULL DO
                -- Extract team name, country, and check for private entrants
                SET new_team_name  = SUBSTRING_INDEX(res_team_name, '|', 1);
                SET new_team_cntry = SUBSTRING_INDEX(res_team_cntry, '|', 1);
                SET new_team_ord   = new_team_ord + 1;
                -- Detect and handle private entrants
                IF new_team_name LIKE '% (private entrant)' THEN
                    SET new_team_name = REPLACE(new_team_name, ' (private entrant)', '');
                END IF;
                -- Check if team name is not empty
                IF new_team_name != '' THEN
                    -- Begin handling database exceptions
                    BEGIN
                        DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_team_id = NULL;
                        -- Lookup team in the database
                        SET new_team_cntry = NULLIF(new_team_cntry, '');
                        INSERT IGNORE INTO Team (team_name, country)
                        VALUES (new_team_name, new_team_cntry);
                    END;
                    -- Insert TeamResult association
                    INSERT IGNORE INTO TeamResult (team_name, race_id, car_number, ord_num)
                    VALUES (new_team_name, res_race_yr, res_car_nbr, new_team_ord);
                END IF;
                -- Update variables for the next iteration
                IF NOT INSTR(res_team_name, '|') THEN
                    SET res_team_name  = NULL;
                    SET res_team_cntry = NULL;
                ELSE
                    SET res_team_name  = SUBSTR(res_team_name , INSTR(res_team_name , '|') + 1);
                    SET res_team_cntry = SUBSTR(res_team_cntry, INSTR(res_team_cntry, '|') + 1);
                END IF;
            END WHILE;
            -- Retrieve the last inserted Result ID
            SET new_res_id = LAST_INSERT_ID();
            -- Insert DriverResult association
            IF new_driver_id IS NOT NULL AND new_res_id IS NOT NULL THEN
                INSERT IGNORE INTO DriverResult (driver_id, race_id, car_number, driver_order, team_name)
                VALUES (
                    new_driver_id,
                    res_race_yr,
                    res_car_nbr,
                    new_drv_ord,
                    new_team_name
                );
            END IF;
            -- Update variables for the next iteration
            IF NOT INSTR(res_drivers_name, '|') THEN
                SET res_drivers_name = NULL;
                SET res_drivers_cntry = NULL;
            ELSE
                SET res_drivers_name = SUBSTR(res_drivers_name, INSTR(res_drivers_name, '|') + 1);
                SET res_drivers_cntry = SUBSTR(res_drivers_cntry, INSTR(res_drivers_cntry, '|') + 1);
            END IF;
        END WHILE;
        -- Commit the transaction
        COMMIT;
    -- End the result processing loop
    END LOOP; 
END;
END// 
DELIMITER ;