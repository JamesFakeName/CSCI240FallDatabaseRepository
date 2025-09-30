-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: FilmClub
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.1

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
-- Table structure for table `Actor`
--

DROP TABLE IF EXISTS `Actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Actor` (
  `Person_ID` int NOT NULL,
  `Lead_or_Side_Role` text,
  `Typical_Role` text,
  `Gender` text,
  PRIMARY KEY (`Person_ID`),
  CONSTRAINT `fk_Actor_Person` FOREIGN KEY (`Person_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Actor`
--

LOCK TABLES `Actor` WRITE;
/*!40000 ALTER TABLE `Actor` DISABLE KEYS */;
INSERT INTO `Actor` VALUES (4,'Lead','Fool','Male'),(5,'Lead','Romantic Interest','Female'),(6,'Side','Comedic','Male'),(7,'Lead','Voice_Actor','Female'),(8,'Side','Cameo','Male');
/*!40000 ALTER TABLE `Actor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Content_Provider`
--

DROP TABLE IF EXISTS `Content_Provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Content_Provider` (
  `Company_ID` int NOT NULL AUTO_INCREMENT,
  `Company_Name` text,
  `Stream` tinyint(1) DEFAULT NULL,
  `Rent` tinyint(1) DEFAULT NULL,
  `Sell` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Company_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Content_Provider`
--

LOCK TABLES `Content_Provider` WRITE;
/*!40000 ALTER TABLE `Content_Provider` DISABLE KEYS */;
INSERT INTO `Content_Provider` VALUES (1,'Amazon Prime',1,1,1),(2,'Netflix',1,0,0),(3,'HBO MAX',1,0,0);
/*!40000 ALTER TABLE `Content_Provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Director`
--

DROP TABLE IF EXISTS `Director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Director` (
  `Person_ID` int NOT NULL,
  `Total_Films` int DEFAULT '0',
  `Typical_Genre` text,
  `Awards` text,
  PRIMARY KEY (`Person_ID`),
  CONSTRAINT `fk_Director_Person` FOREIGN KEY (`Person_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Director`
--

LOCK TABLES `Director` WRITE;
/*!40000 ALTER TABLE `Director` DISABLE KEYS */;
INSERT INTO `Director` VALUES (1,7,'Drama','BAFTA'),(2,12,'Fantasy','Oscar'),(3,1,'Drama','Film Festivals'),(8,10,'Thriller','BAFTA');
/*!40000 ALTER TABLE `Director` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Film`
--

DROP TABLE IF EXISTS `Film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Film` (
  `Title` varchar(128) NOT NULL,
  `Genre` text,
  `Nationality` text,
  `Run_Time` time DEFAULT NULL,
  `Director_ID` int DEFAULT NULL,
  PRIMARY KEY (`Title`),
  KEY `fk_Film_Person` (`Director_ID`),
  CONSTRAINT `fk_Film_Person` FOREIGN KEY (`Director_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Film`
--

LOCK TABLES `Film` WRITE;
/*!40000 ALTER TABLE `Film` DISABLE KEYS */;
INSERT INTO `Film` VALUES ('Amores Perros','Drama','Mexico','02:33:00',1),('Howl\'s Moving Castle','Fantasy','Japan','01:59:00',2),('Mars Express','SciFi','France','01:29:00',3),('Pulp Fiction','Crime','USA','02:34:00',8);
/*!40000 ALTER TABLE `Film` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FilmActor`
--

DROP TABLE IF EXISTS `FilmActor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FilmActor` (
  `Film_Title` varchar(128) DEFAULT NULL,
  `Actor_ID` int DEFAULT NULL,
  KEY `fk_FilmActor_Actor` (`Actor_ID`),
  KEY `fk_FilmActor_Film` (`Film_Title`),
  CONSTRAINT `fk_FilmActor_Actor` FOREIGN KEY (`Actor_ID`) REFERENCES `Actor` (`Person_ID`),
  CONSTRAINT `fk_FilmActor_Film` FOREIGN KEY (`Film_Title`) REFERENCES `Film` (`Title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FilmActor`
--

LOCK TABLES `FilmActor` WRITE;
/*!40000 ALTER TABLE `FilmActor` DISABLE KEYS */;
INSERT INTO `FilmActor` VALUES ('Amores Perros',4),('Howl\'s Moving Castle',5),('Howl\'s Moving Castle',6),('Mars Express',7),('Pulp Fiction',8);
/*!40000 ALTER TABLE `FilmActor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Film_Provided`
--

DROP TABLE IF EXISTS `Film_Provided`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Film_Provided` (
  `Title` varchar(128) DEFAULT NULL,
  `Company_ID` int DEFAULT NULL,
  KEY `fk_Film_Provided_Film` (`Title`),
  KEY `fk_Film_Provided_Content_Provider` (`Company_ID`),
  CONSTRAINT `fk_Film_Provided_Content_Provider` FOREIGN KEY (`Company_ID`) REFERENCES `Content_Provider` (`Company_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Film_Provided_Film` FOREIGN KEY (`Title`) REFERENCES `Film` (`Title`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Film_Provided`
--

LOCK TABLES `Film_Provided` WRITE;
/*!40000 ALTER TABLE `Film_Provided` DISABLE KEYS */;
INSERT INTO `Film_Provided` VALUES ('Amores Perros',1),('Howl\'s Moving Castle',1),('Howl\'s Moving Castle',2),('Mars Express',1),('Pulp Fiction',1);
/*!40000 ALTER TABLE `Film_Provided` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `Person_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` text,
  `Last_Name` text,
  `Languages` text,
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES (1,'Alejandro','Inarritu','Spanish'),(2,'Hayao','Miyazaki','Japanese'),(3,'Jeremie','Perin','French'),(4,'Gael','Bernal','Spanish'),(5,'Jean','Simmons','English'),(6,'Billy','Crystal','English'),(7,'Morla','Gorrondona','English'),(8,'Quentin','Tarantino','English');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-30 19:27:46
