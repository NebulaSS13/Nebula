--
-- Table structure for table `erro_messages`
--

CREATE TABLE IF NOT EXISTS `erro_messages` (
  `id` int(11) NOT NULL,
  `type` enum('memo','message','message sent','note','watchlist entry') NOT NULL,
  `targetckey` varchar(32) NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `text` TEXT NOT NULL,
  `timestamp` datetime NOT NULL,
  `server` varchar(32) DEFAULT NULL,
  `secret` tinyint(1) DEFAULT 0,
  `lasteditor` varchar(32) DEFAULT NULL,
  `edits` text,
  PRIMARY KEY (`id`),
  KEY `idx_msg_ckey_time` (`targetckey`,`timestamp`),
  KEY `idx_msg_type_ckeys_time` (`type`,`targetckey`,`adminckey`,`timestamp`),
  KEY `idx_msg_type_ckey_time_odr` (`type`,`targetckey`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `erro_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
