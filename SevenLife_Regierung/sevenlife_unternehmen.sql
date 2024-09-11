CREATE TABLE IF NOT EXISTS 'unternehmen'(
  `identifier` varchar(250) DEFAULT NULL,
  `firmenname` varchar(30) DEFAULT NULL,
  `firmenvalue` int(11) DEFAULT NULL,
  `cash` int(11) DEFAULT '0',
  `bueronummer` int(11) DEFAULT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `items`(name, label, `weight`, `rare`, `can_remove`) VALUES
("personalausweis", "Personalausweis", 2, 2 ,2),
("lizenzbuch", "Lizenzbuch", 2, 2 ,2);
