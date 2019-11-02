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
CREATE DATABASE IF NOT EXISTS `tourdb_new` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `tourdb_new`;

-- ---------------------------------------------
-- Level 1 tables - required to be created first
-- ---------------------------------------------

-- tourdb_new.kmlStyles
CREATE TABLE IF NOT EXISTS `kmlStyles` (
  `kmlstyleId` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `styColorNormal` varchar(8) NOT NULL,
  `styWidthNormal` int(11) NOT NULL,
  `styLineNormal` varchar(30) DEFAULT NULL,
  `styColorHighlighted` varchar(8) DEFAULT NULL,
  `styWidthHighlighted` int(11) DEFAULT NULL,
  `styLineHighlighted` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`kmlstyleId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.users
CREATE TABLE IF NOT EXISTS `users` (
  `userId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique Id of table',
  `login` varchar(50) NOT NULL COMMENT 'Login the user enters to access the db',
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwd` blob NOT NULL COMMENT 'password encrypted (aes)',
  `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
  `fk_crtUserId` int(11) NOT NULL,
  `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fk_updUserId` int(11) NOT NULL,
  PRIMARY KEY (`userId`),
  CONSTRAINT `login_UNIQUE` UNIQUE (`login`),
  CONSTRAINT `email_UNIQUE` UNIQUE (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.countries
CREATE TABLE IF NOT EXISTS `countries` (
    `countryId` int(11) NOT NULL AUTO_INCREMENT,
    `ISOcode` VARCHAR(2) NOT NULL,  
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`countryId`),
    CONSTRAINT `ISOcode_UNIQUE` UNIQUE (`ISOcode`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.cantons
CREATE TABLE IF NOT EXISTS `cantons` (
    `cantonId` int(11) NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(2) NOT NULL,  
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`cantonId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.areas
CREATE TABLE IF NOT EXISTS `areas` (
    `areaId` int(11) NOT NULL AUTO_INCREMENT,
    `fk_parentId` int(11) DEFAULT NULL,
    `code` varchar(10) NOT NULL,
    `name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`areaId`),
    CONSTRAINT `area_ifk_parentId`
        FOREIGN KEY (`fk_parentId`)
        REFERENCES `areas` (`areaId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.types
CREATE TABLE IF NOT EXISTS `types` (
    `typeId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique Primary Id',
    `code` varchar(10) NOT NULL COLLATE 'utf32_general_ci' COMMENT 'Code of Type (e.g. SST)',
    `name` varchar(50) NOT NULL,
    `fk_parentId` int(11) DEFAULT NULL COMMENT 'Points to partent type if subtype',
    `usage` varchar(10) NOT NULL COMMENT 'Tracks, Waypoints, Segments',
    PRIMARY KEY (`typeId`),
    CONSTRAINT `types_ifk_parentId`
        FOREIGN KEY (`fk_parentId`)
        REFERENCES `types` (`typeId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Collects all types and subtypes for tracks, waypoints, segs';

-- tourdb_new.grades
CREATE TABLE IF NOT EXISTS `grades` (
    `gradeId` int(11) NOT NULL AUTO_INCREMENT,
    `code` varchar(10) NOT NULL,
    `group` varchar(10) DEFAULT NULL,
    `fk_typeId` int(11) DEFAULT NULL,
    `sort` int(11) DEFAULT NULL,
    PRIMARY KEY (`gradeId`),
    CONSTRAINT `grades_ifk_typeId`
        FOREIGN KEY (`fk_typeId`)
        REFERENCES `types` (`typeId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.waypoints
CREATE TABLE IF NOT EXISTS `waypoints` (
    `waypointId` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) DEFAULT NULL,
    `fk_typeId` int(11) NOT NULL,
    `fk_areaId` int(11) DEFAULT NULL,
    `fk_cantonId` int(11) DEFAULT NULL,
    `fk_countryId` int(11) DEFAULT NULL,
    `altitude` int(11) NOT NULL DEFAULT 0,
    `owner` varchar(50) DEFAULT NULL,
    `website` varchar(255) DEFAULT NULL,
    `remarks` varchar(1024) DEFAULT NULL,
    `UIAA4000` tinyint(1) DEFAULT NULL,
    `fk_toOfCantonId` int(11) NOT NULL,
    `coordLV3Est` int(11) DEFAULT NULL,
    `coordLV3Nord` int(11) DEFAULT NULL,
    `coordWGS84E` double DEFAULT NULL,
    `coordWGS84N` double DEFAULT NULL,
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`waypointId`),
    CONSTRAINT `wayp_ifk_typeId`
        FOREIGN KEY (`fk_typeId`)
        REFERENCES `types` (`typeId`),
    CONSTRAINT `wayp_ifk_areaId`
        FOREIGN KEY (`fk_areaId`)
        REFERENCES `areas` (`areaId`),
    CONSTRAINT `wayp_ifk_cantonId`
        FOREIGN KEY (`fk_cantonId`)
        REFERENCES `cantons` (`cantonId`),
    CONSTRAINT `wayp_ifk_countryId`
        FOREIGN KEY (`fk_countryId`)
        REFERENCES `countries` (`countryId`),
    CONSTRAINT `wayp_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `wayp_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.part
CREATE TABLE IF NOT EXISTS `participants` (
    `partId` int(11) NOT NULL AUTO_INCREMENT,
    `firstName` varchar(30) DEFAULT NULL,
    `lastName` varchar(30) DEFAULT NULL,
    `fk_userId` int(11) NOT NULL ,
    `crtDate` timestamp NULL DEFAULT current_timestamp(),
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`partId`),
    CONSTRAINT `part_ifk_userId`
        FOREIGN KEY (`fk_userId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `part_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `part_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.tracks
CREATE TABLE IF NOT EXISTS `tracks` (
    `trackId` int(11) NOT NULL AUTO_INCREMENT,
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
    PRIMARY KEY (`trackId`),
    CONSTRAINT `trk_ifk_subtypeId`
        FOREIGN KEY (`fk_subtypeId`)
        REFERENCES `types` (`typeId`),
    CONSTRAINT `trk_ifk_gradeId`
        FOREIGN KEY (`fk_gradeId`)
        REFERENCES `grades` (`gradeId`),
    CONSTRAINT `trk_ifk_areaId`
        FOREIGN KEY (`fk_areaId`)
        REFERENCES `areas` (`areaId`),
    CONSTRAINT `trk_ifk_countryId`
        FOREIGN KEY (`fk_countryId`)
        REFERENCES `countries` (`countryId`),
    CONSTRAINT `trk_ifk_userId`
        FOREIGN KEY (`fk_userId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `trk_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `trk_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.track_part
CREATE TABLE IF NOT EXISTS `track_part` (
    `trackPartId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
    `fk_trackId` int(11) NOT NULL COMMENT 'ID of related track',
    `fk_partId` int(11) NOT NULL COMMENT 'ID of participant',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`trackPartId`),
    CONSTRAINT `trkpart_ifk_trackId`
        FOREIGN KEY (`fk_trackId`)
        REFERENCES `tracks` (`trackId`),
    CONSTRAINT `trkpart_ifk_partId`
        FOREIGN KEY (`fk_partId`)
        REFERENCES `participants` (`partId`),
    CONSTRAINT `trkpart_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `trkpart_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Table links tracks with waypoints';

-- tourdb_new.track_wayp
CREATE TABLE IF NOT EXISTS `track_wayp` (
    `trackWaypId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
    `fk_trackId` int(11) NOT NULL COMMENT 'ID of related track',
    `fk_waypId` int(11) NOT NULL COMMENT 'ID of waypoint',
    `reached` tinyint(1) NOT NULL COMMENT 'True if reached',
    `crtDate` timestamp NULL DEFAULT current_timestamp() COMMENT 'Created Timestamp',
    `fk_crtUserId` int(11) NOT NULL,
    `updDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `fk_updUserId` int(11) NOT NULL,
    PRIMARY KEY (`trackWaypId`),
    CONSTRAINT `trkwayp_ifk_trackId`
        FOREIGN KEY (`fk_trackId`)
        REFERENCES `tracks` (`trackId`),
    CONSTRAINT `trkwayp_ifk_waypId`
        FOREIGN KEY (`fk_waypId`)
        REFERENCES `waypoints` (`waypointId`),
    CONSTRAINT `trkwayp_ifk_crtUserId`
        FOREIGN KEY (`fk_crtUserId`)
        REFERENCES `users` (`userId`),
    CONSTRAINT `trkwayp_ifk_updUserId`
        FOREIGN KEY (`fk_updUserId`)
        REFERENCES `users` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COMMENT='Table links tracks with waypoints';

-- tourdb_new.segments
CREATE TABLE IF NOT EXISTS `segments` (
  `segmentId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `routeName` varchar(255) DEFAULT NULL COMMENT 'Name of Route',
  `fk_typeId` int(11) NOT NULL,
  `fk_countryId` int(11) NOT NULL,
  `fk_cantonId` int(11) NOT NULL,
  `fk_areaId` int(11) DEFAULT NULL COMMENT 'Geographical area (in CH the SAC areas are used)',
  `fk_gradeId` int(11) NOT NULL COMMENT 'Overall grade - Reference is SAC grade (''Hochtourenskala'')',
  `fk_climbGradeId` int(11) DEFAULT NULL COMMENT 'Climbing Grade',
  `firn` varchar(10) DEFAULT NULL COMMENT 'Steepness of firn ice',
  `ernsthaft` varchar(10) DEFAULT NULL COMMENT 'Ernsthaftigkeit --> Seriousness of Route (as given by the source)',
  `expo` text NOT NULL COMMENT 'Exposition',
  `rockShare` int(11) DEFAULT NULL COMMENT 'Share of rock contact in relation to overall tour',
  `startTargetTime` time DEFAULT NULL COMMENT 'Estimated time from start to target location',
  `targetEndTime` time DEFAULT NULL COMMENT 'Time required for the descend',
  `MUStartTarget` int(11) DEFAULT NULL COMMENT 'Asc/desc meters between start and target',
  `MDStartTarget` int(11) DEFAULT NULL,
  `MUTargetEnd` int(11) DEFAULT NULL,
  `MDTargetEnd` int(11) DEFAULT NULL,
  `fk_startLocationId` int(11) NOT NULL COMMENT 'Starting point of segment',
  `fk_targetLocationId` int(11) NOT NULL COMMENT 'Target location of segment',
  `fk_finishLocationId` int(11) DEFAULT NULL COMMENT 'End location of segment',
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
  PRIMARY KEY (`segmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- tourdb_new.sources
CREATE TABLE IF NOT EXISTS `sources` (
  `sourceId` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `remarks` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`sourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
