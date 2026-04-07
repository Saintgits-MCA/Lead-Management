-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: leads
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `client_data`
--

DROP TABLE IF EXISTS `client_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `status` varchar(10) NOT NULL,
  `address` longtext,
  `gst` varchar(50) DEFAULT NULL,
  `logo` varchar(500) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `header_image` varchar(100) DEFAULT NULL,
  `quotation_footer_image` varchar(100) DEFAULT NULL,
  `about` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_data`
--

LOCK TABLES `client_data` WRITE;
/*!40000 ALTER TABLE `client_data` DISABLE KEYS */;
INSERT INTO `client_data` VALUES (1,'8782788925','NAN8925@HE','Nandagopan Marar','Physio Clinic','8782788925','nandan_dummy@gmail.com','2025-12-17 16:15:25.017524','2025-12-22 12:40:11.895294','Active',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'9447742364','ANG2364@58','Angel Maria Kondody','Maria Kondody Travels','9447742364','kondodymotors_dummy@gmail.com','2025-12-17 17:03:59.621506','2025-12-22 12:40:49.687358','Active',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'8782788936','NAN8936@X3','Naveen','Naveen Textiles','8782788936','naveen-dumy@gmail.com','2025-12-18 09:38:03.161915','2025-12-22 12:39:54.743137','Active',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'8795788935','SON8935@W9','Sonu AB','Modern Roofing Pvt Ltd','8795788935','sonutech_dummy@gmail.com','2025-12-18 11:01:02.725412','2026-02-09 11:43:09.414822','Active','Erayil Kadavu,Kottayam','32AKZPM7513K1ZL','client_logos\\8795788935\\logo.jpg',NULL,'','','About Company                \r\n                \r\n                '),(5,'8782788935','MER8935@5Z','Merin','Nexgen EHR','8782788935','tisser.tech_dummy@gmail.com','2025-12-18 12:18:11.023698','2025-12-20 15:33:23.790515','Active','Erayil Kadavu,Kottayam','32AKZPM7513K1ZL','client_logos\\8782788935\\logo.webp','https://nexgenehr.in',NULL,NULL,NULL),(6,'9787742365','MAR2365@FC','Maria Mathew','Varikkadan Travels','9787742365','varikkadan_dummy@gmail.com','2025-12-19 17:51:27.942089','2025-12-22 14:57:35.190648','Suspended','Kottayam','ASDFV14233S','client_logos\\9787742365\\logo.png',NULL,NULL,NULL,NULL),(7,'7256798923','ARU8923@5T','Arunima','ARM Stores','7256798923','arunima_dummy@gmail.com','2025-12-20 13:00:03.234756','2025-12-22 12:39:41.130986','Active',NULL,'32AKZPM7513K1ZL',NULL,NULL,NULL,NULL,NULL),(8,'7504678888','MER8888@6N','Merin Joseph','NexgenEHR','7504678888','merin_dummy123@gmail.com','2026-01-21 13:20:26.287257','2026-01-21 13:20:26.287257','Active','Kottayam','ASDFV14233W',NULL,'https://abctechnologies.com','','',NULL),(9,'7902622237','ABH2237@SP','Abhinesh Mon','New Tech Media Solutions','7902622237','dvrktm@gmail.com','2026-01-21 15:04:31.033069','2026-02-09 13:52:50.706678','Active','Opp. Vision Honda,Nattakom, Kottayam','32AOVPA1572L1ZS','client_logos\\7902622237\\logo.png','https://www.newtechmediasolution.com','','',NULL),(10,'9562766838','admin','Testclient','Maria Kondody Travels','9562364567','tecknohow.132@gmail.com','2026-01-21 15:08:38.711580','2026-01-29 09:45:43.230648','Active','Kottayam','AFDPV14233F',NULL,'https://nexgenehr.in','','',NULL),(11,'8782788937','MAR8937@5P','Marvel Bags','ABC Technologies Pvt Ltd','8782788937','naveen_dummy@gmail.com','2026-01-23 13:55:39.126963','2026-02-09 12:41:44.797290','Suspended','jg','AFDPV14233F',NULL,'https://nexgenehr.in/','','',NULL);
/*!40000 ALTER TABLE `client_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'companyadmin','Admin@123');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `document_id` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `type` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_id` (`document_id`),
  KEY `lead_app_document_client_id_a23adc36_fk_client_data_id` (`client_id`),
  CONSTRAINT `lead_app_document_client_id_a23adc36_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
INSERT INTO `document` VALUES (3,'LIC345773829','Enterprise License','bbdchsdhhbv hjdbvkrb','License','2026-01-05 10:35:30.111817',4,'2026-01-30'),(4,'LIC349773829','Pan Card','bvbbmvm','Document','2026-01-05 10:41:21.362030',4,'2026-01-30'),(5,'LIC342773829','License','vxxcvbb','License','2026-01-05 12:59:03.218558',4,'2026-02-28'),(6,'MUNCIPALITY LICENSE','License','','license','2026-01-07 16:03:49.899609',4,'2026-02-03'),(7,'LIC346773856','License','gvhj','','2026-01-16 11:00:10.894730',4,'2026-01-23'),(8,'KL33N 3448','Vitara Brezza','insurace Renewal','Insurancece','2026-01-21 15:42:24.937180',9,'2026-01-23'),(9,'KL33N1423','Vitara Brezza','Pollution','Pollution','2026-01-21 15:42:55.898688',9,'2026-01-30'),(10,'BUILDING NATTAKOM','Muncipality License renewal','','License','2026-01-21 15:44:01.250184',9,'2026-03-31'),(11,'LIC349773881','Important Docs','dsfssd','fgsdf','2026-02-09 10:29:04.879141',4,'2026-03-07');
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiryfor`
--

DROP TABLE IF EXISTS `enquiryfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiryfor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `status` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `EnquiryFor_client_id_name_38f02666_uniq` (`client_id`,`name`),
  CONSTRAINT `EnquiryFor_client_id_d52bddd2_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiryfor`
--

LOCK TABLES `enquiryfor` WRITE;
/*!40000 ALTER TABLE `enquiryfor` DISABLE KEYS */;
INSERT INTO `enquiryfor` VALUES (1,'Logo','2025-12-22 16:12:06.891951','2025-12-22 16:34:36.083443',4,'Active'),(2,'Website','2025-12-22 16:34:21.833112','2025-12-22 16:34:21.833112',4,'Active'),(3,'Application','2025-12-22 17:19:41.855085','2025-12-22 17:19:41.855085',4,'Active'),(4,'Portfolio','2025-12-22 17:21:29.283884','2026-01-03 13:34:53.691855',4,'Active'),(5,'Videography','2025-12-22 17:21:45.283366','2025-12-22 17:21:45.283366',4,'Active'),(6,'Reels','2025-12-22 17:21:56.527184','2025-12-22 17:21:56.527184',4,'Active'),(7,'Automatc Gate','2026-01-21 15:17:08.000543','2026-01-21 15:17:08.000543',9,'Active'),(8,'Automatic Shutter','2026-01-21 15:17:16.522203','2026-01-21 15:17:16.522203',9,'Active'),(9,'Gate Maintenance','2026-01-21 15:17:38.435617','2026-01-21 15:17:38.435617',9,'Active'),(10,'Remote Repair','2026-01-21 15:18:01.939868','2026-01-21 15:18:01.939868',9,'Active'),(11,'Automatic Gate','2026-02-06 10:56:58.912275','2026-02-06 10:59:24.597463',4,'Active'),(12,'Advertisement','2026-02-09 10:42:25.105977','2026-02-09 10:42:25.105977',4,'Active');
/*!40000 ALTER TABLE `enquiryfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followup_table`
--

DROP TABLE IF EXISTS `followup_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `followup_table` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lead_id` int NOT NULL,
  `client_id` int NOT NULL,
  `status` varchar(50) NOT NULL,
  `next_followup_date` date DEFAULT NULL,
  `next_followup_time` time(6) DEFAULT NULL,
  `converted_time` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followup_table`
--

LOCK TABLES `followup_table` WRITE;
/*!40000 ALTER TABLE `followup_table` DISABLE KEYS */;
INSERT INTO `followup_table` VALUES (1,1,4,'Follow-up','2026-01-29','16:00:00.000000','2026-01-03 13:55:12.645184','2026-01-03 13:55:12.645184'),(2,2,4,'Converted','2025-12-30','05:25:00.000000','2026-01-03 15:07:53.513792','2026-01-03 15:07:53.513792'),(4,9,9,'Converted','2026-01-23','08:01:00.000000','2026-01-22 15:04:15.800792','2026-01-22 15:03:46.011309');
/*!40000 ALTER TABLE `followup_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followupremark`
--

DROP TABLE IF EXISTS `followupremark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `followupremark` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lead_id` int NOT NULL,
  `client_id` int NOT NULL,
  `remark_date` date NOT NULL,
  `remark_text` varchar(500) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `followup_id_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_app_followuprem_followup_id_id_e97a2545_fk_lead_app_` (`followup_id_id`),
  CONSTRAINT `lead_app_followuprem_followup_id_id_e97a2545_fk_lead_app_` FOREIGN KEY (`followup_id_id`) REFERENCES `followup_table` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followupremark`
--

LOCK TABLES `followupremark` WRITE;
/*!40000 ALTER TABLE `followupremark` DISABLE KEYS */;
INSERT INTO `followupremark` VALUES (1,1,4,'2026-01-03','hjkb','2026-01-03 13:14:11.824105',1),(2,1,4,'2026-01-03','Add More beutiful images','2026-01-03 14:49:13.534473',1),(3,2,4,'2026-01-03','Accepted Good one','2026-01-03 15:06:27.100838',2),(4,1,4,'2026-01-05',',,m,m','2026-01-05 09:48:48.160535',1),(5,1,4,'2026-01-05','.m.m,m','2026-01-05 09:48:48.160535',1),(6,9,9,'2026-01-22','bxcvbxbc','2026-01-22 15:03:46.011309',4),(7,9,9,'2026-01-22','Good','2026-01-22 15:04:15.801792',4),(8,1,4,'2026-02-09','dsvdbvdsxczvfvsdfsf','2026-02-09 10:41:39.897035',1);
/*!40000 ALTER TABLE `followupremark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lead_app_employee`
--

DROP TABLE IF EXISTS `lead_app_employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_app_employee` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_code` varchar(20) NOT NULL,
  `employee_name` varchar(100) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `email` varchar(254) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `address` longtext,
  `designation` varchar(100) NOT NULL,
  `join_date` date NOT NULL,
  `status` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `Password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  UNIQUE KEY `email` (`email`),
  KEY `Employee_client_id_fe4c438f_fk_client_data_id` (`client_id`),
  CONSTRAINT `Employee_client_id_fe4c438f_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lead_app_employee`
--

LOCK TABLES `lead_app_employee` WRITE;
/*!40000 ALTER TABLE `lead_app_employee` DISABLE KEYS */;
INSERT INTO `lead_app_employee` VALUES (1,'SON000001','Sonu A B','Male','sonutech_dummy@gmail.com','8795788935','7th mile,Kottayam','Owner','2025-12-02',1,'2025-12-18 16:25:56.632769','2026-02-09 09:34:03.296136',4,'root'),(2,'SON000002','Ben Alex Thevalliparambil','Male','benalex_dummy@gmail.com','9856341224','Kottayam','Project Manager','2025-12-01',1,'2025-12-18 16:58:01.543443','2025-12-20 09:41:52.916016',4,'root'),(3,'SON000003','Manuel','Male','manuel@gmail.com','7683678212','Kottayam','Developer','2025-12-09',1,'2025-12-19 17:23:05.215507','2025-12-19 17:23:44.360627',4,'root'),(4,'SON000004','Samuel Johnson','Male','samuelj@gmail.com','9946341224','Kottayam','Jr Developer','2025-12-10',1,'2025-12-19 17:37:41.778684','2025-12-19 17:54:56.321186',4,'Samuel@9946'),(5,'SON000005','Simon Alex Thevalliparambil','Male','simon__dummy@gmail.com','9046341224','Ernakulam','Jr Developer','2025-12-18',1,'2025-12-22 10:57:45.920415','2025-12-22 10:59:56.875382',4,'root'),(6,'SON000006','Joseph Alex Thevalliparambil','Male','joseph__dummy@gmail.com','8399020210','Ernakulam','Jr Developer','2025-12-18',1,'2025-12-22 11:08:05.123537','2025-12-22 11:14:45.545625',4,'Joseph@123'),(7,'NW1000','Rejisha','Female','dvrktm@gmail.com','7902622237','Kottayam','Manager','2026-01-01',1,'2026-01-21 15:15:28.321394','2026-01-22 16:44:14.776061',9,'123456'),(8,'SON0000190','Shiju','Male','bcm@gmail.com','8756341229','Kottayam','Jr Developer','2026-01-22',1,'2026-01-22 12:36:31.990343','2026-01-22 12:37:23.791474',4,'SON8935@W9'),(9,'SON0000008','Joseph Mel Joel','Male','teckno32@gmail.com','8795788939','Kottayam','Developer','2026-02-10',1,'2026-02-07 17:34:56.289527','2026-02-07 17:37:57.843278',4,'root'),(10,'SON000010','Moncy Samuel','Male','tecknohow.132@gmail.com','8795788938','hterr','Manager','2026-02-09',1,'2026-02-09 09:35:20.405385','2026-02-09 09:35:55.244177',4,'root');
/*!40000 ALTER TABLE `lead_app_employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_table`
--

DROP TABLE IF EXISTS `leads_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leads_table` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(150) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `address` longtext,
  `location` varchar(100) DEFAULT NULL,
  `product_category` varchar(100) NOT NULL,
  `lead_source_id` bigint NOT NULL,
  `requirement_details` longtext,
  `next_followup_date` date DEFAULT NULL,
  `followup_time` time(6) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `remarks` longtext,
  `assign_to` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `deleted_at` datetime(6) DEFAULT NULL,
  `client_id` bigint NOT NULL,
  `staff_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Lead_table_client_id_61c82500_fk_client_data_id` (`client_id`),
  KEY `Lead_table_lead_source_id_b7564021` (`lead_source_id`),
  KEY `Lead_table_staff_id_4d2ab166_fk_Employee_id` (`staff_id`),
  CONSTRAINT `Lead_table_client_id_61c82500_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`),
  CONSTRAINT `Lead_table_lead_source_id_b7564021_fk_LeadSource_id` FOREIGN KEY (`lead_source_id`) REFERENCES `leadsource` (`id`),
  CONSTRAINT `Lead_table_staff_id_4d2ab166_fk_Employee_id` FOREIGN KEY (`staff_id`) REFERENCES `lead_app_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_table`
--

LOCK TABLES `leads_table` WRITE;
/*!40000 ALTER TABLE `leads_table` DISABLE KEYS */;
INSERT INTO `leads_table` VALUES (1,'Shyju Philip','9495213142','shyju@gmail.com','Erayil Kadavu,Kottayam',NULL,'Website',15,'Nice Logo with Web Application apt for enterprise','2026-01-29','16:00:00.000000','Follow-up',NULL,'Sonu A B','2025-12-19 13:41:10.579956','2026-02-09 10:41:39.909023',NULL,4,NULL),(2,'Sabu','9674564635','sabu@gmail.com','Erumely','Kottayam','Logo',18,NULL,'2025-12-30','05:25:00.000000','Converted',NULL,'Samuel Johnson','2025-12-22 15:27:01.702947','2026-01-14 14:43:16.543427',NULL,4,NULL),(3,'Shibu','7446545528','admin@shibu.com',NULL,'Ernakulam','Application',20,NULL,'2025-12-31','12:05:00.000000','Quoted',NULL,'Simon Alex Thevalliparambil','2025-12-23 13:04:00.372879','2026-01-14 14:43:07.689606',NULL,4,NULL),(4,'Byju Philip','9898953132',NULL,'Kottayam',NULL,'Application',19,NULL,'2025-12-17','21:37:00.000000','Quoted',NULL,'Sonu A B','2025-12-30 16:37:27.384853','2026-01-22 13:35:27.062883',NULL,4,NULL),(5,'vnbnn','9562766835','modernroofing23@gmail.com',NULL,'jkhjh','Logo',16,NULL,'2025-12-31','15:28:00.000000','Quoted',NULL,'Sonu A B','2025-12-31 10:53:21.288161','2026-02-06 10:38:32.071779',NULL,4,NULL),(6,'Benz','6778798989','benz@gmail.com','','','Reels',16,'dwewd','2026-01-28','18:40:00.000000','Quoted','Hai','Sonu A B','2025-12-31 10:53:52.370705','2026-01-23 12:28:32.738580',NULL,4,1),(7,'David','9048844713','david@gmail.com','Kottayam','kumarakom','Application',16,'websirte withb  pg , hfhnajklfbadskjf afkdsnfkjdnf vsdsd kf vnkjlesf afadsfsdanfkjn fkjdsafk','2025-01-18','17:35:00.000000','Quoted','mrng call chyenam','Sonu A B','2026-01-07 15:52:03.373435','2026-01-29 13:56:00.013917',NULL,4,1),(8,'Samson','7562737653',NULL,NULL,NULL,'Logo',16,NULL,'2026-02-04','16:03:00.000000','Quoted',NULL,NULL,'2026-01-14 14:45:05.809922','2026-01-19 15:03:47.497515',NULL,4,NULL),(9,'Rupesh1','9496465349',NULL,NULL,'changancherry','Automatc Gate',22,NULL,'2026-01-23','08:01:00.000000','Converted',NULL,'Rejisha','2026-01-21 15:22:28.284413','2026-01-22 15:04:15.803789',NULL,9,NULL),(10,'Shyju Philip','9447742361','shyju@gmail.com','Kottayam ',NULL,'Automatc Gate',21,'Sliding Gate','2026-02-06','18:38:00.000000','Quoted',NULL,NULL,'2026-01-22 15:34:33.302803','2026-01-22 16:36:44.681212',NULL,9,NULL),(11,'Samu','9647859609','samu@yahoo.com',NULL,NULL,'Gate Maintenance',22,NULL,NULL,NULL,'New',NULL,'Rejisha','2026-01-22 15:39:20.713834','2026-01-22 16:04:47.127621',NULL,9,NULL),(12,'Sonu','9447742365','tisser@gmail.com','dcd','changancherry','Application',17,'dsfvss',NULL,'12:15:00.000000','Quoted','asdcas','Sonu A B','2026-01-23 10:15:37.405406','2026-01-23 10:28:38.962006',NULL,4,NULL),(13,'Babu Thomas','9447742367','naveen@gmail.com','Kottayam','Kottayam','Logo',18,'dsfrgdfg','2026-01-28','15:32:00.000000','New','ddf','Sonu A B','2026-01-23 12:32:28.838033','2026-02-06 11:00:04.489867',NULL,4,1),(14,'Manikyan','8782788921',NULL,NULL,NULL,'Automatic Gate',16,NULL,NULL,NULL,'New',NULL,'Sonu A B','2026-01-23 16:22:58.953748','2026-02-06 10:59:53.949621',NULL,4,1),(15,'Binu V Abraham','8836783983','shimne@gmail.com',NULL,'changancherry','Application',16,NULL,NULL,NULL,'Quoted',NULL,NULL,'2026-02-09 09:37:07.312904','2026-02-09 10:15:29.325271',NULL,4,NULL),(16,'Joshy','9447742365','tecknohow.132@gmail.com','','','Application',17,'','2026-02-19','22:47:00.000000','New','',NULL,'2026-02-09 10:55:35.553758','2026-02-09 11:05:36.146819',NULL,4,1),(17,'Philip','7898367349','tecknohow.132@gmail.com','','','Application',17,'','2026-02-19','22:47:00.000000','New','','Sonu A B','2026-02-09 10:55:35.618881','2026-02-09 11:12:12.125133',NULL,4,1),(18,'Tecknohow Troubleshooting','7875885744','tecknohow.132@gmail.com','','','Application',16,'',NULL,NULL,'New','',NULL,'2026-02-09 11:14:26.238935','2026-02-09 11:14:26.238935',NULL,4,1),(19,'Ben','9447742368','','','','Logo',18,'',NULL,NULL,'New','',NULL,'2026-02-09 11:18:08.860465','2026-02-09 11:18:08.860465',NULL,4,1),(20,'Joshu Peter','9447742365','','','','Portfolio',18,'',NULL,NULL,'New','','Sonu A B','2026-02-09 11:19:47.764190','2026-02-09 11:19:47.764190',NULL,4,1);
/*!40000 ALTER TABLE `leads_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leadsource`
--

DROP TABLE IF EXISTS `leadsource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leadsource` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `status` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Lead_Source_client_id_28ad5b48_fk_client_data_id` (`client_id`),
  CONSTRAINT `Lead_Source_client_id_28ad5b48_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leadsource`
--

LOCK TABLES `leadsource` WRITE;
/*!40000 ALTER TABLE `leadsource` DISABLE KEYS */;
INSERT INTO `leadsource` VALUES (8,'Social Media','2025-12-19 12:36:15.109815',5,'Active'),(13,'Advertisement','2025-12-22 10:16:16.958081',6,'Active'),(15,'Digital Marketing','2026-01-07 15:54:46.356603',4,'Active'),(16,'Google','2026-01-07 15:54:54.416160',4,'Active'),(17,'BNI','2026-01-07 15:55:01.961581',4,'Active'),(18,'Website','2026-01-07 15:55:12.288412',4,'Active'),(19,'Client Reference','2026-01-07 15:55:26.729846',4,'Active'),(20,'Walking Customer','2026-01-07 15:55:41.233690',4,'Active'),(21,'Instagram','2026-01-21 15:18:13.703414',9,'Active'),(22,'BNI','2026-01-21 15:18:56.226121',9,'Active'),(23,'JCI','2026-01-21 15:19:01.111247',9,'Active'),(24,'Lions','2026-01-21 15:19:07.152242',9,'Active'),(25,'Google','2026-01-21 15:19:15.068638',9,'Active'),(26,'Website','2026-01-21 15:19:24.341048',9,'Active'),(27,'Client Reference','2026-01-21 15:19:36.090908',9,'Active'),(28,'Social','2026-02-07 16:50:20.060500',4,'Inactive'),(29,'Facebook','2026-02-09 10:42:52.891803',4,'Active');
/*!40000 ALTER TABLE `leadsource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `gst_type` varchar(10) NOT NULL,
  `gst` decimal(5,2) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `status` varchar(10) NOT NULL,
  `hsn_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Product_client_id_52f25a29_fk_client_data_id` (`client_id`),
  CONSTRAINT `Product_client_id_52f25a29_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Roof Top Red',12000.00,'GST',18.00,'2025-12-19 11:11:53.805418','2026-01-21 17:28:44.918760',4,'Active','876546'),(2,'Logo',13450.00,'GST',18.00,'2025-12-19 11:13:38.404787','2026-01-21 17:28:58.551798',4,'Active','873546'),(3,'Welding set',1500.00,'GST',5.00,'2025-12-19 11:17:55.014876','2026-02-06 10:57:13.055256',4,'Active','89786'),(4,'Website',1300.00,'GST',18.00,'2025-12-19 12:36:39.100037','2025-12-19 12:45:09.133716',5,'Active',NULL),(5,'Website',12000.00,'GST',18.00,'2025-12-22 10:19:26.075001','2026-01-21 17:29:54.778480',4,'Active','907878'),(6,'Icon',200.00,'GST',18.00,'2026-01-03 16:45:26.138473','2026-01-21 17:29:42.749946',4,'Active','897864'),(7,'Web Socket',300.00,'GST',18.00,'2026-01-03 16:45:57.757720','2026-01-21 17:30:08.424012',4,'Active','876540'),(8,'Application',1800.00,'GST',18.00,'2026-01-14 14:28:39.541922','2026-01-21 17:30:22.410539',4,'Active','908979'),(9,'Video',1800.00,'GST',0.00,'2026-01-14 14:32:00.704099','2026-01-22 10:39:27.537396',4,'Active','08788'),(10,'Gate Motor USA',37000.00,'GST',18.00,'2026-01-21 15:20:32.802749','2026-01-22 16:37:25.203601',9,'Active','897867'),(11,'Gate 12 feet',35000.00,'GST',5.00,'2026-01-21 15:21:01.611474','2026-01-21 15:52:54.345117',9,'Active',NULL),(12,'shutter',45000.00,'GST',12.00,'2026-01-21 15:21:23.953914','2026-01-21 15:53:02.061408',9,'Active',NULL),(13,'Swing gate Arm Type Openor Motor',20000.00,'IGST',18.00,'2026-01-21 15:59:56.248972','2026-01-22 16:37:17.075020',9,'Active','89786'),(14,'Controlling Box',5000.00,'GST',0.00,'2026-01-21 16:00:27.225397','2026-01-21 16:00:27.225397',9,'Active',NULL),(15,'Laptop Service',500.00,'GST',5.00,'2026-01-22 10:55:29.357145','2026-01-22 10:55:29.357145',4,'Active','5456'),(16,'Sheet',1200.00,'GST',18.00,'2026-02-09 10:43:16.866029','2026-02-09 10:43:16.866029',4,'Active','8978612');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotation`
--

DROP TABLE IF EXISTS `quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_name` varchar(200) NOT NULL,
  `client_phone` varchar(20) NOT NULL,
  `client_email` varchar(100) NOT NULL,
  `client_address` longtext NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `gst_type` varchar(10) NOT NULL,
  `gst_amount` decimal(12,2) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `notes` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `lead_id` bigint DEFAULT NULL,
  `valid_upto` date NOT NULL,
  `cgst` decimal(12,2) DEFAULT NULL,
  `igst` decimal(12,2) DEFAULT NULL,
  `sgst` decimal(12,2) DEFAULT NULL,
  `quotation_number` varchar(80) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `staff_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_app_quotation_client_id_21f5a2f2_fk_client_data_id` (`client_id`),
  KEY `lead_app_quotation_lead_id_05a5cd50_fk_Lead_table_id` (`lead_id`),
  KEY `Quotation_staff_id_a874b158_fk_Employee_id` (`staff_id`),
  CONSTRAINT `lead_app_quotation_client_id_21f5a2f2_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`),
  CONSTRAINT `lead_app_quotation_lead_id_05a5cd50_fk_Lead_table_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_table` (`id`),
  CONSTRAINT `Quotation_staff_id_a874b158_fk_Employee_id` FOREIGN KEY (`staff_id`) REFERENCES `lead_app_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotation`
--

LOCK TABLES `quotation` WRITE;
/*!40000 ALTER TABLE `quotation` DISABLE KEYS */;
INSERT INTO `quotation` VALUES (1,'Shyju Philip','9495213142','shyju@gmail.com','Erayil Kadavu,Kottayam',27250.00,'GST',4515.00,31765.00,'fdfg,mmf','2025-12-30 09:56:13.256537',4,1,'2025-12-18',2257.50,0.00,2257.50,'QUO-4_2025123000001','6',1),(2,'Sabu','9674564635','sabu@gmail.com','Erumely,Kottayam',3000.00,'GST',540.00,3540.00,'Super','2025-12-30 14:28:55.217413',4,2,'2026-01-22',270.00,0.00,270.00,'QUO-4_2025123000002','2',NULL),(3,'Shibu','7446545528','shibu@gmail.com','Erumely,Kottayam',17450.00,'GST',3141.00,20591.00,'Web Application ','2025-12-30 16:22:43.142907',4,3,'2026-01-05',1570.50,0.00,1570.50,'QUO-4_2025123000003','3',NULL),(4,'David','9048844711','shibu@gmail.com','Erayil Kadavu,Kottayam',25500.00,'GST',4395.00,29895.00,'vzvvcsx','2026-01-09 09:58:38.775174',4,7,'2026-01-31',2197.50,0.00,2197.50,'QUO-4_2026010900001','5',1),(6,'Samson','7562737653','samson@gmail.com','None',13250.00,'GST',2385.00,15635.00,'efv','2026-01-14 15:22:36.028367',4,8,'2026-01-22',1192.50,0.00,1192.50,'QUO-4_2026011400002','2',NULL),(7,'Benz Alex','6778798989','benz@gmail.com','Kottayam',5800.00,'GST',396.00,6196.00,'vnbvb','2026-01-14 16:09:05.586048',4,6,'2026-01-14',198.00,0.00,198.00,'QUO-4_2026011400002','7',1),(8,'Rupesh1','9496465349','tissertechindia@gmail.com','None',162000.00,'GST',19210.00,181210.00,'dadfadsf sfgdsgsdg ','2026-01-21 15:25:24.771032',9,9,'2026-01-31',9605.00,0.00,9605.00,'QUO-9_2026012100001','2',NULL),(11,'vnbnn','9562796835','modernroofing23@gmail.com','None',29100.00,'GST',4575.00,33675.00,'ffghh','2026-01-22 11:00:31.477142',4,5,'2026-01-22',2287.50,0.00,2287.50,'QUO-4_2026012200001','2',NULL),(12,'Byju Philip','9898953132','None','Kottayam',15300.00,'',2235.00,17535.00,'hgjhg','2026-01-22 13:35:27.041030',4,4,'2026-01-31',1117.50,NULL,1117.50,'QUO-4_2026012200002','1',NULL),(13,'Shyju Philip','9447742361','shyju@gmail.com','Kottayam ',20000.00,'',3600.00,23600.00,'dsfvsdfgvsdg','2026-01-22 16:36:44.665087',9,10,'2026-01-30',NULL,3600.00,NULL,'QUO-9_2026012200001','1',NULL),(14,'Sonu','9447742365','tisser@gmail.com','dcd',24500.00,'GST',4345.00,28845.00,'jhgvhj','2026-01-23 10:28:38.902865',4,12,'2026-01-30',2172.50,0.00,2172.50,'QUO-4_2026012300001','2',1),(23,'Binu V Abraham','8836783983','shimne@gmail.com','None',12300.00,'GST',2214.00,14514.00,'vsdfv','2026-02-09 10:15:29.294349',4,15,'2026-02-20',1107.00,0.00,1107.00,'QUO-4_2026020900001','7',NULL);
/*!40000 ALTER TABLE `quotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotationitem`
--

DROP TABLE IF EXISTS `quotationitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotationitem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `product_id` bigint NOT NULL,
  `quotation_id` bigint NOT NULL,
  `cgst` decimal(12,2) DEFAULT NULL,
  `igst` decimal(12,2) DEFAULT NULL,
  `sgst` decimal(12,2) DEFAULT NULL,
  `description` longtext,
  `unit` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_app_quotationitem_product_id_768ce1ec_fk_Product_id` (`product_id`),
  KEY `lead_app_quotationit_quotation_id_7c19c80b_fk_lead_app_` (`quotation_id`),
  CONSTRAINT `lead_app_quotationit_quotation_id_7c19c80b_fk_lead_app_` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`),
  CONSTRAINT `lead_app_quotationitem_product_id_768ce1ec_fk_Product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `quotationitem_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotationitem`
--

LOCK TABLES `quotationitem` WRITE;
/*!40000 ALTER TABLE `quotationitem` DISABLE KEYS */;
INSERT INTO `quotationitem` VALUES (1,2,12000.00,24000.00,1,1,2160.00,0.00,2160.00,NULL,NULL),(2,2,1500.00,3000.00,3,2,270.00,NULL,270.00,NULL,NULL),(3,2,1500.00,3000.00,3,1,75.00,0.00,75.00,NULL,NULL),(4,1,5450.00,5450.00,2,3,490.50,NULL,490.50,NULL,NULL),(5,1,12000.00,12000.00,5,3,1080.00,NULL,1080.00,NULL,NULL),(7,1,250.00,250.00,2,1,22.50,0.00,22.50,NULL,NULL),(8,2,12000.00,24000.00,1,4,2160.00,NULL,2160.00,'Steel','Nos'),(9,1,13250.00,13250.00,2,6,1192.50,NULL,1192.50,'Beautiful natural Logo with greenish color','Nos'),(11,2,1100.00,2200.00,2,7,198.00,0.00,198.00,'Beautiful natural Logo with greenish color',''),(12,2,1800.00,3600.00,9,7,0.00,0.00,0.00,'NAtural Beauty greenery covering video',''),(13,1,37000.00,37000.00,10,8,3330.00,NULL,3330.00,'',''),(14,1,35000.00,35000.00,11,8,875.00,NULL,875.00,'',''),(15,2,45000.00,90000.00,12,8,5400.00,NULL,5400.00,'',''),(16,2,12000.00,24000.00,1,11,2160.00,NULL,2160.00,'Steel',''),(17,1,5100.00,5100.00,15,11,127.50,NULL,127.50,'Motherboard compaint',''),(18,1,1500.00,1500.00,3,4,37.50,NULL,37.50,'',''),(19,1,12000.00,12000.00,1,12,1080.00,NULL,1080.00,'','Nos'),(20,1,1500.00,1500.00,3,12,37.50,NULL,37.50,'','unit'),(21,1,1800.00,1800.00,9,12,0.00,NULL,0.00,'',''),(22,1,20000.00,20000.00,13,13,NULL,3600.00,NULL,'gate','Nos'),(23,2,12000.00,24000.00,1,14,2160.00,0.00,2160.00,NULL,NULL),(24,1,500.00,500.00,15,14,12.50,0.00,12.50,NULL,NULL),(25,1,12000.00,12000.00,1,23,1080.00,NULL,1080.00,'',''),(26,1,300.00,300.00,7,23,27.00,NULL,27.00,'','');
/*!40000 ALTER TABLE `quotationitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terms_conditions`
--

DROP TABLE IF EXISTS `terms_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terms_conditions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` longtext,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_app_privacypolicy_client_id_517080f7_fk_client_data_id` (`client_id`),
  CONSTRAINT `lead_app_privacypolicy_client_id_517080f7_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terms_conditions`
--

LOCK TABLES `terms_conditions` WRITE;
/*!40000 ALTER TABLE `terms_conditions` DISABLE KEYS */;
INSERT INTO `terms_conditions` VALUES (1,'Last updated: January 27, 2026\r\n\r\nModern Roofing (\"we\", \"us\", or \"our\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your personal information when you visit our website [www.modernroofing.com], request a quote, use our services, or interact with us in any way.\r\n\r\nBy using our website or services, you agree to the collection and use of information in accordance with this policy.\r\n\r\n1. Information We Collect\r\n\r\nWe may collect the following types of information:\r\n\r\nA. Information You Provide Directly\r\n- Full name\r\n- Phone number\r\n- Email address\r\n- Postal address / property address\r\n- Details about your roofing project (e.g., type of roof, size, issues observed, photos you upload)\r\n- Payment information (handled securely through third-party processors – we do not store full card details)\r\n\r\nB. Information Collected Automatically\r\n- IP address\r\n- Browser type and version\r\n- Device information\r\n- Pages visited, time spent on pages, and referral sources\r\n- Cookies and similar tracking technologies\r\n\r\nC. Information from Site Interactions\r\n- Photos or measurements you upload when requesting an estimate\r\n- Communication history (chat messages, emails, call notes)\r\n\r\n2. How We Use Your Information\r\n\r\nWe use the collected information to:\r\n\r\n- Provide roofing consultation, estimates, inspections, and installation services\r\n- Respond to quote requests, schedule site visits, and communicate about your project\r\n- Process payments and send invoices\r\n- Improve our website, services, and customer experience\r\n- Send important service updates, appointment reminders, or follow-up messages\r\n- Detect and prevent fraud, abuse, or technical issues\r\n- Comply with legal obligations (e.g., contracts, warranties, tax requirements)\r\n\r\n3. How We Share Your Information\r\n\r\nWe do not sell your personal information. We may share your information only in these cases:\r\n\r\n- With trusted service providers (e.g., payment processors, cloud storage, CRM systems, marketing tools) who are bound by confidentiality\r\n- With subcontractors or partners involved in your specific roofing project (with your knowledge/consent where appropriate)\r\n- With insurance companies when processing warranty or insurance claims\r\n- When required by law, court order, or government authorities\r\n- In connection with a business transfer (merger, acquisition, or sale of assets)\r\n\r\n4. Data Storage & Security\r\n\r\n- Your information is stored on secure servers, primarily in [country/region – e.g., the United States or compliant cloud providers].\r\n- We use industry-standard security measures (encryption, access controls, etc.) to protect your data.\r\n- However, no method of electronic transmission or storage is completely secure.\r\n\r\n5. Your Rights\r\n\r\nYou may have the right to:\r\n\r\n- Access the personal information we hold about you\r\n- Request correction of inaccurate or incomplete data\r\n- Request deletion of your data (subject to legal and contractual retention obligations)\r\n- Opt-out of marketing communications\r\n- Withdraw consent where our processing is based on consent\r\n\r\nTo exercise these rights, please contact us using the information below.\r\n\r\n6. Data Retention\r\n\r\nWe keep your information only as long as necessary for the purposes described in this policy, or as required by law (typically 7 years for financial/tax records and warranty documentation). After this period, data is securely deleted or anonymized.\r\n\r\n7. Cookies & Tracking Technologies\r\n\r\nWe use cookies and similar technologies to enhance your experience, analyze site usage, and deliver personalized content. You can manage your cookie preferences through your browser settings. For more details, see our Cookie Policy [link if you have a separate page].\r\n\r\n8. Children\'s Privacy\r\n\r\nOur services are not directed to children under 18 years of age. We do not knowingly collect personal information from children.\r\n\r\n9. Changes to This Privacy Policy\r\n\r\nWe may update this Privacy Policy from time to time. The updated version will be posted on this page with a revised \"Last updated\" date. We recommend reviewing this page periodically.\r\n\r\n10. Contact Us\r\n\r\nIf you have any questions about this Privacy Policy or our data practices, please contact us:\r\n\r\nModern Roofing  \r\n45 Sullyruth Court  \r\nBunker Hill, WV 25413  \r\nUnited States  \r\n\r\nPhone: [your phone number]  \r\nEmail: info@modernroofing.com  \r\nWebsite: https://www.modernroofing.com\r\n\r\nThank you for choosing Modern Roofing.  \r\nWe value your trust and are committed to protecting your privacy.','2026-02-09 10:34:41.005289',4),(3,'Terms and Conditions\r\n This document is an electronic record in terms of Information Technology Act, 2000 and rules thereunder as applicable and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.\r\n Refund policy: Refunds will be credited to beneficiaries bank account within 5-7 days\r\n This document is published in accordance with the provisions of Rule 3 (1) of the Information Technology (Intermediaries guidelines) Rules, 2011 that require publishing the rules and regulations, privacy policy and Terms of Use for access or usage of domain name https://newtechmediasolution.com/ , including the related mobile site and mobile application (hereinafter referred to as \'Platform\').\r\n The Platform is owned by Abhinesh Mon, a company incorporated under the Companies Act, 1956 with its registered office Opposite Vision Honda,Cement Junction, Nattakom, Kottayam 686013).','2026-01-21 15:44:49.980993',9);
/*!40000 ALTER TABLE `terms_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'leads'
--

--
-- Dumping routines for database 'leads'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-11 16:27:00
