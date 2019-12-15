-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  Dim 15 déc. 2019 à 09:57
-- Version du serveur :  10.4.10-MariaDB
-- Version de PHP :  7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `realistic_base`
--

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamid` varchar(255) NOT NULL,
  `name` text NOT NULL DEFAULT '""',
  `money` int(11) DEFAULT 0,
  `bank_money` int(11) NOT NULL DEFAULT 1000,
  `position` text NOT NULL DEFAULT '""',
  `model` text NOT NULL DEFAULT '""',
  `admin` int(11) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 100,
  `armor` int(11) NOT NULL DEFAULT 0,
  `thirst` int(11) NOT NULL DEFAULT 100,
  `stamina` int(11) NOT NULL DEFAULT 100,
  `hunger` int(11) NOT NULL DEFAULT 100,
  `inventory` text NOT NULL DEFAULT '""',
  `weapons` text NOT NULL DEFAULT '""',
  PRIMARY KEY (`id`),
  UNIQUE KEY `steamidindex` (`steamid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `steamid`, `name`, `money`, `bank_money`, `position`, `model`, `admin`, `health`, `armor`, `thirst`, `stamina`, `hunger`, `inventory`, `weapons`) VALUES
(1, '76561198161920297', '\"\"', 0, 1000, '126003,79415,1567', '', 0, 100, 50, 100, 100, 100, '', '12');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
