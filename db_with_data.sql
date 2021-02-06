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
  `nazev` varchar(45) NOT NULL,
  `datum_vysetreni` date NOT NULL,
  `pracovnik` varchar(45) NOT NULL,
  `ukoly` varchar(45) DEFAULT 'ukoly',
  `diagnoza_table_ID` int unsigned NOT NULL,
  `diagnoza_table_pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`diagnoza_table_ID`,`diagnoza_table_pacient_ID`),
  KEY `fk_Diagnosticke_vysetrenie_diagnoza_table1_idx` (`diagnoza_table_ID`,`diagnoza_table_pacient_ID`),
  CONSTRAINT `fk_Diagnosticke_vysetrenie_diagnoza_table1` FOREIGN KEY (`diagnoza_table_ID`, `diagnoza_table_pacient_ID`) REFERENCES `diagnoza_table` (`ID`, `pacient_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Diagnosticke_vysetrenie`
--

LOCK TABLES `Diagnosticke_vysetrenie` WRITE;
/*!40000 ALTER TABLE `Diagnosticke_vysetrenie` DISABLE KEYS */;
INSERT INTO `Diagnosticke_vysetrenie` VALUES (1,'sken','1255-05-05','dominika','ukoly',1,1),(2,'sken','1255-05-05','dominika','ukoly',2,2),(3,'sken','1255-05-05','dominika','ukoly',3,2),(4,'ohnive','1855-05-05','dominika','ukoly',4,3),(5,'fukanie','1855-05-05','dominika','ukoly',4,3),(6,'odber krvy','1855-05-05','dominika','ukoly',4,3),(7,'kreslenie','1855-05-05','dominika','ukoly',7,4),(8,'posudok','1855-05-05','dominika','ukoly',7,4),(9,'ziadne','4444-04-14','dominika','ukoly',7,4);
/*!40000 ALTER TABLE `Diagnosticke_vysetrenie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnoza_table`
--

DROP TABLE IF EXISTS `diagnoza_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoza_table` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `diagnoza` varchar(45) NOT NULL,
  `stav` varchar(45) NOT NULL,
  `datum_vytvoreni` date NOT NULL,
  `datum_zmeny` date NOT NULL,
  `Diagnosticke_vysetrenia` varchar(45) DEFAULT 'Diagnosticke_vysetrenia',
  `pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`pacient_ID`),
  KEY `fk_diagnoza_table_pacient_idx` (`pacient_ID`),
  CONSTRAINT `fk_diagnoza_table_pacient` FOREIGN KEY (`pacient_ID`) REFERENCES `pacient` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoza_table`
--

LOCK TABLES `diagnoza_table` WRITE;
/*!40000 ALTER TABLE `diagnoza_table` DISABLE KEYS */;
INSERT INTO `diagnoza_table` VALUES (1,'zavislot na pizzu','novy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',1),(2,'zavislot na pizzu','novy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',2),(3,'zavislot na kebab','novy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',2),(4,'alkohol','novy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',3),(5,'vsetko','novy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',3),(6,'ziadna','nikdy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',4),(7,'farbenie','nikdy','2005-09-06','2020-11-22','Diagnosticke_vysetrenia',4);
/*!40000 ALTER TABLE `diagnoza_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacient`
--

DROP TABLE IF EXISTS `pacient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacient` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `jmeno` varchar(45) NOT NULL,
  `prijmeni` varchar(45) NOT NULL,
  `pohlavi` varchar(45) NOT NULL,
  `datum_narozeni` date NOT NULL,
  `diagnozy` varchar(45) DEFAULT 'diagnozy',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacient`
--

LOCK TABLES `pacient` WRITE;
/*!40000 ALTER TABLE `pacient` DISABLE KEYS */;
INSERT INTO `pacient` VALUES (1,'pacient1','prijmeni','neviem','2155-09-06','diagnozy'),(2,'pacient2','prijmen3','neviem','0666-09-06','diagnozy'),(3,'tatiana','nie','zena','0666-06-06','diagnozy'),(4,'dominika','vesela','zena','1996-04-14','diagnozy');
/*!40000 ALTER TABLE `pacient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ukol`
--

DROP TABLE IF EXISTS `ukol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ukol` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `jmeno` varchar(45) NOT NULL,
  `subor_grafickeho_tabletu` varchar(45) DEFAULT NULL,
  `datum_vytvoreni` date NOT NULL,
  `datum_zmeny` date NOT NULL,
  `velkost_suboru` int unsigned DEFAULT NULL,
  `Diagnosticke_vysetrenie_ID` int unsigned NOT NULL,
  `Diagnosticke_vysetrenie_diagnoza_table_ID` int unsigned NOT NULL,
  `Diagnosticke_vysetrenie_diagnoza_table_pacient_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`,`Diagnosticke_vysetrenie_ID`,`Diagnosticke_vysetrenie_diagnoza_table_ID`,`Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`),
  KEY `fk_ukol_Diagnosticke_vysetrenie1_idx` (`Diagnosticke_vysetrenie_ID`,`Diagnosticke_vysetrenie_diagnoza_table_ID`,`Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`),
  CONSTRAINT `fk_ukol_Diagnosticke_vysetrenie1` FOREIGN KEY (`Diagnosticke_vysetrenie_ID`, `Diagnosticke_vysetrenie_diagnoza_table_ID`, `Diagnosticke_vysetrenie_diagnoza_table_pacient_ID`) REFERENCES `Diagnosticke_vysetrenie` (`ID`, `diagnoza_table_ID`, `diagnoza_table_pacient_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ukol`
--

LOCK TABLES `ukol` WRITE;
/*!40000 ALTER TABLE `ukol` DISABLE KEYS */;
INSERT INTO `ukol` VALUES (1,'default1',NULL,'1645-08-07','2020-11-22',NULL,1,1,1),(2,'default2',NULL,'1645-08-07','2020-11-22',NULL,1,1,1),(3,'default3',NULL,'1645-08-07','2020-11-22',NULL,1,1,1),(4,'default4',NULL,'0145-08-07','2020-11-22',NULL,2,2,2),(5,'default4',NULL,'1455-08-07','2020-11-22',NULL,2,2,2),(6,'default5',NULL,'1455-08-07','2020-11-22',NULL,3,3,2),(7,'default6',NULL,'1455-08-07','2020-11-22',NULL,4,4,3),(8,'default6',NULL,'1455-08-07','2020-11-22',NULL,5,4,3),(9,'default7',NULL,'1455-08-07','2020-11-22',NULL,5,4,3),(10,'default8',NULL,'1455-08-07','2020-11-22',NULL,6,4,3),(11,'default9',NULL,'1455-08-07','2020-11-22',NULL,9,7,4);
/*!40000 ALTER TABLE `ukol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `username` varchar(16) NOT NULL,
  `password` varchar(128) NOT NULL,
  `jmeno` varchar(45) NOT NULL,
  `prijmeni` varchar(45) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('kamas','cb4bbdfc9b682c298cdfc02cf3b67c6175acc7715b67cdfa7a489975061574d23b3eb1d44ee8e973740d10962890b0c4ff22c3e40fca4dada644ac26bc90b755','kamas','tom'),('shewi','8a827e58f89b473fd09b9c09e6d3e60e66a8343fc4e7c84b92807792f04f1ec375768a8616a44a89af7c34291a8a72300cb010e070432c0322f0f7f976118ed0','dominika','peroxide');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-06 15:33:50
