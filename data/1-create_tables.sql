DROP TABLE IF EXISTS TeamResult;
DROP TABLE IF EXISTS DriverResult;
DROP TABLE IF EXISTS CarTyre;
DROP TABLE IF EXISTS Tyre;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Result;
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
    id YEAR,
    PRIMARY KEY (id)
);

-- CarClass table
CREATE TABLE IF NOT EXISTS CarClass(
    id VARCHAR(50) NOT NULL,
    class_desc VARCHAR(150),
    PRIMARY KEY (id)
);

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
    race_id YEAR NOT NULL,
    car_number VARCHAR(3),
    car_id INT,
    PRIMARY KEY (race_id, car_number),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES Car(id)
);

-- Result table
CREATE TABLE IF NOT EXISTS Result (
    race_id YEAR NOT NULL,
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
    race_id YEAR NOT NULL,
    car_number VARCHAR(3),
    driver_order INT,
    team_name VARCHAR(100),
    PRIMARY KEY (driver_id, race_id, car_number),
    FOREIGN KEY (driver_id) REFERENCES Driver(id),
    FOREIGN KEY (race_id, car_number) REFERENCES Result(race_id, car_number)
);

CREATE TABLE IF NOT EXISTS TeamResult(
    team_name VARCHAR(100),
    race_id YEAR NOT NULL, 
    car_number VARCHAR(3),
    ord_num INT,
    PRIMARY KEY(team_name, race_id, car_number),
    FOREIGN KEY (team_name) REFERENCES Team(team_name),
    FOREIGN KEY (race_id, car_number) REFERENCES Result(race_id, car_number)
);
