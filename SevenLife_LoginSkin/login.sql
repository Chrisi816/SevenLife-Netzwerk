CREATE TABLE IF NOT EXISTS`login_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifer` varchar(250) DEFAULT NULL,
  `benutzername` varchar(200) DEFAULT NULL,
  `passwort` varchar(200) DEFAULT NULL,
  `fertiggestellt` varchar(200) DEFAULT "false",
  `illigalorlegal` int(2) DEFAULT "0";
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifer` (`identifer`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

ALTER TABLE login_accounts
ADD `illigalorlegal` int(2) DEFAULT "0"

INSERT INTO login_accounts ( `identifer`, `benutzername`, `passwort`, `fertiggestellt`, `illigalorlegal`) VALUES
('d82c46e0d9809de097c96da0e8e379673ff665f1', 'HerrDrBaum', '08294Affalter', '1','1'),
('7a5876b5dc5b4d9bdbd92eaeb9128ff070390a33', 'vAzoniq', 'piti piti','1','2'),
('a65b27827ab1ac4bf3e6f475175a3dc2477eecab', 'Jxxq', 'Dla0,1ab!x','1','2');