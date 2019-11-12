-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server Version:               10.2.27-MariaDB - mariadb.org binary distribution
-- Server Betriebssystem:        Win64
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Database structure for new tourdb
CREATE DATABASE IF NOT EXISTS `tourdb_new` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `tourdb_new`;

-- ---------------------------------
-- Migrate data for table kmlstyles'
-- ---------------------------------
INSERT INTO `tourdb_new`.`kmlStyles` (
    `kmlstyleId`, 
    `code`, 
    `styColorNormal`, 
    `styWidthNormal`, 
    `styLineNormal`,
    `styColorHighlighted`,
    `styWidthHighlighted`,
    `styLineHighlighted`
) SELECT 
    `ID`,
    `styCode`,
    `styColorNormal`,
    `styWidthNormal`,
    `styLineNormal`,
    `styColorHighlighted`,
    `styWidthHighlighted`,
    `styLineHighlighted`
FROM `tourdb2_prod`.`tbl_kmlstyle`; 

-- ----------------------------
-- Migrate data for table users
-- ----------------------------
-- TASK:
-- - Change email to unique value
INSERT INTO `tourdb_new`.`users` (
    `login`,
    `firstName`,
    `lastName`,
    `email`,
    `passwd`,
    `crtDate`,
    `fk_crtUserId`,
    `updDate`,
    `fk_updUserId`
) SELECT 
    `usrLogin`,
    `usrFirstName`,
    `usrLastName`,
    `usrEmail`,
    `usrPasswd`,
    `usrCreatedDate`,
    1,
    `usrUpdatedDate`,
    1
FROM `tourdb2_prod`.`tbl_users`;

-- ----------------------
-- Create table countries
-- ----------------------
INSERT INTO `tourdb_new`.`countries` (
    `name`,
    `code`
) VALUES
    ('Afghanistan', 'AF'),
    ('Albania', 'AL'),
    ('Algeria', 'DZ'),
    ('American Samoa', 'AS'),
    ('Andorra', 'AD'),
    ('Angola', 'AO'),
    ('Anguilla', 'AI'),
    ('Antarctica', 'AQ'),
    ('Antigua and Barbuda', 'AG'),
    ('Argentina', 'AR'),
    ('Armenia', 'AM'),
    ('Aruba', 'AW'),
    ('Australia', 'AU'),
    ('Austria', 'AT'),
    ('Azerbaijan', 'AZ'),
    ('Bahamas', 'BS'),
    ('Bahrain', 'BH'),
    ('Bangladesh', 'BD'),
    ('Barbados', 'BB'),
    ('Belarus', 'BY'),
    ('Belgium', 'BE'),
    ('Belize', 'BZ'),
    ('Benin', 'BJ'),
    ('Bermuda', 'BM'),
    ('Bhutan', 'BT'),
    ('Bolivia', 'BO'),
    ('Bonaire', 'BQ'),
    ('Bosnia and Herzegovina', 'BA'),
    ('Botswana', 'BW'),
    ('Bouvet Island', 'BV'),
    ('Brazil', 'BR'),
    ('British Indian Ocean Territory', 'IO'),
    ('Brunei Darussalam', 'BN'),
    ('Bulgaria', 'BG'),
    ('Burkina Faso', 'BF'),
    ('Burundi', 'BI'),
    ('Cambodia', 'KH'),
    ('Cameroon', 'CM'),
    ('Canada', 'CA'),
    ('Cape Verde', 'CV'),
    ('Cayman Islands', 'KY'),
    ('Central African Republic', 'CF'),
    ('Chad', 'TD'),
    ('Chile', 'CL'),
    ('China', 'CN'),
    ('Christmas Island', 'CX'),
    ('Cocos (Keeling) Islands', 'CC'),
    ('Colombia', 'CO'),
    ('Comoros', 'KM'),
    ('Congo', 'CG'),
    ('Congo', 'CD'),
    ('Cook Islands', 'CK'),
    ('Costa Rica', 'CR'),
    ('Côte d\'Ivoire', 'CI'),
    ('Croatia', 'HR'),
    ('Cuba', 'CU'),
    ('CuraÃ§ao', 'CW'),
    ('Cyprus', 'CY'),
    ('Czech Republic', 'CZ'),
    ('Denmark', 'DK'),
    ('Djibouti', 'DJ'),
    ('Dominica', 'DM'),
    ('Dominican Republic', 'DO'),
    ('Ecuador', 'EC'),
    ('Egypt', 'EG'),
    ('El Salvador', 'SV'),
    ('Equatorial Guinea', 'GQ'),
    ('Eritrea', 'ER'),
    ('Estonia', 'EE'),
    ('Ethiopia', 'ET'),
    ('Falkland Islands (Malvinas)', 'FK'),
    ('Faroe Islands', 'FO'),
    ('Fiji', 'FJ'),
    ('Finland', 'FI'),
    ('France', 'FR'),
    ('French Guiana', 'GF'),
    ('French Polynesia', 'PF'),
    ('French Southern Territories', 'TF'),
    ('Gabon', 'GA'),
    ('Gambia', 'GM'),
    ('Georgia', 'GE'),
    ('Germany', 'DE'),
    ('Ghana', 'GH'),
    ('Gibraltar', 'GI'),
    ('Greece', 'GR'),
    ('Greenland', 'GL'),
    ('Grenada', 'GD'),
    ('Guadeloupe', 'GP'),
    ('Guam', 'GU'),
    ('Guatemala', 'GT'),
    ('Guernsey', 'GG'),
    ('Guinea', 'GN'),
    ('Guinea-Bissau', 'GW'),
    ('Guyana', 'GY'),
    ('Haiti', 'HT'),
    ('Heard Island and McDonald Islands', 'HM'),
    ('Holy See (Vatican City State)', 'VA'),
    ('Honduras', 'HN'),
    ('Hong Kong', 'HK'),
    ('Hungary', 'HU'),
    ('Iceland', 'IS'),
    ('India', 'IN'),
    ('Indonesia', 'ID'),
    ('Iran', 'IR'),
    ('Iraq', 'IQ'),
    ('Ireland', 'IE'),
    ('Islands', 'AX'),
    ('Isle of Man', 'IM'),
    ('Israel', 'IL'),
    ('Italy', 'IT'),
    ('Jamaica', 'JM'),
    ('Japan', 'JP'),
    ('Jersey', 'JE'),
    ('Jordan', 'JO'),
    ('Kazakhstan', 'KZ'),
    ('Kenya', 'KE'),
    ('Kiribati', 'KI'),
    ('North Korea', 'KP'),
    ('South Korea', 'KR'),
    ('Kuwait', 'KW'),
    ('Kyrgyzstan', 'KG'),
    ('Laos', 'LA'),
    ('Latvia', 'LV'),
    ('Lebanon', 'LB'),
    ('Lesotho', 'LS'),
    ('Liberia', 'LR'),
    ('Libya', 'LY'),
    ('Liechtenstein', 'LI'),
    ('Lithuania', 'LT'),
    ('Luxembourg', 'LU'),
    ('Macao', 'MO'),
    ('Macedonia', 'MK'),
    ('Madagascar', 'MG'),
    ('Malawi', 'MW'),
    ('Malaysia', 'MY'),
    ('Maldives', 'MV'),
    ('Mali', 'ML'),
    ('Malta', 'MT'),
    ('Marshall Islands', 'MH'),
    ('Martinique', 'MQ'),
    ('Mauritania', 'MR'),
    ('Mauritius', 'MU'),
    ('Mayotte', 'YT'),
    ('Mexico', 'MX'),
    ('Micronesia', 'FM'),
    ('Moldova', 'MD'),
    ('Monaco', 'MC'),
    ('Mongolia', 'MN'),
    ('Montenegro', 'ME'),
    ('Montserrat', 'MS'),
    ('Morocco', 'MA'),
    ('Mozambique', 'MZ'),
    ('Myanmar', 'MM'),
    ('Namibia', 'NA'),
    ('Nauru', 'NR'),
    ('Nepal', 'NP'),
    ('Netherlands', 'NL'),
    ('New Caledonia', 'NC'),
    ('New Zealand', 'NZ'),
    ('Nicaragua', 'NI'),
    ('Niger', 'NE'),
    ('Nigeria', 'NG'),
    ('Niue', 'NU'),
    ('Norfolk Island', 'NF'),
    ('Northern Mariana Islands', 'MP'),
    ('Norway', 'NO'),
    ('Oman', 'OM'),
    ('Pakistan', 'PK'),
    ('Palau', 'PW'),
    ('Palestine', 'PS'),
    ('Panama', 'PA'),
    ('Papua New Guinea', 'PG'),
    ('Paraguay', 'PY'),
    ('Peru', 'PE'),
    ('Philippines', 'PH'),
    ('Pitcairn', 'PN'),
    ('Poland', 'PL'),
    ('Portugal', 'PT'),
    ('Puerto Rico', 'PR'),
    ('Qatar', 'QA'),
    ('RÃ©union', 'RE'),
    ('Romania', 'RO'),
    ('Russian Federation', 'RU'),
    ('Rwanda', 'RW'),
    ('Saint BarthÃ©lemy', 'BL'),
    ('Saint Helena', 'SH'),
    ('Saint Kitts and Nevis', 'KN'),
    ('Saint Lucia', 'LC'),
    ('Saint Martin (French part)', 'MF'),
    ('Saint Pierre and Miquelon', 'PM'),
    ('Saint Vincent and the Grenadines', 'VC'),
    ('Samoa', 'WS'),
    ('San Marino', 'SM'),
    ('Sao Tome and Principe', 'ST'),
    ('Saudi Arabia', 'SA'),
    ('Senegal', 'SN'),
    ('Serbia', 'RS'),
    ('Seychelles', 'SC'),
    ('Sierra Leone', 'SL'),
    ('Singapore', 'SG'),
    ('Sint Maarten (Dutch part)', 'SX'),
    ('Slovakia', 'SK'),
    ('Slovenia', 'SI'),
    ('Solomon Islands', 'SB'),
    ('Somalia', 'SO'),
    ('South Africa', 'ZA'),
    ('South Georgia and the South Sandwich Islands', 'GS'),
    ('South Sudan', 'SS'),
    ('Spain', 'ES'),
    ('Sri Lanka', 'LK'),
    ('Sudan', 'SD'),
    ('Suriname', 'SR'),
    ('Svalbard and Jan Mayen', 'SJ'),
    ('Swaziland', 'SZ'),
    ('Sweden', 'SE'),
    ('Switzerland', 'CH'),
    ('Syrian Arab Republic', 'SY'),
    ('Taiwan', 'TW'),
    ('Tajikistan', 'TJ'),
    ('Tanzania', 'TZ'),
    ('Thailand', 'TH'),
    ('Timor-Leste', 'TL'),
    ('Togo', 'TG'),
    ('Tokelau', 'TK'),
    ('Tonga', 'TO'),
    ('Trinidad and Tobago', 'TT'),
    ('Tunisia', 'TN'),
    ('Turkey', 'TR'),
    ('Turkmenistan', 'TM'),
    ('Turks and Caicos Islands', 'TC'),
    ('Tuvalu', 'TV'),
    ('Uganda', 'UG'),
    ('Ukraine', 'UA'),
    ('United Arab Emirates', 'AE'),
    ('United Kingdom', 'GB'),
    ('United States', 'US'),
    ('United States Minor Outlying Islands', 'UM'),
    ('Uruguay', 'UY'),
    ('Uzbekistan', 'UZ'),
    ('Vanuatu', 'VU'),
    ('Venezuela', 'VE'),
    ('Viet Nam', 'VN'),
    ('British Virgin Islands', 'VG'),
    ('US Virgin Islands', 'VI'),
    ('Wallis and Futuna', 'WF'),
    ('Western Sahara', 'EH'),
    ('Yemen', 'YE'),
    ('Zambia', 'ZM'),
    ('Zimbabwe', 'ZW');

-- --------------------'
-- Create table cantons
-- --------------------
INSERT INTO `cantons` (
    `name`,
    `code`  
) VALUES
    ('Aargau','AG'),
    ('Appenzell Ausserrhoden','AR'),
    ('Appenzell Innerrhoden','AI'),
    ('Basel-Landschaft','BL'),
    ('Basel-Stadt','BS'),
    ('Bern','BE'),
    ('Freiburg','FR'),
    ('Genf','GE'),
    ('Glarus','GL'),
    ('Graubünden','GR'),
    ('Jura','JU'),
    ('Luzern','LU'),
    ('Neuenburg','NE'),
    ('Nidwalden','NW'),
    ('Obwalden','OW'),
    ('St. Gallen','SG'),
    ('Schaffhausen','SH'),
    ('Schwyz','SZ'),
    ('Solothurn','SO'),
    ('Tessin','TI'),
    ('Thurgau','TG'),
    ('Uri','UR'),
    ('Waadt','VD'),
    ('Wallis','VS'),
    ('Zürich','ZH'),
    ('Zug','ZG');

-- -------------------------------------'
-- tourdb_new.areas (load regions first)
-- -------------------------------------
INSERT INTO `tourdb_new`.`areas` (
    `code`,
    `name`
)
SELECT 
    `regNameShort`,
    `regNameLong`
FROM `tourdb2_prod`.`tbl_regions`;

-- -----------------------------
-- tourdb_new.areas (load areas)
-- -----------------------------
INSERT INTO `tourdb_new`.`areas` (
    `fk_regionId`,
    `code`,
    `name`
)
SELECT 
    `tourdb_new`.`areas`.`areaId`,
    `tourdb2_prod`.`tbl_areas`.`areaNameShort`,
    `tourdb2_prod`.`tbl_areas`.`areaNameLong`
FROM `tourdb2_prod`.`tbl_areas`
JOIN `tourdb2_prod`.`tbl_regions` ON `tourdb2_prod`.`tbl_areas`.`areaRegionFID` = `tourdb2_prod`.`tbl_regions`.`regID`
JOIN `tourdb_new`.`areas` ON `tourdb2_prod`.`tbl_regions`.`regNameShort` = `tourdb_new`.`areas`.`code`;

-- --------------------------------------------------
-- tourdb_new.types (load types - fk_regionId = NULL)
-- --------------------------------------------------
INSERT INTO `tourdb_new`.`types` (
    `code`,
    `name`,
    `usage`
) 
SELECT 
 	`tourdb2_prod`.`tbl_types`.`typCode`,
	`tourdb2_prod`.`tbl_types`.`typName`,
	CAST(`tourdb2_prod`.`tbl_types`.`typPurpose` AS CHAR)
FROM `tourdb2_prod`.`tbl_types`
WHERE `tourdb2_prod`.`tbl_types`.`typParentId` IS NULL;

-- ---------------------------------------------------
-- tourdb_new.types (load types - fk_regionId <> NULL)
-- ---------------------------------------------------
INSERT INTO `types` (
    `code`,
    `name`,
    `fk_parentId`,
    `usage`
) 
SELECT 
 	`stype`.`typCode` AS stypeCode,
	`stype`.`typName` AS stypName,
	`ttype`.`typeId` AS newTypeId,
	`stype`.`typPurpose` AS stypeUsage
FROM `tourdb2_prod`.`tbl_types` AS `stype`
JOIN `tourdb2_prod`.`tbl_types` AS `ptype` ON `stype`.`typParentId` = `ptype`.`typId` 
JOIN `tourdb_new`.`types` AS ttype ON ptype.typCode = ttype.code
WHERE `stype`.`typParentId` IS NOT NULL;

-- -----------------
-- tourdb_new.grades
-- -----------------
-- TASK: 
-- - add type to table
INSERT INTO `tourdb_new`.`grades` (
    `code`,
    `group`,
    `level`,
    `uiiaEq`,
    `fk_typeId`,
    `sort`
) VALUES
    ('1', '1', 'I', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 10),
    ('2a', '2', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 20),
    ('2b', '2', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 24),
    ('2c', '2', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 26),
    ('3a', '3', 'III', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 30),
    ('3b', '3', 'III', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 34),
    ('3c', '3', 'III', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 36),
    ('4a', '4', 'IV', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 40),
    ('4b', '4', 'IV', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 44),
    ('4c', '4', 'IV', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 46),
    ('5a', '5', 'V', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 50),
    ('5b', '5', 'V', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 54),
    ('5c', '5', 'VI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 56),
    ('6a', '6', 'VI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 60),
    ('6a+', '6', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 62),
    ('6b', '6', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 64),
    ('6b+', '6', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 65),
    ('6c', '6', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 66),
    ('6c+', '6', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 68),
    ('7a', '7', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 70),
    ('7a+', '7', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 72),
    ('7b', '7', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 74),
    ('7b+', '7', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 75),
    ('7c', '7', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 76),
    ('7c+', '7', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 78),
    ('8a', '8', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 80),
    ('8a+', '8', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 82),
    ('8b', '8', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 84),
    ('8b+', '8', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 85),
    ('8c', '8', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 86),
    ('8c+', '8', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 88),
    ('9a', '9', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 90),
    ('9a+', '9', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 92),
    ('9b', '9', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 94),
    ('9b+', '9', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 95),
    ('9c', '9', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'fr_grd' ), 96),
    ('I', 'I', 'I', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 10),
    ('II-', 'II', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 20),
    ('II', 'II', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 24),
    ('II+', 'II', 'II', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 26),
    ('III-', 'III', 'III', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 30),
    ('III', 'III', 'III', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 34),
    ('III+', 'III', 'III', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 36),
    ('IV-', 'IV', 'IV', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 40),
    ('IV', 'IV', 'IV', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 44),
    ('IV+', 'IV', 'IV', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 46),
    ('V', 'V', 'V', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 50),
    ('V-', 'V', 'V', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 54),
    ('V+', 'V', 'V', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 56),
    ('VI', 'VI', 'VI', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 60),
    ('VI-', 'VI', 'VI', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 64),
    ('VI+', 'VI', 'VI', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 66),
    ('VII', 'VII', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 70),
    ('VII-', 'VII', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 74),
    ('VII+', 'VII', 'VII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 76),
    ('VIII', 'VIII', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 80),
    ('VIII-', 'VIII', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 84),
    ('VIII+', 'VIII', 'VIII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 86),
    ('IX-', 'IX', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 90),
    ('IX', 'IX', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 94),
    ('IX+', 'IX', 'IX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 96),
    ('X-', 'X', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 100),
    ('X', 'X', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 104),
    ('X+', 'X', 'X', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 106),
    ('XI-', 'XI', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 110),
    ('XI', 'XI', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 114),
    ('XI+', 'XI', 'XI', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 116),
    ('XII-', 'XII', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 120),
    ('XII', 'XII', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 124),
    ('XII+', 'XII', 'XII', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'uiia_grd' ), 126),
    ('E1', 'E1', 'E1', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 10),
    ('E2', 'E2', 'E2', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 20),
    ('E3', 'E3', 'E3', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 30),
    ('E4', 'E4', 'E4', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 40),
    ('E5', 'E5', 'E5', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 50),
    ('!1', '!1', '!1', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 60),
    ('!2', '!2', '!2', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 70),
    ('!3', '!3', '!3', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'ehaft' ), 80),
    ('WT1', 'WT1', 'WT1', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sst_grd' ), 10),
    ('WT2', 'WT2', 'WT2', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sst_grd' ), 20),
    ('WT3', 'WT3', 'WT3', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sst_grd' ), 30),
    ('WT4', 'WT4', 'WT4', 'IV', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sst_grd' ), 40),
    ('WT5', 'WT5', 'WT5', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sst_grd' ), 50),
    ('T1', 'T1', 'T1', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 10),
    ('T2', 'T2', 'T2', 'I', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 20),
    ('T3-', 'T3', 'T3', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 30),
    ('T3', 'T3', 'T3', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 34),
    ('T3+', 'T3', 'T3', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 36),
    ('T4-', 'T4', 'T4', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 40),
    ('T4', 'T4', 'T4', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 44),
    ('T4+', 'T4', 'T4', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 46),
    ('T5-', 'T5', 'T5', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 50),
    ('T5', 'T5', 'T5', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 54),
    ('T5+', 'T5', 'T5', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 56),
    ('T6-', 'T6', 'T6', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 60),
    ('T6', 'T6', 'T6', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 64),
    ('T6+', 'T6', 'T6', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 66),
    ('L-', 'L', 'L', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 100),
    ('L', 'L', 'L', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 104),
    ('L+', 'L', 'L', 'II', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 106),
    ('WS-', 'WS', 'WS-', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 110),
    ('WS', 'WS', 'WS', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 114),
    ('WS+', 'WS', 'WS+', 'III', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 116),
    ('ZS-', 'ZS', 'ZS-', 'VI', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 120),
    ('ZS', 'ZS', 'ZS', 'VI', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 124),
    ('ZS+', 'ZS', 'ZS+', 'VI', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 126),
    ('S-', 'SC', 'SC', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 130),
    ('S', 'SC', 'SC', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 134),
    ('S+', 'SC', 'SC', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 136),
    ('SS-', 'SS', 'SS', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 140),
    ('SS', 'SS', 'SS', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 144),
    ('SS+', 'SS', 'SS', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 146),
    ('AS', 'AS', 'AS', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 150),
    ('EX', 'EX', 'EX', 'V', (SELECT tourdb_new.types.typeId FROM tourdb_new.types WHERE tourdb_new.types.code = 'sac_grd' ), 160);

-- TASK: remove grades with all NULL values 

-- --------------------
-- tourdb_new.waypoints
-- --------------------
INSERT INTO `tourdb_new`.`waypoints` (
	`name`,
	`fk_typeId`,
	`fk_areaId`,
    `fk_regionId`,
	`canton`,
	`fk_countryId`,
	`altitude`,
	`owner`,
	`website`,
	`remarks`,
	`UIAA4000`,
	`fk_topOfCantonId`,
	`coordLV3Est`,
	`coordLV3Nord`,
	`coordWGS84E`,
	`coordWGS84N`,
	`crtDate`,
	`fk_crtUserId`,
	`updDate`,
	`fk_updUserId`,
    `origWaypId`
) 
SELECT
    IF(ISNULL(`tourdb2_prod`.`tbl_waypoints`.`waypNameLong`), `tourdb2_prod`.`tbl_waypoints`.`waypNameShort`,`tourdb2_prod`.`tbl_waypoints`.`waypNameLong`) AS name,
	`tourdb_new`.`types`.`typeId`,
	`tourdb_new`.`areas`.`areaId` AS area,
    IF(`regions`.`areaId` = 0, 1, `regions`.`areaId`) AS region,
	`tourdb2_prod`.`tbl_waypoints`.`waypCanton`,
	`tourdb_new`.`countries`.`countryId`,
	`tourdb2_prod`.`tbl_waypoints`.`waypAltitude`,
	`tourdb2_prod`.`tbl_waypoints`.`waypOwner`,
	`tourdb2_prod`.`tbl_waypoints`.`waypWebsite`,
	`tourdb2_prod`.`tbl_waypoints`.`waypRemarks`,
	`tourdb2_prod`.`tbl_waypoints`.`waypUIAA4000`,
	`tourdb_new`.`cantons`.`cantonId` AS 'topofcanton',
	`tourdb2_prod`.`tbl_waypoints`.`waypCoordLV3Est`,
	`tourdb2_prod`.`tbl_waypoints`.`waypCoordLV3Nord`,
	`tourdb2_prod`.`tbl_waypoints`.`waypCoordWGS84E`,
	`tourdb2_prod`.`tbl_waypoints`.`waypCoordWGS84N`,
	`tourdb2_prod`.`tbl_waypoints`.`waypCreatedDate`,
	1,
	`tourdb2_prod`.`tbl_waypoints`.`waypUpdatedDate`,
	1,
    `tourdb2_prod`.`tbl_waypoints`.`waypID`
FROM `tourdb2_prod`.`tbl_waypoints`
-- type
JOIN `tourdb2_prod`.`tbl_types` ON `tourdb2_prod`.`tbl_waypoints`.`waypTypeFid` = `tourdb2_prod`.`tbl_types`.`typId`
JOIN `tourdb_new`.`types` ON `tourdb2_prod`.`tbl_types`.`typCode` = `tourdb_new`.`types`.`code`
-- region
LEFT OUTER JOIN `tourdb2_prod`.`tbl_regions` ON `tourdb2_prod`.`tbl_waypoints`.`waypRegionFID` = `tourdb2_prod`.`tbl_regions`.`regID`
LEFT OUTER JOIN `tourdb_new`.`areas` AS regions ON `tourdb2_prod`.`tbl_regions`.`regNameShort` = regions.`code`
-- area
LEFT OUTER JOIN `tourdb2_prod`.`tbl_areas` ON `tourdb2_prod`.`tbl_waypoints`.`waypAreaFID` = `tourdb2_prod`.`tbl_areas`.`areaID`
LEFT OUTER JOIN `tourdb_new`.`areas` ON `tourdb2_prod`.`tbl_areas`.`areaNameShort` = `tourdb_new`.`areas`.`code`
-- country
LEFT OUTER JOIN `tourdb_new`.`countries` ON `tourdb2_prod`.`tbl_waypoints`.`waypCountry` = `tourdb_new`.`countries`.`code`
-- to of canton
LEFT OUTER JOIN `tourdb_new`.`cantons` ON tourdb2_prod.tbl_waypoints.waypToOfCant = tourdb_new.cantons.code;

-- ---------------
-- tourdb_new.part
-- ---------------
INSERT INTO `tourdb_new`.`participants` (
    `firstName`,
    `lastName`,
    `fk_userId`,
    `crtDate`,
    `fk_crtUserId`,
    `updDate`,
    `fk_updUserId`,
    `origPartId`
)
SELECT
    `prtFirstName`,
	`prtLastName`,
	1,
	`prtCreatedDate`,
    1,
	`prtUpdatedDate`,
    1,
    `prtId`
FROM `tourdb2_prod`.`tbl_part`
;
-- -----------------
-- tourdb_new.tracks
-- -----------------
INSERT INTO `tracks` (
	`name`,
	`route`,
	`fk_subtypeId`,
	`fk_gradeId`,
	`org`,
	`event`,
	`remarks`,
	`fk_countryId`,
	`distance`,
	`meterUp`,
	`meterDown`,
	`dateBegin`,
	`peakTime`,
	`lowTime`,
	`dateFinish`,
	`startEle`,
	`peakEle`,
	`lowEle`,
	`finishEle`,
	`fk_userId`,
	`coordinates`,
	`coordTop`,
	`coordBottom`,
	`coordLeft`,
	`coordRight`,
	`crtDate`,
	`fk_crtUserId`,
	`updDate`,
	`fk_updUserId`,
    `origTrkId`
)
SELECT 
	`trkTrackName`,
	`trkRoute`,
	`tourdb_new`.`types`.`typeId`,
 	`tourdb_new`.`grades`.`gradeId`,
	`trkOrg`,
	`trkEvent`,
	`trkRemarks`,
	`tourdb_new`.`countries`.countryId,
	`trkDistance`,
	`trkMeterUp`,
	`trkMeterDown`,
	`trkDateBegin`,
	`trkPeakTime`,
	`trkLowTime`,
	`trkDateFinish`,
	`trkStartEle`,
	`trkPeakEle`,
	`trkLowEle`,
	`trkFinishEle`,
	1,
	`trkCoordinates`,
	`trkCoordTop`,
	`trkCoordBottom`,
	`trkCoordLeft`,
	`trkCoordRight`,
	`trkCreatedDate`,
    1,
	`trkUpdatedDate`,
    1,
    `trkId`
FROM `tourdb2_prod`.`tbl_tracks`
-- type
LEFT OUTER JOIN `tourdb2_prod`.`tbl_types` ON `tourdb2_prod`.`tbl_tracks`.`trkSubtypeFid` = `tourdb2_prod`.`tbl_types`.`typId`
LEFT OUTER JOIN `tourdb_new`.`types` ON `tourdb2_prod`.`tbl_types`.`typCode` = `tourdb_new`.`types`.`code` 
AND `tourdb_new`.`types`.`fk_parentId` IS NOT NULL 

-- grade
LEFT OUTER JOIN `tourdb2_prod`.`tbl_grades` ON `tourdb2_prod`.`tbl_tracks`.`trkGrade` = `tourdb2_prod`.`tbl_grades`.`grdCodeID`
LEFT OUTER JOIN `tourdb_new`.`grades` ON `tourdb2_prod`.`tbl_grades`.`grdCodeID` = `tourdb_new`.`grades`.`code`
-- country
LEFT OUTER JOIN `tourdb_new`.`countries` ON `tourdb2_prod`.`tbl_tracks`.`trkCountry` = `tourdb_new`.`countries`.`code`;

-- ---------------------
-- tourdb_new.track_part
-- ---------------------
-- TASK: remove records in source where trkId or partId does not exist anymore
INSERT INTO `tourdb_new`.`track_part` (
	`fk_trackId`,
	`fk_partId`,
	`crtDate`,
	`fk_crtUserId`,
	`updDate`,
	`fk_updUserId`
)
SELECT 
	`tourdb_new`.`tracks`.`trackId`,
	`tourdb_new`.`participants`.`participantId`,
	`trpaCreatedDate`,
    1,
	`trpapdatedDate`,
    1
FROM tourdb2_prod.tbl_track_part
JOIN tourdb_new.tracks ON tbl_track_part.trpaTrkId = tourdb_new.tracks.origTrkId
JOIN tourdb_new.participants ON tbl_track_part.trpaPartId = tourdb_new.participants.origPartId;


-- ---------------------
-- tourdb_new.track_wayp
-- ---------------------
-- TASK: remove records in source where trkId or waypId does not exist anymore
INSERT INTO `tourdb_new`.`track_wayp` (
	`fk_trackId`,
	`fk_waypId`,
    `reached`, 
	`crtDate`,
	`fk_crtUserId`,
	`updDate`,
	`fk_updUserId`
)
SELECT 
	`tourdb_new`.`tracks`.`trackId`,
	`tourdb_new`.`waypoints`.`waypointId`,
    `trwpReached_f`,
	`trwpCreatedDate`,
    1,
	`trwpUpdatedDate`,
    1
FROM tourdb2_prod.tbl_track_wayp
JOIN tourdb_new.tracks ON tbl_track_wayp.trwpTrkId = tourdb_new.tracks.origTrkId
JOIN tourdb_new.waypoints ON tbl_track_wayp.trwpWaypId = tourdb_new.waypoints.origWaypId;

-- ------------------
-- tourdb_new.sources
-- ------------------
INSERT INTO `tourdb_new`.`sources` (
	`code`,
	`name`,
	`remarks`
)
SELECT 
    `srcCode`,
	`srcName`,
	`srcRemarks`
FROM tourdb2_prod.tbl_sources;

-- -------------------
-- tourdb_new.segments
-- -------------------
INSERT INTO `tourdb_new`.`segments` (
	`segName`,
	`routeName`,
    `fk_typeId`,
 	`fk_countryId`,
 	`fk_cantonId`,
 	`fk_areaId`,
	`fk_gradeId`,
	`fk_climbGradeId`,
	`firn`,
	`fk_ehaftId`,
	`expo`,
	`rockShare`,
	`startTargetTime`,
	`targetEndTime`,
	`MUStartTarget`, `MDStartTarget`, `MUTargetEnd`, `MDTargetEnd`,
	`fk_startLocId`,
	`fk_targetLocId`,
	`fk_finishLocId`,
	`remarks`,
	`fk_sourceId`,
	`sourceRef`,
	`coordinates`, `coordTop`, `coordBottom`, `coordLeft`, `coordRight`,
	`crtDate`, `fk_crtUserId`, `updDate`, `fk_updUserId`,
    `origSegId`
)
SELECT 
   `segName`,
	`segRouteName`,
	`tourdb_new`.`types`.`typeId`,
	`countries`.`countryId`,
	`cantons`.`cantonId`,
	`areas`.`areaId`,
	`grades`.`gradeId` AS 'grade',
	`clGrd`.`gradeId` AS 'climb_grade',
	`segFirn`,
	`ehaft`.`gradeId` AS 'ehaft',
	`segExpo`,
	`segRockShare`,
	`segTStartTarget`,
	`segTTargetEnd`,
	`segMUStartTarget`,
	`segMDStartTarget`,
	`segMUTargetEnd`,
	`segMDTargetEnd`,
	`segStartLoc`.`waypointId` AS 'startloc',
	`segTargetLoc`.`waypointId` AS 'targetloc',
	`segFinishLoc`.`waypointId` AS 'finishloc',
	`segRemarks`,
   `tourdb_new`.`sources`.`sourceId`,
	`segSourceRef`,
	`segCoordinates`, `segCoordTop`, `segCoordBottom`, `segCoordLeft`, `segCoordRight`,
	`segCreatedDate`, 1, `segUpdatedDate`, 1,
	`segId`
FROM `tourdb2_prod`.`tbl_segments`
-- type
JOIN `tourdb2_prod`.`tbl_types` ON `tourdb2_prod`.`tbl_segments`.`segTypeFid` = `tourdb2_prod`.`tbl_types`.`typId`
JOIN `tourdb_new`.`types` ON `tourdb2_prod`.`tbl_types`.`typCode` = `tourdb_new`.`types`.`code`AND `types`.`usage`= 'seg'
-- country
LEFT OUTER JOIN `tourdb_new`.`countries` ON `tourdb2_prod`.`tbl_segments`.`segCountry` = `countries`.`code`
-- canton
LEFT OUTER JOIN `tourdb_new`.`cantons` ON `tourdb2_prod`.`tbl_segments`.`segCanton` = `cantons`.`code`
-- area
LEFT OUTER JOIN `tourdb2_prod`.`tbl_areas` ON `tourdb2_prod`.`tbl_segments`.`segAreaFID` = `tourdb2_prod`.`tbl_areas`.`areaID`
LEFT OUTER JOIN `tourdb_new`.`areas` ON `tourdb2_prod`.`tbl_areas`.`areaNameShort` = `tourdb_new`.`areas`.`code`
-- grade
LEFT OUTER JOIN `tourdb_new`.`grades` ON `tourdb2_prod`.`tbl_segments`.`segGradeFID` = `tourdb_new`.`grades`.`code`
-- climbing grade
LEFT OUTER JOIN `tourdb_new`.`grades` clGrd ON `tourdb2_prod`.`tbl_segments`.`segClimbGradeFID` = clGrd.`code`
-- Ernsthaftigkeit
LEFT OUTER JOIN `tourdb_new`.`grades` ehaft ON `tourdb2_prod`.`tbl_segments`.`segEhaft` = `ehaft`.`code`
-- segStartLocationFID
LEFT OUTER JOIN `tourdb2_prod`.`tbl_waypoints` segStartLoc_o  ON `tourdb2_prod`.`tbl_segments`.`segStartLocationFID` = segStartLoc_o.waypID
LEFT OUTER JOIN tourdb_new.waypoints segStartLoc ON segStartLoc.name = segStartLoc_o.waypNameLong
-- segTargetLocationFID
LEFT OUTER JOIN `tourdb2_prod`.`tbl_waypoints` segTargetLoc_o ON `tourdb2_prod`.`tbl_segments`.`segTargetLocationFID` = segTargetLoc_o.waypID
LEFT OUTER JOIN tourdb_new.waypoints segTargetLoc ON segTargetLoc.name = segTargetLoc_o.waypNameLong 
-- segFinishLocationFID
LEFT OUTER JOIN `tourdb2_prod`.`tbl_waypoints` segFinishLoc_o ON `tourdb2_prod`.`tbl_segments`.`segFinishLocationFID` = segFinishLoc_o.waypID
LEFT OUTER JOIN tourdb_new.waypoints segFinishLoc ON segFinishLoc.name = segFinishLoc_o.waypNameLong 
-- segSourceFID
LEFT OUTER JOIN tourdb_new.sources ON tourdb2_prod.tbl_segments.segSourceFID = tourdb_new.sources.code ;



