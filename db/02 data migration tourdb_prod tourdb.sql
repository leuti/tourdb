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
    ( SELECT `tourdb_new`.`userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
    `usrUpdatedDate`,
    ( SELECT `tourdb_new`.`userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' )
FROM `tourdb_prod`.`tbl_users`;

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
	`topOfCanton`,
	`coordLV3Est`,
	`coordLV3Nord`,
	`coordWGS84E`,
	`coordWGS84N`,
	`crtDate`,
	`fk_crtUserId`,
	`updDate`,
	`fk_updUserId`
) 
SELECT
    IF(ISNULL(`tourdb_prod`.`tbl_waypoints`.`waypNameLong`), `tourdb_prod`.`tbl_waypoints`.`waypNameShort`,`tourdb_prod`.`tbl_waypoints`.`waypNameLong`) AS name,
	`tourdb_new`.`types`.`typeId`,
	`tourdb_new`.`areas`.`areaId` AS area,
    IF(`regions`.`areaId` = 0, 1, `regions`.`areaId`) AS region,
	`tourdb_prod`.`tbl_waypoints`.`waypCanton`,
	`tourdb_new`.`countries`.`countryId`,
	`tourdb_prod`.`tbl_waypoints`.`waypAltitude`,
	`tourdb_prod`.`tbl_waypoints`.`waypOwner`,
	`tourdb_prod`.`tbl_waypoints`.`waypWebsite`,
	`tourdb_prod`.`tbl_waypoints`.`waypRemarks`,
	`tourdb_prod`.`tbl_waypoints`.`waypUIAA4000`,
	IF(`tourdb_prod`.`tbl_waypoints`.`waypToOfCant` = 0, NULL, `tourdb_prod`.`tbl_waypoints`.`waypToOfCant`),
	`tourdb_prod`.`tbl_waypoints`.`waypCoordLV3Est`,
	`tourdb_prod`.`tbl_waypoints`.`waypCoordLV3Nord`,
	`tourdb_prod`.`tbl_waypoints`.`waypCoordWGS84E`,
	`tourdb_prod`.`tbl_waypoints`.`waypCoordWGS84N`,
	`tourdb_prod`.`tbl_waypoints`.`waypCreatedDate`,
	( SELECT `tourdb_new`.`userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
	`tourdb_prod`.`tbl_waypoints`.`waypUpdatedDate`,
	( SELECT `tourdb_new`.`userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' )
	
FROM `tourdb_prod`.`tbl_waypoints`
-- type
JOIN `tourdb_prod`.`tbl_types` ON `tourdb_prod`.`tbl_waypoints`.`waypTypeFid` = `tourdb_prod`.`tbl_types`.`typId`
JOIN `tourdb_new`.`types` ON `tourdb_prod`.`tbl_types`.`typCode` = `tourdb_new`.`types`.`code`
-- region
LEFT OUTER JOIN `tourdb_prod`.`tbl_regions` ON `tourdb_prod`.`tbl_waypoints`.`waypRegionFID` = `tourdb_prod`.`tbl_regions`.`regID`
LEFT OUTER JOIN `tourdb_new`.`areas` AS regions ON `tourdb_prod`.`tbl_regions`.`regNameShort` = regions.`code`
-- area
LEFT OUTER JOIN `tourdb_prod`.`tbl_areas` ON `tourdb_prod`.`tbl_waypoints`.`waypAreaFID` = `tourdb_prod`.`tbl_areas`.`areaID`
LEFT OUTER JOIN `tourdb_new`.`areas` ON `tourdb_prod`.`tbl_areas`.`areaNameShort` = `tourdb_new`.`areas`.`code`
-- country
LEFT OUTER JOIN `tourdb_new`.`countries` ON `tourdb_prod`.`tbl_waypoints`.`waypCountry` = `tourdb_new`.`countries`.`code`
;

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
    `fk_updUserId`
)
SELECT
    `prtFirstName`,
	`prtLastName`,
	( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
	`prtCreatedDate`,
    ( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
	`prtUpdatedDate`,
    ( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' )
FROM `tourdb_prod`.`tbl_part`
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
	`fk_updUserId`
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
	( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
	`trkCoordinates`,
	`trkCoordTop`,
	`trkCoordBottom`,
	`trkCoordLeft`,
	`trkCoordRight`,
	`trkCreatedDate`,
    ( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' ),
	`trkUpdatedDate`,
    ( SELECT `userId` FROM `tourdb_new`.`users` WHERE `login` = 'LEUT' )
FROM `tourdb_prod`.`tbl_tracks`
-- type
LEFT OUTER JOIN `tourdb_prod`.`tbl_types` ON `tourdb_prod`.`tbl_tracks`.`trkSubtypeFid` = `tourdb_prod`.`tbl_types`.`typId`
LEFT OUTER JOIN `tourdb_new`.`types` ON `tourdb_prod`.`tbl_types`.`typCode` = `tourdb_new`.`types`.`code` 
AND `tourdb_new`.`types`.`fk_parentId` IS NOT NULL 

-- grade
LEFT OUTER JOIN `tourdb_prod`.`tbl_grades` ON `tourdb_prod`.`tbl_tracks`.`trkGrade` = `tourdb_prod`.`tbl_grades`.`grdCodeID`
LEFT OUTER JOIN `tourdb_new`.`grades` ON `tourdb_prod`.`tbl_grades`.`grdCodeID` = `tourdb_new`.`grades`.`code`
-- country
LEFT OUTER JOIN `tourdb_new`.`countries` ON `tourdb_prod`.`tbl_tracks`.`trkCountry` = `tourdb_new`.`countries`.`code`;

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
