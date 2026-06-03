-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 03, 2026 at 02:43 AM
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
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `Appointment_ID` int(11) NOT NULL,
  `Client_ID` int(11) DEFAULT NULL,
  `Design_ID` int(11) DEFAULT NULL,
  `Appointment_Date` date DEFAULT NULL,
  `Appointment_Time` time DEFAULT NULL,
  `Booking_Source` varchar(255) DEFAULT NULL,
  `Booking_Date_Time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `STATUS` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`Appointment_ID`, `Client_ID`, `Design_ID`, `Appointment_Date`, `Appointment_Time`, `Booking_Source`, `Booking_Date_Time`, `STATUS`) VALUES
(1, 1001, 1, '2026-05-31', NULL, NULL, '2026-06-02 10:50:57', 'Completed'),
(2, 1001, 2, '2026-06-01', NULL, NULL, '2026-06-01 10:46:09', 'Completed'),
(3, 1001, 3, '2026-06-01', NULL, NULL, '2026-06-02 10:51:02', 'Completed'),
(4, 1001, 2, '2026-06-01', NULL, NULL, '2026-06-01 14:17:23', 'Completed'),
(5, 1001, 4, '2026-06-01', NULL, NULL, '2026-06-02 10:51:04', 'Completed'),
(6, 1001, 4, '2026-06-01', NULL, NULL, '2026-06-01 16:16:47', 'Completed'),
(7, 1001, 1, '2026-06-02', NULL, NULL, '2026-06-02 07:20:04', 'Completed'),
(8, 1001, 5, '2026-06-02', NULL, NULL, '2026-06-02 07:21:19', 'Completed'),
(9, 1001, 4, '2026-06-02', NULL, NULL, '2026-06-02 10:51:14', 'Completed'),
(10, 1001, 6, '2026-06-02', NULL, NULL, '2026-06-02 09:03:43', 'Completed'),
(11, 1001, 7, '2026-06-02', NULL, NULL, '2026-06-02 09:11:52', 'Completed'),
(12, 1001, 8, '2026-06-02', NULL, NULL, '2026-06-02 09:24:32', 'Completed'),
(13, 1001, 1, '2026-06-02', NULL, NULL, '2026-06-02 11:24:27', 'Completed'),
(14, 1001, 1, '2026-06-02', NULL, NULL, '2026-06-02 11:24:55', 'Completed'),
(15, 1001, 8, '2026-06-02', NULL, NULL, '2026-06-02 11:29:24', 'Completed'),
(16, 1001, 8, '2026-06-02', NULL, NULL, '2026-06-02 11:30:04', 'Completed'),
(17, 1001, 9, '2026-06-02', NULL, NULL, '2026-06-03 00:03:00', 'Cancelled'),
(18, 1004, 10, '2026-06-03', NULL, NULL, '2026-06-03 00:00:17', 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `Client_ID` int(11) NOT NULL,
  `Full_Name` varchar(255) DEFAULT NULL,
  `Phone` varchar(255) DEFAULT NULL,
  `Email_Add` varchar(255) DEFAULT NULL,
  `Soc_Med_Acc` varchar(255) DEFAULT NULL,
  `Birthday` date DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Favorite_Music` varchar(255) DEFAULT NULL,
  `Date_Registered` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`Client_ID`, `Full_Name`, `Phone`, `Email_Add`, `Soc_Med_Acc`, `Birthday`, `Address`, `Favorite_Music`, `Date_Registered`) VALUES
(1001, 'Rens', '+12 111 222 1111', 'rens@gmail.com', '@facebook', '2000-01-01', 'Legaz', 'Rock', '2026-05-24'),
(1002, 'Enzo Manzano', '+63 222 223 4141', '@example.com', '@instagram', '2003-02-01', 'Dmatagpuan City', 'kpop', '2026-05-24'),
(1003, 'Aaron Beard', '+63 111 111 1111', 'beard@gmail.com', '@social', '2000-01-14', 'Legazpi, City', 'Classic', '2026-05-31'),
(1004, 'Jane Doe', '+63 222 223 4141', '@example.com', '@social', '2000-01-01', 'Kilicao, Albay', 'Jpop', '2026-06-02');

-- --------------------------------------------------------

--
-- Table structure for table `design_inspo`
--

CREATE TABLE `design_inspo` (
  `Design_ID` int(11) NOT NULL,
  `Client_ID` int(11) DEFAULT NULL,
  `Image_File_Path` varchar(255) DEFAULT NULL,
  `Design_Description` text DEFAULT NULL,
  `Date_Added` datetime DEFAULT NULL,
  `Times_Used` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `design_inspo`
--

INSERT INTO `design_inspo` (`Design_ID`, `Client_ID`, `Image_File_Path`, `Design_Description`, `Date_Added`, `Times_Used`) VALUES
(1, 1001, NULL, 'Beige', NULL, 1),
(2, 1001, NULL, 'temp', NULL, 2),
(3, 1001, NULL, 'N/A', NULL, 1),
(4, 1001, NULL, 'Floral', NULL, 3),
(5, 1001, NULL, 'Forest', NULL, 2),
(6, 1001, NULL, 'Red', NULL, 1),
(7, 1001, '/static/uploads/design_c579d7bd366749f8ad0ca0fb7a92865c.jpeg', 'Butterfly', NULL, 3),
(8, 1001, NULL, 'Pink', NULL, 6),
(9, 1001, NULL, 'Ocean', '2026-06-02 19:48:12', 1),
(10, 1004, NULL, 'Purple', '2026-06-03 08:00:17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `discount`
--

CREATE TABLE `discount` (
  `Discount_ID` int(11) NOT NULL,
  `Discount_Name` varchar(255) DEFAULT NULL,
  `Discount_Type` varchar(255) DEFAULT NULL,
  `Discount_Value` decimal(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discount`
--

INSERT INTO `discount` (`Discount_ID`, `Discount_Name`, `Discount_Type`, `Discount_Value`) VALUES
(1, 'Student', NULL, 20.00);

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `Visit_ID` int(11) NOT NULL,
  `Client_ID` int(11) DEFAULT NULL,
  `Visit_Date` date DEFAULT NULL,
  `Service_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`Visit_ID`, `Client_ID`, `Visit_Date`, `Service_ID`) VALUES
(1, 1001, '2026-05-31', 1),
(2, 1001, '2026-06-01', 5),
(3, 1001, '2026-06-01', 1),
(4, 1001, '2026-06-01', 1),
(5, 1001, '2026-06-01', 1),
(6, 1001, '2026-06-01', 1),
(7, 1001, '2026-06-02', 1),
(8, 1001, '2026-06-02', 9),
(9, 1001, '2026-06-02', 1),
(10, 1001, '2026-06-02', 1),
(11, 1001, '2026-06-02', 1),
(12, 1001, '2026-06-02', 3),
(13, 1001, '2026-06-02', 6),
(14, 1001, '2026-06-02', 1),
(15, 1001, '2026-06-02', 1),
(16, 1001, '2026-06-02', 1),
(17, 1001, '2026-06-02', 10),
(18, 1001, '2026-06-02', 5),
(19, 1001, '2026-06-02', 4),
(20, 1001, '2026-06-02', 1),
(21, 1004, '2026-06-03', 1),
(22, 1004, '2026-06-03', 2);

-- --------------------------------------------------------

--
-- Table structure for table `nail_size`
--

CREATE TABLE `nail_size` (
  `Size_ID` int(11) NOT NULL,
  `Client_ID` int(11) DEFAULT NULL,
  `L_Thumb_Size` decimal(4,1) DEFAULT NULL,
  `L_Index_Size` decimal(4,1) DEFAULT NULL,
  `L_Middle_Size` decimal(4,1) DEFAULT NULL,
  `L_Ring_Size` decimal(4,1) DEFAULT NULL,
  `L_Pinky_Size` decimal(4,1) DEFAULT NULL,
  `R_Thumb_Size` decimal(4,1) DEFAULT NULL,
  `R_Index_Size` decimal(4,1) DEFAULT NULL,
  `R_Middle_Size` decimal(4,1) DEFAULT NULL,
  `R_Ring_Size` decimal(4,1) DEFAULT NULL,
  `R_Pinky_Size` decimal(4,1) DEFAULT NULL,
  `Date_Measured` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nail_size`
--

INSERT INTO `nail_size` (`Size_ID`, `Client_ID`, `L_Thumb_Size`, `L_Index_Size`, `L_Middle_Size`, `L_Ring_Size`, `L_Pinky_Size`, `R_Thumb_Size`, `R_Index_Size`, `R_Middle_Size`, `R_Ring_Size`, `R_Pinky_Size`, `Date_Measured`) VALUES
(1, 1001, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, NULL),
(2, 1001, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, NULL),
(3, 1001, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, 30.0, NULL),
(4, 1001, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, NULL),
(5, 1001, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, NULL),
(6, 1001, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, NULL),
(8, 1004, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0, '2026-06-03');

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

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `Transaction_ID` int(11) NOT NULL,
  `Appointment_ID` int(11) DEFAULT NULL,
  `Client_ID` int(11) DEFAULT NULL,
  `Service_ID` int(11) DEFAULT NULL,
  `Transaction_Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Base_Amount` decimal(7,2) DEFAULT NULL,
  `Discount_ID` int(11) DEFAULT NULL,
  `Discount_Amount` decimal(4,2) DEFAULT NULL,
  `Total_Amount` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`Transaction_ID`, `Appointment_ID`, `Client_ID`, `Service_ID`, `Transaction_Date`, `Base_Amount`, `Discount_ID`, `Discount_Amount`, `Total_Amount`) VALUES
(1, 1, 1001, 1, '2026-05-30 16:00:00', NULL, NULL, NULL, 449.00),
(2, 2, 1001, 5, '2026-05-31 16:00:00', NULL, NULL, NULL, 299.00),
(3, 3, 1001, 1, '2026-05-31 16:00:00', NULL, NULL, NULL, 449.00),
(4, 4, 1001, 1, '2026-05-31 16:00:00', NULL, NULL, NULL, 449.00),
(5, 5, 1001, 1, '2026-05-31 16:00:00', NULL, NULL, NULL, 449.00),
(6, 6, 1001, 1, '2026-05-31 16:00:00', NULL, NULL, NULL, 449.00),
(7, 7, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(8, 7, 1001, 9, '2026-06-01 16:00:00', NULL, NULL, NULL, 170.00),
(9, 8, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(10, 9, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(11, 10, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(12, 11, 1001, 3, '2026-06-01 16:00:00', NULL, NULL, NULL, 549.00),
(13, 12, 1001, 6, '2026-06-01 16:00:00', NULL, NULL, NULL, 349.00),
(14, 13, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(15, 14, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(16, 15, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(17, 16, 1001, 10, '2026-06-01 16:00:00', NULL, NULL, NULL, 200.00),
(18, 16, 1001, 5, '2026-06-01 16:00:00', NULL, NULL, NULL, 299.00),
(19, 16, 1001, 4, '2026-06-01 16:00:00', NULL, NULL, NULL, 599.00),
(20, 17, 1001, 1, '2026-06-01 16:00:00', NULL, NULL, NULL, 449.00),
(21, 18, 1004, 1, '2026-06-02 16:00:00', 449.00, 1, 89.80, 359.20),
(22, 18, 1004, 2, '2026-06-02 16:00:00', 499.00, 1, 99.80, 399.20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`Appointment_ID`),
  ADD KEY `FK_App_ClientID` (`Client_ID`),
  ADD KEY `FK_App_DesignID` (`Design_ID`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`Client_ID`);

--
-- Indexes for table `design_inspo`
--
ALTER TABLE `design_inspo`
  ADD PRIMARY KEY (`Design_ID`),
  ADD KEY `FK_Design_ClientID` (`Client_ID`);

--
-- Indexes for table `discount`
--
ALTER TABLE `discount`
  ADD PRIMARY KEY (`Discount_ID`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`Visit_ID`),
  ADD KEY `FK_Hist_ClientID` (`Client_ID`),
  ADD KEY `FK_Hist_ServiceID` (`Service_ID`);

--
-- Indexes for table `nail_size`
--
ALTER TABLE `nail_size`
  ADD PRIMARY KEY (`Size_ID`),
  ADD KEY `FK_Nail_ClientID` (`Client_ID`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`Service_ID`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`Transaction_ID`),
  ADD KEY `FK_Trans_AppID` (`Appointment_ID`),
  ADD KEY `FK_Trans_ClientID` (`Client_ID`),
  ADD KEY `FK_Trans_ServiceID` (`Service_ID`),
  ADD KEY `FK_Trans_DiscountID` (`Discount_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `Appointment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `design_inspo`
--
ALTER TABLE `design_inspo`
  MODIFY `Design_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `Visit_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `nail_size`
--
ALTER TABLE `nail_size`
  MODIFY `Size_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `Transaction_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `FK_App_ClientID` FOREIGN KEY (`Client_ID`) REFERENCES `client` (`Client_ID`),
  ADD CONSTRAINT `FK_App_DesignID` FOREIGN KEY (`Design_ID`) REFERENCES `design_inspo` (`Design_ID`);

--
-- Constraints for table `design_inspo`
--
ALTER TABLE `design_inspo`
  ADD CONSTRAINT `FK_Design_ClientID` FOREIGN KEY (`Client_ID`) REFERENCES `client` (`Client_ID`);

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `FK_Hist_ClientID` FOREIGN KEY (`Client_ID`) REFERENCES `client` (`Client_ID`),
  ADD CONSTRAINT `FK_Hist_ServiceID` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`);

--
-- Constraints for table `nail_size`
--
ALTER TABLE `nail_size`
  ADD CONSTRAINT `FK_Nail_ClientID` FOREIGN KEY (`Client_ID`) REFERENCES `client` (`Client_ID`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `FK_Trans_AppID` FOREIGN KEY (`Appointment_ID`) REFERENCES `appointment` (`Appointment_ID`),
  ADD CONSTRAINT `FK_Trans_ClientID` FOREIGN KEY (`Client_ID`) REFERENCES `client` (`Client_ID`),
  ADD CONSTRAINT `FK_Trans_DiscountID` FOREIGN KEY (`Discount_ID`) REFERENCES `discount` (`Discount_ID`),
  ADD CONSTRAINT `FK_Trans_ServiceID` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
