DROP TABLE IF EXISTS TeamResult;
drop table if exists DriverResult;
DROP TABLE IF EXISTS CarTyre;
DROP TABLE IF EXISTS Tyre;
DROP TABLE IF EXISTS Team;
drop table if exists Result;
DROP TABLE IF EXISTS CarNumber;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS CarClass;
DROP TABLE IF EXISTS Race;
DROP TABLE IF EXISTS Driver;

-- Driver table
CREATE TABLE IF NOT EXISTS Driver (
    id INT NOT NULL AUTO_INCREMENT,
    driver_name VARCHAR(50),
    country CHAR(4),
    PRIMARY KEY (id)
);

-- Race table
CREATE TABLE IF NOT EXISTS Race (
    id INT,
    -- race_yr INT NOT NULL,
    PRIMARY KEY (id)
);

-- Populate the Race table
INSERT INTO Race(id)
SELECT distinct race_yr
FROM results_in;

-- CarClass table
CREATE TABLE IF NOT EXISTS CarClass(
    id VARCHAR(50) NOT NULL,
    class_desc VARCHAR(50),
    PRIMARY KEY (id)
);

-- Populate the CarClass table (ill go back and add descriptions to these later)
INSERT INTO CarClass(id)
SELECT DISTINCT car_class
FROM results_in;

-- Car table
CREATE TABLE IF NOT EXISTS Car (
    id INT NOT NULL AUTO_INCREMENT,
    car_class_id VARCHAR(50),
    car_chassis VARCHAR(50),
    car_engine VARCHAR(50),
    PRIMARY KEY (id),
    FOREIGN KEY (car_class_id) REFERENCES CarClass(id)
);

-- CarNumber table
CREATE TABLE IF NOT EXISTS CarNumber (
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    car_id INT,
    PRIMARY KEY (race_id, car_number),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES Car(id)
);

-- Result table
CREATE TABLE IF NOT EXISTS Result (
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    pos VARCHAR(3) NOT NULL,
    laps INT,
    -- format used by the data [DECIMAL(8, 3)]
    distance DECIMAL(8, 3) NULL,
    racing_time TIME,
    retirement_reason VARCHAR(50) NULL,
    PRIMARY KEY (race_id, car_number),
    FOREIGN KEY (race_id, car_number) REFERENCES CarNumber(race_id, car_number)
);

-- Team table
CREATE TABLE IF NOT EXISTS Team (
    -- id INT NOT NULL AUTO_INCREMENT,
    team_name VARCHAR(100),
    country CHAR(4),
    PRIMARY KEY (team_name)
);

-- Tyre table
CREATE TABLE IF NOT EXISTS Tyre (
    id CHAR(2) NOT NULL,
    tyre_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert data into Tyre
INSERT INTO Tyre (id, tyre_name)
VALUES ('A', 'Avon'),
    ('BF', 'BF Goodrich'),
    ('Br', 'Barum'),
    ('B', 'Bridgestone'),
    ('C', 'Continental'),
    ('D', 'Dunlop'),
    ('E', 'Englebert'),
    ('F', 'Firestone'),
    ('G', 'Goodyear'),
    ('H', 'Hankook'),
    ('I', 'India'),
    ('Kl', 'Klèber'),
    ('Ku', 'Kumho'),
    ('M', 'Michelin'),
    ('P', 'Pirelli'),
    ('R', 'Rapson'),
    ('Y', 'Yokohama');

-- CarTyre table
CREATE TABLE IF NOT EXISTS CarTyre (
    car_id INT NOT NULL,
    tyre_id CHAR(2) NOT NULL,
    PRIMARY KEY (car_id, tyre_id),
    FOREIGN KEY (car_id) REFERENCES CarNumber(car_id),
    FOREIGN KEY (tyre_id) REFERENCES Tyre(id)
);

-- DriverResult table
CREATE TABLE IF NOT EXISTS DriverResult(
    driver_id INT NOT NULL,
    -- result_id INT NOT NULL,
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    driver_order INT,
    team_name VARCHAR(100),
    PRIMARY KEY (driver_id, race_id, car_number),
    FOREIGN KEY (driver_id) REFERENCES Driver(id),
    FOREIGN KEY (race_id, car_number) REFERENCES Result(race_id, car_number)
);

CREATE TABLE IF NOT EXISTS TeamResult(
    team_name VARCHAR(100),
    race_id INT NOT NULL, 
    car_number VARCHAR(3),
    ord_num INT,
    PRIMARY KEY(team_name, race_id, car_number),
    FOREIGN KEY (team_name) REFERENCES Team(team_name),
    FOREIGN KEY (race_id, car_number) REFERENCES Result(race_id, car_number)
);

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

    -- Start the procedure
    BEGIN res_loop: LOOP
        SET new_car_id = NULL;
        SET new_carnb_id = NULL;
        SET new_team_id = NULL;
        SET new_driver_id = NULL;

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

        IF done THEN
            LEAVE res_loop;
        END IF;

        SET new_drv_ord = 0;

        -- Start a transaction
        START TRANSACTION;

        WHILE res_drivers_name IS NOT NULL DO
            SET new_drv_name = SUBSTRING_INDEX(res_drivers_name, '|', 1);
            SET new_drv_cntry = SUBSTRING_INDEX(res_drivers_cntry, '|', 1);
            SET new_drv_ord = new_drv_ord + 1;

            IF new_drv_name != '' AND new_drv_cntry != '' THEN
                SET tmp_drv_name = new_drv_name;

                IF new_drv_name LIKE '%''%''%' THEN
                    SET fst_qt_idx = INSTR(new_drv_name, '''');
                    SET snd_qt_idx = LOCATE('''', new_drv_name, fst_qt_idx + 1);
                    SET tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);
                    SET tmp_drv_name = CONCAT(tmp_drv_name, TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1)));
                END IF;

                SET tmp_drv_name = REPLACE(tmp_drv_name, '(', '');
                SET tmp_drv_name = REPLACE(tmp_drv_name, ')', '');
                SET new_drv_name = TRIM(tmp_drv_name);

                BEGIN
                    DECLARE CONTINUE HANDLER FOR NOT FOUND
                        SET new_driver_id = NULL;

                    SELECT id INTO new_driver_id
                    FROM Driver
                    WHERE ((driver_name IS NULL) OR driver_name = new_drv_name)
                        AND driver_name = new_drv_name
                        AND country = new_drv_cntry;

                    IF new_driver_id IS NULL THEN
                        INSERT INTO Driver (driver_name, country)
                        VALUES (new_drv_name, new_drv_cntry);
                        SET new_driver_id = LAST_INSERT_ID();
                    END IF;
                END;
            END IF;

            IF res_car_chassis != '' OR res_car_engine != '' THEN
                BEGIN
                    DECLARE CONTINUE HANDLER FOR NOT FOUND
                        SET new_car_id = NULL;

                    SET res_car_class = NULLIF(res_car_class, '');
                    SET res_car_engine = NULLIF(res_car_engine, '');

                    SELECT id INTO new_car_id
                    FROM Car
                    WHERE car_chassis = res_car_chassis
                        AND ((car_engine IS NULL AND res_car_engine IS NULL) OR car_engine = res_car_engine);

                    IF new_car_id IS NULL THEN
                        INSERT INTO Car (car_class_id, car_chassis, car_engine)
                        VALUES (res_car_class, res_car_chassis, res_car_engine);
                        SET new_car_id = LAST_INSERT_ID();
                    END IF;
                END;
            ELSE
                SET new_car_id = NULL;
            END IF;

            INSERT IGNORE INTO CarNumber (race_id, car_number, car_id)
            VALUES (res_race_yr, res_car_nbr, new_car_id);

            SET new_carnb_id = LAST_INSERT_ID();

            IF res_car_tyres IS NOT NULL THEN
                INSERT IGNORE INTO CarTyre (car_id, tyre_id)
                SELECT new_carnb_id, id
                FROM Tyre
                WHERE tyre_name = res_car_tyres;
            END IF;

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

            IF res_team_name LIKE '%"' THEN
                SET res_team_name = REPLACE(SUBSTR(res_team_name, 1, CHAR_LENGTH(res_team_name) - 1), '""', '"');
            END IF;

            SET new_team_ord = 0;
            WHILE res_team_name IS NOT NULL DO
                SET new_team_name  = SUBSTRING_INDEX(res_team_name, '|', 1);
                SET new_team_cntry = SUBSTRING_INDEX(res_team_cntry, '|', 1);
                SET new_team_ord   = new_team_ord + 1;

                IF new_team_name LIKE '% (private entrant)' THEN
                    SET new_team_name = REPLACE(new_team_name, ' (private entrant)', '');
                END IF;

                IF new_team_name != '' THEN
                    BEGIN
                        DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_team_id = NULL;

                        SET new_team_cntry = NULLIF(new_team_cntry, '');

                        INSERT IGNORE INTO Team (team_name, country)
                        VALUES (new_team_name, new_team_cntry);

                    END;

                    INSERT IGNORE INTO TeamResult (team_name, race_id, car_number, ord_num)
                    VALUES (new_team_name, res_race_yr, res_car_nbr, new_team_ord);
                END IF;

                IF NOT INSTR(res_team_name, '|') THEN
                    SET res_team_name  = NULL;
                    SET res_team_cntry = NULL;
                ELSE
                    SET res_team_name  = SUBSTR(res_team_name , INSTR(res_team_name , '|') + 1);
                    SET res_team_cntry = SUBSTR(res_team_cntry, INSTR(res_team_cntry, '|') + 1);
                END IF;
            END WHILE;

            SET new_res_id = LAST_INSERT_ID();

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
    END LOOP;
END;
END// 
DELIMITER ;

call process_drivers();