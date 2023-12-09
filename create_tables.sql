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
    full_name VARCHAR(50),
    country CHAR(4),
    PRIMARY KEY (id)
);

-- Race table
CREATE TABLE IF NOT EXISTS Race (
    id INT NOT NULL AUTO_INCREMENT,
    race_yr INT NOT NULL,
    PRIMARY KEY (id)
);

-- CarClass table
CREATE TABLE IF NOT EXISTS CarClass(
    id VARCHAR(50) NOT NULL,
    class_desc VARCHAR(50),
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
    id INT NOT NULL AUTO_INCREMENT,
    race_id INT NOT NULL,
    car_id INT NOT NULL,
    car_number VARCHAR(3) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (race_id) REFERENCES Race(id),
    FOREIGN KEY (car_id) REFERENCES Car(id)
);

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

-- Team table
CREATE TABLE IF NOT EXISTS Team (
    id INT NOT NULL AUTO_INCREMENT,
    team_name VARCHAR(64),
    country CHAR(4),
    PRIMARY KEY (id)
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
    FOREIGN KEY (car_id) REFERENCES CarNumber(id),
    FOREIGN KEY (tyre_id) REFERENCES Tyre(id)
);

-- DriverResult table
CREATE TABLE IF NOT EXISTS DriverResult(
    driver_id INT NOT NULL,
    result_id INT NOT NULL,
    place INT NOT NULL,
    PRIMARY KEY (driver_id, result_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(id),
    FOREIGN KEY (result_id) REFERENCES Result(id)
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