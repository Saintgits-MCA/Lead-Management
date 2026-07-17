-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 16, 2026 at 01:36 PM
-- Server version: 10.11.13-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myquotedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add Client', 7, 'add_client'),
(26, 'Can change Client', 7, 'change_client'),
(27, 'Can delete Client', 7, 'delete_client'),
(28, 'Can view Client', 7, 'view_client'),
(29, 'Can add employee', 8, 'add_employee'),
(30, 'Can change employee', 8, 'change_employee'),
(31, 'Can delete employee', 8, 'delete_employee'),
(32, 'Can view employee', 8, 'view_employee'),
(33, 'Can add Lead Source', 9, 'add_leadsource'),
(34, 'Can change Lead Source', 9, 'change_leadsource'),
(35, 'Can delete Lead Source', 9, 'delete_leadsource'),
(36, 'Can view Lead Source', 9, 'view_leadsource'),
(37, 'Can add Product', 10, 'add_product'),
(38, 'Can change Product', 10, 'change_product'),
(39, 'Can delete Product', 10, 'delete_product'),
(40, 'Can view Product', 10, 'view_product'),
(41, 'Can add lead', 11, 'add_lead'),
(42, 'Can change lead', 11, 'change_lead'),
(43, 'Can delete lead', 11, 'delete_lead'),
(44, 'Can view lead', 11, 'view_lead'),
(45, 'Can add Enquiry Category', 12, 'add_enquiryfor'),
(46, 'Can change Enquiry Category', 12, 'change_enquiryfor'),
(47, 'Can delete Enquiry Category', 12, 'delete_enquiryfor'),
(48, 'Can view Enquiry Category', 12, 'view_enquiryfor'),
(49, 'Can add quotation item', 13, 'add_quotationitem'),
(50, 'Can change quotation item', 13, 'change_quotationitem'),
(51, 'Can delete quotation item', 13, 'delete_quotationitem'),
(52, 'Can view quotation item', 13, 'view_quotationitem'),
(53, 'Can add quotation', 14, 'add_quotation'),
(54, 'Can change quotation', 14, 'change_quotation'),
(55, 'Can delete quotation', 14, 'delete_quotation'),
(56, 'Can view quotation', 14, 'view_quotation'),
(57, 'Can add follow up', 15, 'add_followup'),
(58, 'Can change follow up', 15, 'change_followup'),
(59, 'Can delete follow up', 15, 'delete_followup'),
(60, 'Can view follow up', 15, 'view_followup'),
(61, 'Can add follow up remark', 16, 'add_followupremark'),
(62, 'Can change follow up remark', 16, 'change_followupremark'),
(63, 'Can delete follow up remark', 16, 'delete_followupremark'),
(64, 'Can view follow up remark', 16, 'view_followupremark'),
(65, 'Can add document', 17, 'add_document'),
(66, 'Can change document', 17, 'change_document'),
(67, 'Can delete document', 17, 'delete_document'),
(68, 'Can view document', 17, 'view_document'),
(69, 'Can add privacy policy', 18, 'add_privacypolicy'),
(70, 'Can change privacy policy', 18, 'change_privacypolicy'),
(71, 'Can delete privacy policy', 18, 'delete_privacypolicy'),
(72, 'Can view privacy policy', 18, 'view_privacypolicy'),
(73, 'Can add terms_conditions', 18, 'add_terms_conditions'),
(74, 'Can change terms_conditions', 18, 'change_terms_conditions'),
(75, 'Can delete terms_conditions', 18, 'delete_terms_conditions'),
(76, 'Can view terms_conditions', 18, 'view_terms_conditions'),
(77, 'Can add company', 19, 'add_company'),
(78, 'Can change company', 19, 'change_company'),
(79, 'Can delete company', 19, 'delete_company'),
(80, 'Can view company', 19, 'view_company'),
(81, 'Can add leads', 11, 'add_leads'),
(82, 'Can change leads', 11, 'change_leads'),
(83, 'Can delete leads', 11, 'delete_leads'),
(84, 'Can view leads', 11, 'view_leads'),
(85, 'Can add client_data', 7, 'add_client_data'),
(86, 'Can change client_data', 7, 'change_client_data'),
(87, 'Can delete client_data', 7, 'delete_client_data'),
(88, 'Can view client_data', 7, 'view_client_data'),
(89, 'Can add leads_table', 11, 'add_leads_table'),
(90, 'Can change leads_table', 11, 'change_leads_table'),
(91, 'Can delete leads_table', 11, 'delete_leads_table'),
(92, 'Can view leads_table', 11, 'view_leads_table'),
(93, 'Can add followup_table', 15, 'add_followup_table'),
(94, 'Can change followup_table', 15, 'change_followup_table'),
(95, 'Can delete followup_table', 15, 'delete_followup_table'),
(96, 'Can view followup_table', 15, 'view_followup_table');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1000000$a1kIKwrYF4LLXqkGibg69X$6N0QPOdrjPl5JUhSwUygyW6vshWUTDNj4UdBC3/I6/o=', '2026-01-19 12:10:18.197209', 1, 'Prudhwi2002', '', '', 'prudhwiraj@gmail.com', 1, 1, '2026-01-19 12:09:17.055833');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_data`
--

CREATE TABLE `client_data` (
  `id` bigint(20) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `status` varchar(10) NOT NULL,
  `address` longtext DEFAULT NULL,
  `gst` varchar(50) DEFAULT NULL,
  `logo` varchar(500) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `header_image` varchar(100) DEFAULT NULL,
  `quotation_footer_image` varchar(100) DEFAULT NULL,
  `about` longtext DEFAULT NULL,
  `last_logout_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client_data`
--

INSERT INTO `client_data` (`id`, `username`, `password`, `client_name`, `business_name`, `phone_number`, `email`, `created_at`, `updated_at`, `status`, `address`, `gst`, `logo`, `website`, `header_image`, `quotation_footer_image`, `about`, `last_logout_at`) VALUES
(15, '7012733944', 'SAN3944@BT', 'Santhosh', 'Modern Roofing & Glazing', '7012733944', 'sales.tissertech@gmail.com', '2026-02-13 13:04:17.471075', '2026-02-13 14:23:25.303182', 'Active', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(16, '7012744933', 'REJ4933@UQ', 'Rejisha Abhinesh', 'New Tech Media Solution', '7012744933', 'sales.tissertech@gmail.com', '2026-02-13 14:18:55.589138', '2026-02-13 14:22:37.170207', 'Active', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(17, '9946971999', 'AIS1999@22', 'Aiswarya', 'Tisser Technologies', '9946971999', 'sales.tissertech@gmail.com', '2026-02-13 17:27:41.511196', '2026-05-30 20:42:22.703127', 'Suspended', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(18, '9495959809', 'SEE9809@JC', 'Seena', 'Tisser Technologies Pvt LLP', '9495959809', 'seenaajay9@gmail.com', '2026-02-16 10:54:18.027571', '2026-05-30 20:42:28.808954', 'Suspended', NULL, NULL, 'client_logos/9495959809/logo.jpg', NULL, '', '', 'None\r\n                ', NULL),
(19, '7902622237', 'REJ2237@K9', 'Rejisha ', 'New Tech Media Solution', '7902622237', 'dvrktm@gmail.com', '2026-02-16 15:30:51.403467', '2026-05-30 20:42:16.595931', 'Suspended', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(20, '8075102790', 'RUP2790@AT', 'Rupesh', 'Tisser Technologies', '8075102790', 'info@tissertechnologies.com', '2026-02-24 17:03:47.815726', '2026-05-30 20:41:59.665105', 'Suspended', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(21, '9495959880', 'TES9880@GZ', 'Testclient1', 'Business1', '9495959880', 'nmjkingslier@gmail.com', '2026-02-26 10:19:48.809150', '2026-02-26 14:46:39.038294', 'Active', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(22, '9744321991', 'SHI1991@TW', 'Shijo', 'Smart Systems', '9744321991', 'smartelvsystems@gmail.com', '2026-03-03 16:25:20.159215', '2026-05-30 20:41:50.740210', 'Suspended', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(23, '9895868636', 'JOS8636@GL', 'Josni', 'ABC', '9895868636', 'test77@gmail.com', '2026-04-10 15:18:12.277364', '2026-05-30 20:41:27.724209', 'Suspended', 'Test', '1234', NULL, NULL, '', '', NULL, NULL),
(24, '9048844711', 'TT@2026', 'Tisser Technologies', 'Tisser', '9048844711', 'info@tissertech.com', '2026-05-30 20:31:50.598388', '2026-05-30 20:31:50.598468', 'Active', NULL, NULL, NULL, NULL, '', '', NULL, NULL),
(25, '9562561332', 'SHI1332@FK', 'Shines Mathew', 'CARRON SANITARYWARES', '9562561332', 'carronsanitarywares@gmail.com', '2026-07-07 09:43:41.271498', '2026-07-07 09:43:41.271609', 'Active', NULL, NULL, 'client_logos/9562561332/logo.png', NULL, '', '', NULL, NULL),
(26, '9562766836', 'tester123', 'TEST', 'TEST', '9562766836', 'test@gmail.com', '2026-07-13 11:58:13.065243', '2026-07-16 17:05:51.300413', 'Active', 'Kottayam', 'GSTIN156728', 'client_logos/9562766836/logo.png', NULL, '', '', 'None\r\n                \r\n                \r\n                \r\n                \r\n                ', NULL),
(27, '9072605509', 'JOJ5509@6V', 'JOJIN', 'FORTUNO BUILD SOLUTIONS', '9072605509', 'fortunobuilds@gmail.com', '2026-07-16 11:21:42.180624', '2026-07-16 11:21:42.180673', 'Active', '1st Floor, KSM Building, Kolani-Vengaloor Bypass Thodupuzha, Idukki 685608', '32AGBPV7077P1ZO', 'client_logos/9072605509/logo.jpeg', NULL, '', '', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` bigint(20) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `username`, `password`) VALUES
(1, 'companyadmin', 'Admin@123');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(7, 'lead_app', 'client_data'),
(19, 'lead_app', 'company'),
(17, 'lead_app', 'document'),
(8, 'lead_app', 'employee'),
(12, 'lead_app', 'enquiryfor'),
(15, 'lead_app', 'followup_table'),
(16, 'lead_app', 'followupremark'),
(11, 'lead_app', 'leads_table'),
(9, 'lead_app', 'leadsource'),
(10, 'lead_app', 'product'),
(14, 'lead_app', 'quotation'),
(13, 'lead_app', 'quotationitem'),
(18, 'lead_app', 'terms_conditions'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-12-17 16:11:23.035137'),
(2, 'auth', '0001_initial', '2025-12-17 16:11:25.101801'),
(3, 'admin', '0001_initial', '2025-12-17 16:11:25.492251'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-12-17 16:11:25.507879'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-12-17 16:11:25.537175'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-12-17 16:11:25.841671'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-12-17 16:11:26.027841'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-12-17 16:11:26.080726'),
(9, 'auth', '0004_alter_user_username_opts', '2025-12-17 16:11:26.097271'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-12-17 16:11:26.269878'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-12-17 16:11:26.280822'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-12-17 16:11:26.303658'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-12-17 16:11:26.508130'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-12-17 16:11:26.679984'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-12-17 16:11:26.766668'),
(16, 'auth', '0011_update_proxy_permissions', '2025-12-17 16:11:26.809739'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-12-17 16:11:26.995776'),
(18, 'lead_app', '0001_initial', '2025-12-17 16:11:27.119103'),
(19, 'sessions', '0001_initial', '2025-12-17 16:11:27.233729'),
(20, 'lead_app', '0002_client_address_client_gst_client_logo_client_website', '2025-12-18 11:49:32.751470'),
(21, 'lead_app', '0003_employee', '2025-12-18 15:12:02.864412'),
(22, 'lead_app', '0004_employee_client', '2025-12-18 16:00:28.174067'),
(23, 'lead_app', '0004_alter_employee_options', '2025-12-18 16:12:11.905740'),
(24, 'lead_app', '0002_leadsource', '2025-12-19 09:43:53.727142'),
(25, 'lead_app', '0003_alter_leadsource_table', '2025-12-19 10:03:12.823088'),
(26, 'lead_app', '0004_product', '2025-12-19 11:04:41.934766'),
(27, 'lead_app', '0005_lead', '2025-12-19 12:52:49.588594'),
(28, 'lead_app', '0006_alter_lead_lead_source', '2025-12-19 12:57:30.570633'),
(29, 'lead_app', '0007_employee_password_alter_lead_updated_at', '2025-12-19 17:29:13.268978'),
(30, 'lead_app', '0008_leadsource_status_product_status', '2025-12-22 09:38:09.595104'),
(31, 'lead_app', '0009_alter_leadsource_name', '2025-12-22 10:17:18.410112'),
(32, 'lead_app', '0010_enquiryfor', '2025-12-22 15:58:44.942499'),
(33, 'lead_app', '0011_enquiryfor_status', '2025-12-22 16:00:17.274154'),
(34, 'lead_app', '0012_quotation_quotationitem', '2025-12-29 15:21:56.630870'),
(35, 'lead_app', '0013_quotation_valid_upto', '2025-12-29 17:09:56.392690'),
(36, 'lead_app', '0014_quotation_cgst_quotation_igst_quotation_sgst_and_more', '2025-12-29 17:32:08.977530'),
(37, 'lead_app', '0015_quotation_quotation_number_and_more', '2025-12-30 15:54:45.432614'),
(38, 'lead_app', '0016_quotation_version_alter_quotation_valid_upto', '2025-12-31 12:46:11.637710'),
(39, 'lead_app', '0017_followup_alter_quotation_valid_upto_followupremark', '2026-01-03 12:49:38.544017'),
(40, 'lead_app', '0018_alter_followupremark_created_at_and_more', '2026-01-05 09:48:40.166968'),
(41, 'lead_app', '0019_document_expiry_date_alter_followupremark_created_at_and_more', '2026-01-05 10:10:15.428389'),
(42, 'lead_app', '0020_alter_followupremark_created_at_and_more', '2026-01-05 10:10:15.467454'),
(43, 'lead_app', '0021_alter_followupremark_created_at_and_more', '2026-01-05 10:10:15.501356'),
(44, 'lead_app', '0022_alter_followupremark_created_at_and_more', '2026-01-05 10:10:15.534392'),
(45, 'lead_app', '0023_alter_followupremark_created_at_and_more', '2026-01-05 10:10:15.557925'),
(46, 'lead_app', '0024_client_header_image_client_quotation_footer_image', '2026-01-05 13:31:34.874270'),
(47, 'lead_app', '0025_alter_client_quotation_footer_image', '2026-01-05 14:16:37.492794'),
(48, 'lead_app', '0026_quotationitem_description_quotationitem_unit', '2026-01-14 15:15:32.615596'),
(49, 'lead_app', '0027_client_about', '2026-01-15 12:06:57.885619'),
(50, 'lead_app', '0028_privacypolicy', '2026-01-15 15:24:33.737887'),
(51, 'lead_app', '0029_remove_privacypolicy_updated_by', '2026-01-15 15:37:32.400265'),
(52, 'lead_app', '0030_rename_privacypolicy_terms_conditions', '2026-01-15 16:35:52.338994'),
(53, 'lead_app', '0031_alter_terms_conditions_options_and_more', '2026-01-16 11:24:09.990849'),
(54, 'lead_app', '0032_alter_document_table', '2026-01-19 12:59:59.852054'),
(55, 'lead_app', '0033_alter_document_table_alter_followup_table_and_more', '2026-01-19 13:16:45.901838'),
(56, 'lead_app', '0034_alter_client_table', '2026-01-19 13:18:41.463937'),
(57, 'lead_app', '0035_lead_staff', '2026-01-19 15:41:14.766883'),
(58, 'lead_app', '0036_quotation_staff', '2026-01-19 16:56:26.918903'),
(59, 'lead_app', '0037_product_hsn_code', '2026-01-21 17:00:55.839493'),
(60, 'lead_app', '0038_alter_followup_converted_time', '2026-01-22 15:01:54.149889'),
(61, 'lead_app', '0039_company', '2026-01-22 16:28:46.359670'),
(62, 'lead_app', '0040_alter_product_options_alter_employee_table_and_more', '2026-02-07 16:40:26.950879'),
(63, 'lead_app', '0041_rename_lead_leads_alter_leadsource_options', '2026-02-07 17:14:09.788888'),
(64, 'lead_app', '0042_rename_client_client_data_alter_client_data_options_and_more', '2026-02-09 09:31:48.642476'),
(65, 'lead_app', '0043_alter_employee_options_alter_employee_table', '2026-02-09 09:31:48.985155'),
(66, 'lead_app', '0044_rename_leads_leads_table_alter_leads_table_table', '2026-02-09 09:46:19.439245'),
(67, 'lead_app', '0045_rename_followup_followup_table_and_more', '2026-02-09 10:41:04.395551'),
(68, 'lead_app', '0002_alter_enquiryfor_name', '2026-02-26 17:39:04.085891'),
(69, 'lead_app', '0003_quotationitem_spec', '2026-03-30 17:32:57.935893'),
(70, 'lead_app', '0004_client_data_last_logout_at', '2026-04-01 17:43:18.583998');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('03sku9cm40cim1gimajcon43d7d94jyg', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wSZS9:9xXyNKG86Tr0BrIMW2_i8wF_wBZwvPTQMaLd5xNoRxo', '2026-06-11 17:33:09.825858'),
('0tfzhp33hvwoxbhnm34wvsit79cdqk7z', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpSC4_tyAxrxLd6FoAJbonbg:1vbWIH:dnf0eaHNY7P6-PlQLXNMhrD0enSTRnYbPkSJPIfpLd8', '2026-01-16 09:27:41.627345'),
('12nd3f3zdgf12i1o57ksc8b5fjvwuv4m', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vlheL:4_F6hbcj46Cx-ZmQWhrVPVRh4yPC4GKHRLk5NZDpxVo', '2026-02-13 11:36:33.198860'),
('4g205lsjjpjfy67ar7en85as42imoftm', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wkKNy:NrsbLG-PeoU2r_vudPJza-Rf5Rz8yutzklDOuEkz7cc', '2026-07-30 17:06:14.594931'),
('4z80q12ixcj6mfpc1tvk5yj54f7fteq7', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAzn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAcnAnQA:1vq9LG:a84y-xwmTP4mveUhugPoJFuOyb2q-pb39XAeMHwOZ9g', '2026-02-25 17:59:14.363262'),
('5dxjxtsgv0y6sokhux9hcud7wc14slnm', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlAuflJeamKlkpBefnlSo4OinBxQsy8vNAEhbmlqbmFhaWxqZAudTcgpz8ytRUTLPhMiDTDZH4KOYrOCEbkpuflJmDZkctAOrGSKY:1vkd1Y:RVnQ1J2w1Rzh_1sAmiT3KqkR5M1Iqcfss4eaQJI_n7M', '2026-02-10 12:28:04.548588'),
('60dejfh37fmi9iiufsqz6cch9xtlx647', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wkJXH:b_XsM4WlU6W6Vq9m8Ek8N9coyecjqWSw9ehM7By1_BY', '2026-07-30 16:11:47.093124'),
('6yahofr6sxsb5mnf38dwyj8nb1k6czd9', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vbxyS:j-K1CFykZmb6HV4og5uog7SDlYg49Iz7wqu1g_Ndbec', '2026-01-17 15:01:04.989413'),
('7r4bjvnu8icr0r3jz6qtv65zkfzj4iy9', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpSC4_tyAxrxLd6FoAJbonbg:1vaQub:K2kQaWMHcBCWi9WhEWHNpJPuXR2M7XDHLUq16JlkrLQ', '2026-01-13 09:30:45.315679'),
('7v9zwyq2g6e3ynb1bpianq4hgw0g9l8z', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzS3Iya9MTcUjk5miZGVojCSQl5ibqmSl5JiXVaqEJJybn5SZA5KwNLE0BUILA0ulWgDyHyrE:1wFmWZ:ofXzQkbqNIN67LGljhay7TKG1J_njKtegxgX95uEXpk', '2026-05-07 10:52:51.683095'),
('7vd6o1a5bz3asdvylu5agq7ubc4hd7tv', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wTLB0:_VpdSBCk9wdL4f5MqfAlyMBBw18EYZEEVxIjiMMmhrY', '2026-06-13 20:30:38.615473'),
('7vjjf6kms1hvfs3p9ilr7m2tcznz9gjb', '.eJx1jc0KQEAUhV9FZ20jZMyOV_AA8nNjaubeSSwk7y4lkSzPOZ3v29CJ8w2vtZVhoL42DD1PC4XorCGef3s_ChM0VJanmVJ5nCIEOW9lJfq-7sX00NEjc-NOTCW8BEVQPiFOWmM_jst_cpI7vSgl9gPruEim:1vkbnR:hi91eLZxjoqPNpwh5SuYajIVrTnn0EHSHhdcc9m8ddM', '2026-02-10 11:09:25.193127'),
('80oe2rvar0l8e3tjepl62zx24ihcicd0', '.eJxljUEOQDAQRa8is7YRRHXHFRxA0AlN2plGWIi4OxaaYvnfS97fYTAaaWkNjyOqVhPIZV4xfrhWIDO_qLMIEhqmNapq8NxNTLcQRZkXQpRpfjm0zvCG-G97c9eTYL_6UR1GLPfa_D4Gtq6j7XtxnAifSKY:1vlmDz:_ilYZKJmwX_iL9mbIfLrMs1P4KGB0EuIYGZfg79EXvc', '2026-02-13 16:29:39.712137'),
('8ltsnnluszdgotf5nbf4kg4f8b2vnkt3', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYkXZOTnpSpZKVmYW5qaW1hYGpsq6Sil5hbk5FempmLqgstkpihZGSLx8xJzQcYE5-eVKjgqOCEbkpuflJkDscPUzNjE0MjIRAluP8gcEzgPxRSQIcn5uQWJeZXoDqkFAAI9SIs:1vd2kZ:VpZDKiiIi9YYny-qh788GphAYO7OsGWEsF2Br3azy5E', '2026-01-20 14:19:11.929496'),
('9fo0youinwzcyo39kuzpl4cky8l2bhsp', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlZA7n5iXmpipZKXn5e3n6KcFFCzLy80DClgbmRmYGpqYGlkq1AGQpJrs:1wkIKg:4_Gv6G8tnhDnmRwD2Twykm_ukXHWwLJk2c5Fu7ajDYE', '2026-07-30 14:54:42.893674'),
('9hfgivtbt1dmq0lua37jk19gm95ya8y3', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpUC41tyAnvzI1FdNsuAzIdEMkPor5Ck7IhuTmJ2XmoNlRCwBmuT8-:1vkydF:d8TAT4Gv1IrfogWLOQURJhm_KkGq54d6wZLjd_hWo_0', '2026-02-11 11:32:25.840465'),
('9rl2skg49hw0edrryqc4msufy0rewbw4', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlAuflJeamKlkpBefnlSo4OinBxQsy8vNAEhbmlqbmFhaWxqZKtQCZuSdu:1vanu8:qjdSPrUo6kHt-snQhEnTQGQN1UIxYDg__a-LvoyyoYU', '2026-01-14 10:03:48.740848'),
('9sx6oqbqfytac8y60u2ie0s3sptyiorb', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1voFX6:PI9JpmLYY_VfY-zufzs0tHIonmE-7gAQnTY0qfi4M_A', '2026-02-20 12:11:36.752238'),
('9tz0duqt9jy2w36c2h31kic1xtz1mix1', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYkXZOTnpSpZKVmYW5qaW1hYGpsq6Sil5hbk5FempmLqgstkpihZGSLx8xJzQcYE5-eVKjgqOCEbkpuflJkDscPUzNjE0MjIRAluP8gcEzgPxRSQIcn5uQWJeZXoDqkFAAI9SIs:1vi4YA:TbWRFkUhei2FGg-pVv3AR48sYXRWwjM4iuhMjuWLMlw', '2026-02-03 11:15:10.096968'),
('a613804p0liag5zn84gnfkpec5fddrwz', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAHn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAc3QnRQ:1wBQDk:HXsMOMe1DS1RJozqdKcQt9S8TSGpiOHVUQXxVT4T6bY', '2026-04-25 10:15:24.344880'),
('acam76fa8cvrvlufux5bnm9ck1vopoca', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vhhjg:jl5lUhM9PkgHF4RpEXhyfj2T7IcgNCOLkB8RJAhv87c', '2026-02-02 10:53:32.184460'),
('b7ty94lkcqj71q985iuq0rfz5vvfdlfg', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vllWv:SQ2_hsZJhkq7pHuEAE5UyIb_0VD5xAgORBsalySylXQ', '2026-02-13 15:45:09.268750'),
('b88smhj6lu5sfbj53nzfgv5b7ih052u0', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGRnDuXmJualKVkpe-cV5mUpw0YKM_DyQsKWFpamFmYWZsZlSLQCnyh3x:1wSWPI:SEbyzRW-rlln1ikhiTQ6_So6q9LIbqHDIggTyV2T1b0', '2026-06-11 14:18:00.190033'),
('c78qzu6t1s7279918vvomf6oe7lgm1gb', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGZrDuXmJualKVkqOmcXliUWViUpwiYKM_DyQjKWliZmluaGlpaVSLQAP1B82:1vsK49:ADOiHaTCEmwAfRRDpGx2Ap1hpLmRrSc5lseLd9xcda0', '2026-03-03 17:50:33.461732'),
('ct4r9z2ovh3scaup6qherxrig7gwyc19', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vgGiF:pV5KZeewMu0b4er5TUzfCLrN_4gfM3k2EynBUH-cKn4', '2026-01-29 11:50:07.778972'),
('do6a8kjl3yuxo7d7b8ipgizmqqrvvwcq', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpUC41tyAnvzI1FdNsuAzIdEMkPor5Ck7IhuTmJ2XmoNlRCwBmuT8-:1voESk:dFp0rJYn65ImerwSh2z8FocXX8bmCmUMk-pdhvte_hQ', '2026-02-20 11:03:02.882800'),
('en4fkei8kim13n1e5kqz4dst0k9cjqdj', '.eJyrVkrNLcjJr0xNjc_JT09PTYnPzFOyKikqTdVByGSmKFkZIvHzEnNTlayUgvPzShUcFZyUkKRy85Myc0CSFuaWpuYWFpbGpkDp5JzM1LwSsDkmcB6KKU4IVRjugIoXZOTnoZlcCwB8VT8-:1vlJFl:zvnr8lPs9NMT7Fmfj_pYUPgEmLmmuTm2cyl5FuY37a8', '2026-02-12 09:33:33.346841'),
('f3bb9xr6avltcgjcyn7ieel3q0w9mc7t', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1vpjwL:Sc0Lin2Hdxx_pe7fZLpd6HpRUjeyhCRhIm1OkPLpdhM', '2026-02-24 14:51:49.613765'),
('fgf1neoc64qrnnnb65h3lcodknhwpvtl', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGZrDuXmJualKVkqOmcXliUWViUpwiYKM_DyQjKWliZmluaGlpaVSLQAP1B82:1wSXty:OtowYgnE2vxjwdrJSx8u9hAw_alL-bgMSqOPqOdhjCo', '2026-06-11 15:53:46.047958'),
('g4vcp6o5srpqgyq4ox4726d6u5wa3ozi', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGRnAuXmJualKVkpBpQWpxRlKcOGCjPw8kLiFgbmpoYGRuaWBUi0AybseRQ:1vuqjG:C6RJoqdPhAcUloioF1F1060X9eTqJAVYF-Yx4MhfOAY', '2026-03-10 17:07:26.404189'),
('gcc19qc133n10fgxo14j8noakmx2bmg2', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vftNA:eAo3ivwxqFrQm30EVMX-EiaBlk4fTPNqvl0QKNysvns', '2026-01-28 10:54:48.481396'),
('heb9puv983xx6ge13uquouvrgsy7tg9k', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vcbvh:eXOJqEPz_lX2yb7nAMB8v_fX28psGMp7oxrulB39EzA', '2026-01-19 09:40:53.670440'),
('hyytun76ogcw6mzmkhdvzbn0f64u74mo', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKV6QkZ-XqmSlZGlqZmRuZmZhbKZUCwB8uBsl:1wjuQy:7N1vy6FZrC6ImbVYLBe7_Bc2FNnYa9_8JEC9diSTQQs', '2026-07-29 13:23:36.669595'),
('i8b15q4ew5ekwxft19q793mu0m79bahu', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vgF1P:FZoWQI_T-4hugQ5zP3OxcFKH2lW0lt9SwHhudKziGCw', '2026-01-29 10:01:47.275006'),
('j04gmp2ks62vjj2p0koc3qu0wy2uyt2s', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAHn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAc3QnRQ:1vuONQ:hZZ99Ke-UTVFWVrI12csk4RktvAvzFuhx5bvuzzOqL4', '2026-03-09 10:51:00.532883'),
('j7jh0nw1ctfjhiqn192j5by3gtczegm6', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpUC41tyAnvzI1FdNsuAzIdEMkPor5Ck7IhuTmJ2XmQOwwNTM2MTQyMlGqBQBmCj8j:1vdRSv:6z8uvizH94UU_QeI_K7d4x_G3IO_Owu5Ne0LvL6Fjlg', '2026-01-21 16:42:37.010486'),
('kfmsaneiz0rhvvfon8e7c5hy2oj8hq9b', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1vsxUw:AcJcXJbRm_0qGHSuipygjrEfZLWgoTm4mMyMYy_Vl4I', '2026-03-05 11:56:50.559286'),
('ksg8lmzgs6rxw1tj6x6ioej5mkaffu3l', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vcxiS:nfQKPP0QTwRtCzHMdRnwvWJ8lxcyokU5ot49MAK9pAY', '2026-01-20 08:56:40.950213'),
('l33crbnj5vz4qxch5zr8kcpa829hhb86', '.eJx1jUEKwjAQRe8yazcBmXSy8wCeoYztUAeSSagtEsS7q0VCQVz-9-D9Bww5FbbaxzxNMvZqEJZ5lQMMUcWWv1xHCM63aZwEApz0due5MjRRrtk-huiI5B0RvZ2kEnMV-a03s_XdDnwfzmzrvpDyReN20FGHHhE9PF_pZ0kz:1wG8Z8:4WqX0tJVp8s8eMX3NrK4s9MxeE9Gjb8OxIwfnP-_4g8', '2026-05-08 10:24:58.288073'),
('mj7p1lbamfumlkp222g4gze96azu4y7j', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbGpUi0AwnkeBg:1vfv92:93c_wszdu_8ByAHEzpm-xRq6l3jsEPa4qsZTnHGcISo', '2026-01-28 12:48:20.720606'),
('npa1aysxp7nn73xafk0bd7yqgst9we6s', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGVrCuXmJualKVkpBqVmZxRmJCkpwiYKM_DyQjLmlgZGZkZGRsblSLQAEZx69:1vrvSl:6_ERa26J5wrsLvfJJbUmBIQIX7cT35MtwEYwI_KeP80', '2026-03-02 15:34:19.215768'),
('q59atqt2l35quy7eze8vdpcv0vn5ld81', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpSC4_tyAxrxLd6FoAJbonbg:1vbYbu:6EhTbiMiPJFl6pFvbmDmR-K453Mybsn3e2ANGq6MZrQ', '2026-01-16 11:56:06.769022'),
('r8m8vyumcr3y8lcqfw4dp40q3nnze6d5', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlAuflJeamKlkpBefnlSo4OinBxQsy8vNAEhbmlqbmFhaWxqZKtQCZuSdu:1vXuQD:-exv2OVs_9BMjTM1u-yn9jca-kd7aQD6qis1-y4VgHQ', '2026-01-06 10:24:57.064152'),
('rbph3fg9p4vaalmqi8modm3drndxe95v', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wQNM8:eYgKHoo5bfFGznABoMI2e-OAfehdI8wc8Xd-5Foahqg', '2026-06-05 16:13:52.344878'),
('rc8abymhicnvpqgy888tqxwq9621qgme', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpSC4_tyAxrxLd6FoAJbonbg:1vXxbe:WB9hhIYFwAWMVw44Yja7R-u6qEAoe2zwnWg0HzhrC0g', '2026-01-06 13:48:58.886288'),
('s4iwmlh6a8on910hvp7rbfzw147yz4rv', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1w2T1l:8MiY3G3Scc35DNm5X2MAst7Ynpqo_FVDMGMevkPaG24', '2026-03-31 17:26:01.292910'),
('s4qku0j4h3ehv9oy1tiiy1ucl0uqmei3', 'e30:1ve4eK:Xhpu56giPr9nlr-k92YnrYnVEwMxioqzO5eiI0M37_k', '2026-01-23 10:33:00.420055'),
('s67nzlg3izrgl15cfcwu35q6wocx1nut', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1vqlyK:upx_UB3rttqa9z2AIb-D2gHufN09MHFVJdLFr75VsTY', '2026-02-27 11:14:08.621071'),
('sg3qeuqhzwcfnu3n3s3nyis9r20epc2t', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlAuflJeamKlkpBefnlSo4OinBxQsy8vNAEhbmlqbmFhaWxqZAudTcgpz8ytRUTLPhMiDTDZH4KOYrOCEbkpuflJmDZkctAOrGSKY:1vm2A4:NMJjcDqReL2KeYcRn1Pptp68oYzdX43BW45dhPDj2zQ', '2026-02-14 09:30:40.424081'),
('sofd88n2saqro6pq7t9sl620pf17xwiu', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1vd5oG:LnincBKk7AlH9fcvBS9IyQaXQk93JJJOONbdNHz_uKQ', '2026-01-20 17:35:12.587328'),
('suvz2yq9v7ua47fx1edpxfz3rl9wt5ec', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAHn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAc3QnRQ:1wFmlf:51dlOxH3ICj_8CeBCKnDFmOPTmL6mDiFjMmG7l5GmcY', '2026-05-07 11:08:27.688161'),
('t22ej9rpfyt1hqm4byqw1ohgqy5gaj9y', '.eJyrVkrNLcjJr0xNjc_JT09PTYnPzFOyKikqTdVByGSmKFkZIvHzEnNTlayUgvPzShUcFZyUkKRy85Myc0CSFuaWpuYWFpbGpkDp5JzM1LwSsDkmcB6KKU4IVRjugIoXZOTnYZqcn1uQmFeJrqkWAB47SKY:1vpLNN:SvxNGXlGgY8H1t_0mFZyNfw7vLQbbv5Al9wZV0eTxJA', '2026-02-23 12:38:05.793205'),
('tex1obcs6j190f8ee2r8gquxsuoof5ju', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYkXZOTnpSpZKVmYW5qaW1hYGpsq6Sil5hbk5FempmLqgstkpihZGSLx8xJzQcYE5-eVKjgqOCEbkpuflJkDscPUzNjE0MjIRAluP8gcEzgPxRQnpVoAYvo_Iw:1vgxNN:0IYoPcDUnEQjThjqYqXf26n2VaqbfVSMsd5O2Fu5z9Q', '2026-01-31 09:23:25.031543'),
('ugw3xkyhac5xn29a703ea4y7hsmqmmfc', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZmcB5eYm5qUpWSsH5eaUKjk5KcPGCjPw8kISFuaWpuYWFpbEpUC41tyAnvzI1FdNsuAzIdEMkPor5Ck7IhuTmJ2XmQOwwNTM2MTQyMlGqBQBmCj8j:1vh3cY:V2LBVdP-Wt9FIBqwXGgwMa_h262XqlEJfsNI1otMsRw', '2026-01-31 16:03:30.807073'),
('y55dxsghjj7wcr6molbsiphr4n4o6hxv', 'e30:1vqQBX:xsS3fRcfxhPnmCMVrz-izbttxFdcBW3l09crO7Cm-Lw', '2026-02-26 11:58:19.282126'),
('y8o5to63ia8oky3jgwn6ywthvibqbmb9', 'eyJjb21wYW55X2xvZ2dlZF9pbiI6dHJ1ZX0:1wHF2H:Pz00-Owck_o0_cVjSxBAeJzl-nn4ZU_4kyEEeNUp-vI', '2026-05-11 11:31:37.874213'),
('ytz6so4k7baejoqpx2t0jhmbclo2qk65', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAHn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAc3QnRQ:1vsxoD:SavEAgKvmyaz80SHrxASi_3wMv53M9bY_AJRL24MK40', '2026-03-05 12:16:45.339895'),
('yv0hulrn2crnz034p4di9nkrotj06tus', '.eJyrVkrOyUzNK4nPyU9PT02Jz8xTsiopKk3VgYlnpihZGRnBuXmJualKVkrBGZlZ-Upw0YKM_DyQsKW5iYmxkaGlpaFSLQCmNx3X:1vxNir:NWh8-aFunVfTfjXyy2TDYAovRi-Qu8xqX1ovRQEsiWY', '2026-03-17 16:45:29.323242'),
('zqiy9lad040zcslsbxlkkpnxqjqmm68x', '.eJyrVkrOzy1IzKuMz8lPT09Nic_MU7IqKSpN1VFKzslMzSvBKZ6ZomRlaAHn5iXmpipZKQWnpuYlKsFFCzLy80DCliaWpkBoYWCpVAsAc3QnRQ:1w0XmC:ZRziiR53zsPXeNKFNtjePdirHfS2Abg8aIsj91Sl_Mg', '2026-03-26 10:06:00.160425');

-- --------------------------------------------------------

--
-- Table structure for table `document`
--

CREATE TABLE `document` (
  `id` bigint(20) NOT NULL,
  `document_id` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `type` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `document`
--

INSERT INTO `document` (`id`, `document_id`, `title`, `description`, `type`, `created_at`, `client_id`, `expiry_date`) VALUES
(12, 'LIC349773829', 'Pan Card', '', '', '2026-02-23 10:00:34.854056', 18, '2026-02-26'),
(13, 'LICENSE', 'driving', '', 'license', '2026-03-03 11:29:38.497628', 18, '2026-03-08'),
(14, 'DOC-2345', 'Aadhar Card', 'tester', 'Aadhar Card', '2026-04-06 09:45:59.909581', 18, '2035-04-06'),
(15, 'HVHVH', 'Ghvhvv', 'hv Hvhvh', 'B hvhv', '2026-04-25 17:05:14.954028', 18, '2026-04-16');

-- --------------------------------------------------------

--
-- Table structure for table `enquiryfor`
--

CREATE TABLE `enquiryfor` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enquiryfor`
--

INSERT INTO `enquiryfor` (`id`, `name`, `created_at`, `updated_at`, `client_id`, `status`) VALUES
(13, 'Logo', '2026-02-13 17:37:22.202140', '2026-02-16 11:30:33.297488', 17, 'Inactive'),
(14, 'Website', '2026-02-13 17:37:39.254210', '2026-02-16 11:30:40.218242', 17, 'Inactive'),
(15, 'Digital marketing', '2026-02-13 17:37:54.361709', '2026-02-13 17:37:54.361750', 17, 'Active'),
(23, 'Application', '2026-02-16 10:58:20.448670', '2026-02-16 11:04:59.849403', 18, 'Active'),
(47, 'Logo', '2026-02-16 11:19:44.844640', '2026-02-26 17:40:44.668977', 18, 'Active'),
(48, 'Website', '2026-02-16 11:20:19.398494', '2026-02-26 17:40:23.490980', 18, 'Active'),
(49, 'Referral', '2026-02-16 11:27:19.670994', '2026-02-26 13:46:47.751612', 18, 'Active'),
(50, 'Cantilever Accessories', '2026-02-16 16:39:26.293624', '2026-02-16 16:39:26.293690', 19, 'Active'),
(59, 'Website Application', '2026-02-26 11:21:53.928854', '2026-02-26 11:21:53.928902', 21, 'Active'),
(73, 'Referrals', '2026-02-26 17:49:30.738581', '2026-02-26 17:49:36.448500', 17, 'Active'),
(74, 'DOOR & WINDOWS', '2026-05-28 14:33:02.010891', '2026-05-28 14:33:02.010956', 23, 'Active'),
(75, 'Website', '2026-05-30 20:37:13.837587', '2026-05-30 20:37:13.837644', 24, 'Active'),
(76, 'Nexgen', '2026-05-30 20:37:19.803510', '2026-05-30 20:37:19.803575', 24, 'Active'),
(77, 'Dm', '2026-05-30 20:37:38.683168', '2026-05-30 20:37:38.683226', 24, 'Active'),
(78, 'Branding', '2026-05-30 20:37:43.811174', '2026-05-30 20:37:43.811226', 24, 'Active'),
(79, 'Website Redesign', '2026-05-30 20:37:54.358614', '2026-05-30 20:37:54.358657', 24, 'Active'),
(80, 'Crm', '2026-05-30 20:37:59.060423', '2026-05-30 20:37:59.060468', 24, 'Active'),
(81, 'Whatsapp Api', '2026-05-30 20:38:06.141592', '2026-05-30 20:38:06.141676', 24, 'Active'),
(82, 'Email Service', '2026-05-30 20:38:28.761966', '2026-05-30 20:38:28.762016', 24, 'Active'),
(83, 'Mobile App', '2026-05-30 20:38:41.971771', '2026-05-30 20:38:41.971862', 24, 'Active'),
(84, 'Loan', '2026-07-13 15:49:23.551941', '2026-07-13 15:49:23.552010', 26, 'Active'),
(85, 'Door&Window', '2026-07-16 11:23:44.110900', '2026-07-16 11:23:44.110939', 27, 'Active'),
(86, 'Window', '2026-07-16 11:23:51.460240', '2026-07-16 11:23:51.460274', 27, 'Active'),
(87, 'Door', '2026-07-16 11:23:58.864741', '2026-07-16 11:23:58.864775', 27, 'Active'),
(88, 'Logo', '2026-07-16 11:24:06.241199', '2026-07-16 11:24:06.241237', 27, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `followupremark`
--

CREATE TABLE `followupremark` (
  `id` bigint(20) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `remark_date` date NOT NULL,
  `remark_text` varchar(500) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `followup_id_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `followupremark`
--

INSERT INTO `followupremark` (`id`, `lead_id`, `client_id`, `remark_date`, `remark_text`, `created_at`, `followup_id_id`) VALUES
(12, 22, 17, '2026-02-13', 'add something', '2026-02-13 17:49:35.909281', 7),
(13, 22, 17, '2026-02-16', 'ggh', '2026-02-16 15:16:08.673818', 7),
(14, 22, 17, '2026-02-16', 'test', '2026-02-16 17:35:52.681756', 7),
(15, 22, 17, '2026-02-16', 'test', '2026-02-16 17:39:49.359939', 7),
(16, 22, 17, '2026-02-17', 'hh', '2026-02-17 10:38:47.815841', 7),
(17, 24, 18, '2026-03-30', 'ZCxCaxc', '2026-03-30 10:34:30.183750', 8),
(18, 24, 18, '2026-03-31', 'ewedwd', '2026-03-31 12:27:04.982865', 8),
(19, 24, 18, '2026-04-27', 'csa', '2026-04-27 10:55:55.771494', 8),
(20, 24, 18, '2026-04-27', 'cx', '2026-04-27 11:10:32.089863', 8);

-- --------------------------------------------------------

--
-- Table structure for table `followup_table`
--

CREATE TABLE `followup_table` (
  `id` bigint(20) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `next_followup_date` date DEFAULT NULL,
  `next_followup_time` time(6) DEFAULT NULL,
  `converted_time` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `followup_table`
--

INSERT INTO `followup_table` (`id`, `lead_id`, `client_id`, `status`, `next_followup_date`, `next_followup_time`, `converted_time`, `created_at`) VALUES
(7, 22, 17, 'Converted', '2026-02-16', '17:41:00.000000', '2026-02-17 10:38:47.812580', '2026-02-13 17:49:35.905188'),
(8, 24, 18, 'Follow-up', '2026-03-21', '14:08:00.000000', '2026-04-27 10:55:55.762186', '2026-03-30 10:34:30.180041');

-- --------------------------------------------------------

--
-- Table structure for table `leadsource`
--

CREATE TABLE `leadsource` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leadsource`
--

INSERT INTO `leadsource` (`id`, `name`, `created_at`, `client_id`, `status`) VALUES
(31, 'Website', '2026-02-13 17:36:09.660818', 17, 'Active'),
(32, 'Reference', '2026-02-13 17:36:21.052275', 17, 'Active'),
(33, 'Google', '2026-02-13 17:36:51.499216', 17, 'Active'),
(34, 'Google', '2026-02-16 10:56:47.514722', 18, 'Active'),
(35, 'Website', '2026-02-16 11:02:42.532152', 18, 'Active'),
(36, 'Advertisement', '2026-02-16 11:26:36.893823', 18, 'Active'),
(37, 'BNI', '2026-02-16 11:29:06.701610', 18, 'Active'),
(38, 'Logo', '2026-02-26 11:12:16.313255', 21, 'Inactive'),
(39, 'FACE BOOK', '2026-05-28 14:33:27.283043', 23, 'Active'),
(40, 'Google', '2026-07-13 15:49:07.459439', 26, 'Active'),
(41, 'Direct shop', '2026-07-16 11:23:13.903168', 27, 'Active'),
(42, 'Advertisment', '2026-07-16 11:23:22.099452', 27, 'Active'),
(43, 'Website', '2026-07-16 11:23:30.360965', 27, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `leads_table`
--

CREATE TABLE `leads_table` (
  `id` bigint(20) NOT NULL,
  `customer_name` varchar(150) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `product_category` varchar(100) NOT NULL,
  `lead_source_id` bigint(20) NOT NULL,
  `requirement_details` longtext DEFAULT NULL,
  `next_followup_date` date DEFAULT NULL,
  `followup_time` time(6) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `remarks` longtext DEFAULT NULL,
  `assign_to` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `deleted_at` datetime(6) DEFAULT NULL,
  `client_id` bigint(20) NOT NULL,
  `staff_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leads_table`
--

INSERT INTO `leads_table` (`id`, `customer_name`, `phone`, `email`, `address`, `location`, `product_category`, `lead_source_id`, `requirement_details`, `next_followup_date`, `followup_time`, `status`, `remarks`, `assign_to`, `created_at`, `updated_at`, `deleted_at`, `client_id`, `staff_id`) VALUES
(22, 'Arun', '9992345245', 'test@gmail.com', 'af', 'Kottayam', 'Website', 32, 'test', '2026-02-16', '17:41:00.000000', 'Converted', 'as', NULL, '2026-02-13 17:39:28.706150', '2026-02-17 10:38:47.817391', NULL, 17, NULL),
(23, 'seena', '9495959809', NULL, NULL, NULL, 'Logo', 31, NULL, NULL, NULL, 'Quoted', NULL, NULL, '2026-02-16 10:40:12.088362', '2026-02-17 10:36:46.947015', NULL, 17, NULL),
(24, 'Nikhita', '9495959990', NULL, 'kottayam\r\n', NULL, 'Application', 34, NULL, '2026-03-21', '14:08:00.000000', 'Follow-up', NULL, NULL, '2026-02-16 11:09:48.640489', '2026-04-27 11:10:32.090962', NULL, 18, NULL),
(25, 'Arun', '9447742399', 'test121@gmail.com', 'fghj', 'Kottayam', 'Digital marketing', 31, 'test', '2026-02-18', '17:13:00.000000', 'Quoted', 'gg', NULL, '2026-02-16 15:12:24.169643', '2026-02-16 15:14:52.664773', NULL, 17, NULL),
(26, 'Arunima', '7902622299', 'Abc@gmail.com', 'trtgh', 'Kottayam', 'Digital marketing', 32, 'wdfgh', '2026-02-26', '18:05:00.000000', 'Quoted', NULL, NULL, '2026-02-18 16:04:33.878679', '2026-02-18 16:05:04.946094', NULL, 17, NULL),
(27, 'amal', '7902628238', 'Abc@gmail.com', 'drfgh', 'Kottayam', 'Digital marketing', 33, 'dgfg', '2026-03-06', '16:21:00.000000', 'Quoted', 'h', NULL, '2026-02-18 16:19:17.984270', '2026-02-18 16:19:46.053280', NULL, 17, NULL),
(28, 'test', '9449742365', 'test121@gmail.com', 'sdfg', 'Kottayam', 'Digital marketing', 32, 'test', '2026-02-25', '11:40:00.000000', 'Quoted', 'gg', NULL, '2026-02-20 11:38:46.324714', '2026-02-20 11:39:24.089273', NULL, 17, NULL),
(29, 'roy', '7012733949', NULL, 'bb', 'Kottayam', 'Digital marketing', 31, 'dose', '2026-03-05', '11:46:00.000000', 'Quoted', 'yh', NULL, '2026-02-20 11:45:23.344607', '2026-02-26 16:40:18.002209', NULL, 17, NULL),
(30, 'Sonu', '9647859609', NULL, NULL, NULL, 'Application', 34, NULL, NULL, NULL, 'Quoted', NULL, NULL, '2026-02-23 09:55:32.528767', '2026-03-31 11:26:45.824823', NULL, 18, NULL),
(31, 'Arun', '9447711365', 'test77@gmail.com', 'test', 'Kottayam', 'Digital marketing', 33, 'fhffggh', '2026-02-28', '10:04:00.000000', 'Converted', 'er', NULL, '2026-02-26 10:04:12.459552', '2026-02-26 10:07:57.733141', NULL, 17, NULL),
(32, 'Saju D', '7846473822', 'tecknohow.132@gmail.com', NULL, 'Ernakulam', 'Digital marketing', 31, NULL, '2026-03-13', '07:23:00.000000', 'Quoted', NULL, NULL, '2026-02-26 10:23:38.729222', '2026-03-31 10:41:55.076929', NULL, 17, NULL),
(33, 'nikhita', '9495959809', 'gknair3002@gmail.com', NULL, 'kottayam', 'Logo', 34, NULL, NULL, NULL, 'Quoted', NULL, 'Anju', '2026-03-03 11:26:25.828467', '2026-03-30 17:38:57.350124', NULL, 18, NULL),
(34, 'test', '7907622238', 'test77@gmail.com', 'fghj', 'Kottayam', 'Digital marketing', 31, 'rtf', '2026-03-06', '15:59:00.000000', 'Quoted', NULL, NULL, '2026-03-03 15:59:19.001483', '2026-03-03 15:59:56.090237', NULL, 17, NULL),
(35, 'Arun', '7902162238', 'Abc@gmail.com', 'zxx', 'Kottayam', 'Digital marketing', 32, 'test', '2026-03-20', '12:15:00.000000', 'Converted', 'ss', NULL, '2026-03-17 12:15:47.709694', '2026-03-17 12:17:37.460885', NULL, 17, NULL),
(36, 'Test', '6802162238', 'test451@gmail.com', 'dfg', 'Kottayam', 'Digital marketing', 31, 'dfh', '2026-04-04', '11:22:00.000000', 'Quoted', 's', NULL, '2026-03-31 11:08:13.857821', '2026-03-31 11:09:04.008911', NULL, 17, NULL),
(37, 'Tester', '9400069615', 'tester@gmail.com', NULL, 'kottayam', 'Website', 35, 'tester', '2026-04-06', '09:40:00.000000', 'Follow-up', NULL, NULL, '2026-04-06 09:40:57.442667', '2026-04-06 09:42:58.600883', NULL, 18, NULL),
(38, 'Emel Test', '9400069615', 'emelbinu6@gmail.com', NULL, 'kottayam', 'Application', 34, 'tester', '2026-04-06', '10:10:00.000000', 'New', NULL, NULL, '2026-04-06 10:10:31.359942', '2026-04-06 10:10:31.359972', NULL, 18, NULL),
(39, 'tester22', '9488823561', 'tester22@gmail.com', NULL, 'kottayam', 'Website', 37, 'test', '2026-04-06', '10:22:00.000000', 'New', NULL, NULL, '2026-04-06 10:22:52.525641', '2026-04-06 10:22:52.525711', NULL, 18, NULL),
(40, 'Test', '8892345245', NULL, 'ggg', 'Kottayam', 'Digital marketing', 31, 'ffff', '2026-04-08', NULL, 'Quoted', NULL, NULL, '2026-04-06 15:10:31.934012', '2026-04-06 15:11:25.862391', NULL, 17, NULL),
(41, 'TEST', '9447711365', 'Abc@gmail.com', 'hh', 'Kottayam', 'Digital marketing', 31, 'trh', '2026-04-14', '14:59:00.000000', 'Quoted', 'TT', NULL, '2026-04-10 14:58:13.046231', '2026-04-10 15:01:23.886827', NULL, 17, NULL),
(42, 'Arunima', '7902622238', 'Abc@gmail.com', 'gh', 'Kottayam', 'Digital marketing', 31, NULL, NULL, NULL, 'New', NULL, NULL, '2026-04-10 15:07:43.407147', '2026-04-10 15:07:43.407195', NULL, 17, NULL),
(43, 'ANISH', '8606566900', NULL, 'Vaikom', ' VAIKOM', 'DOOR & WINDOWS', 39, 'DOOR & WINDOWS', '2026-06-05', '11:00:00.000000', 'Quoted', 'PLANNING STAGE', NULL, '2026-05-28 14:37:58.720902', '2026-05-28 14:48:59.607073', NULL, 23, NULL),
(44, 'Sandhya', '7902622238', 'Abc@gmail.com', 'Kottayam', 'Kottayam', 'Digital marketing', 31, NULL, '2026-05-30', '10:00:00.000000', 'Quoted', 'dd', NULL, '2026-05-28 15:55:04.596945', '2026-05-28 15:55:25.903033', NULL, 17, NULL),
(45, 'LESTIN', '8765434567', NULL, NULL, NULL, 'Loan', 40, NULL, NULL, '15:50:00.000000', 'Quoted', NULL, NULL, '2026-07-13 15:49:57.702210', '2026-07-16 12:22:27.672934', NULL, 26, NULL),
(46, 'MS SAVITHA', '8281329430', NULL, 'ALAPPUZHA', 'ALAPPUZHA', 'Door&Window', 42, 'STOCK CHECKING NEEDED', '2026-07-15', '11:30:00.000000', 'Quoted', NULL, 'Josni', '2026-07-16 11:51:30.844734', '2026-07-16 11:57:25.604583', NULL, 27, NULL),
(47, 'Arun', '9447711365', 'test12@gmail.com', 'Kottayam', 'Kottayam', 'Door', 43, 'ryu', '2026-07-01', '10:00:00.000000', 'Quoted', NULL, 'Jojin', '2026-07-16 11:59:21.572964', '2026-07-16 15:48:31.225293', NULL, 27, NULL),
(48, 'xx', '7902162238', 'test121@gmail.com', NULL, 'Kottayam', 'Logo', 43, NULL, NULL, NULL, 'Quoted', NULL, NULL, '2026-07-16 15:34:51.776082', '2026-07-16 15:35:14.602152', NULL, 27, NULL),
(49, 'teest', '947123456', NULL, NULL, 'Kottayam', 'Door&Window', 41, NULL, '2026-07-17', NULL, 'New', NULL, NULL, '2026-07-16 15:55:15.411260', '2026-07-16 15:55:15.411300', NULL, 27, NULL),
(50, 'Emel', '9400069615', 'emelbinu94@gmail.com', NULL, 'kottayam', 'Logo', 42, 'tester', '2026-07-16', '16:42:00.000000', 'Quoted', NULL, NULL, '2026-07-16 16:43:40.635842', '2026-07-16 16:43:40.635904', NULL, 27, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lead_app_employee`
--

CREATE TABLE `lead_app_employee` (
  `id` bigint(20) NOT NULL,
  `employee_code` varchar(20) NOT NULL,
  `employee_name` varchar(100) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `email` varchar(254) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `address` longtext DEFAULT NULL,
  `designation` varchar(100) NOT NULL,
  `join_date` date NOT NULL,
  `status` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lead_app_employee`
--

INSERT INTO `lead_app_employee` (`id`, `employee_code`, `employee_name`, `gender`, `email`, `mobile`, `address`, `designation`, `join_date`, `status`, `created_at`, `updated_at`, `client_id`, `Password`) VALUES
(11, 'EMP123', 'Manu', 'Male', 'Abc@gmail.com', '9898676667', 'hgnhhn', 'Admin', '2026-02-03', 1, '2026-02-16 09:23:37.393917', '2026-02-16 09:23:37.393991', 17, 'root'),
(12, '123', 'Arun', 'Male', 'test77@gmail.com', '9898676633', 'gfgggh', 'Reseptionist', '2025-11-17', 1, '2026-02-16 09:24:47.110694', '2026-02-16 10:36:53.742762', 17, 'root'),
(13, '001', 'Anju', 'Female', 'gknair3002@gmail.com', '9495959809', 'Kottayam', 'Accountant', '2026-03-01', 1, '2026-03-03 11:24:24.164767', '2026-03-30 17:34:36.703482', 18, 'root'),
(14, 'EMP-234', 'Emel Binu', 'Male', 'emelbinu94@gmail.com', '9400069615', 'Tester', 'Developer', '2026-04-06', 1, '2026-04-06 09:44:41.740247', '2026-04-06 09:44:41.740283', 18, 'emel1234'),
(15, 'ER123', 'TESTER', 'Male', 'naveenpt04@outlook.com', '9562766836', 'Karingattil House,\r\nBethel Road,', 'Software Developer', '2026-07-15', 1, '2026-07-15 13:22:29.247046', '2026-07-15 13:22:29.247092', 26, 'root'),
(16, '1234577', 'Josni', 'Others', 'test121@gmail.com', '9895868636', 'test', 'Admin', '2025-12-23', 1, '2026-07-16 11:47:47.444754', '2026-07-16 11:47:47.444789', 27, 'josni@123'),
(17, 'EP123', 'Jojin', 'Others', 'fortunobuilds@gmail.com', '9072605509', 'test', 'Admin', '2026-04-23', 1, '2026-07-16 11:49:32.420495', '2026-07-16 11:49:32.420518', 27, 'jojin@123');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` bigint(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `gst_type` varchar(10) NOT NULL,
  `gst` decimal(5,2) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `status` varchar(10) NOT NULL,
  `hsn_code` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `rate`, `gst_type`, `gst`, `created_at`, `updated_at`, `client_id`, `status`, `hsn_code`) VALUES
(17, 'Website', 23000.00, 'GST', 9.00, '2026-02-13 17:40:40.647872', '2026-02-13 17:40:40.647929', 17, 'Active', ''),
(18, 'Logo', 5000.00, 'GST', 18.00, '2026-02-16 11:00:30.334520', '2026-03-30 17:36:10.763144', 18, 'Active', '876549'),
(19, 'Website', 5000.00, 'GST', 18.00, '2026-02-16 11:27:56.318073', '2026-03-31 12:25:48.507121', 18, 'Active', '908979'),
(20, 'digital marketing', 10000.00, 'GST', 9.00, '2026-02-16 15:14:14.587359', '2026-02-16 15:14:14.587399', 17, 'Active', ''),
(21, 'CANTILEVER ACCESSORIES', 34000.00, 'GST', 18.00, '2026-02-16 15:39:35.162174', '2026-02-16 15:39:35.162227', 19, 'Active', '85011020'),
(22, 'Door', 1000.00, 'GST', 0.00, '2026-02-20 12:45:48.288836', '2026-02-20 12:45:48.288894', 17, 'Active', ''),
(23, 'Reels', 1000.00, 'GST', 18.00, '2026-03-31 12:26:36.249637', '2026-03-31 12:26:50.227193', 18, 'Active', '876543'),
(24, 'App', 10000.00, 'GST', 2.20, '2026-04-06 09:46:49.568628', '2026-04-06 09:46:49.568682', 18, 'Active', '8547081'),
(25, 'EMBOOSED WOOD 6\" FRAME', 48000.00, 'GST', 0.00, '2026-05-28 14:34:21.618616', '2026-05-28 14:34:21.618678', 23, 'Active', ''),
(26, 'W3 CLASSIC BROWN', 25000.00, 'GST', 0.00, '2026-05-28 14:36:05.702264', '2026-05-28 14:36:05.702306', 23, 'Active', ''),
(27, 'Website', 2.00, 'IGST', 18.00, '2026-05-30 20:36:17.489566', '2026-05-30 20:36:17.489694', 24, 'Active', '998314'),
(28, 'Negen', 36000.00, 'IGST', 18.00, '2026-05-30 20:36:40.538508', '2026-05-30 20:36:40.538632', 24, 'Active', '998314'),
(29, 'Erp', 3.00, 'IGST', 18.00, '2026-05-30 20:36:56.613253', '2026-05-30 20:36:56.613301', 24, 'Active', '998314'),
(30, 'PRODUCT122', 230.00, 'GST', 18.00, '2026-07-13 15:48:40.790791', '2026-07-13 15:48:40.790849', 26, 'Active', '6572'),
(31, 'TATA PRAVESH CLASSIC PEBBLE ULT-RAL FW4 MESH 200*180', 47270.00, 'GST', 0.00, '2026-07-16 11:28:04.990785', '2026-07-16 11:28:04.990828', 27, 'Active', ''),
(32, 'CLASSIC PEBBLE ULT-RAL FW3 MESH 150*180', 37070.00, 'GST', 0.00, '2026-07-16 11:28:29.619116', '2026-07-16 11:28:29.619173', 27, 'Active', ''),
(33, 'CLASSIC PEBBLE ULT-RAL FW2 MESH 100*180', 27450.00, 'GST', 0.00, '2026-07-16 11:29:13.235886', '2026-07-16 11:29:13.235922', 27, 'Active', ''),
(34, 'CLASSIC PEBBLE ULT-RAL FW1 MESH 50*180', 19190.00, 'GST', 0.00, '2026-07-16 11:29:49.983545', '2026-07-16 11:29:49.983578', 27, 'Active', ''),
(35, 'CLASSIC PEBBLE ULT-RAL KW4 MESH 200*100', 32460.00, 'GST', 0.00, '2026-07-16 11:30:13.003270', '2026-07-16 11:30:13.003307', 27, 'Active', ''),
(36, 'CLASSIC PEBBLE ULT-RAL KW3 MESH 150*100', 26530.00, 'GST', 0.00, '2026-07-16 11:30:39.665677', '2026-07-16 11:30:39.665716', 27, 'Active', ''),
(37, 'CLASSIC PEBBLE ULT-RAL KW2 MESH 100*100', 20530.00, 'GST', 0.00, '2026-07-16 11:31:03.676452', '2026-07-16 11:31:03.676489', 27, 'Active', ''),
(38, 'CLASSIC PEBBLE ULT-RAL KW1 MESH 50*100', 15110.00, 'GST', 0.00, '2026-07-16 11:31:29.322149', '2026-07-16 11:31:29.322181', 27, 'Active', ''),
(39, 'CLASSIC PEBBLE ULT-RAL MESH 200*140', 15110.00, 'GST', 0.00, '2026-07-16 11:31:52.138785', '2026-07-16 11:31:52.138852', 27, 'Active', ''),
(40, 'CLASSIC PEBBLE ULT-RAL MESH 150*140', 31230.00, 'GST', 0.00, '2026-07-16 11:32:12.895582', '2026-07-16 11:32:12.895612', 27, 'Active', ''),
(41, 'CLASSIC PEBBLE ULT-RAL MESH 100*140', 23980.00, 'GST', 0.00, '2026-07-16 11:32:44.711233', '2026-07-16 11:32:44.711290', 27, 'Active', ''),
(42, 'CLASSIC PEBBLE ULT-RAL MESH 50*140', 17160.00, 'GST', 0.00, '2026-07-16 11:33:21.885108', '2026-07-16 11:33:21.885136', 27, 'Active', ''),
(43, 'CLASSIC PEBBLE ULT-RAL V2 90*60', 13610.00, 'GST', 0.00, '2026-07-16 11:33:50.025779', '2026-07-16 11:33:50.025811', 27, 'Active', ''),
(44, 'CLASSIC PEBBLE ULT-RAL V1 60*60', 11820.00, 'GST', 0.00, '2026-07-16 11:36:20.176647', '2026-07-16 11:36:20.176706', 27, 'Active', ''),
(45, 'CLASSIC PEBBLE ULT-RAL V1 60*50', 10530.00, 'GST', 0.00, '2026-07-16 11:36:47.402801', '2026-07-16 11:36:47.402831', 27, 'Active', ''),
(46, 'CLASSIC PEBBLE ULT-RAL V1 60*40', 9530.00, 'GST', 0.00, '2026-07-16 11:37:06.640585', '2026-07-16 11:37:06.640627', 27, 'Active', ''),
(47, 'CLASSIC PEBBLE ULT-RAL KW4- 200*100', 27440.00, 'GST', 0.00, '2026-07-16 11:37:22.350798', '2026-07-16 11:37:22.350827', 27, 'Active', ''),
(48, 'CLASSIC PEBBLE ULT-RAL KW3 150*100', 22690.00, 'GST', 0.00, '2026-07-16 11:37:43.519907', '2026-07-16 11:37:43.519938', 27, 'Active', ''),
(49, 'CLASSIC PEBBLE ULT-RAL KW2 100*100', 17860.00, 'GST', 0.00, '2026-07-16 11:38:11.298420', '2026-07-16 11:38:11.298449', 27, 'Active', ''),
(50, 'CLASSIC PEBBLE ULT-RAL KW1 50*100', 13580.00, 'GST', 0.00, '2026-07-16 11:38:42.754972', '2026-07-16 11:38:42.755008', 27, 'Active', ''),
(51, 'CLASSIC PEBBLE ECO K-GRILL ULT-RAL W4-200*140', 38570.00, 'GST', 0.00, '2026-07-16 11:39:51.360113', '2026-07-16 11:39:51.360186', 27, 'Active', ''),
(52, 'CLASSIC PEBBLE ECO K GRILL ULT-RAL W3-150*140', 31350.00, 'GST', 0.00, '2026-07-16 11:40:13.208574', '2026-07-16 11:40:13.208619', 27, 'Active', ''),
(53, 'CLASSIC PEBBLE ECO K GRILL ULT-RAL W2-100*140', 25480.00, 'GST', 0.00, '2026-07-16 11:40:33.129166', '2026-07-16 11:40:33.129221', 27, 'Active', ''),
(54, 'CLASSIC PEBBLE ECO K GRILL ULT-RAL W1-50*140', 19110.00, 'GST', 0.00, '2026-07-16 11:41:25.630120', '2026-07-16 11:41:25.630168', 27, 'Active', ''),
(55, 'CLASSIC PEBBLE ECO N GRILL ULT-RAL 200*100', 34020.00, 'GST', 0.00, '2026-07-16 11:41:52.367010', '2026-07-16 11:41:52.367051', 27, 'Active', ''),
(56, 'CLASSIC PEBBLE ECO ULT-RAL 150*140', 28420.00, 'GST', 0.00, '2026-07-16 11:42:11.968309', '2026-07-16 11:42:11.968393', 27, 'Active', ''),
(57, 'CLASSIC PEBBLE ECO ULT-RAL 100*140', 23480.00, 'GST', 0.00, '2026-07-16 11:42:35.764661', '2026-07-16 11:42:35.764705', 27, 'Active', ''),
(58, 'CLASSIC PEBBLE ECO ULT-RAL 50*140', 18070.00, 'GST', 0.00, '2026-07-16 11:42:51.755525', '2026-07-16 11:42:51.755579', 27, 'Active', ''),
(59, 'CLASSIC PEBBLE ULT-RAL 200*140', 32910.00, 'GST', 0.00, '2026-07-16 11:43:08.549413', '2026-07-16 11:43:08.549449', 27, 'Active', ''),
(60, 'CLASSIC PEBBLE ULT-RAL 150*140', 26850.00, 'GST', 0.00, '2026-07-16 11:43:27.182322', '2026-07-16 11:43:27.182389', 27, 'Active', ''),
(61, 'CLASSIC PEBBLE ULT-RAL 100*140', 20780.00, 'GST', 0.00, '2026-07-16 11:43:50.316621', '2026-07-16 11:43:50.316657', 27, 'Active', ''),
(62, 'CLASSIC PEBBLE ULT-RAL 50*140', 15290.00, 'GST', 0.00, '2026-07-16 11:44:07.934700', '2026-07-16 15:52:14.365604', 27, 'Active', '12'),
(63, 'Logo', 500.00, 'GST', 0.00, '2026-07-16 11:44:30.629552', '2026-07-16 11:44:30.629590', 27, 'Active', '1213');

-- --------------------------------------------------------

--
-- Table structure for table `quotation`
--

CREATE TABLE `quotation` (
  `id` bigint(20) NOT NULL,
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
  `client_id` bigint(20) NOT NULL,
  `lead_id` bigint(20) DEFAULT NULL,
  `valid_upto` date NOT NULL,
  `cgst` decimal(12,2) DEFAULT NULL,
  `igst` decimal(12,2) DEFAULT NULL,
  `sgst` decimal(12,2) DEFAULT NULL,
  `quotation_number` varchar(80) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quotation`
--

INSERT INTO `quotation` (`id`, `client_name`, `client_phone`, `client_email`, `client_address`, `subtotal`, `gst_type`, `gst_amount`, `total`, `notes`, `created_at`, `client_id`, `lead_id`, `valid_upto`, `cgst`, `igst`, `sgst`, `quotation_number`, `version`, `staff_id`) VALUES
(27, 'Arun', '9992345245', 'test@gmail.com', 'af', 28000.00, 'GST', 2520.00, 30520.00, '', '2026-02-13 17:41:15.365512', 17, 22, '2026-02-19', 1260.00, 0.00, 1260.00, 'QUO-17_2026021300001', '2', NULL),
(28, 'Arun', '9447742399', 'test121@gmail.com', 'fghj', 10000.00, '', 900.00, 10900.00, 'hj', '2026-02-16 15:14:52.658377', 17, 25, '2026-02-26', 450.00, NULL, 450.00, 'QUO-17_2026021600001', '1', NULL),
(29, 'seena', '9495959809', 'None', 'None', 23000.00, '', 2070.00, 25070.00, '', '2026-02-17 10:36:46.941544', 17, 23, '2026-02-20', 1035.00, NULL, 1035.00, 'QUO-17_2026021700001', '1', NULL),
(30, 'Arunima', '7902622299', 'Abc@gmail.com', 'trtgh', 10000.00, '', 900.00, 10900.00, '', '2026-02-18 16:05:04.941538', 17, 26, '2026-02-27', 450.00, NULL, 450.00, 'QUO-17_2026021800001', '1', NULL),
(31, 'amal', '7902628238', 'Abc@gmail.com', 'drfgh', 10000.00, '', 900.00, 10900.00, '', '2026-02-18 16:19:46.049171', 17, 27, '2026-02-25', 450.00, NULL, 450.00, 'QUO-17_2026021800002', '1', NULL),
(32, 'test', '9449742365', 'test121@gmail.com', 'sdfg', 5000.00, '', 450.00, 5450.00, '', '2026-02-20 11:39:24.082183', 17, 28, '2026-02-27', 225.00, NULL, 225.00, 'QUO-17_2026022000001', '1', NULL),
(33, 'roy', '7012733949', 'None', 'bb', 1000.00, '', 0.00, 1000.00, '', '2026-02-20 12:46:47.025830', 17, 29, '2026-02-27', NULL, NULL, NULL, 'QUO-17_2026022000002', '1', NULL),
(34, 'Nikhita', '9495959990', 'None', 'Kottayam', 5000.00, 'GST', 900.00, 5900.00, 'r66', '2026-02-23 09:51:57.468030', 18, 24, '2026-04-11', 450.00, 0.00, 450.00, 'QUO-18_2026022300001', '3', NULL),
(35, 'Arun', '9447711365', 'test77@gmail.com', 'test', 33000.00, 'GST', 2970.00, 35970.00, '', '2026-02-26 10:06:12.165553', 17, 31, '2026-02-28', 1485.00, 0.00, 1485.00, 'QUO-17_2026022600001', '2', NULL),
(36, 'nikhita', '9495959809', 'gknair3002@gmail.com', 'Kottayam', 5000.00, 'GST', 900.00, 5900.00, 'hjfuj', '2026-03-03 13:38:38.640806', 18, 33, '2026-04-08', 450.00, 0.00, 450.00, 'QUO-18_2026030300001', '5', NULL),
(37, 'test', '7907622238', 'test77@gmail.com', 'fghj', 10000.00, '', 900.00, 10900.00, '', '2026-03-03 15:59:56.078119', 17, 34, '2026-03-12', 450.00, NULL, 450.00, 'QUO-17_2026030300001', '1', NULL),
(38, 'Arun', '7902162238', 'Abc@gmail.com', 'zxx', 10000.00, 'GST', 900.00, 10900.00, '', '2026-03-17 12:17:10.449434', 17, 35, '2026-04-08', 450.00, 0.00, 450.00, 'QUO-17_2026031700001', '2', NULL),
(39, 'Saju D', '7846473822', 'tecknohow.132@gmail.com', 'None', 23000.00, '', 2070.00, 25070.00, '', '2026-03-31 10:41:55.059524', 17, 32, '2026-04-30', 1035.00, NULL, 1035.00, 'QUO-17_2026033100001', '1', NULL),
(40, 'Test', '6802162238', 'test451@gmail.com', 'dfg', 10000.00, '', 900.00, 10900.00, '', '2026-03-31 11:09:03.999960', 17, 36, '2026-04-09', 450.00, NULL, 450.00, 'QUO-17_2026033100002', '1', NULL),
(41, 'Sonu', '9647859609', 'None', 'None', 5000.00, '', 900.00, 5900.00, 'axcdscds', '2026-03-31 11:26:45.818758', 18, 30, '2026-04-11', 450.00, NULL, 450.00, 'QUO-18_2026033100001', '1', NULL),
(42, 'Tester', '9400069615', 'test@gmail.com', '', 6000.00, 'GST', 1080.00, 7080.00, '', '2026-04-06 09:42:11.796455', 18, 37, '2028-04-05', 540.00, NULL, 540.00, 'QUO-18_2026040600001', '1', NULL),
(43, 'Test', '8892345245', 'None', 'ggg', 10000.00, 'GST', 900.00, 10900.00, '', '2026-04-06 15:11:25.855021', 17, 40, '2026-04-15', 450.00, 0.00, 450.00, 'QUO-17_2026040600001', '2', NULL),
(44, 'TEST', '9447711365', 'Abc@gmail.com', 'hh', 10000.00, '', 900.00, 10900.00, '', '2026-04-10 15:01:23.871551', 17, 41, '2026-04-17', 450.00, NULL, 450.00, 'QUO-17_2026041000001', '1', NULL),
(45, 'ANISH', '8606566900', 'None', 'VAIKOM', 73000.00, 'GST', 0.00, 73000.00, '', '2026-05-28 14:43:01.636405', 23, 43, '2026-05-30', 0.00, 0.00, 0.00, 'QUO-23_2026052800001', '2', NULL),
(46, 'Sandhya', '7902622238', 'Abc@gmail.com', 'Kottayam', 10000.00, '', 900.00, 10900.00, '', '2026-05-28 15:55:25.897079', 17, 44, '2026-05-30', 450.00, NULL, 450.00, 'QUO-17_2026052800001', '1', NULL),
(47, 'MS SAVITHA', '8281329430', 'None', 'ALAPPUZHA', 326870.00, '', 0.00, 326870.00, '', '2026-07-16 11:57:25.581429', 27, 46, '2026-07-31', NULL, NULL, NULL, 'QUO-27_2026071600001', '1', NULL),
(48, 'Arun', '9447711365', 'test12@gmail.com', 'Kottayam', 15290.00, 'GST', 0.00, 15290.00, 'lg', '2026-07-16 12:00:04.447828', 27, 47, '2026-07-30', 0.00, 0.00, 0.00, 'QUO-27_2026071600002', '7', NULL),
(49, 'LESTIN', '8765434567', 'None', 'None', 230.00, '', 41.40, 271.40, '', '2026-07-16 12:22:27.668514', 26, 45, '2026-07-16', 20.70, NULL, 20.70, 'QUO-26_2026071600001', '1', NULL),
(50, 'xx', '7902162238', 'test121@gmail.com', 'None', 500.00, '', 0.00, 500.00, '', '2026-07-16 15:35:14.596686', 27, 48, '2026-07-31', NULL, NULL, NULL, 'QUO-27_2026071600003', '1', NULL),
(51, 'Emel', '9400069615', 'emelbinu94@gmail.com', '', 500.00, 'GST', 0.00, 500.00, 'tedter', '2026-07-16 16:52:31.908034', 27, 50, '2027-08-19', 0.00, NULL, 0.00, 'QUO-27_2026071600004', '1', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `quotationitem`
--

CREATE TABLE `quotationitem` (
  `id` bigint(20) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `quotation_id` bigint(20) NOT NULL,
  `cgst` decimal(12,2) DEFAULT NULL,
  `igst` decimal(12,2) DEFAULT NULL,
  `sgst` decimal(12,2) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `spec` varchar(255) DEFAULT NULL
) ;

--
-- Dumping data for table `quotationitem`
--

INSERT INTO `quotationitem` (`id`, `quantity`, `rate`, `amount`, `product_id`, `quotation_id`, `cgst`, `igst`, `sgst`, `description`, `unit`, `spec`) VALUES
(31, 1, 5000.00, 5000.00, 17, 27, 225.00, NULL, 225.00, '', '', NULL),
(32, 1, 10000.00, 10000.00, 20, 28, 450.00, NULL, 450.00, '', '', NULL),
(33, 1, 23000.00, 23000.00, 17, 29, 1035.00, NULL, 1035.00, '', '', NULL),
(34, 1, 10000.00, 10000.00, 20, 30, 450.00, NULL, 450.00, '', '', NULL),
(35, 1, 10000.00, 10000.00, 20, 31, 450.00, NULL, 450.00, '', '', NULL),
(36, 1, 5000.00, 5000.00, 20, 32, 225.00, NULL, 225.00, '', '', NULL),
(37, 1, 1000.00, 1000.00, 22, 33, 0.00, NULL, 0.00, '', '', NULL),
(38, 1, 5000.00, 5000.00, 18, 34, 450.00, NULL, 450.00, '', '', 'Color:red\r\nModel:PG123'),
(39, 1, 10000.00, 10000.00, 20, 35, 450.00, NULL, 450.00, '', '', NULL),
(40, 1, 23000.00, 23000.00, 17, 35, 1035.00, NULL, 1035.00, '', '', NULL),
(41, 1, 5000.00, 5000.00, 18, 36, 450.00, NULL, 450.00, 'Naturistic Logo with Greenish for ecotoursim', '', 'Color:Blue\r\nModel:7890'),
(42, 1, 10000.00, 10000.00, 20, 37, 450.00, NULL, 450.00, '', '', NULL),
(43, 1, 10000.00, 10000.00, 20, 38, 450.00, NULL, 450.00, '', '', 'size;45\r\ncolor-blue\r\n'),
(44, 1, 23000.00, 23000.00, 17, 39, 1035.00, NULL, 1035.00, '', '', 'size 20\r\ncolor\r\n'),
(45, 1, 10000.00, 10000.00, 20, 40, 450.00, NULL, 450.00, '', '', 'Size-10\r\nColor-Blue\r\n'),
(46, 1, 5000.00, 5000.00, 19, 41, 450.00, NULL, 450.00, '', '', ''),
(47, 1, 1000.00, 1000.00, 23, 42, 90.00, NULL, 90.00, 'tester', 'Nos', 'test'),
(48, 1, 5000.00, 5000.00, 19, 42, 450.00, NULL, 450.00, 'tester1', 'Nos', 'test2'),
(49, 1, 10000.00, 10000.00, 20, 43, 450.00, NULL, 450.00, '', '', 'Size-100           \r\nColor-white'),
(50, 1, 10000.00, 10000.00, 20, 44, 450.00, NULL, 450.00, '', '', ''),
(51, 1, 48000.00, 48000.00, 25, 45, 0.00, NULL, 0.00, '', '', 'SUNTEAK - 110X210'),
(52, 1, 25000.00, 25000.00, 26, 45, 0.00, NULL, 0.00, '', '', 'BROWN -150X140'),
(53, 1, 10000.00, 10000.00, 20, 46, 450.00, NULL, 450.00, '', '', ''),
(54, 4, 26850.00, 107400.00, 60, 47, 0.00, NULL, 0.00, '', '', ''),
(55, 4, 32910.00, 131640.00, 59, 47, 0.00, NULL, 0.00, '', '', ''),
(56, 2, 13580.00, 27160.00, 50, 47, 0.00, NULL, 0.00, '', '', ''),
(57, 1, 15290.00, 15290.00, 62, 47, 0.00, NULL, 0.00, '', '', ''),
(58, 2, 22690.00, 45380.00, 48, 47, 0.00, NULL, 0.00, '', '', ''),
(60, 1, 230.00, 230.00, 30, 49, 20.70, NULL, 20.70, '', '', ''),
(61, 1, 15290.00, 15290.00, 62, 48, 0.00, NULL, 0.00, '', 'Nos', '-'),
(62, 1, 500.00, 500.00, 63, 50, 0.00, NULL, 0.00, '', '', ''),
(63, 1, 500.00, 500.00, 63, 51, 0.00, NULL, 0.00, 'tester', 'Nos', 'tedrer');

-- --------------------------------------------------------

--
-- Table structure for table `terms_conditions`
--

CREATE TABLE `terms_conditions` (
  `id` bigint(20) NOT NULL,
  `content` longtext DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `terms_conditions`
--

INSERT INTO `terms_conditions` (`id`, `content`, `updated_at`, `client_id`) VALUES
(4, '', '2026-02-13 15:49:12.524520', 15),
(5, '.', '2026-02-26 16:20:43.268016', 17),
(7, '', '2026-02-23 10:48:46.121824', 19),
(8, '', '2026-03-17 17:25:54.431322', 22),
(9, '', '2026-03-30 17:40:06.057427', 18),
(10, '', '2026-05-28 14:40:33.746488', 23),
(11, '\"GST @18% INCLUDED. STATUTORY CHARGES IF ANY WILL BE EXTRA\r\nDOOR/WINDOW FRAMES, ACCESSORIES, INSTALLATION, TRANSPORTATION, WARRANTY ALL INCLUSIVE\"				\r\n\"50% ADVANCE ALONG WITH P.O FOR ORDER CONFIRMATION\r\nBALANCE 50% BEFORE DELIVERY\"				\r\nDELIVERY WITHIN 90-100 DAYS FROM DATE OF ORDER CONFIRMATION ALONG WITH ADVANCE				\r\n\"STANDARD WARRANTY IS FOR 1 YEAR\r\nAMC WITH ADDITIONAL WARRANTY IS AVAILABLE FOR SELECT MODELS.(RS.800 EXTRA FOR 4 YEARS)\"				\r\n\"ONCE MATERIAL IS READY, CUSTOMERS SHOULD ACCEPT DELIVERY WITHIN 15 DAYS\r\nUNLOADING/UNION CHARGE, POSITIONING, ELECTRICITY TO BE PROVIDED BY CUSTOMER\r\nALL CIVIL WORK TO MAINTAIN EXACT WALL OPENINGS WILL BE CUSTOMER SCOPE\r\nAdditional arrangements required to complete the installation such as shifting of unite, wall corrections (cutting/chipping), Silicon Filling & extra filling material are under customer scope\r\n Ensuring finished floor level & wall opening as per the ordered size mentioned in this booking form is the sole responsibility of the customer.\r\nINSTALLERS NOT BOUND TO DO ANY MASONRY WORK\r\nPRODUCTS ONCE ORDERED CANNOT BE CANCELLED OR MODIFIED\r\nGOODS ONCE SOLD WILL NOT BE TAKEN BACK\"', '2026-07-16 14:56:31.047479', 27);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `client_data`
--
ALTER TABLE `client_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `document`
--
ALTER TABLE `document`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `document_id` (`document_id`),
  ADD KEY `lead_app_document_client_id_a23adc36_fk_client_data_id` (`client_id`);

--
-- Indexes for table `enquiryfor`
--
ALTER TABLE `enquiryfor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `EnquiryFor_client_id_name_38f02666_uniq` (`client_id`,`name`);

--
-- Indexes for table `followupremark`
--
ALTER TABLE `followupremark`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_app_followuprem_followup_id_id_e97a2545_fk_lead_app_` (`followup_id_id`);

--
-- Indexes for table `followup_table`
--
ALTER TABLE `followup_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leadsource`
--
ALTER TABLE `leadsource`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Lead_Source_client_id_28ad5b48_fk_client_data_id` (`client_id`);

--
-- Indexes for table `leads_table`
--
ALTER TABLE `leads_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Lead_table_client_id_61c82500_fk_client_data_id` (`client_id`),
  ADD KEY `Lead_table_lead_source_id_b7564021` (`lead_source_id`),
  ADD KEY `Lead_table_staff_id_4d2ab166_fk_Employee_id` (`staff_id`);

--
-- Indexes for table `lead_app_employee`
--
ALTER TABLE `lead_app_employee`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employee_code` (`employee_code`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `Employee_client_id_fe4c438f_fk_client_data_id` (`client_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Product_client_id_52f25a29_fk_client_data_id` (`client_id`);

--
-- Indexes for table `quotation`
--
ALTER TABLE `quotation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_app_quotation_client_id_21f5a2f2_fk_client_data_id` (`client_id`),
  ADD KEY `lead_app_quotation_lead_id_05a5cd50_fk_Lead_table_id` (`lead_id`),
  ADD KEY `Quotation_staff_id_a874b158_fk_Employee_id` (`staff_id`);

--
-- Indexes for table `quotationitem`
--
ALTER TABLE `quotationitem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_app_quotationitem_product_id_768ce1ec_fk_Product_id` (`product_id`),
  ADD KEY `lead_app_quotationit_quotation_id_7c19c80b_fk_lead_app_` (`quotation_id`);

--
-- Indexes for table `terms_conditions`
--
ALTER TABLE `terms_conditions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_app_privacypolicy_client_id_517080f7_fk_client_data_id` (`client_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client_data`
--
ALTER TABLE `client_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `document`
--
ALTER TABLE `document`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `enquiryfor`
--
ALTER TABLE `enquiryfor`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `followupremark`
--
ALTER TABLE `followupremark`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `followup_table`
--
ALTER TABLE `followup_table`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `leadsource`
--
ALTER TABLE `leadsource`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `leads_table`
--
ALTER TABLE `leads_table`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `lead_app_employee`
--
ALTER TABLE `lead_app_employee`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `quotation`
--
ALTER TABLE `quotation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `quotationitem`
--
ALTER TABLE `quotationitem`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `terms_conditions`
--
ALTER TABLE `terms_conditions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `document`
--
ALTER TABLE `document`
  ADD CONSTRAINT `lead_app_document_client_id_a23adc36_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);

--
-- Constraints for table `enquiryfor`
--
ALTER TABLE `enquiryfor`
  ADD CONSTRAINT `EnquiryFor_client_id_d52bddd2_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);

--
-- Constraints for table `followupremark`
--
ALTER TABLE `followupremark`
  ADD CONSTRAINT `lead_app_followuprem_followup_id_id_e97a2545_fk_lead_app_` FOREIGN KEY (`followup_id_id`) REFERENCES `followup_table` (`id`);

--
-- Constraints for table `leadsource`
--
ALTER TABLE `leadsource`
  ADD CONSTRAINT `Lead_Source_client_id_28ad5b48_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);

--
-- Constraints for table `leads_table`
--
ALTER TABLE `leads_table`
  ADD CONSTRAINT `Lead_table_client_id_61c82500_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`),
  ADD CONSTRAINT `Lead_table_lead_source_id_b7564021_fk_LeadSource_id` FOREIGN KEY (`lead_source_id`) REFERENCES `leadsource` (`id`),
  ADD CONSTRAINT `Lead_table_staff_id_4d2ab166_fk_Employee_id` FOREIGN KEY (`staff_id`) REFERENCES `lead_app_employee` (`id`);

--
-- Constraints for table `lead_app_employee`
--
ALTER TABLE `lead_app_employee`
  ADD CONSTRAINT `Employee_client_id_fe4c438f_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `Product_client_id_52f25a29_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);

--
-- Constraints for table `quotation`
--
ALTER TABLE `quotation`
  ADD CONSTRAINT `Quotation_staff_id_a874b158_fk_Employee_id` FOREIGN KEY (`staff_id`) REFERENCES `lead_app_employee` (`id`),
  ADD CONSTRAINT `lead_app_quotation_client_id_21f5a2f2_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`),
  ADD CONSTRAINT `lead_app_quotation_lead_id_05a5cd50_fk_Lead_table_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_table` (`id`);

--
-- Constraints for table `quotationitem`
--
ALTER TABLE `quotationitem`
  ADD CONSTRAINT `lead_app_quotationit_quotation_id_7c19c80b_fk_lead_app_` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`),
  ADD CONSTRAINT `lead_app_quotationitem_product_id_768ce1ec_fk_Product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `terms_conditions`
--
ALTER TABLE `terms_conditions`
  ADD CONSTRAINT `lead_app_privacypolicy_client_id_517080f7_fk_client_data_id` FOREIGN KEY (`client_id`) REFERENCES `client_data` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
