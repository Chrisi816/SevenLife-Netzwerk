CREATE TABLE IF NOT EXISTS `battlepassmissionen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `index1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `progress1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `index2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `progress2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `index3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `progress3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;