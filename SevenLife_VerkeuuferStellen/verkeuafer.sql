CREATE TABLE IF NOT EXISTS `verkeaufer` (
  `id` int(11) DEFAULT NULL ,
  `item` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT INTO `verkeaufer` (`id`,`item`, `preis`) VALUES
('1','Nagel','3'),
('2','Nagel','3'),
('3','Nagel','3');

INSERT INTO `verkeaufer` (`id`,`item`, `preis`) VALUES
('1','Verpackte_Orangen','5'),
('2','Verpackte_Orangen','5'),
('3','Verpackte_Orangen','5'),



INSERT INTO `verkeaufer` (`id`,`item`, `preis`) VALUES
('1','Barsch','5'),
('2','Barsch','5'),
('3','Barsch','5'),
('1','Karpfen','5'),
('2','Karpfen','5'),
('3','Karpfen','5'),
('1','Forelle','5'),
('2','Forelle','5'),
('3','Forelle','5'),
('1','Lachs','5'),
('2','Lachs','5'),
('3','Lachs','5'),