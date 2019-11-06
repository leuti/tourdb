-- =====================
-- == Check migration ==
-- =====================


-- ---------------------------------
-- Migrate data for table kmlstyles'
-- ---------------------------------

-- ----------------------------
-- Migrate data for table users
-- ----------------------------

-- ----------------
-- tourdb_new.areas
-- ----------------

-- Display differences
SELECT `region`, `area`, COUNT(1) AS counter
FROM (
	SELECT 
		"old" AS source,
		tourdb2_prod.tbl_regions.regNameShort AS `region`,
		null AS `area`,
		tourdb2_prod.tbl_regions.regNameLong AS `name`
	FROM tourdb2_prod.tbl_regions
	UNION SELECT 
		"old" AS source,
		tourdb2_prod.tbl_regions.regNameShort AS `region`,
		tourdb2_prod.tbl_areas.areaNameShort AS `area`,
		tourdb2_prod.tbl_areas.areaNameLong AS `name`
	FROM tourdb2_prod.tbl_regions
	JOIN tourdb2_prod.tbl_areas ON tourdb2_prod.tbl_regions.regID = tourdb2_prod.tbl_areas.areaRegionFID
	UNION SELECT 
		"new" AS SOURCE,
		IF(ISNULL(tourdb_new.areas.fk_regionId), tourdb_new.areas.code, regions.code)  AS `region`,
		IF(ISNULL(tourdb_new.areas.fk_regionId), regions.code, tourdb_new.areas.code) AS `area`,
		tourdb_new.areas.name AS `name`
	FROM tourdb_new.areas
	left outer JOIN tourdb_new.areas regions ON tourdb_new.areas.fk_regionId = regions.areaId
	ORDER BY region, AREA, source
) AS `union` 
GROUP BY `region`, `area`
HAVING `counter` <> 2;

-- ----------------
-- tourdb_new.types
-- ----------------

-- Display only differences
SELECT `type`, `name`, `parent`, `purpose`, COUNT(1) AS counter
FROM (
	SELECT 
			"old" AS source,
			tourdb2_prod.tbl_types.typCode AS `type`,
			tourdb2_prod.tbl_types.typName AS `name`,
			ptype.typCode AS `parent`,
			tourdb2_prod.tbl_types.typPurpose AS `purpose`
		FROM tourdb2_prod.tbl_types
		left OUTER JOIN tourdb2_prod.tbl_types ptype ON tourdb2_prod.tbl_types.typParentId = ptype.typId
		
		-- types (new)
		UNION ALL SELECT 
			"new" AS source,
			tourdb_new.types.code AS `type`,
			tourdb_new.types.name AS `name`,
			ptype.code AS `parent`,
			types.usage AS `purpose`
		FROM tourdb_new.types
		left outer JOIN tourdb_new.types ptype ON tourdb_new.types.fk_parentId = ptype.typeId
		ORDER BY `parent`, `type`, `source`
) AS `union` 
GROUP BY `type`, `name`, `parent`, `purpose`
HAVING `counter` <> 2;

-- -----------------
-- tourdb_new.grades
-- -----------------
-- TODO:
-- - add type to compare

-- Display only differences
SELECT `code`, `group`, `sort`, COUNT(1) AS counter
FROM (
	SELECT 
		"old" AS `source`,
		`grdCodeID` AS `code`,
		`grdGroup` AS `group`,
	--	`grdType` AS `type`,
		`grdSort` AS `sort`
	FROM tourdb2_prod.tbl_grades
	UNION ALL SELECT 
		"new" AS `source`,
		`grades`.`code` AS `code`,
		`group` AS `group`,
	--	`tourdb_new`.`types`.`code` AS `type`,
		`sort` AS `sort`
	FROM tourdb_new.grades
	left outer JOIN tourdb_new.types ON fk_typeId = types.typeId
	ORDER BY `code`, `source`
) AS `union` 
GROUP BY `code`, `group`, `sort`
HAVING `counter` <> 2;

-- --------------------
-- tourdb_new.waypoints
-- --------------------

-- Display only differences
SELECT `origWaypId`, `name`, `type`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		`waypId` AS 'origWaypId',
		`waypNameLong` AS 'name',
		`tbl_types`.`typCode` AS 'type',
		`waypAreaFID` AS 'area',
		`tbl_regions`.`regNameShort` AS 'region',
		`waypCanton` AS 'canton',
		`waypCountry` AS 'country',
		`waypAltitude` AS 'altitude',
		`waypOwner` AS 'owner',
		`waypWebsite` AS 'web',
		`waypRemarks` AS 'remarks',
		`waypUIAA4000` AS '4000er',
		IF(`waypToOfCant` = '0' OR `waypToOfCant` = '', NULL, `waypToOfCant`)  AS 'topofcanton',
		`waypCoordLV3Est` AS 'lv3e',
		`waypCoordLV3Nord` AS 'lv3n',
		`waypCoordWGS84E` AS 'wgs84e',
		`waypCoordWGS84N` AS 'wgs84n',
		`waypCreatedDate` AS 'crtdate',
		`waypUpdatedDate` AS 'upddate'
	FROM tourdb2_prod.tbl_waypoints
	LEFT OUTER JOIN tourdb2_prod.tbl_types ON tbl_waypoints.waypTypeFid = tbl_types.typId
	LEFT OUTER JOIN tourdb2_prod.tbl_regions ON tbl_waypoints.waypRegionFID = tbl_regions.regId

	UNION ALL SELECT 
		'new' AS 'source',
		`origWaypId` AS 'origWaypId',
		`waypoints`.`name` AS 'name',
		`types`.`code` AS 'type',
		`areas`.`code` AS 'area',
		`regions`.`code` AS 'region',
		`canton` AS 'canton',
		`countries`.`code` AS 'country',
		`altitude` AS 'altitude',
		`owner` AS 'owner',
		`website` AS 'web',
		`remarks` AS 'remarks',
		`UIAA4000` AS '4000er',
		`topOfCanton` AS 'topofcanton',
		`coordLV3Est` AS 'lv3e',
		`coordLV3Nord` AS 'lv3n',
		`coordWGS84E` AS 'wgs84e',
		`coordWGS84N` AS 'wgs84n',
		`crtDate` AS 'crtdate',
		`updDate` AS 'upddate'
	FROM tourdb_new.waypoints
	left outer JOIN tourdb_new.types ON fk_typeId = types.typeId
	left outer JOIN tourdb_new.areas ON fk_areaId = areas.areaId
	left outer JOIN tourdb_new.areas regions ON waypoints.fk_regionId = regions.areaId
	left outer JOIN tourdb_new.countries ON fk_countryId = countries.countryId
	ORDER BY `origWaypId`, `name`, `type`
) AS `union` 
GROUP BY `origWaypId`, `name`, `type`
HAVING `counter` <> 2;	

-- ---------------
-- tourdb_new.part
-- ---------------

-- Display only differences
SELECT `origPartId`, COUNT(1) AS counter
FROM (
	SELECT
		'old' AS 'source',
		`prtId` AS 'origPartId', 
		`prtFirstName` AS 'firstname',
		`prtLastName` AS 'lastname',
		`partUsrId` AS 'partUsr'
	FROM  `tourdb2_prod`.`tbl_part`
	UNION ALL SELECT 
		'new' AS 'source',
		`origPartId` AS 'origPartId',
		`firstName` AS 'firstname',
		`lastName` AS 'lastname',
		`fk_userId` AS 'partUsr'
	FROM `participants`
	ORDER BY origPartId, source
) AS `union` 
GROUP BY `origPartId`, `firstname`, `lastname`, `partUsr`
HAVING `counter` <> 2;	

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
