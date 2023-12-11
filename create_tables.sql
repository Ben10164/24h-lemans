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

/*markdown
# Driver
*/

-- Driver table
CREATE TABLE IF NOT EXISTS Driver (
    id INT NOT NULL AUTO_INCREMENT,
    driver_name VARCHAR(50),
    country CHAR(4),
    PRIMARY KEY (id)
);

/*markdown
# Race
*/

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

/*markdown
# CarClass
*/

-- CarClass table
CREATE TABLE IF NOT EXISTS CarClass(
    id VARCHAR(50) NOT NULL,
    class_desc VARCHAR(50),
    PRIMARY KEY (id)
);

/*markdown
# Car
*/

-- Car table
CREATE TABLE IF NOT EXISTS Car (
    id INT NOT NULL AUTO_INCREMENT,
    car_class_id VARCHAR(50),
    car_chassis VARCHAR(50),
    car_engine VARCHAR(50),
    PRIMARY KEY (id),
    FOREIGN KEY (car_class_id) REFERENCES CarClass(id)
);

/*markdown
# CarNumber
*/

-- CarNumber table
CREATE TABLE IF NOT EXISTS CarNumber (
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    car_id INT,
    PRIMARY KEY (race_id, car_number),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES Car(id)
);

/*markdown
# Result
*/

-- Result table
CREATE TABLE IF NOT EXISTS Result (
    -- id INT NOT NULL AUTO_INCREMENT,
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    pos VARCHAR(3) NOT NULL,
    laps INT,
    -- format used by the data [DECIMAL(8, 3)]
    distance DECIMAL(8, 3) NULL, 
    racing_time TIME,
    retirement_reason VARCHAR(128) NULL,
    -- PRIMARY KEY (id),
    PRIMARY KEY (race_id, car_number),
    FOREIGN KEY (race_id, car_number) REFERENCES CarNumber(race_id, car_number)
);

/*markdown
# Team
*/

-- Team table
CREATE TABLE IF NOT EXISTS Team (
    id INT NOT NULL AUTO_INCREMENT,
    team_name VARCHAR(64),
    country CHAR(4),
    PRIMARY KEY (id)
);

/*markdown
# Tyre
*/

-- Tyre table
CREATE TABLE IF NOT EXISTS Tyre (
    id CHAR(2) NOT NULL,
    tyre_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert data into Tyre
INSERT INTO
    Tyre (id, tyre_name)
VALUES
    ('A', 'Avon'),
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

/*markdown
# CarTyre
*/

-- CarTyre table
CREATE TABLE IF NOT EXISTS CarTyre (
    car_id INT NOT NULL,
    tyre_id CHAR(2) NOT NULL,
    PRIMARY KEY (car_id, tyre_id),
    FOREIGN KEY (car_id) REFERENCES CarNumber(car_id),
    FOREIGN KEY (tyre_id) REFERENCES Tyre(id)
);

/*markdown
# DriverResult
*/

-- DriverResult table
CREATE TABLE IF NOT EXISTS DriverResult(
    driver_id INT NOT NULL,
    -- result_id INT NOT NULL,
    race_id INT NOT NULL,
    car_number VARCHAR(3),
    driver_order INT,
    PRIMARY KEY (driver_id, race_id, car_number),
    FOREIGN KEY (driver_id) REFERENCES Driver(id),
    FOREIGN KEY (race_id, car_number) REFERENCES Result(race_id, car_number)
);

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS process_drivers;

DELIMITER //

-- Create the procedure
CREATE PROCEDURE process_drivers()
BEGIN
    -- Declare variables
    DECLARE res_id INT;
    DECLARE res_race_yr INT;
    DECLARE res_pos VARCHAR(3);
    DECLARE res_car_class VARCHAR(12);
    DECLARE res_car_nbr VARCHAR(3);
    DECLARE res_team_cntry VARCHAR(16);
    DECLARE res_team_name VARCHAR(128);
    DECLARE res_drivers_cntry VARCHAR(32);
    DECLARE res_drivers_name VARCHAR(256);
    DECLARE res_car_chassis VARCHAR(64);
    DECLARE res_car_engine VARCHAR(64);
    DECLARE res_car_tyres VARCHAR(16);
    DECLARE res_laps INT;
    DECLARE res_distance DECIMAL(8, 3);
    DECLARE res_racing_time TIME(3);
    DECLARE res_reason VARCHAR(128);

    DECLARE new_driver_id INT;
    DECLARE new_drv_name VARCHAR(64);
    DECLARE new_drv_title VARCHAR(16);
    DECLARE new_drv_fname VARCHAR(32);
    DECLARE new_drv_lname VARCHAR(32);
    DECLARE new_drv_nick VARCHAR(32);
    DECLARE new_drv_nm_sfx VARCHAR(4);
    DECLARE new_drv_sex CHAR(1);
    DECLARE new_drv_cntry CHAR(4);
    DECLARE new_drv_ord INT;
    DECLARE tmp_drv_name VARCHAR(64);
    DECLARE fst_qt_idx INTEGER;
    DECLARE snd_qt_idx INTEGER;
    DECLARE new_car_id INTEGER;
    DECLARE new_carnb_id INTEGER;
    DECLARE new_team_id INTEGER;
    DECLARE new_res_id INT; -- Added declaration for new_res_id

    -- Declare the cursor outside of the BEGIN...END block
    DECLARE done INT DEFAULT FALSE;

    -- Declare CONTINUE HANDLER inside the BEGIN...END block
    DECLARE cur_results CURSOR FOR
        SELECT id, race_yr, pos, car_class, car_nbr, team_cntry, team_name, drivers_cntry, drivers_name, car_chassis, car_engine, car_tyres, laps, distance, racing_time, reason
        FROM results_in
        WHERE processed IS FALSE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

     -- Open the cursor
        OPEN cur_results;

    -- Start the procedure
    BEGIN
        res_loop: LOOP
            SET new_car_id = NULL;
            SET new_carnb_id = NULL;
            SET new_team_id = NULL;
            SET new_driver_id = NULL;

            FETCH cur_results INTO
                res_id, res_race_yr, res_pos, res_car_class, res_car_nbr, res_team_cntry, res_team_name, res_drivers_cntry, res_drivers_name,
                res_car_chassis, res_car_engine, res_car_tyres, res_laps, res_distance, res_racing_time, res_reason;

            IF done THEN
                LEAVE res_loop;
            END IF;

            SET new_drv_ord = 0;

            -- Start a transaction
            START TRANSACTION;
            WHILE res_drivers_name IS NOT NULL DO
                SET new_drv_title = NULL;
                SET new_drv_name = SUBSTRING_INDEX(res_drivers_name, '|', 1);
                SET new_drv_nick = NULL;
                SET new_drv_nm_sfx = NULL;
                SET new_drv_cntry = SUBSTRING_INDEX(res_drivers_cntry, '|', 1);
                SET new_drv_sex = 'M';
                SET new_drv_ord = new_drv_ord + 1;

                -- Detect females
                IF new_drv_name LIKE 'Mme%' OR new_drv_name LIKE 'Miss%' OR new_drv_name LIKE 'Mrs.%' THEN
                    SET new_drv_sex = 'F';
                    SET new_drv_name = SUBSTR(new_drv_name, INSTR(new_drv_name, ' ') + 1);
                END IF;

                IF new_drv_name != '' AND new_drv_cntry != '' THEN
                    SET tmp_drv_name = new_drv_name;

                    IF new_drv_name LIKE '%''%''%' THEN
                        -- name with two single quotes
                        SET fst_qt_idx = INSTR(new_drv_name, '''');
                        SET snd_qt_idx = LOCATE('''', new_drv_name, fst_qt_idx + 1);

                        SET tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);
                        SET tmp_drv_name = CONCAT(tmp_drv_name, TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1)));
                        SET new_drv_nick = SUBSTRING(new_drv_name, fst_qt_idx + 1, snd_qt_idx - fst_qt_idx - 1);
                    END IF;

                    -- clean braces in name and trim
                    SET tmp_drv_name = REPLACE(tmp_drv_name, '(', '');
                    SET tmp_drv_name = REPLACE(tmp_drv_name, ')', '');
                    SET new_drv_name = TRIM(tmp_drv_name);

                    BEGIN
                        DECLARE CONTINUE HANDLER FOR NOT FOUND
                            SET new_driver_id = NULL;

                        -- Query should be a unique or non-unique index lookup on idx_driver_unq
                        SELECT id INTO new_driver_id
                        FROM Driver
                        WHERE (
                            (driver_name IS NULL)
                            OR driver_name = new_drv_name
                        )
                            AND driver_name = new_drv_name
                            AND country = new_drv_cntry;

                        IF new_driver_id IS NULL THEN
                            INSERT INTO Driver (driver_name, country)
                            VALUES (new_drv_name, new_drv_cntry);
                            SET new_driver_id = LAST_INSERT_ID();
                        END IF;
                    END;

                END IF;
                /* Create car */
    IF  res_car_chassis != '' OR res_car_engine != '' THEN
      BEGIN
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_car_id = NULL;

        SET res_car_class  = NULLIF(res_car_class, '');
        SET res_car_engine = NULLIF(res_car_engine, '');

        /* Check if car exists */
        SELECT id
          INTO new_car_id
          FROM Car
         WHERE  car_chassis = res_car_chassis
           AND (   (car_engine IS NULL AND res_car_engine IS NULL)
                OR car_engine  = res_car_engine
               );

        /* else create it */
        IF new_car_id IS NULL THEN
          INSERT INTO Car (car_chassis, car_engine)
          VALUES ( res_car_chassis, res_car_engine);
          SET new_car_id = LAST_INSERT_ID();
        END IF;
      END;
    ELSE /* car not defined */
      SET new_car_id = NULL;
    END IF;

    INSERT IGNORE INTO CarNumber (race_id, car_number, car_id)
    VALUES (res_race_yr, res_car_nbr, new_car_id);

    SET new_carnb_id = LAST_INSERT_ID();
                 /* Create result */
            INSERT IGNORE INTO Result (race_id, car_number, pos, laps, distance, racing_time, retirement_reason)
            VALUES (res_race_yr, res_car_nbr, res_pos, res_laps, res_distance, res_racing_time, res_reason);

                SET new_res_id = LAST_INSERT_ID();
                IF new_driver_id IS NOT NULL AND new_res_id IS NOT NULL THEN
                    INSERT IGNORE INTO DriverResult (driver_id, race_id, car_number, driver_order)
                    VALUES (new_driver_id, res_race_yr, res_car_nbr, new_drv_ord);
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

END //

DELIMITER ;


call process_drivers();

select * from Result limit 10;