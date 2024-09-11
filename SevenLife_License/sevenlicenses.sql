ALTER TABLE seven_licenses 
ADD `flylicense` varchar(20) DEFAULT "false",
ADD `bootlicense`varchar(20) DEFAULT"false",
ADD `lkwlicense` varchar(20) DEFAULT "false",
ADD `motorlicense`varchar(20) DEFAULT"false",
ADD `flyllicensetheorie`varchar(20) DEFAULT"false",
ADD `motorlicensetheorie`varchar(20) DEFAULT"false",
ADD `lkwtheorie`varchar(20) DEFAULT"false",
ADD `boottheorie`varchar(20) DEFAULT"false",
ADD `driverlicensetheorie`varchar(20) DEFAULT"false",
ADD `driveID`varchar(80) DEFAULT NULL,

ALTER TABLE owned_vehicles
ADD `registered` int(2) DEFAULT '0',
ADD `fuel` varchar(100) DEFAULT '0';