-- Populate the Race table
INSERT INTO Race(id)
SELECT distinct race_yr
FROM results_in;


-- Populate the CarClass table (ill go back and add descriptions to these later)
INSERT INTO CarClass(id)
SELECT DISTINCT car_class 
FROM results_in;

-- This took a very long time...
-- I did have some help with this person online who
-- decided to make some simple descriptions for all of the classes
-- But then there was a lot of copy paste...
UPDATE CarClass
SET class_desc = 
    CASE 
        WHEN id = '1.1' THEN 'Class 1.1 (Up to 1.1 Liters)'
        WHEN id = '1.5' THEN 'Class 1.5 (Up to 1.5 Liters)'
        WHEN id = '2.0' THEN 'Class 2.0 (Up to 2.0 Liters)'
        WHEN id = '3.0' THEN 'Class 3.0 (Up to 3.0 Liters)'
        WHEN id = '4.0' THEN 'Class 4.0 (Up to 4.0 Liters)'
        WHEN id = '5.0' THEN 'Class 5.0 (Up to 5.0 Liters)'
        WHEN id = '750' THEN 'S-750 Class 750cc'
        WHEN id = '8.0' THEN 'Class 8.0 (Up to 8.0 Liters)'
        WHEN id = '750' THEN 'S-750 Class 750cc'
        WHEN id = '8.0' THEN 'Class 8.0 (Up to 8.0 Liters)'
        WHEN id = 'B' THEN 'Group B (Historical rally cars, known for high performance)'
        WHEN id = 'C' THEN 'Group C (Endurance racing prototype class)'
        WHEN id = 'C1' THEN 'Group C1 (Subclass within Group C, typically with smaller engines)'
        WHEN id = 'C2' THEN 'Group C2 (Subclass within Group C, often with smaller teams and budgets)'
        WHEN id = 'C3' THEN 'Group C3 (Subclass within Group C, featuring certain specifications)'
        WHEN id = 'C4' THEN 'Group C4 (Subclass within Group C, with distinct characteristics)'
        WHEN id = 'CJr' THEN 'Group CJr (Junior class within the Group C category)'
        WHEN id = 'E+3.0' THEN 'Class E (Up to 3.0 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E1.0' THEN 'Class 1.0 (Up to 1.0 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E1.15' THEN 'Class 1.15 (Up to 1.15 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E1.3' THEN 'Class 1.3 (Up to 1.3 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E1.6' THEN 'Class 1.6 (Up to 1.6 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E2.0' THEN 'Class 2.0 (Up to 2.0 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E3.0' THEN 'Class 3.0 (Up to 3.0 Liters. Specifically uses the Renault Energy Engine)'
        WHEN id = 'E850' THEN 'Class 850 (850cc. Specifically uses the Renault Energy Engine)'
        WHEN id = 'Exp' THEN 'Experimental Class (Features innovative or experimental vehicle designs)'
        WHEN id = 'Gr.4' THEN 'Group 4 (Historical rally and racing cars with specific regulations)'
        WHEN id = 'Gr.5' THEN 'Group 5 (Sportscar racing class known for diversity and innovation)'
        WHEN id = 'Gr.5+2.0' THEN 'Group 5 (Engines > 2.0L. Modified Group 5 cars with larger engines)'
        WHEN id = 'Gr.5+2.5' THEN 'Group 5 (Engines > 2.5L. Modified Group 5 cars with larger engines)'
        WHEN id = 'Gr.6' THEN 'Group 6 (Prototype racing class with less restrictive regulations)'
        WHEN id = 'GT' THEN 'Grand Touring (High-performance cars adapted for long-distance racing)'
        WHEN id = 'GT+2.0' THEN 'GT (Engines > 2.0L. Modified GT cars with larger engines)'
        WHEN id = 'GT+3.0' THEN 'GT (Engines > 3.0L. Modified GT cars with larger engines)'
        WHEN id = 'GT+5.0' THEN 'GT (Engines > 5.0L. Modified GT cars with larger engines)'
        WHEN id = 'GT1' THEN 'GT1 (Top-tier Grand Touring class featuring high-performance cars)'
        WHEN id = 'GT1.1' THEN 'GT1 (Up to 1.1 Liters. GT1 class with smaller engines)'
        WHEN id = 'GT1.15' THEN 'GT1 (Up to 1.15 Liters. GT1 class with smaller engines)'
        WHEN id = 'GT1.3' THEN 'GT1 (Up to 1.3 Liters. GT1 class with smaller engines)'
        WHEN id = 'GT1.5' THEN 'GT1 (Up to 1.5 Liters. GT1 class with smaller engines)'
        WHEN id = 'GT1.6' THEN 'GT1 (Up to 1.6 Liters. GT1 class with smaller engines)'
        WHEN id = 'GT2' THEN 'GT2 (Second-tier Grand Touring class with slightly less powerful cars)'
        WHEN id = 'GT2.0' THEN 'GT2 (Up to 2.0 Liters. GT2 class with smaller engines)'
        WHEN id = 'GT2.5' THEN 'GT2 (Up to 2.5 Liters. GT2 class with smaller engines)'
        WHEN id = 'GT3.0' THEN 'GT3 (Up to 3.0 Liters. GT3 class with smaller engines)'
        WHEN id = 'GT4.0' THEN 'GT4 (Up to 4.0 Liters. GT4 class with smaller engines)'
        WHEN id = 'GT5.0' THEN 'GT5 (Up to 5.0 Liters. GT5 class with smaller engines)'
        WHEN id = 'GT750' THEN 'GT750 (Specific class with 750cc engine capacity)'
        WHEN id = 'GTEAm' THEN 'GT Endurance Amateur (Amateur category within GT Endurance racing)'
        WHEN id = 'GTO' THEN 'Grand Touring Over (Historical class with high-performance GT cars)'
        WHEN id = 'GTP' THEN 'Grand Touring Prototype (Prototype racing class with GT-style cars)'
        WHEN id = 'GTP+3.0' THEN 'GTP (Engines > 3.0L. Modified GTP cars with larger engines)'
        WHEN id = 'GTP3.0' THEN 'GTP3.0 (GTP class with engines specifically > 3.0L)'
        WHEN id = 'GTS' THEN 'Grand Touring Sport (Sportscar class with high-performance cars)'
        WHEN id = 'GTS+5.0' THEN 'GTS (Engines > 5.0L. Modified GTS cars with larger engines)'
        WHEN id = 'GTS2.5' THEN 'GTS (Up to 2.5 Liters. GTS class with smaller engines)'
        WHEN id = 'GTS3.0' THEN 'GTS (Up to 3.0 Liters. GTS class with smaller engines)'
        WHEN id = 'GTS5.0' THEN 'GTS (Up to 5.0 Liters. GTS class with smaller engines)'
        WHEN id = 'GTSer.' THEN 'Grand Touring Series (General series featuring various GT classes)'
        WHEN id = 'GTX' THEN 'Grand Touring Experimental (Experimental GT racing class)'
        WHEN id = 'Hypercar' THEN 'Hypercar (Top-tier class featuring the fastest and most advanced cars)'
        WHEN id = 'IMSA' THEN 'International Motor Sports Association (North American motorsport organization)'
        WHEN id = 'IMSA+2.5' THEN 'IMSA (Engines > 2.5L. Modified IMSA cars with larger engines)'
        WHEN id = 'IMSAGTO' THEN 'IMSA Grand Touring Over (Historical IMSA class with high-performance cars)'
        WHEN id = 'IMSAGTP' THEN 'IMSA Grand Touring Prototype (Prototype racing class in IMSA)'
        WHEN id = 'IMSAGTS' THEN 'IMSA Grand Touring Sport (Sportscar class in IMSA)'
        WHEN id = 'IMSAGTX' THEN 'IMSA Grand Touring Experimental (Experimental class in IMSA)'
        WHEN id = 'IMSALights' THEN 'IMSA Lights (Developmental series within IMSA)'
        WHEN id = 'Innovation' THEN 'Innovation Class (Class for innovative or cutting-edge vehicle designs)'
        WHEN id = 'Innovative' THEN 'Innovative Class (Class for pioneering and experimental vehicle concepts)'
        WHEN id = 'LMGT1' THEN 'Le Mans Grand Touring 1 (Top-tier GT class at the Le Mans 24 Hours)'
        WHEN id = 'LMGT2' THEN 'Le Mans Grand Touring 2 (Second-tier GT class at the Le Mans 24 Hours)'
        WHEN id = 'LMGTEAm' THEN 'Le Mans Grand Touring Endurance Amateur (Amateur category in Le Mans GT Endurance)'
        WHEN id = 'LMGTEPro' THEN 'Le Mans Grand Touring Endurance Professional (Professional category in Le Mans GT Endurance)'
        WHEN id = 'LMGTP' THEN 'Le Mans Grand Touring Prototype (Prototype racing class at the Le Mans 24 Hours)'
        WHEN id = 'LMP' THEN 'Le Mans Prototype (General category for prototype racing at Le Mans)'
        WHEN id = 'LMP1' THEN 'Le Mans Prototype 1 (Top-tier prototype racing class)'
        WHEN id = 'LMP1-H' THEN 'Le Mans Prototype 1 - Hybrid (Hybrid-powered LMP1 cars)'
        WHEN id = 'LMP1-L' THEN 'Le Mans Prototype 1 - Light (Lightweight LMP1 cars)'
        WHEN id = 'LMP1/C90' THEN 'Le Mans Prototype 1/C90 (LMP1 cars conforming to the C90 regulations)'
        WHEN id = 'LMP1C90' THEN 'Le Mans Prototype 1 C90 (Alternative designation for LMP1 cars under C90 regulations)'
        WHEN id = 'LMP2' THEN 'Le Mans Prototype 2 (Second-tier prototype racing class)'
        WHEN id = 'LMP2(Pro-Am)' THEN 'Le Mans Prototype 2 (Pro-Am) (Pro-Am subclass within LMP2)'
        WHEN id = 'LMP675' THEN 'Le Mans Prototype 675 (Class featuring cars conforming to LMP675 regulations)'
        WHEN id = 'LMP900' THEN 'Le Mans Prototype 900 (Class featuring cars conforming to LMP900 regulations)'
        WHEN id = 'LMPC' THEN 'Le Mans Prototype Challenge (Developmental class featuring spec chassis)'
        WHEN id = 'NASCAR' THEN 'National Association for Stock Car Auto Racing (Prominent North American stock car racing organization)'
        WHEN id = 'P+3.0' THEN 'Prototype (Engines > 3.0L. Modified prototype cars with larger engines)'
        WHEN id = 'P+5.0' THEN 'Prototype (Engines > 5.0L. Modified prototype cars with larger engines)'
        WHEN id = 'P1.0' THEN 'Prototype 1.0 (Top-tier prototype racing class with 1.0L engine limit)'
        WHEN id = 'P1.15' THEN 'Prototype 1.15 (Top-tier prototype racing class with 1.15L engine limit)'
        WHEN id = 'P1.3' THEN 'Prototype 1.3 (Top-tier prototype racing class with 1.3L engine limit)'
        WHEN id = 'P1.6' THEN 'Prototype 1.6 (Top-tier prototype racing class with 1.6L engine limit)'
        WHEN id = 'P2' THEN 'Prototype 2 (Second-tier prototype racing class)'
        WHEN id = 'P2.0' THEN 'Prototype 2.0 (Second-tier prototype racing class with 2.0L engine limit)'
        WHEN id = 'P2.5' THEN 'Prototype 2.5 (Second-tier prototype racing class with 2.5L engine limit)'
        WHEN id = 'P3.0' THEN 'Prototype 3.0 (Second-tier prototype racing class with 3.0L engine limit)'
        WHEN id = 'P4.0' THEN 'Prototype 4.0 (Second-tier prototype racing class with 4.0L engine limit)'
        WHEN id = 'P5.0' THEN 'Prototype 5.0 (Second-tier prototype racing class with 5.0L engine limit)'
        WHEN id = 'P850' THEN 'Prototype 850 (Second-tier prototype racing class with 850cc engine limit)'
        WHEN id = 'S+2.0' THEN 'Sport (Engines > 2.0L. Modified sports cars with larger engines)'
        WHEN id = 'S+3.0' THEN 'Sport (Engines > 3.0L. Modified sports cars with larger engines)'
        WHEN id = 'S+8.0' THEN 'Sport (Engines > 8.0L. Modified sports cars with larger engines)'
        WHEN id = 'S1.0' THEN 'Sport 1.0 (Sports cars with up to 1.0L engine capacity)'
        WHEN id = 'S1.1' THEN 'Sport 1.1 (Sports cars with up to 1.1L engine capacity)'
        WHEN id = 'S1.15' THEN 'Sport 1.15 (Sports cars with up to 1.15L engine capacity)'
        WHEN id = 'S1.3' THEN 'Sport 1.3 (Sports cars with up to 1.3L engine capacity)'
        WHEN id = 'S1.5' THEN 'Sport 1.5 (Sports cars with up to 1.5L engine capacity)'
        WHEN id = 'S1.6' THEN 'Sport 1.6 (Sports cars with up to 1.6L engine capacity)'
        WHEN id = 'S2.0' THEN 'Sport 2.0 (Sports cars with up to 2.0L engine capacity)'
        WHEN id = 'S2.5' THEN 'Sport 2.5 (Sports cars with up to 2.5L engine capacity)'
        WHEN id = 'S3.0' THEN 'Sport 3.0 (Sports cars with up to 3.0L engine capacity)'
        WHEN id = 'S5.0' THEN 'Sport 5.0 (Sports cars with up to 5.0L engine capacity)'
        WHEN id = 'S750' THEN 'Sport 750 (Sports cars with 750cc engine capacity)'
        WHEN id = 'S8.0' THEN 'Sport 8.0 (Sports cars with up to 8.0L engine capacity)'
        WHEN id = 'S850' THEN 'Sport 850 (Sports cars with 850cc engine capacity)'
        WHEN id = 'T' THEN 'Touring (Cars adapted for touring and long-distance racing)'
        WHEN id = 'T3.0' THEN 'Touring 3.0 (Touring cars with up to 3.0L engine capacity)'
        WHEN id = 'T5.0' THEN 'Touring 5.0 (Touring cars with up to 5.0L engine capacity)'
        WHEN id = 'TS' THEN 'Touring Sport (Touring cars adapted for sportier performance)'
        WHEN id = 'TS2.5' THEN 'Touring Sport 2.5 (Touring cars with up to 2.5L engine capacity)'
        WHEN id = 'TS3.0' THEN 'Touring Sport 3.0 (Touring cars with up to 3.0L engine capacity)'
        WHEN id = 'WSC' THEN 'World Sportscar Championship (Championship featuring various sportscar classes)'
    END;

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