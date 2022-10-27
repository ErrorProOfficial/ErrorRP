CREATE TABLE `characters_accounts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `balance` int(20) DEFAULT 0,
  `authorized` varchar(500) DEFAULT NULL,
  `transactions` varchar(60000) DEFAULT '{}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

ALTER TABLE `characters_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;