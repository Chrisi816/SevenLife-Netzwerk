INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES 
('personalausweis', 'Personalausweis', '5','1', '2'),
('keys', 'Schlüssel Paar', '5','1', '2'),
;
ALTER TABLE `owned_vehicles` ADD COLUMN `keys` VARCHAR(250) DEFAULT NULL;