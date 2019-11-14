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

-- ****************************
-- *****   T  A   S   K   *****
-- ****************************
-- Change Unique ID from tableId to id (e.g. cantonId to Id) --> including all indices
-- Change name of indices to tbl_field


-- Database structure for new tourdb
CREATE DATABASE IF NOT EXISTS `tourdb_new` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `tourdb_new`;

-- =============================================
-- Level 1 tables - required to be created first
-- =============================================

-- --------------------
-- tourdb_new.kmlStyles
-- --------------------
CREATE TABLE IF NOT EXISTS `kmlStyles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `colorNormal` varchar(8) NOT NULL,
  `widthNormal` int(11) NOT NULL,
  `lineNormal` varchar(30) DEFAULT NULL,
  `colorHighlighted` varchar(8) DEFAULT NULL,
  `widthHighlighted` int(11) DEFAULT NULL,
  `lineHighlighted` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ----------------
-- tourdb_new.users
-- ----------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique Id of table',
  `login` varchar(50) NOT NULL COMMENT 'Login the user enters to access the db',
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwd` blob NOT NULL COMMENT 'password encrypted (aes)',
  `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
  `fk_crtUserId` int(11) NOT NULL,
  `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fk_updUserId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `login` UNIQUE (`login`),
  CONSTRAINT `email` UNIQUE (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- --------------------
-- tourdb_new.countries
-- --------------------
CREATE TABLE IF NOT EXISTS `countries` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(2) NOT NULL,  
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `code` UNIQUE (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ------------------
-- tourdb_new.cantons
-- ------------------
CREATE TABLE IF NOT EXISTS `cantons` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(2) NOT NULL,  
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ----------------
-- tourdb_new.areas
-- ----------------
CREATE TABLE IF NOT EXISTS `areas` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `fk_regionId` int(11) DEFAULT NULL,
    `code` varchar(10) NOT NULL,
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ----------------
-- tourdb_new.types
-- ----------------
CREATE TABLE IF NOT EXISTS `types` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique Primary Id',
    `code` varchar(10) NOT NULL COMMENT 'Code of Type (e.g. SST)',
    `name` varchar(50) NOT NULL,
    `fk_parentId` int(11) DEFAULT NULL COMMENT 'Points to partent type if subtype',
    `usage` varchar(10) NOT NULL COMMENT 'Tracks, Waypoints, Segments',
    PRIMARY KEY (`id`),
    CONSTRAINT `types_ifk_parentId`
        FOREIGN KEY (`fk_parentId`)
        REFERENCES `types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Collects all types and subtypes for tracks, waypoints, segs';

-- -----------------
-- tourdb_new.grades
-- -----------------
CREATE TABLE IF NOT EXISTS `grades` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `code` varchar(10) NOT NULL COMMENT 'Code of grade',
    `group` varchar(10) NOT NULL COMMENT 'Group of grade (without +/-',
    `uiiaEq` varchar(10) NOT NULL COMMENT 'UIIA equivalent of grade',
    `level` varchar(10) NOT NULL COMMENT 'Difficulty level of grade',
    `fk_typeId` int(11) NOT NULL COMMENT 'Type of grade',
    `sort` int(11) DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `grades_ifk_typeId`
         FOREIGN KEY (`fk_typeId`)
         REFERENCES `types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- --------------------
-- tourdb_new.waypoints
-- --------------------
CREATE TABLE IF NOT EXISTS `waypoints` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) DEFAULT NULL,
    `fk_typeId` int(11) NOT NULL,
    `fk_areaId` int(11) DEFAULT NULL,
    `fk_regionId` int(11) DEFAULT NULL,
    `canton` varchar(10) DEFAULT NULL,
    `fk_countryId` int(11) DEFAULT NULL,
    `altitude` int(11) NOT NULL DEFAULT 0,
    `owner` varchar(50) DEFAULT NULL,
    `website` varchar(255) DEFAULT NULL,
    `remarks` varchar(1024) DEFAULT NULL,
    `UIAA4000` tinyint(1) DEFAULT 0,
    `fk_topOfCantonId` int(11) DEFAULT NULL,
    `coordLV3Est` int(11) DEFAULT NULL,
    `coordLV3Nord` int(11) DEFAULT NULL,
    `coordWGS84E` double DEFAULT NULL,
    `coordWGS84N` double DEFAULT NULL,
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    `origWaypId` int(11) NOT NULL COMMENT 'Required for migation - to be deleted',
    PRIMARY KEY (`id`),
    CONSTRAINT `wayp_ifk_typeId`
        FOREIGN KEY (`fk_typeId`)
        REFERENCES `types` (`id`),
    CONSTRAINT `wayp_ifk_regionId`
        FOREIGN KEY (`fk_regionId`)
        REFERENCES `areas` (`id`),
    CONSTRAINT `wayp_ifk_areaId`
        FOREIGN KEY (`fk_areaId`)
        REFERENCES `areas` (`id`),
    CONSTRAINT `wayp_ifk_countryId`
        FOREIGN KEY (`fk_countryId`)
        REFERENCES `countries` (`id`),
    CONSTRAINT `wayp_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `wayp_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ---------------
-- tourdb_new.part
-- ---------------
CREATE TABLE IF NOT EXISTS `participants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `firstName` varchar(30) DEFAULT NULL,
    `lastName` varchar(30) DEFAULT NULL,
    `fk_userId` int(11) NOT NULL ,
    `crtDate` timestamp NULL DEFAULT current_timestamp(),
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    `origPartId` int(11) NOT NULL COMMENT 'Required for migation - to be deleted',
    PRIMARY KEY (`id`),
    CONSTRAINT `part_ifk_userId`
        FOREIGN KEY (`fk_userId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `part_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `part_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- -----------------
-- tourdb_new.tracks
-- -----------------
CREATE TABLE IF NOT EXISTS `tracks` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) DEFAULT NULL COMMENT 'Target of the track',
    `route` varchar(1024) DEFAULT NULL COMMENT 'Key waypoints on the route',
    `fk_subtypeId` int(11) NOT NULL,
    `fk_gradeId` int(11) DEFAULT NULL COMMENT 'Schwierigkeitsgrad',
    `org` varchar(50) DEFAULT NULL COMMENT 'Type of organisation',
    `event` varchar(50) DEFAULT NULL COMMENT 'Type of event',
    `remarks` varchar(1024) DEFAULT NULL COMMENT 'Remarks',
    `fk_areaId` int(11) DEFAULT NULL COMMENT 'Area',
    `fk_countryId` int(11) DEFAULT NULL COMMENT 'Country',
    `distance` decimal(7,3) DEFAULT NULL COMMENT 'Distance in km',
    `meterUp` decimal(8,3) DEFAULT NULL COMMENT 'Meters ascended',
    `meterDown` decimal(8,3) DEFAULT NULL COMMENT 'Meters descended',
    `dateBegin` datetime NOT NULL COMMENT 'Content of GPX gpx->metadata->time>',
    `peakTime` time DEFAULT NULL,
    `lowTime` time DEFAULT NULL,
    `dateFinish` datetime DEFAULT NULL COMMENT 'End time of track recording',
    `startEle` int(5) DEFAULT NULL,
    `peakEle` int(5) DEFAULT NULL,
    `lowEle` int(5) DEFAULT NULL,
    `finishEle` int(5) DEFAULT NULL,
    `fk_userId` int(11) NOT NULL COMMENT 'ID of user creating the track',
    `coordinates` longtext NOT NULL,
    `coordTop` int(11) NOT NULL COMMENT 'Y coord of northern most point of track',
    `coordBottom` int(11) NOT NULL COMMENT 'Y coord of southern most point of track',
    `coordLeft` int(11) NOT NULL COMMENT 'X coord of western most point of track',
    `coordRight` int(11) NOT NULL COMMENT 'X coord of easter most point of track',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    `origTrkId` int(11) NOT NULL COMMENT 'Required for migation - to be deleted',
    PRIMARY KEY (`id`),
    CONSTRAINT `trk_ifk_subtypeId`
        FOREIGN KEY (`fk_subtypeId`)
        REFERENCES `types` (`id`),
    CONSTRAINT `trk_ifk_gradeId`
        FOREIGN KEY (`fk_gradeId`)
        REFERENCES `grades` (`id`),
    CONSTRAINT `trk_ifk_areaId`
        FOREIGN KEY (`fk_areaId`)
        REFERENCES `areas` (`id`),
    CONSTRAINT `trk_ifk_countryId`
        FOREIGN KEY (`fk_countryId`)
        REFERENCES `countries` (`id`),
    CONSTRAINT `trk_ifk_userId`
        FOREIGN KEY (`fk_userId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `trk_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `trk_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ---------------------
-- tourdb_new.track_part
-- ---------------------
CREATE TABLE IF NOT EXISTS `track_part` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
    `fk_trackId` int(11) NOT NULL COMMENT 'ID of related track',
    `fk_participantId` int(11) NOT NULL COMMENT 'ID of participant',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `trkpart_ifk_trackId`
        FOREIGN KEY (`fk_trackId`)
        REFERENCES `tracks` (`id`),
    CONSTRAINT `trkpart_ifk_participantId`
        FOREIGN KEY (`fk_participantId`)
        REFERENCES `participants` (`id`),
    CONSTRAINT `trkpart_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `trkpart_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Table links tracks with waypoints';

-- ---------------------
-- tourdb_new.track_wayp
-- ---------------------
CREATE TABLE IF NOT EXISTS `track_wayp` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
    `fk_trackId` int(11) NOT NULL COMMENT 'ID of related track',
    `fk_waypointId` int(11) NOT NULL COMMENT 'ID of waypoint',
    `reached` tinyint(1) NOT NULL COMMENT 'True if reached',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `trkwayp_ifk_trackId`
        FOREIGN KEY (`fk_trackId`)
        REFERENCES `tracks` (`id`),
    CONSTRAINT `trkwayp_ifk_waypointId`
        FOREIGN KEY (`fk_waypointId`)
        REFERENCES `waypoints` (`id`),
    CONSTRAINT `trkwayp_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `trkwayp_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Table links tracks with waypoints';

-- ------------------
-- tourdb_new.sources
-- ------------------
CREATE TABLE IF NOT EXISTS `sources` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `code` varchar(50) NOT NULL,
    `name` varchar(255) DEFAULT NULL,
    `remarks` varchar(1024) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- -------------------
-- tourdb_new.segments
-- -------------------
CREATE TABLE IF NOT EXISTS `segments` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `segName` varchar(255) DEFAULT NULL COMMENT 'Name of Segment',
    `routeName` varchar(255) DEFAULT NULL COMMENT 'Name of Route',
    `fk_typeId` int(11) NOT NULL,
    `fk_countryId` int(11) DEFAULT NULL,
    `fk_cantonId` int(11) DEFAULT NULL,
    `fk_areaId` int(11) DEFAULT NULL COMMENT 'Geographical area (in CH the SAC areas are used)',
    `fk_gradeId` int(11) DEFAULT NULL COMMENT 'Overall grade - Reference is SAC grade (''Hochtourenskala'')',
    `fk_climbGradeId` int(11) DEFAULT NULL COMMENT 'Climbing Grade',
    `firn` varchar(10) DEFAULT NULL COMMENT 'Steepness of firn ice',
    `fk_ehaftId` int(11) DEFAULT NULL COMMENT 'Ernsthaftigkeit --> Seriousness of Route (as given by the source)',
    `expo` text NOT NULL COMMENT 'Exposition',
    `rockShare` int(11) DEFAULT NULL COMMENT 'Share of rock contact in relation to overall tour',
    `startTargetTime` time DEFAULT NULL COMMENT 'Estimated time from start to target location',
    `targetEndTime` time DEFAULT NULL COMMENT 'Time required for the descend',
    `MUStartTarget` int(11) DEFAULT NULL COMMENT 'Asc/desc meters between start and target',
    `MDStartTarget` int(11) DEFAULT NULL,
    `MUTargetEnd` int(11) DEFAULT NULL,
    `MDTargetEnd` int(11) DEFAULT NULL,
    `fk_startLocId` int(11) DEFAULT NULL COMMENT 'Starting point of segment',
    `fk_targetLocId` int(11) DEFAULT NULL COMMENT 'Target location of segment',
    `fk_finishLocId` int(11) DEFAULT NULL COMMENT 'End location of segment',
    `remarks` varchar(1024) DEFAULT NULL,
    `fk_sourceId` int(11) NOT NULL COMMENT 'ID of the source',
    `sourceRef` varchar(20) NOT NULL COMMENT 'Reference or ID from the source',
    `coordinates` longtext DEFAULT NULL COMMENT 'Coordinates (WGS84) to create tracks',
    `coordTop` int(11) NOT NULL COMMENT 'Y coord of northern most point of segments',
    `coordBottom` int(11) NOT NULL COMMENT 'Y coord of southern most point of segments',
    `coordLeft` int(11) NOT NULL COMMENT 'X coord of western most point of segments',
    `coordRight` int(11) NOT NULL COMMENT 'X coord of easter most point of segments',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    `origSegId` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `seg_ifk_typeId`
        FOREIGN KEY (`fk_typeId`)
        REFERENCES `types` (`id`),
    CONSTRAINT `seg_ifk_countryId`
        FOREIGN KEY (`fk_countryId`)
        REFERENCES `countries` (`id`),
    CONSTRAINT `seg_ifk_cantonId`
        FOREIGN KEY (`fk_cantonId`)
        REFERENCES `cantons` (`id`),    
    CONSTRAINT `seg_ifk_areaId`
        FOREIGN KEY (`fk_areaId`)
        REFERENCES `areas` (`id`),    
    CONSTRAINT `seg_ifk_gradeId`
        FOREIGN KEY (`fk_gradeId`)
        REFERENCES `grades` (`id`),
    CONSTRAINT `seg_ifk_climbGradeId`
        FOREIGN KEY (`fk_climbGradeId`)
        REFERENCES `grades` (`id`),
    CONSTRAINT `seg_ifk_ehaftId`
        FOREIGN KEY (`fk_ehaftId`)
        REFERENCES `grades` (`id`),    
    CONSTRAINT `seg_ifk_startLocId`
        FOREIGN KEY (`fk_startLocId`)   
        REFERENCES `waypoints` (`id`),    
    CONSTRAINT `seg_ifk_targetLocId`
        FOREIGN KEY (`fk_targetLocId`)
        REFERENCES `waypoints` (`id`),    
    CONSTRAINT `seg_ifk_finishLocId`
        FOREIGN KEY (`fk_finishLocId`)
        REFERENCES `waypoints` (`id`),
    CONSTRAINT `seg_ifk_sourceId`
        FOREIGN KEY (`fk_sourceId`)
        REFERENCES `sources` (`id`),
    CONSTRAINT `seg_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`id`),
    CONSTRAINT `seg_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`id`)  
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
