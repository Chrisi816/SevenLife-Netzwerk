ALTER TABLE `users`
ADD COLUMN `BankCard` int(20) DEFAULT 1;

CREATE TABLE IF NOT EXISTS`transaktion-logs` (
  `identifier` varchar(250) DEFAULT NULL,
  `typ` varchar(250) DEFAULT NULL,
  `geld` varchar(50) DEFAULT NULL,
  `who` varchar(250) DEFAULT NULL
) PRIMARY KEY identifier

CREATE TABLE IF NOT EXISTS `transaktion_logs` (
  `identifier` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `typ` int(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `geld` int(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `who` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `crypto_handelszentrum` (
  `btcwert` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ethwert`varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `typ` int(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `crypto_handelszentrum` (`btcwert`, `ethwert`, `typ`) VALUES 
('1000', '1000', '1'),

;