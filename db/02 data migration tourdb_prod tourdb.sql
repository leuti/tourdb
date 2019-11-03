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
FROM `tourdb_prod`.`tbl_kmlstyle`; 

-- ----------------------------
-- Migrate data for table users
-- ----------------------------
-- ToDo:
-- - Change email to unique value

INSERT INTO `tourdb_new`.`users` (
    `userId`,
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
    `usrId`,
    `usrLogin`,
    `usrFirstName`,
    `usrLastName`,
    `usrEmail`,
    `usrPasswd`,
    `usrCreatedDate`,
    ( SELECT usrId FROM `tourdb_prod`.`tbl_users` WHERE `usrLogin` = 'LEUT' ),
    `usrUpdatedDate`,
    ( SELECT usrId FROM `tourdb_prod`.`tbl_users` WHERE `usrLogin` = 'LEUT' )
FROM `tourdb_prod`.`tbl_users`;

-- ----------------------
-- Create table countries
-- ----------------------
INSERT INTO `tourdb_new`.`countries` (
    `name`,
    `ISOcode`
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
FROM `tourdb_prod`.`tbl_regions`;

-- -----------------------------
-- tourdb_new.areas (load areas)
-- -----------------------------
INSERT INTO `tourdb_new`.`areas` (
    `fk_parentId`,
    `code`,
    `name`
)
SELECT 
    `tourdb_new`.`areas`.`areaId`,
    `tourdb_prod`.`tbl_areas`.`areaNameShort`,
    `tourdb_prod`.`tbl_areas`.`areaNameLong`
FROM `tourdb_prod`.`tbl_areas`
JOIN `tourdb_prod`.`tbl_regions` ON `tourdb_prod`.`tbl_areas`.`areaRegionFID` = `tourdb_prod`.`tbl_regions`.`regID`
JOIN `tourdb_new`.`areas` ON `tourdb_prod`.`tbl_regions`.`regNameShort` = `tourdb_new`.`areas`.`code`;

-- --------------------------------------------------
-- tourdb_new.types (load types - fk_parentId = NULL)
-- --------------------------------------------------
INSERT INTO `tourdb_new`.`types` (
    `code`,
    `name`,
    `usage`
) 
SELECT 
 	`tourdb_prod`.`tbl_types`.`typCode`,
	`tourdb_prod`.`tbl_types`.`typName`,
	`tourdb_prod`.`tbl_types`.`typPurpose`
FROM `tourdb_prod`.`tbl_types`
WHERE `tourdb_prod`.`tbl_types`.`typParentId` IS NULL;

-- ---------------------------------------------------
-- tourdb_new.types (load types - fk_parentId <> NULL)
-- ---------------------------------------------------
-- TASKS:
-- - remove COLATE FROM TABLE (added because join did not work otherwise)
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
FROM `tourdb_prod`.`tbl_types` AS `stype`
JOIN `tourdb_prod`.`tbl_types` AS `ptype` ON `stype`.`typParentId` = `ptype`.`typId` 
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
    `sort`
)
SELECT 
    `tourdb_prod`.`tbl_grades`.`grdCodeID`,
    `tourdb_prod`.`tbl_grades`.`grdGroup`,
    `tourdb_prod`.`tbl_grades`.`grdSort`
FROM `tourdb_prod`.`tbl_grades`;

-- --------------------
-- tourdb_new.waypoints
-- --------------------

-- ---------------
-- tourdb_new.part
-- ---------------

-- -----------------
-- tourdb_new.tracks
-- -----------------

-- ---------------------
-- tourdb_new.track_part
-- ---------------------

-- ---------------------
-- tourdb_new.track_wayp
-- ---------------------

-- -------------------
-- tourdb_new.segments
-- -------------------

-- ------------------
-- tourdb_new.sources
-- ------------------
