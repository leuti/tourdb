-- =====================
-- == Check migration ==
-- =====================

-- STATUS
-- ------
-- kmlstyles: check missing
-- users: check missing
-- areas: check OK
-- types: check OK
-- waypoints: topOfCantons not in table waypoints
-- participants: check OK
-- tracks: grades not correct
-- track_part: two duplicates
-- track_wayp: check OK
-- segments: check OK
-- sources: check missing

-- --------------------------------
-- Migrate data for table kmlstyles
-- --------------------------------

-- ----------------------------
-- Migrate data for table users
-- ----------------------------

-- ----------------
-- tourdb_new.areas
-- ----------------
SELECT `region`, `area`, COUNT(1) AS counter
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
GROUP BY `region`, `area`, `name`
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

-- --------------------
-- tourdb_new.waypoints
-- --------------------
SELECT `source`, `origWaypId`,`name`,`type`,`area`,`region`,`canton`,`country`,`altitude`,`owner`,`web`,`remarks`,
		 `4000er`,`topofcanton`,`lv3e`,`lv3n`,`wgs84e`,`wgs84n`,`crtdate`,`update`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		`waypId` AS 'origWaypId',
		`waypNameLong` AS 'name',
		`tbl_types`.`typCode` AS 'type',
		tbl_areas.areaNameShort AS 'area',
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
		`waypUpdatedDate` AS 'update'
	FROM tourdb2_prod.tbl_waypoints
	LEFT OUTER JOIN tourdb2_prod.tbl_types ON tbl_waypoints.waypTypeFid = tbl_types.typId
	LEFT OUTER JOIN tourdb2_prod.tbl_areas ON tbl_waypoints.waypAreaFID = tbl_areas.areaID
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
		`updDate` AS 'update'
	FROM tourdb_new.waypoints
	LEFT OUTER JOIN tourdb_new.types ON fk_typeId = types.typeId
	LEFT OUTER JOIN tourdb_new.areas ON fk_areaId = areas.areaId
	LEFT OUTER JOIN tourdb_new.areas regions ON waypoints.fk_regionId = regions.areaId
	LEFT OUTER JOIN tourdb_new.countries ON fk_countryId = countries.countryId
	LEFT OUTER JOIN tourdb_new.cantons ON fk_toOfCantonId = cantons.cantonId
	ORDER BY `origWaypId`, `name`, `type`
) AS `union` 
GROUP BY `origWaypId`,`name`,`type`,`area`,`region`,`canton`,`country`,`altitude`,`owner`,`web`,`remarks`,
		 `4000er`,`topofcanton`,`lv3e`,`lv3n`,`wgs84e`,`wgs84n`,`crtdate`,`update`
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
	FROM `tourdb_new`.`participants`
	ORDER BY origPartId, source
) AS `union` 
GROUP BY `origPartId`, `firstname`, `lastname`, `partUsr`
HAVING `counter` <> 2;	

-- -----------------
-- tourdb_new.tracks
-- -----------------
SELECT `source`, `origTrkId`, `name`, `route`, `subtype`, `type`, `grade`,
		`org`, `event`, `remarks`, `country`, `distance`,`meterup`,
		`meterdown`,`datebegin`,`peaktime`,`lowtime`,`datefinish`,
		`startele`,`peakele`,`lowele`,`finishele`,`coord`,
		`coordtop`,`coordbottom`,`coordleft`,`coordright`, COUNT(1) AS counter
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
SELECT `source`, `segName`, `routeName`,`type`, `country`, `canton`, `area`, `grade`, `clGrade`, `firn`,
		`ehaft`, `expo`, `rockShare`, `TTargetEnd`, `MDStartTarget`, 
		`MUTargetEnd`, `MDTargetEnd`, `startLoc`, `targetLoc`, `remarks`,
		`quelle`, `sourceRef`, `coord`, `coordTop`, `coordBottom`, 
		`coordLeft`, `coordRight`, `origSegId`, COUNT(1) AS counter
FROM (
	SELECT 
		'old' AS 'source',
		`segName` AS 'segName',
		`segRouteName` AS 'routeName',
		`tourdb2_prod`.`tbl_types`.`typCode` AS 'type',
		`segCountry` AS 'country',
		`segCanton` AS 'canton',
		`tourdb2_prod`.`tbl_areas`.`areaNameShort` AS 'area',
		IF( `segGradeFID` = '??', NULL, `segGradeFID`) AS 'grade',
		IF( ISNULL(`segClimbGradeFID`), '', `segClimbGradeFID`) AS 'clGrade',
		`segFirn` AS 'firn',
		IF( ISNULL(`segEhaft`), '', `segEhaft`) AS 'ehaft',
		`segExpo` AS 'expo',
		`segRockShare` AS 'rockShare',
		`segTStartTarget` AS 'TStartTarget', `segTTargetEnd` AS 'TTargetEnd',
		`segMUStartTarget` AS 'MUStartTarget',	`segMDStartTarget` AS 'MDStartTarget', 
		`segMUTargetEnd` AS 'MUTargetEnd', `segMDTargetEnd` AS 'MDTargetEnd',
		`startLoc`.`waypNameLong` AS 'startLoc', `targetLoc`.`waypNameLong` AS 'targetLoc', `finishLoc`.`waypNameLong` AS 'finishLoc',
		`segRemarks` AS 'remarks',
		`segSourceFID` AS 'quelle', `segSourceRef` AS 'sourceRef',
		`segCoordinates` AS 'coord', `segCoordTop` AS 'coordTop', `segCoordBottom` AS 'coordBottom', 
		`segCoordLeft` AS 'coordLeft', `segCoordRight` AS 'coordRight',
		`segId` AS 'origSegId'
	FROM `tourdb2_prod`.`tbl_segments`
	-- types
	LEFT OUTER JOIN tourdb2_prod.tbl_types ON tourdb2_prod.tbl_segments.segTypeFid = tourdb2_prod.tbl_types.typId 
	-- areas
	LEFT OUTER JOIN tourdb2_prod.tbl_areas ON tourdb2_prod.tbl_segments.segAreaFID = tourdb2_prod.tbl_areas.areaID
	-- Start Location 
	LEFT OUTER JOIN tourdb2_prod.tbl_waypoints startLoc ON tourdb2_prod.tbl_segments.segStartLocationFID = startLoc.waypID
	-- Target Location 
	LEFT OUTER JOIN tourdb2_prod.tbl_waypoints targetLoc ON tourdb2_prod.tbl_segments.segTargetLocationFID = targetLoc.waypID
	-- Finish Location 
	LEFT OUTER JOIN tourdb2_prod.tbl_waypoints finishLoc ON tourdb2_prod.tbl_segments.segFinishLocationFID = finishLoc.waypID

	UNION ALL SELECT
		'new' AS 'source',
		`segName` AS 'segName',
		`routeName` AS 'routeName',
		`tourdb_new`.`types`.`code` AS 'type',
		`tourdb_new`.`countries`.`code` AS 'country',
		IF( ISNULL(`tourdb_new`.`cantons`.`code`), '', `tourdb_new`.`cantons`.`code`) AS 'canton',
		`tourdb_new`.`areas`.`code` AS 'area',
		`tourdb_new`.`grades`.`code` AS 'grade',
		IF( ISNULL(`clGrades`.`code`), '', `clGrades`.`code`) AS 'clGrade',
		`firn` AS 'firn',
		IF( ISNULL(`ehaft`.`code`), '', `ehaft`.`code`) AS 'ehaft',
		`expo` AS 'expo',
		`rockShare` AS 'rockShare',
		`startTargetTime` AS 'TStartTarget',`targetEndTime` AS 'TTargetEnd',
		`MUStartTarget` AS 'MUStartTarget', `MDStartTarget` AS 'MDStartTarget', 
		`MUTargetEnd` AS 'MUTargetEnd', `MDTargetEnd` AS 'MDTargetEnd',
		`startLoc`.`name` AS 'startLoc', 
		`targetLoc`.`name` AS 'targetLoc', 
		`finishLoc`.`name` AS 'finishLoc',
		`tourdb_new`.`segments`.`remarks` AS 'remarks',
		tourdb_new.sources.code AS 'quelle', `sourceRef` AS 'sourceRef',
		`coordinates` AS 'coord', `coordTop` AS 'coordTop', `coordBottom` AS 'coordBottom', 
		`coordLeft` AS 'coordLeft', `coordRight` AS 'coordRight',
		`origSegId` AS 'origSegId'
	FROM `tourdb_new`.`segments`
	-- types
	LEFT OUTER JOIN tourdb_new.types ON tourdb_new.segments.fk_typeId = tourdb_new.types.typeId
	-- country
	LEFT OUTER  JOIN tourdb_new.countries ON tourdb_new.segments.fk_countryId = tourdb_new.countries.countryId
	-- canton
	LEFT OUTER  JOIN tourdb_new.cantons ON tourdb_new.segments.fk_cantonId = tourdb_new.cantons.cantonId
	-- areas
	LEFT OUTER  JOIN tourdb_new.areas ON tourdb_new.segments.fk_areaId = tourdb_new.areas.areaId
	-- grade
	LEFT OUTER  JOIN tourdb_new.grades ON tourdb_new.segments.fk_gradeId = tourdb_new.grades.gradeId
	-- climbing grade
	LEFT OUTER  JOIN tourdb_new.grades clGrades ON tourdb_new.segments.fk_climbGradeId = clGrades.gradeId
	-- Ernsthaftigkeit
	LEFT OUTER  JOIN tourdb_new.grades ehaft ON tourdb_new.segments.fk_ehaftId = ehaft.gradeId
	-- Start loaction 
	LEFT OUTER  JOIN tourdb_new.waypoints startLoc ON tourdb_new.segments.fk_startLocId = startLoc.waypointId
	-- Target loaction 
	LEFT OUTER  JOIN tourdb_new.waypoints targetLoc ON tourdb_new.segments.fk_targetLocId = targetLoc.waypointId
	-- Finish loaction 
	LEFT OUTER  JOIN tourdb_new.waypoints finishLoc ON tourdb_new.segments.fk_finishLocId = finishLoc.waypointId
	-- Source
	LEFT OUTER  JOIN tourdb_new.sources ON tourdb_new.segments.fk_sourceId = tourdb_new.sources.sourceId
) AS `union` 
GROUP BY `segName`, `routeName`,`type`, `country`, `canton`, `area`, `grade`, `clGrade`, `firn`,
		`ehaft`, `expo`, `rockShare`, `TTargetEnd`, `MDStartTarget`, 
		`MUTargetEnd`, `MDTargetEnd`, `startLoc`, `targetLoc`, `remarks`,
		`quelle`, `sourceRef`, `coord`, `coordTop`, `coordBottom`, 
		`coordLeft`, `coordRight`, `origSegId`
HAVING `counter` <> 2;	

-- ------------------
-- tourdb_new.sources
-- ------------------
