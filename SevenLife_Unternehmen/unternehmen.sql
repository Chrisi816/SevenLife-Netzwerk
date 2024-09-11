CREATE TABLE IF NOT EXISTS `unternehmensautos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firmenname` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `automodel` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `herstellungsitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firmenname` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `herstellung` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vollendet` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `angestellte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firmenname` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `identifier` varchar(240) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rang` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `shophistory` (
  `shopid` int(11) DEFAULT NULL,
  `item` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `anzahl` varchar(240) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preis` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uhrzeit` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`shopid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `tankehistory` (
  `shopid` int(11) DEFAULT NULL,
  `liter` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preis` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uhrzeit` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`shopid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

ALTER TABLE tankstellen 
ADD `money` int(20) DEFAULT "0",

CREATE TABLE IF NOT EXISTS `unternehmensautos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firmenid` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `automodel` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `unternehmenjobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firmenid` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `beschreibung` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `geld` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `anngenommen` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail1` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail2` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail3` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `check` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
