CREATE TABLE IF NOT EXISTS `postal` (
  `toidentifer` varchar(250) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `things` varchar(50) DEFAULT NULL,
  `number` int(100) DEFAULT NULL,
  `id` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `postal`(`toidentifer`, `name`, `things`, `number`, `id`) VALUES 
("58fed2e48156829810005e837f7a51c2ed444ac9", "Chrisi", "water", 10, "30300202")

ALTER TABLE `postal`
ADD `number` int(100) DEFAULT NULL
ALTER TABLE `postal`
ADD `id` int(100) DEFAULT NULL