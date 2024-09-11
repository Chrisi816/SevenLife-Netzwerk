DROP TABLE IF EXISTS banlist;
CREATE TABLE IF NOT EXISTS banlist (
  license varchar(50) COLLATE utf8mb4_bin PRIMARY KEY,
  identifier varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  xboxlid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  ip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  targetplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  sourceplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  reason varchar(255) NOT NULL,
  timeat varchar(50) NOT NULL,
  expiration varchar(50) NOT NULL,
  permanent int(1) NOT NULL DEFAULT 0
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

DROP TABLE IF EXISTS banhistory;
CREATE TABLE IF NOT EXISTS banhistory (
  id int(11) AUTO_INCREMENT PRIMARY KEY,
  license varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  identifier varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  liveid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  xboxlid varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  discord varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  ip varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  targetplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  sourceplayername varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  reason varchar(255) NOT NULL,
  timeat int(11) NOT NULL,
  added varchar(40) NOT NULL,
  expiration int(11) NOT NULL,
  permanent int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;