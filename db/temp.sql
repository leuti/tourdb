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

-- select track + participants + waypoints (separated by type)
-- PROJECT