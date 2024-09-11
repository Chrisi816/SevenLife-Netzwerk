
CREATE TABLE IF NOT EXISTS `bauitems` (
  `item` varchar (50) DEFAULT NULL,
  `label` varchar (50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `src` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `bauitems` (`item`, `label`, `price`, `src`) VALUES 
('spaten', 'Spaten', '3500','spaten'),
('WEAPON_SWITCHBLADE', 'Klappmesser', '6500','messer'),
('WEAPON_FLASHLIGHT', 'Taschenlampe', '500','taschenlampe')
;