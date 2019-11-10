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
SELECT `region `area COUNT(1) AS counter
FROM (
	SELECT 
		"old" AS source,
		tourdb2_prod.tbl_regions.regNameShort AS `region`,
		null AS `area`,
		tourdb2_prod.tbl_regions.regNameLong AS `name`
	FROM tourdb2_prod.tbl_regions
	UNION ALL SELECT 
		"old" AS source,
		tourdb2_prod.tbl_regions.regNameShort AS `region`,
		tourdb2_prod.tbl_areas.areaNameShort AS `area`,
		tourdb2_prod.tbl_areas.areaNameLong AS `name`
	FROM tourdb2_prod.tbl_regions
	JOIN tourdb2_prod.tbl_areas ON tourdb2_prod.tbl_regions.regID = tourdb2_prod.tbl_areas.areaRegionFID
	UNION ALL SELECT 
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
-- TASK:
-- add type to compare
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
SELECT `origTrkId`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		`trkId` AS 'origTrkId',
		`trkTrackName` AS 'name',
		`trkRoute` AS 'route',
		`tbl_types`.`typCode` AS 'type',
		`subtypes`.`typCode` AS 'subtype',
		IF(`trkGrade` = '', NULL, `trkGrade`)  AS 'grade',
		`trkOrg` AS 'org',
		`trkEvent` AS 'event',
		`trkRemarks` AS 'remarks',
		`trkCountry` AS 'country',
		`trkDistance` AS 'distance',
		`trkMeterUp` AS 'meterup',
		`trkMeterDown` AS 'meterdown',
		`trkDateBegin` AS 'datebegin',
		`trkPeakTime` AS 'peaktime',
		`trkLowTime` AS 'lowtime',
		`trkDateFinish` AS 'datefinish',
		`trkStartEle` AS 'startele',
		`trkPeakEle` AS 'peakele',
		`trkLowEle` AS 'lowele',
		`trkFinishEle` AS 'finishele',
		`trkCoordinates` AS 'coord',
		`trkCoordTop` AS 'coordtop',
		`trkCoordBottom` AS 'coordbottom',
		`trkCoordLeft` AS 'coordleft', 
		`trkCoordRight` AS 'coordright'
	FROM tourdb2_prod.tbl_tracks
	-- types
	LEFT OUTER JOIN tourdb2_prod.tbl_types ON tbl_tracks.trkTypeFid = tbl_types.typId
	-- subtypes
	LEFT OUTER	JOIN tourdb2_prod.tbl_types subtypes ON tbl_tracks.trkSubtypeFid = subtypes.typId

	UNION ALL SELECT
		'new' AS 'source',
		`tourdb_new`.`tracks`.`origTrkId` AS 'origTrkId',
		`tourdb_new`.`tracks`.`name` AS 'name',
		`tourdb_new`.`tracks`.`route` AS 'route',
		`ptype`.`code` AS 'subtype',
		`stype`.`code` AS 'type',
		`grades`.`code` AS 'grade',
		`tourdb_new`.`tracks`.`org` AS 'org',
		`tourdb_new`.`tracks`.`event` AS 'event',
		`tourdb_new`.`tracks`.`remarks` AS 'remarks',
		`countries`.`code` AS 'country',
		`tourdb_new`.`tracks`.`distance` AS 'distance',
		`tourdb_new`.`tracks`.`meterUp`  AS 'meterup',
		`tourdb_new`.`tracks`.`meterDown` AS 'meterdown',
		`tourdb_new`.`tracks`.`dateBegin` AS 'datebegin',
		`tourdb_new`.`tracks`.`peakTime` AS 'peaktime',
		`tourdb_new`.`tracks`.`lowTime` AS 'lowtime',
		`tourdb_new`.`tracks`.`dateFinish` AS 'datefinish',
		`tourdb_new`.`tracks`.`startEle` AS 'startele',
		`tourdb_new`.`tracks`.`peakEle` AS 'peakele',
		`tourdb_new`.`tracks`.`lowEle` AS 'lowele',
		`tourdb_new`.`tracks`.`finishEle` AS 'finishele',
		`tourdb_new`.`tracks`.`coordinates` AS 'coord',
		`tourdb_new`.`tracks`.`coordTop` AS 'coordtop',
		`tourdb_new`.`tracks`.`coordBottom` AS 'coordbottom',
		`tourdb_new`.`tracks`.`coordLeft` AS 'coordleft',
		`tourdb_new`.`tracks`.`coordRight` AS 'coordright'
	FROM tourdb_new.tracks
	-- subtype
	LEFT OUTER JOIN tourdb_new.types stype ON tourdb_new.tracks.fk_subtypeId = stype.typeId
	-- type
	LEFT OUTER JOIN tourdb_new.types ptype ON stype.fk_parentId = ptype.typeId
	-- grade
	LEFT OUTER JOIN tourdb_new.grades ON tourdb_new.tracks.fk_gradeId = grades.gradeId
	-- country
	LEFT OUTER JOIN tourdb_new.countries ON tourdb_new.tracks.fk_countryId = countries.countryId

	ORDER BY origTrkId, source
) AS `union` 
GROUP BY `origTrkId`, `name`, `route`, `subtype`, `type`, `grade`,
		`org`, `event`, `remarks`, `country`, `distance`,`meterup`,
		`meterdown`,`datebegin`,`peaktime`,`lowtime`,`datefinish`,
		`startele`,`peakele`,`lowele`,`finishele`,`coord`,
		`coordtop`,`coordbottom`,`coordleft`,`coordright`
HAVING `counter` <> 2;	


-- ---------------------
-- tourdb_new.track_part
-- ---------------------
SELECT `origTrkId`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		tbl_tracks.trkId AS 'origtrkid',
		tourdb2_prod.tbl_tracks.trkTrackName AS 'name',
		tourdb2_prod.tbl_part.prtFirstName AS 'firstname',
		tourdb2_prod.tbl_part.prtLastName AS 'lastname' 
	FROM tourdb2_prod.tbl_track_part
	JOIN tourdb2_prod.tbl_tracks ON tourdb2_prod.tbl_track_part.trpaTrkId = tourdb2_prod.tbl_tracks.trkId
	JOIN tourdb2_prod.tbl_part ON tourdb2_prod.tbl_part.prtId = tourdb2_prod.tbl_track_part.trpaPartId

	UNION ALL SELECT 
		'new' AS 'source',
		tracks.origTrkId AS 'origtrkid',
		tracks.name AS 'name',
		participants.firstName AS 'firstname',
		participants.lastName AS 'lastname' 
	FROM tourdb_new.track_part 
	JOIN tourdb_new.tracks ON tourdb_new.tracks.trackId = track_part.fk_trackId
	JOIN tourdb_new.participants ON tourdb_new.participants.participantId = track_part.fk_partId
	ORDER BY origtrkid, firstname, lastname, source
) AS `union` 
GROUP BY `origTrkId`, `name`, `firstname`, `lastname`
HAVING `counter` <> 2;	

-- ---------------------
-- tourdb_new.track_wayp
-- ---------------------
SELECT `origTrkId`, `trackname`, `waypointname`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		tbl_tracks.trkId AS 'origtrkid',
		tourdb2_prod.tbl_tracks.trkTrackName AS 'trackname',
		tourdb2_prod.tbl_waypoints.waypNameLong AS 'waypointname'
	FROM tourdb2_prod.tbl_track_wayp
	JOIN tourdb2_prod.tbl_tracks ON tourdb2_prod.tbl_track_wayp.trwpTrkId = tourdb2_prod.tbl_tracks.trkId
	JOIN tourdb2_prod.tbl_waypoints ON tourdb2_prod.tbl_waypoints.waypId = tourdb2_prod.tbl_track_wayp.trwpWaypId

	UNION ALL SELECT 
		'new' AS 'source',
		tracks.origTrkId AS 'origtrkid',
		tracks.name AS 'trackname',
		waypoints.name AS 'waypointname'
	FROM tourdb_new.track_wayp 
	JOIN tourdb_new.tracks ON tourdb_new.tracks.trackId = track_wayp.fk_trackId
	JOIN tourdb_new.waypoints ON tourdb_new.waypoints.waypointId = track_wayp.fk_waypId
	ORDER BY origtrkid, trackname, waypointname, source
) AS `union` 
GROUP BY `origTrkId`, `trackname`, `waypointname`
HAVING `counter` <> 2;	


-- -------------------
-- tourdb_new.segments
-- -------------------

-- ------------------
-- tourdb_new.sources
-- ------------------
