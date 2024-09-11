CREATE TABLE IF NOT EXISTS`phone_einstellungen` (
  `identifer` varchar(250) DEFAULT NULL,
  `flugmodus` int(11) DEFAULT NULL,
  `gps` int(11) DEFAULT NULL,
  `onlykontakte` int(11) DEFAULT NULL,
  `wlan` int(11) DEFAULT NULL,
  `linksrechts` int(11) DEFAULT NULL,
  `oben` int(11) DEFAULT NULL,
  `größe` int(11) DEFAULT NULL,
  `wallpaper` varchar(250) DEFAULT NULL,
  `lautstärke` int(11) DEFAULT NULL,
  `song` varchar(250) DEFAULT NULL,
  `push` varchar(250) DEFAULT NULL,
) 
CREATE TABLE IF NOT EXISTS`lifeinvader_accounts` (
  `benutzername` varchar(250) DEFAULT NULL,
  `Passwort` varchar(250) DEFAULT NULL,
  `icon` varchar(250) DEFAULT NULL
) 

CREATE TABLE IF NOT EXISTS`downloadedapps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `name` varchar(250) DEFAULT NULL,
  `download` varchar(250) DEFAULT NULL
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS`lifeinvader_werbungen` (
  `benutzername` varchar(250) DEFAULT NULL,
  `icon` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `nachricht` varchar(250) DEFAULT NULL,
  `premiumornot` int(8) DEFAULT "1"
) 

CREATE TABLE IF NOT EXISTS`bill_options` (
  `benutzername` varchar(250) DEFAULT NULL,
  `icon` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `nachricht` varchar(250) DEFAULT NULL,
  `premiumornot` int(8) DEFAULT "1"
) 

CREATE TABLE IF NOT EXISTS `dipatches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `coords` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `desc` varchar(250) DEFAULT NULL,
  `fraktion` varchar(250) DEFAULT NULL,
  `uhrzeit`varchar(250) DEFAULT NULL,
  `anngenommen`varchar(250) DEFAULT "false",
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `bill_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stand` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;



CREATE TABLE IF NOT EXISTS`cryptos` (
  `id` varchar(250) DEFAULT NULL,
  `benutzername` varchar(250) DEFAULT NULL,
  `passwort` varchar(50) DEFAULT NULL,
  `key` varchar(250) DEFAULT NULL,
  `btc` int(8) DEFAULT "0",
  `eth` int(8) DEFAULT "0";
) 

INSERT INTO `lifeinvader_werbungen` (`benutzername`, `icon`, `titel`, `nachricht`, `premiumornot`) VALUES
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Patrick', 'FÜR FORTNITE', "1" ),
('Chrisi', 'https://cdn.discordapp.com/attachments/950106813435621437/959894435024494653/Screenshot_20220325_225708_com.whatsapp.w4b_edit_10947679079578_2.jpg', 'Geld', 'Ich habe mehr Geld als ihr weshalb ich es mir leisten kann, eine Premium werbung zu machen LULW', "2" )

ALTER TABLE `users` ADD COLUMN `phone_number` VARCHAR(10) NULL;
ALTER TABLE `cryptos` ADD COLUMN `btcwert` int(10) DEFAULT "0";
ALTER TABLE `cryptos` ADD COLUMN `ethwert` int(10) DEFAULT "0";

INSERT INTO `phone_einstellungen` (`identifer`, `flugmodus`, `gps`) VALUES
('58fed2e48156829810005e837f7a51c2ed444ac9', '2', '2');

ALTER TABLE `lifeinvader_accounts` ADD COLUMN `identifier` VARCHAR(250) DEFAULT NULL;

ALTER TABLE `users` ADD COLUMN `transfermoney` VARCHAR(250) DEFAULT NULL;
ALTER TABLE `phone_einstellungen` ADD COLUMN `push` VARCHAR(20) DEFAULT NULL;

INSERT INTO `cryptos` (`id`, `benutzername`, `passwort`, `keyse`, `btc`, `eth`, `btcwert`,`ethwert`) VALUES
('58fed2e48156829810005e837f7a51c2ed444ac9', 'd', 'd', 'HDVJWRDEJC946205499', "100", "100", "100", "100" ),
('7a5876b5dc5b4d9bdbd92eaeb9128ff070390a33', 'k', 'k', 'kk', "1", "1", "100", "100" ),

INSERT INTO `items` (`name`, `label`, `weight`,  `rare`, `can_remove`) VALUES
('phone', 'Handy', '5', `1`, `1` );

CREATE TABLE IF NOT EXISTS`notizen_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifer` varchar(250) DEFAULT NULL,
  `titel` varchar(50) DEFAULT NULL,
  `beschreibung` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifer` (`identifer`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE `phone_gallery` (
   `identifier` VARCHAR(255) NOT NULL , 
   `image` VARCHAR(255) NOT NULL ,
   `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `biographie` varchar(250) DEFAULT NULL,
  `vip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `biographie` varchar(250) DEFAULT NULL,
  `vip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;



CREATE TABLE IF NOT EXISTS `kontakte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `telefonnummer` varchar(50) DEFAULT NULL,
  `bio` varchar(250) DEFAULT NULL,
  `profilbild` varchar(50) DEFAULT NULL,  
  `premiumornot` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;



CREATE TABLE IF NOT EXISTS `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idchat` varchar(11) DEFAULT NULL,
  `identifier` varchar(250) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `telefonnummer` varchar(50) DEFAULT NULL,
  `bio` varchar(250) DEFAULT NULL,
  `profilbild` varchar(50) DEFAULT NULL,  
  `premiumornot` varchar(50) DEFAULT NULL,
  `empfenger1` varchar(250) DEFAULT NULL,
  `empfenger2` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `chatsmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idchat` varchar(11) DEFAULT NULL,
  `identifier` varchar(250) DEFAULT NULL,
  `message` varchar(250) DEFAULT NULL,  
  `gelesen` varchar(50) DEFAULT NULL,
  `currentime` timestamp NULL DEFAULT current_timestamp(),  
  `firstnachricht` varchar(50) DEFAULT NULL,
  `types`varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

ALTER TABLE `users` ADD COLUMN `cleannumber` VARCHAR(250) DEFAULT NULL;



CREATE TABLE IF NOT EXISTS `funkid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `funkid` varchar(250) DEFAULT NULL,  
  `currentime` timestamp NULL DEFAULT current_timestamp(), 
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;



CREATE TABLE IF NOT EXISTS `business` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) DEFAULT NULL,
  `code` varchar(250) DEFAULT NULL,    
  `admin` varchar(250) DEFAULT NULL, 
  `name` varchar(250) DEFAULT NULL,  
  `nummer` varchar(250) DEFAULT NULL,  
  `currentime` timestamp NULL DEFAULT current_timestamp(), 
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `businesschat` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
  `idchat` varchar(11) DEFAULT NULL,
  `identifier` varchar(250) DEFAULT NULL,
  `message` varchar(250) DEFAULT NULL,  
  `gelesen` varchar(50) DEFAULT NULL,
  `currentime` timestamp NULL DEFAULT current_timestamp(),  
  `firstnachricht` varchar(50) DEFAULT NULL,
  `types`varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;