ALTER TABLE `users` ADD COLUMN `wheel` VARCHAR(1) NULL DEFAULT '1'

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('casino_chips', 'Chips', '0', '1', '1'),
('casino_vodka', 'Vodka', '1', '1', '1'),
('casino_wein', 'Wein', '0', '1', '1');