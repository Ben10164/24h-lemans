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
    id INT NOT NULL AUTO_INCREMENT,
    race_yr INT NOT NULL,
    PRIMARY KEY (id)
);

-- Populate the Race table
INSERT INTO Race(race_yr)
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
    id INT NOT NULL AUTO_INCREMENT,
    race_id INT NOT NULL,
    car_id INT NOT NULL,
    car_number VARCHAR(3) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES Car(id)
);

/*markdown
# Result
*/

-- Result table
CREATE TABLE IF NOT EXISTS Result (
    id INT NOT NULL AUTO_INCREMENT,
    race_id INT NOT NULL,
    car_id INT NOT NULL,
    pos VARCHAR(3) NOT NULL,
    laps INT,
    -- format used by the data [DECIMAL(8, 3)]
    distance DECIMAL(8, 3) NULL, 
    racing_time TIME,
    retirement_reason VARCHAR(128) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES CarNumber(id)
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
    FOREIGN KEY (car_id) REFERENCES CarNumber(id),
    FOREIGN KEY (tyre_id) REFERENCES Tyre(id)
);

/*markdown
# DriverResult
*/

-- DriverResult table
CREATE TABLE IF NOT EXISTS DriverResult(
    driver_id INT NOT NULL,
    result_id INT NOT NULL,
    place INT NOT NULL,
    PRIMARY KEY (driver_id, result_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(id),
    FOREIGN KEY (result_id) REFERENCES Result(id)
);

DROP PROCEDURE IF EXISTS process_drivers;
DELIMITER //
CREATE PROCEDURE process_drivers()
BEGIN 
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

    SET
        new_drv_ord = 0;

    WHILE res_drivers_name IS NOT NULL DO
        SET
            new_drv_title = NULL;

        SET
            new_drv_name = SUBSTRING_INDEX(res_drivers_name, '|', 1);

        SET
            new_drv_nick = NULL;

        SET
            new_drv_nm_sfx = NULL;

        SET
            new_drv_cntry = SUBSTRING_INDEX(res_drivers_cntry, '|', 1);

        SET
            new_drv_sex = 'M';

        SET
            new_drv_ord = new_drv_ord + 1;

        /* Detect females */
        IF new_drv_name LIKE 'Mme%'
            OR new_drv_name LIKE 'Miss%'
            OR new_drv_name LIKE 'Mrs.%' THEN
            SET
                new_drv_sex = 'F';

            SET
                new_drv_name = SUBSTR(
                    new_drv_name,
                    INSTR(new_drv_name, ' ') + 1
                );

        END IF;

        IF new_drv_name != ''
            AND new_drv_cntry != '' THEN BEGIN DECLARE tmp_drv_name VARCHAR(64) DEFAULT new_drv_name;

        IF new_drv_name LIKE '%''%''%' THEN
            /* name with two single quotes */
            BEGIN DECLARE fst_qt_idx INTEGER DEFAULT INSTR(new_drv_name, '''');

            DECLARE snd_qt_idx INTEGER DEFAULT LOCATE('''', new_drv_name, fst_qt_idx + 1);

            SET
                tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);

            SET
                tmp_drv_name = CONCAT(
                    tmp_drv_name,
                    TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1))
                );

            SET
                new_drv_nick = SUBSTRING(
                    new_drv_name,
                    fst_qt_idx + 1,
                    snd_qt_idx - fst_qt_idx - 1
                );

            END;

        END IF;

        /* clean braces in name 
        AND trim */
        SET
            new_drv_name = REPLACE(tmp_drv_name, '(', '');

        SET
            new_drv_name = REPLACE(new_drv_name, ')', '');

        SET
            new_drv_name = TRIM(new_drv_name);

        BEGIN DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET
            new_driver_id = NULL;

        /* Query shoud be unique 
        OR non-unique index lookup 
        ON idx_driver_unq */
        SELECT
            id AS id INTO new_driver_id
        FROM
            Driver
        WHERE
            (
                (
                    driver_name IS NULL
                )
                OR driver_name = new_drv_name
            )
            AND driver_name = new_drv_name
            AND country = new_drv_cntry;

        IF new_driver_id IS NULL THEN
            INSERT INTO
                Driver (driver_name, country)
            VALUES
                (
                    new_drv_name,
                    new_drv_cntry
                );

            SET
                new_driver_id = LAST_INSERT_ID();

            END IF;

        END;

        END;

        END IF;

        IF new_driver_id IS NOT NULL THEN
            INSERT INTO
                DriverResult (driver_id, result_id, place)
            VALUES
                (
                    new_driver_id,
                    new_res_id,
                    new_drv_ord
                );

        END IF;

        IF NOT INSTR(res_drivers_name, '|') THEN
            SET
                res_drivers_name = NULL;

            SET
                res_drivers_cntry = NULL;

            ELSE
            SET
                res_drivers_name = SUBSTR(
                    res_drivers_name,
                    INSTR(res_drivers_name, '|') + 1
                );

            SET
                res_drivers_cntry = SUBSTR(
                    res_drivers_cntry,
                    INSTR(res_drivers_cntry, '|') + 1
                );

        END IF;

    END WHILE;

END;
//
DELIMITER ;

call process_drivers();
select * from DriverResult