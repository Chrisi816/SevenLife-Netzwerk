CREATE TABLE IF NOT EXISTS `tankstellen`: 
  `tankstellennummereins` int(11) DEFAULT '1'
  `owner` varchar(250) DEFAULT NULL,
  `firmenname` varchar(30) DEFAULT NULL,
  `activefuel` int(11) DEFAULT '0',
  `wert` int(11) DEFAULT NULL,
  `preisproliter` varchar(20) DEFAULT NULL
; 