CREATE TABLE IF NOT EXISTS ''(
  `identifier` varchar(250) DEFAULT NULL,
  `firmenname` varchar(30) DEFAULT NULL,
  `firmenvalue` int(11) DEFAULT NULL,
  `cash` int(11) DEFAULT '0',
  `bueronummer` int(11) DEFAULT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `items`(name, label, `weight`, `rare`, `can_remove`) VALUES
("personalausweis", "Personalausweis", 2, 2 ,2),
("lizenzbuch", "Lizenzbuch", 2, 2 ,2);

ALTER TABLE users 

ADD warns int(20) DEFAULT "0",
ADD datumerstellen varchar(150) DEFAULT NULL,
ADD statuse varchar(20) DEFAULT "Spieler",
ADD vip varchar(20) DEFAULT "false"

ADD visastufe int(20) DEFAULT "1"
ADD orga int(20) DEFAULT NULL
ADD visaxp int(20) DEFAULT "0"

ADD id int(20) DEFAULT NULL

INSERT INTO `login_accounts`(`identifer`, `benutzername`, `passwort`, `fertiggestellt`, `illigalorlegal`) VALUES
("7a5876b5dc5b4d9bdbd92eaeb9128ff070390a33", "vAzoniq", "piti piti", 1 ,1),
("9fa973c65354ca989497334ee16e0460de10eb4f", "Alex Klaus", "Zilnikov2004@", 1 ,2);

CREATE TABLE times (
	identifier VARCHAR(100) NOT NULL,
	Seconds int(10) NOT NULL,
	Minutes int(10) NOT NULL,
	Hours int(10) NOT NULL,
	Days int(10) NOT NULL,
	PRIMARY KEY (identifier)
);

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `about` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dnt` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
ALTER TABLE reports 

ADD coords varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,

CREATE TABLE IF NOT EXISTS `creatorcodes`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `verlauf-tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `absender` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nachricht` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `absender` (`absender`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


ALTER TABLE `users`
ADD COLUMN `levelbattlepass` varchar(50)  DEFAULT 0,
ADD COLUMN `coinsbattlepass` varchar(50)  DEFAULT 0,
ADD COLUMN `ownpremium` varchar(50)  DEFAULT false,


ALTER TABLE `users` 
ADD COLUMN `phone_number` VARCHAR(10) NULL;

CREATE TABLE IF NOT EXISTS `abgeholtebattlepass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pass` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

