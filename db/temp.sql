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