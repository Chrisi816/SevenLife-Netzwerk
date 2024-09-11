ALTER TABLE `users` ADD `krankheit` varchar(255) COLLATE utf8mb4_bin DEFAULT 'false';
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('hustensaft','Hustensaft','5', '1', '1'),
  ('antibiotikum','Antibiotikum','5', '1', '1'),
  ('antibiotikumRosazea','AntibiotikumRosazea','5', '1', '1'),
  ('coronaimpfung','Corona Impfung','5', '1', '1'),
  ('aspirin','Aspirin','5', '1', '1'),
  ('imodium','Imodium','5', '1', '1'),
  ('aspirinrezept','Asp. Rezept','5', '1', '1'),
  ('imodiumrezept','Imo. Rezept','5', '1', '1'),
  ('rosarezept','Rosa. Rezept','5', '1', '1')
;

