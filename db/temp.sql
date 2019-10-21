INSERT INTO tbl_tracks 
( 
    trkTrackName, trkRoute, trkDateBegin, 
    trkTypeFid, 
    trkSubtypeFid, trkOrg, trkEvent, trkRemarks, 
    trkDistance, trkTimeOverall, trkTimeToPeak, trkTimeToFinish, trkStartEle, trkPeakEle, 
    trkPeakTime, trkLowEle, trkLowTime, trkFinishEle, trkFinishTime, trkGrade, trkMeterUp, 
    trkMeterDown, trkCountry, trkUsrId, trkCoordinates, trkCoordTop, trkCoordBottom, trkCoordLeft, trkCoordRight
)
    -- trkCreatedDate, trkUpdatedDate
VALUES 
(
    'testtrack', 'test route', '2019-10-21 06:00:00', 
    (SELECT typParentId FROM tbl_types WHERE typCode = 'st' AND typPurpose = 'trk' AND typType = 'subtype'), 
    (SELECT typId FROM tbl_types WHERE typCode = 'st' AND typPurpose = 'trk' AND typType = 'subtype'), 'trkOrg', 'trkEvent', 'trkRemarks', 
    12, '00:08:50','00:02:00','00:03:00', 800, 3000, 
    '12:00:00', 800, '08:00', 800, '2019-10-21 06:00:00', 'T3', 2200, 
    -2300, 'CH', 1, 'none', 600000, 300000, 500000, 40000
) 



