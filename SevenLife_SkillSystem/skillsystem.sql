CREATE TABLE IF NOT EXISTS`skillsystem_level` (
  `id` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int(11) COLLATE utf8mb4_unicode_ci DEFAULT 0,
  `xp` int(11) COLLATE utf8mb4_unicode_ci DEFAULT 0,
  `skillpoints` int(11) COLLATE utf8mb4_unicode_ci DEFAULT 0,
   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS`skillsystem_tree` (
  `id` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenobenbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenrechtsbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenrechtsbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenlinksbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `obenlinksbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenobenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenobenbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenobenbutton3` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenmittebutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenmittebutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenmittebutton3` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenuntenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `rechtsuntenuntenbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenobenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenobenbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenobenbutton3` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenmittebutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenmittebutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenmittebutton3` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenuntenbutton1` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  `linksuntenuntenbutton2` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT "false",
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;