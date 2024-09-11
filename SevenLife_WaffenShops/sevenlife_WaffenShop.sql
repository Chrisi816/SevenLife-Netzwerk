CREATE TABLE IF NOT EXISTS `seven_licenses` (
  `identifier` varchar (50) DEFAULT NULL,
  `gunlicense` varchar(50) DEFAULT NULL,
  `driverlicense` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `gunitems` (
  `item` varchar (50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `src` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;