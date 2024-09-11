CREATE TABLE IF NOT EXISTS `showedblips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blipid` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;