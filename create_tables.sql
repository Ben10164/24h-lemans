DROP TABLE IF EXISTS Result;
DROP TABLE IF EXISTS DriverGroupCar;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS DriverGroup;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Class;
-- This will be the file that creates the tables

CREATE TABLE Class (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50)
);

CREATE TABLE Team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(50),
    team_country VARCHAR(50)
);

CREATE TABLE Driver (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_country VARCHAR(3),
    driver_name VARCHAR(50)
);

CREATE TABLE DriverGroup (
    driver_group_id INT AUTO_INCREMENT,
    team_id INT,
    driver_id INT,
    PRIMARY KEY(driver_group_id, driver_id),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Car (
    car_num INT,
    race_year INT,
    team_id INT,
    class_id INT,
    car_chassis VARCHAR(50),
    car_engine VARCHAR(50),
    PRIMARY KEY (car_num, race_year),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

CREATE TABLE DriverGroupCar (
    driver_group_id INT AUTO_INCREMENT,
    car_num INT,
    race_year INT,
    PRIMARY KEY (driver_group_id, race_year),
    FOREIGN KEY (driver_group_id) REFERENCES DriverGroup(driver_group_id),
    FOREIGN KEY (car_num, race_year) REFERENCES Car(car_num, race_year)
);

CREATE TABLE Result (
    car_num INT,
    race_year INT,
    car_result INT,
    car_time FLOAT,
    car_laps INT,
    car_distance FLOAT,
    car_retirement_reason VARCHAR(50),
    PRIMARY KEY (car_num, race_year),
    FOREIGN KEY (car_num, race_year) REFERENCES DriverGroupCar(car_num, race_year)
);
