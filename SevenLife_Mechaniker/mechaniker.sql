CREATE TABLE IF NOT EXISTS`mechaniker_lager` (
  `name` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` int(11) COLLATE utf8mb4_unicode_ci DEFAULT 0,
   PRIMARY KEY (`label`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `mechaniker_lager` (`name`, `label`, `amount`) VALUES
('rad', 'Räder', '0'),
('xenon', 'Xenon Scheinwerfer', '0' ),
('turbo', 'Turbo', '0' ),
('rauchfarbe', 'Rad Rauch Farbe', '0' ),
('vorderestoßstangen', 'Vordere Stoßstangen', '0' ),
('hinterestoßstangen', 'Hintere Stoßstangen', '0' ),
('seitenschweller ', 'Seitenschweller', '0' ),
('auspuff', 'Auspuff', '0' ),
('motorhaube', 'Motorhaube', '0' ),
('motor', 'Motor', '0' ),
('bremsen', 'Bremsem', '0' ),
('getriebe', 'Getriebe', '0' ),
('hupe', 'Hupe', '0' ),
('federung', 'Federung', '0' );

CREATE TABLE IF NOT EXISTS`mechaniker_werkzeug` (
  `name` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` int(11) COLLATE utf8mb4_unicode_ci DEFAULT 0,
   PRIMARY KEY (`label`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `mechaniker_werkzeug` (`name`, `label`, `amount`) VALUES
('repairkitklein', 'Kleines Repair Kit klein', '0'),
('repairkitgroß', 'Großes Repair Kit ', '0' ),
('lackierung', 'Lackierung', '0' );

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('repairkitklein', 'Kleines Repair Kit', '5', '1', '1'),
('repairkitgroß', 'Großes Repair Kit ', '10', '1', '1'),
('lackierung', 'Lackierung', '5', '1', '1' ),
('rad', 'Räder', '0', '1', '1'),
('xenon', 'Xenon Scheinwerfer', '0', '1', '1' ),
('turbo', 'Turbo', '0', '1', '1' ),
('rauchfarbe', 'Rad Rauch Farbe', '0', '1', '1' ),
('vorderestoßstangen', 'Vordere Stoßstangen', '0', '1', '1' ),
('hinterestoßstangen', 'Hintere Stoßstangen', '0', '1', '1' ),
('seitenschweller ', 'Seitenschweller', '0', '1', '1' ),
('auspuff', 'Auspuff', '0', '1', '1' ),
('motorhaube', 'Motorhaube', '0', '1', '1' ),
('motor', 'Motor', '0', '1', '1' ),
('bremsen', 'Bremsem', '0', '1', '1' ),
('getriebe', 'Getriebe', '0', '1', '1' ),
('hupe', 'Hupe', '0', '1', '1' ),
('mixedlakeriung', 'Gemixte Lackierung', '0', '1', '1' ),
('federung', 'Federung', '0', '1', '1' );

CREATE TABLE IF NOT EXISTS`mechaniker_cash` (
  `name` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `money` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `mechaniker_cash` (`name`, `money`) VALUES
('mechaniker', '0');