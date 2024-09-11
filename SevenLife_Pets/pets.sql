CREATE TABLE IF NOT EXISTS `pets` (
  `identifier` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Rotweiler` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `Pudel` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `GRetriever` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `Mops` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `Bolognerser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `Ghirte` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `Huski` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT "false",

  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;