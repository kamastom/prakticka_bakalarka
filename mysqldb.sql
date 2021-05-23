-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Diagnosticke_vysetrenie`
--

DROP TABLE IF EXISTS `Diagnosticke_vysetrenie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Diagnosticke_vysetrenie` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `nazev` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum_vysetreni` date NOT NULL,
  `pracovnik` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ukoly` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT 'ukoly',
  `diagnoza_table_ID` int unsigned NOT NULL,
  `diagnoza_table_pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`diagnoza_table_ID`,`diagnoza_table_pacient_ID`),
  KEY `fk_Diagnosticke_vysetrenie_diagnoza_table1_idx` (`diagnoza_table_ID`,`diagnoza_table_pacient_ID`),
  CONSTRAINT `fk_Diagnosticke_vysetrenie_diagnoza_table1` FOREIGN KEY (`diagnoza_table_ID`, `diagnoza_table_pacient_ID`) REFERENCES `diagnoza_table` (`ID`, `pacient_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `diagnoza_table`
--

DROP TABLE IF EXISTS `diagnoza_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoza_table` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `diagnoza` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stav` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum_vytvoreni` date NOT NULL,
  `datum_zmeny` date NOT NULL,
  `Diagnosticke_vysetrenia` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT 'Diagnosticke_vysetrenia',
  `pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`pacient_ID`),
  KEY `fk_diagnoza_table_pacient_idx` (`pacient_ID`),
  CONSTRAINT `fk_diagnoza_table_pacient` FOREIGN KEY (`pacient_ID`) REFERENCES `pacient` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `pacient`
--

DROP TABLE IF EXISTS `pacient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacient` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `jmeno` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prijmeni` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pohlavi` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum_narozeni` date NOT NULL,
  `diagnozy` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT 'diagnozy',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ENCRYPTION='Y';
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `ukol`
--

DROP TABLE IF EXISTS `ukol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ukol` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `jmeno` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subor_grafickeho_tabletu` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `datum_vytvoreni` date NOT NULL,
  `datum_zmeny` date NOT NULL,
  `velkost_suboru` int unsigned DEFAULT NULL,
  `Diagnosticke_vysetrenie_ID` int unsigned NOT NULL,
  `Diagnosticke_vysetrenie_diagnoza_table_ID` int unsigned NOT NULL,
  `Diagnosticke_vysetrenie_diagnoza_table_pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`Diagnosticke_vysetrenie_ID`,`Diagnosticke_vysetrenie_diagnoza_table_ID`,`Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`),
  KEY `fk_ukol_Diagnosticke_vysetrenie1_idx` (`Diagnosticke_vysetrenie_ID`,`Diagnosticke_vysetrenie_diagnoza_table_ID`,`Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`),
  CONSTRAINT `fk_ukol_Diagnosticke_vysetrenie1` FOREIGN KEY (`Diagnosticke_vysetrenie_ID`, `Diagnosticke_vysetrenie_diagnoza_table_ID`, `Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`) REFERENCES `Diagnosticke_vysetrenie` (`ID`, `diagnoza_table_ID`, `diagnoza_table_pacient_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `username` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jmeno` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prijmeni` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `counter` int NOT NULL,
  `HOTP` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-06 21:58:24
