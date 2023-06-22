--
-- Table structure for table `erro_connection_log`
--
DROP TABLE IF EXISTS `erro_connection_log`;
CREATE TABLE IF NOT EXISTS `erro_connection_log`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`datetime` DATETIME DEFAULT now() NOT NULL,
	`serverip` VARCHAR(32) NOT NULL,
	`ckey` VARCHAR(32) NOT NULL,
	`ip` VARCHAR(32) NOT NULL,
	`computerid` VARCHAR(32) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
