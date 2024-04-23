-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql44.unoeuro.com
-- Generation Time: Apr 23, 2024 at 08:33 PM
-- Server version: 8.0.36-28
-- PHP Version: 8.1.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spaghetticodestudios_com_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `nonces`
--

CREATE TABLE `nonces` (
  `ip_address` varchar(255) NOT NULL,
  `nonce` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `nonces`
--

INSERT INTO `nonces` (`ip_address`, `nonce`) VALUES
('87.52.108.81', '87b287b1482d8a570630a3882576d51300cd811ea7aed4e2b0c13226f9b15391'),
('87.59.206.123', 'd9470cc4dbb63e4b2253c66d456d8e2d786b471aa048dfda1e502b3716fac80b'),
('werwer', 'nonce');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `ID` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`ID`, `username`, `password`) VALUES
(67, 'tqd', '968e2538ad9cac61a8cf7c4edad29adb34e85a5b6687cee9c14e36e1fde074c5'),
(68, 'qq', 'e7bbf0eda002c1ba04bfadfc73ed17c8b71d212419685fe490edfb4586f7030a'),
(70, 'test', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'),
(71, 'victor', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),
(73, 'sdfsf', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'),
(74, 'whoInParis', '95df165fdf3c66eb76971bfcbc5fc3f219f8935821672c05b0bd817184b6d271'),
(75, 'kasper', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3');

-- --------------------------------------------------------

--
-- Table structure for table `UserScore`
--

CREATE TABLE `UserScore` (
  `ID` int NOT NULL,
  `User_ID_FK` int NOT NULL,
  `level` int NOT NULL,
  `value` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `UserScore`
--

INSERT INTO `UserScore` (`ID`, `User_ID_FK`, `level`, `value`) VALUES
(81, 67, 1, 0),
(83, 71, 1, 0),
(84, 70, 2, 100),
(85, 70, 1, 100),
(86, 70, 3, 100),
(87, 70, 4, 100),
(88, 70, 5, 100),
(89, 70, 6, 100);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nonces`
--
ALTER TABLE `nonces`
  ADD UNIQUE KEY `ip_address` (`ip_address`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `UserScore`
--
ALTER TABLE `UserScore`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `User_ID_FK` (`User_ID_FK`,`level`),
  ADD KEY `FK` (`User_ID_FK`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `UserScore`
--
ALTER TABLE `UserScore`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `UserScore`
--
ALTER TABLE `UserScore`
  ADD CONSTRAINT `UserScore_ibfk_1` FOREIGN KEY (`User_ID_FK`) REFERENCES `User` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
