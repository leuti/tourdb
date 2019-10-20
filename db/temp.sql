SELECT 
    trk.trkId,
    trk.trkTrackName,
    trk.trkRoute,
    trk.trkDateBegin,
    trk.trkDateFinish,
    typ.typCode,
    styp.typCode,
    trk.trkOrg,
    trk.trkEvent,
    trk.trkRemarks,
    trk.trkDistance,
    trk.trkTimeOverall,
    trk.trkTimeToPeak,
    trk.trkTimeToFinish,
    trk.trkMeterUp,
    trk.trkMeterDown,
    trk.trkCountry,
    trk.trkUsrId
FROM tbl_tracks trk 
INNER JOIN tbl_types typ ON typ.typId = trk.trkTypeFid
INNER JOIN tbl_types styp ON styp.typId = trk.trkSubtypeFid
LIMIT 20;




SELECT trkId, trkGrade from tbl_tracks;

-- select track + participants
SELECT t.trkId, t.trkTrackName, GROUP_CONCAT(CONCAT(p.prtFirstName, ' ', p.prtLastName)  SEPARATOR ', ') as participants
FROM tbl_tracks t
JOIN tbl_track_part tp ON t.trkId = tp.trpaTrkId
JOIN tbl_part p ON tp.trpaPartId = p.prtId
GROUP BY tp.trpaTrkId

-- select track + participants + waypoints
SELECT t.trkId, t.trkTrackName, GROUP_CONCAT(CONCAT(p.prtFirstName, ' ', p.prtLastName)  SEPARATOR ', ') as participants, GROUP_CONCAT(wayp.waypNameLong SEPARATOR ', ') as peaks 
FROM tbl_tracks t
JOIN tbl_track_part tp ON t.trkId = tp.trpaTrkId
JOIN tbl_part p ON tp.trpaPartId = p.prtId
JOIN tbl_track_wayp tw ON t.trkId = tw.trwpTrkId
JOIN tbl_waypoints wayp ON tw.trwpWaypID = wayp.waypID
GROUP BY tp.trpaTrkId

-- select track + participants + waypoints (unique)
SELECT t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry, 
                GROUP_CONCAT(DISTINCT tp.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT tw.waypNameLong SEPARATOR ', ') AS waypoints 
            FROM tbl_tracks t
            JOIN tbl_types typ ON t.trkTypeFid = typ.typId
            JOIN tbl_types styp ON t.trkSubtypeFid = styp.typId
            LEFT OUTER JOIN (
                SELECT tp.trpaTrkId, CONCAT(p.prtFirstName, ' ', p.prtLastName) AS part
                FROM tbl_track_part tp 
                JOIN tbl_part p ON tp.trpaPartId = p.prtId
                ) AS tp
            ON t.trkId = tp.trpaTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpTrkId = wayp.waypID
                ) AS tw
            ON t.trkId = tw.trwpTrkId
            WHERE trkUsrId = ?
            GROUP BY t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry

-- select track + participants + waypoints (separated by type)
-- PROJECT
SELECT t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry, 
                GROUP_CONCAT(DISTINCT part.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT huts.waypNameLong SEPARATOR ', ') AS huts,
                GROUP_CONCAT(DISTINCT peaks.waypNameLong SEPARATOR ', ') AS peaks,
                GROUP_CONCAT(DISTINCT wpt.waypNameLong SEPARATOR ', ') AS wpt 
            FROM tbl_tracks t
            JOIN tbl_types typ ON t.trkTypeFid = typ.typId
            JOIN tbl_types styp ON t.trkSubtypeFid = styp.typId
            LEFT OUTER JOIN (
                SELECT tp.trpaTrkId, CONCAT(p.prtFirstName, ' ', p.prtLastName) AS part
                FROM tbl_track_part tp 
                JOIN tbl_part p ON tp.trpaPartId = p.prtId
                ) AS part
            ON t.trkId = part.trpaTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpTrkId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'hu'
                ) AS huts
            ON t.trkId = huts.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpTrkId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'gi'
                ) AS peaks
            ON t.trkId = peaks.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpTrkId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode not in ('hu','gi')
                ) AS wpt
            ON t.trkId = wpt.trwpTrkId
            WHERE trkUsrId = ?
            GROUP BY t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry


SELECT tw.trwpTrkId, wpt.waypNameLong, typ.typCode
FROM tbl_track_wayp tw
JOIN tbl_waypoints wpt ON tw.trwpWaypID = wpt.waypID
JOIN tbl_types typ ON wpt.waypTypeFid = typ.typId
WHERE 1

