CREATE TABLE IF NOT EXISTS `arbeitsamt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobname` varchar(250) DEFAULT NULL,
  `label` varchar(250) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  `desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `jobname` (`jobname`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `arbeitsamt`(`jobname`, `label`,`value`, `desc`) VALUES 
("fischer", "Fischer", "Low", "Fortinite"),
("postal", "Briefträger", "Low", "Fortinite")