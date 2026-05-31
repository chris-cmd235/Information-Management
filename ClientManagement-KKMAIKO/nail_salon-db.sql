-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 31, 2026 at 09:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nail_salon-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `Service_ID` int(11) NOT NULL,
  `Service_Name` varchar(255) DEFAULT NULL,
  `Base_Price` decimal(6,2) DEFAULT NULL,
  `Service_Description` text DEFAULT NULL,
  `Ave_Duration` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`Service_ID`, `Service_Name`, `Base_Price`, `Service_Description`, `Ave_Duration`) VALUES
(1, 'Gel X - Plain Color', 449.00, 'Full set of Gel-X extensions with a single solid color polish.', 90),
(2, 'Gel X - Minimal (1-3 colors w/ design)', 499.00, 'Gel-X extensions featuring minimal nail art with up to 3 colors.', 105),
(3, 'Gel X - Intermediate (4-5 colors w/ design)', 549.00, 'Gel-X extensions featuring detailed nail art with 4 to 5 colors.', 120),
(4, 'Gel X - Advanced (6-10 colors w/ design)', 599.00, 'Gel-X extensions featuring intricate, advanced nail art with up to 10 colors.', 150),
(5, 'Gel Manicure - Regular', 299.00, 'Classic manicure paired with long-lasting gel polish and cuticle care.', 60),
(6, 'BIAB Overlay Only (no design)', 349.00, 'Builder in a Bottle application over natural nails for strength, no added art.', 60),
(7, 'BIAB Gel Manicure', 399.00, 'Builder in a Bottle structure overlay paired with a full gel color overlay.', 75),
(8, 'Removal (w/ new set)', 90.00, 'Safe removal of existing extensions or gel polish when purchasing a new set.', 30),
(9, 'Removal (only)', 170.00, 'Safe standalone removal of extensions or gel polish, including nail conditioning.', 30),
(10, 'Squeeze-in fee', 200.00, 'Priority slot booking allocation fee for outside standard operating hours.', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`Service_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
