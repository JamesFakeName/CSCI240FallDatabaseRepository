-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: FilmClub
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.1

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
  PRIMARY KEY (`Person_ID`),
  CONSTRAINT `fk_Director_Person` FOREIGN KEY (`Person_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Director`
--

LOCK TABLES `Director` WRITE;
/*!40000 ALTER TABLE `Director` DISABLE KEYS */;
INSERT INTO `Director` VALUES (1,7,'Drama'),(2,12,'Fantasy'),(3,1,'Drama'),(8,10,'Thriller');
/*!40000 ALTER TABLE `Director` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Director_Awards`
--

DROP TABLE IF EXISTS `Director_Awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Director_Awards` (
  `Person_ID` int DEFAULT NULL,
  `Award` text,
  KEY `fk_Director_Awards_Person` (`Person_ID`),
  CONSTRAINT `fk_Director_Awards_Person` FOREIGN KEY (`Person_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Director_Awards`
--

LOCK TABLES `Director_Awards` WRITE;
/*!40000 ALTER TABLE `Director_Awards` DISABLE KEYS */;
INSERT INTO `Director_Awards` VALUES (1,'BAFTA'),(1,'Oscar'),(1,'Golden Globe'),(1,'Cannes Film Festival'),(2,'BAFTA'),(2,'Oscar'),(2,'Golden Globe'),(8,'BAFTA'),(8,'Oscar'),(8,'Golden Globe'),(8,'Cannes Film Festival');
/*!40000 ALTER TABLE `Director_Awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Film`
--

DROP TABLE IF EXISTS `Film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Film` (
  `Film_ID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(128) NOT NULL,
  `Genre` text,
  `Nationality` text,
  `Run_Time` time DEFAULT NULL,
  `Director_ID` int DEFAULT NULL,
  PRIMARY KEY (`Film_ID`),
  KEY `fk_Film_Person` (`Director_ID`),
  CONSTRAINT `fk_Film_Person` FOREIGN KEY (`Director_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Film`
--

LOCK TABLES `Film` WRITE;
/*!40000 ALTER TABLE `Film` DISABLE KEYS */;
INSERT INTO `Film` VALUES (1,'Amores Perros','Drama','Mexico','02:33:00',1),(2,'Howl\'s Moving Castle','Fantasy','Japan','01:59:00',2),(3,'Mars Express','SciFi','France','01:29:00',3),(4,'Pulp Fiction','Crime','USA','02:34:00',8),(5,'FilmTest','Horror','Mexico',NULL,NULL);
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
  `Film_ID` int DEFAULT NULL,
  KEY `fk_FilmActor_Actor` (`Actor_ID`),
  KEY `fk_FilmActor_Film` (`Film_Title`),
  KEY `fk_FilmActor_Film_Film_ID` (`Film_ID`),
  CONSTRAINT `fk_FilmActor_Actor_Person_ID` FOREIGN KEY (`Actor_ID`) REFERENCES `Actor` (`Person_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_FilmActor_Film_Film_ID` FOREIGN KEY (`Film_ID`) REFERENCES `Film` (`Film_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FilmActor`
--

LOCK TABLES `FilmActor` WRITE;
/*!40000 ALTER TABLE `FilmActor` DISABLE KEYS */;
INSERT INTO `FilmActor` VALUES ('Amores Perros',4,1),('Howl\'s Moving Castle',5,2),('Howl\'s Moving Castle',6,2),('Mars Express',7,3),('Pulp Fiction',8,4),(NULL,7,2),('FilmTest',7,5),('FilmTest',4,5),('FilmTest',4,5),(NULL,6,5);
/*!40000 ALTER TABLE `FilmActor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Film_Available_Via`
--

DROP TABLE IF EXISTS `Film_Available_Via`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Film_Available_Via` (
  `Film_ID` int DEFAULT NULL,
  `Company_ID` int DEFAULT NULL,
  `Medium` text,
  KEY `fk_Film_Available_Via_Film` (`Film_ID`),
  KEY `fk_Film_Available_Via_Content_Provider` (`Company_ID`),
  CONSTRAINT `fk_Film_Available_Via_Content_Provider` FOREIGN KEY (`Company_ID`) REFERENCES `Content_Provider` (`Company_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_Film_Available_Via_Film` FOREIGN KEY (`Film_ID`) REFERENCES `Film` (`Film_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Film_Available_Via`
--

LOCK TABLES `Film_Available_Via` WRITE;
/*!40000 ALTER TABLE `Film_Available_Via` DISABLE KEYS */;
INSERT INTO `Film_Available_Via` VALUES (1,1,'Rent'),(1,1,'Purchase'),(2,1,'Rent'),(2,1,'Purchase'),(2,3,'Stream'),(3,1,'Rent'),(3,1,'Purchase'),(4,1,'Stream'),(4,1,'Rent'),(4,1,'Purchase');
/*!40000 ALTER TABLE `Film_Available_Via` ENABLE KEYS */;
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
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES (1,'Alejandro','Inarritu'),(2,'Hayao','Miyazaki'),(3,'Jeremie','Perin'),(4,'Gael','Bernal'),(5,'Jean','Simmons'),(6,'Billy','Crystal'),(7,'Morla','Gorrondona'),(8,'Quentin','Tarantino'),(9,'Kurt','Russell'),(11,'John ','Carpenter'),(12,'LaKeith ','Stanfield'),(13,'Cio','Cioelle\')'),(14,'Allison\'','Ruth\''),(15,'<h1> Example text </h1>','');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person_Language`
--

DROP TABLE IF EXISTS `Person_Language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person_Language` (
  `Person_ID` int DEFAULT NULL,
  `Language` text,
  KEY `fk_Person_Language_Person` (`Person_ID`),
  CONSTRAINT `fk_Person_Language_Person` FOREIGN KEY (`Person_ID`) REFERENCES `Person` (`Person_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person_Language`
--

LOCK TABLES `Person_Language` WRITE;
/*!40000 ALTER TABLE `Person_Language` DISABLE KEYS */;
INSERT INTO `Person_Language` VALUES (1,'Spanish'),(1,'English'),(2,'Japanese'),(3,'French'),(4,'Spanish'),(5,'English'),(6,'English'),(7,'English'),(8,'English');
/*!40000 ALTER TABLE `Person_Language` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-02 23:11:12
