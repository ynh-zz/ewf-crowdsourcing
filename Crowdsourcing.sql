-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 01, 2013 at 02:33 PM
-- Server version: 5.5.31
-- PHP Version: 5.3.10-1ubuntu3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `Crowdsourcing`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `left` int(11) DEFAULT NULL,
  `right` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `parent_id`, `name`, `icon`, `left`, `right`) VALUES
(1, 0, 'All', 'icon-circle', 0, 7),
(2, 1, 'Technology', 'icon-laptop', 1, 2),
(3, 1, 'Art', 'icon-trash', 3, 6),
(4, 3, 'Stuff', 'icon-leaf', 4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE IF NOT EXISTS `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `lng` double DEFAULT NULL,
  `lat` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`id`, `name`, `country`, `lng`, `lat`) VALUES
(1, 'Bern', 'Switzerland', 46.95, 7.4458),
(2, 'Zurich', 'Switzerland', 47.369, 8.538),
(3, 'New York', 'USA', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `text` text NOT NULL,
  `flagged` tinyint(1) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=54 ;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `project_id`, `user_id`, `parent_id`, `text`, `flagged`, `timestamp`) VALUES
(27, 5, 0, 0, 'He will never find it', NULL, '2013-04-12 09:49:14'),
(33, 4, 0, 0, 'Get a nice hat, one with flowers in it.', NULL, '2013-04-12 17:14:03'),
(36, 7, 0, 0, 'zxcvbnm', NULL, '2013-04-13 18:52:34'),
(37, 7, 0, 36, 'HÃ¼l', NULL, '2013-04-13 20:02:06'),
(45, 4, 2, 0, 'eternal gratitude? No way!', NULL, '2013-04-14 00:00:57'),
(46, 5, 1, 27, 'LOL', NULL, '2013-04-14 02:52:29'),
(48, 5, 3, 27, 'I beg to differ', NULL, '2013-04-14 18:13:10'),
(49, 4, 3, 45, 'You don''t like your own project?', NULL, '2013-04-14 18:18:04'),
(50, 33, 3, 0, 'Ooooh Yeah', NULL, '2013-04-14 22:22:28'),
(52, 33, 1, 50, 'SASAD', NULL, '2013-04-16 07:45:23'),
(53, 33, 1, 0, 'SDASD', NULL, '2013-04-16 07:45:27');

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE IF NOT EXISTS `favorites` (
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fundings`
--

CREATE TABLE IF NOT EXISTS `fundings` (
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `amount` double DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reward_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fundings`
--

INSERT INTO `fundings` (`user_id`, `project_id`, `amount`, `timestamp`, `reward_id`) VALUES
(1, 7, 100, '2013-04-14 12:00:36', 4),
(1, 33, 3100, '2013-04-16 07:42:56', 11),
(2, 34, 256, '2013-04-14 23:05:41', 12),
(3, 4, 143, '2013-04-14 18:18:24', 6),
(3, 5, 1500, '2013-04-14 18:28:10', NULL),
(3, 7, 1000, '2013-04-14 10:56:30', 5),
(3, 32, 2332, '2013-04-14 22:12:07', 9),
(3, 33, 31411, '2013-04-14 22:22:44', 10),
(3, 34, 3233, '2013-04-14 23:07:07', 13),
(5, 33, 2222, '2013-04-14 22:44:56', 11),
(6, 34, 128, '2013-04-14 23:00:36', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `goals`
--

CREATE TABLE IF NOT EXISTS `goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  `title` text NOT NULL,
  `description` longtext,
  `primary` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `goals`
--

INSERT INTO `goals` (`id`, `project_id`, `amount`, `title`, `description`, `primary`) VALUES
(2, 4, 250, 'Hat on the head!', 'A cheap hat, but it''s better than nothing!', 1),
(3, 4, 1500, 'Tophat!', 'Now this is what I call a fine hat!', 0),
(4, 5, 2000, 'Expedition to Helheim!', 'Insert text here...', 1),
(8, 7, 9000000, 'We will buy Kickstarter', 'If we get this much money we will buy Kickstarter and some Ice Cream', 1),
(18, 32, 333, 'asd as dasdads', 'asdadsa da sdasd asd adasdasd', 1),
(19, 33, 31415, 'Develop the fish ice cream', 'We''ll create salmon, tuna and pangasius ice cream', 1),
(20, 33, 40000, 'Eel flavoured Cones', 'We''ll also develop eel flavoured ice cream cones', 0),
(21, 34, 4096, 'Book 5', 'I''ll write book 5, and publish it', 1),
(22, 34, 8192, 'Book 6', 'I''ll write book 6 and publish it', 0);

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE IF NOT EXISTS `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `tag` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `title` text NOT NULL,
  `description` longtext,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `updatetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `user_id`, `city_id`, `category_id`, `title`, `description`, `start`, `end`, `updatetime`) VALUES
(4, 2, 1, 3, 'Patrice needs a Hat', '', '2013-03-25 00:00:00', '2029-06-20 22:28:05', '2013-11-01 09:10:45'),
(5, 1, 0, 1, 'Kieran''s hunt for his hammer', '', '2006-04-09 00:00:00', '2029-06-20 22:28:05', '2013-11-01 09:10:45'),
(7, 2, 2, 4, 'Help us buy Kickstarter', '', '2013-03-25 00:00:00', '2029-06-20 22:28:05', '2013-11-01 09:10:45'),
(32, 3, 3, 2, 'Ginzproject', '', '2013-04-17 00:08:59', '2029-06-20 22:28:05', '2013-11-01 09:10:32'),
(33, 3, 3, 2, 'Fish flavoured Ice Cream', '', '2013-04-25 00:17:05', '2029-06-20 22:28:05', '2013-11-01 09:10:45'),
(34, 6, 3, 3, 'Art of Computer Programming', '', '2013-04-16 00:54:50', '2013-12-06 00:54:50', '2013-11-01 09:10:45');

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

CREATE TABLE IF NOT EXISTS `rewards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` double DEFAULT NULL,
  `description` text,
  `availability` int(11) DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `rewards`
--

INSERT INTO `rewards` (`id`, `amount`, `description`, `availability`, `project_id`) VALUES
(4, 100, 'You can choose one pixel colour on the Kickstarter home page.', 10000, 7),
(5, 1000, 'Pick one of Kickstarters projects to be yours. ', 1000, 7),
(6, 10, 'You will get one free eternal gratitude from Patrice.', 90, 4),
(9, 2332, 'sda da dasd', 22, 32),
(10, 10000, 'One Year of free fish ice cream', 10, 33),
(11, 200, 'One Bucket of fish ice cream', 500, 33),
(12, 256, 'One copy of the complete set', 100, 34),
(13, 1024, 'One SIGNED copy of the complete set', 5, 34);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `description` text,
  `email` varchar(255) NOT NULL,
  `avatar` text,
  `city_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `description`, `email`, `avatar`, `city_id`) VALUES
(1, 'Badass', 'good', 'The most badest user ever.', 'bad@ass.com', NULL, 1),
(2, 'Chuck Norris', 'trololo', 'No description is adequate.', 'nuck@chorris.com', NULL, 1),
(3, 'Ginz', '1234', 'ls -l grep .cpp', 'ginz@ginz.ginz', NULL, 1),
(4, 'ynhwebdev', 'ynhwebdev', 'asdasdas das as dasd', 'ynhwebdev@gmail.com', 'http://www.gravatar.com/avatar/38758db0d1cf0ce3006e36140f01bda6?d=identicon&f=y', 1),
(5, 'asdasdadsa', 'asdasdadsaasdasdadsa', 'asdasdadsaasdasdadsa', 'asdasdadsa@asdasdadsa.com', 'http://www.gravatar.com/avatar/2b864cba5221791cda90bc44fc838e0d?d=identicon&f=y', 3),
(6, 'DonaldK', 'kmp12345', 'Not that Donald, the Turing award winning one. ', 'noemail@since1996.com', 'http://engineering.stanford.edu/sites/default/files/migrated_images/dknuth2.jpg', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
