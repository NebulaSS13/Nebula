DROP TABLE IF EXISTS `erro_admin_tickets`;
CREATE TABLE `erro_admin_tickets` (
  `id` int(11) AUTO_INCREMENT,
  `assignee` text DEFAULT NULL,
  `ckey` varchar(32) NOT NULL,
  `text` text DEFAULT NULL,
  `status` enum('OPEN','ASSIGNED','CLOSED','SOLVED','TIMED_OUT') NOT NULL,
  `round` varchar(32),
  `inround_id` int(11),
  `open_date` date,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;