-- Populate the Race table
INSERT INTO Race(id)
SELECT distinct race_yr
FROM results_in;


-- Populate the CarClass table (ill go back and add descriptions to these later)
INSERT INTO CarClass(id)
SELECT DISTINCT car_class
FROM results_in;

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

call process_drivers();