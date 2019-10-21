const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'tourdb2_prod',
});

connection.connect();

function getAllRecs(usrId, options) {
    return new Promise((resolve, reject) => {

        // Select track main data
        let query = `
            SELECT 
            t.trkId AS id, 
                t.trkTrackName AS name, 
                t.trkRoute AS route , 
                t.trkDateBegin AS dateBegin, 
                typ.typName AS type,
                styp.typName AS subtype, 
                t.trkOrg AS org, 
                t.trkEvent AS event, 
                t.trkRemarks AS remarks, 
                t.trkDistance AS distance, 
                t.trkTimeToPeak AS timeToPeak, 
                t.trkTimeToFinish AS timeToFinish, 
                t.trkGrade AS grade, 
                t.trkMeterUp AS meterUp, 
                t.trkMeterDown AS meterDown, 
                t.trkCountry AS country, 
                GROUP_CONCAT(DISTINCT part.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT huts.waypNameLong SEPARATOR ', ') AS huts,
                GROUP_CONCAT(DISTINCT peaks.waypNameLong SEPARATOR ', ') AS peaks,
                GROUP_CONCAT(DISTINCT wpt.waypNameLong SEPARATOR ', ') AS waypoints 
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
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'hu'
                ) AS huts
            ON t.trkId = huts.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'gi'
                ) AS peaks
            ON t.trkId = peaks.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode not in ('hu','gi')
                ) AS wpt
            ON t.trkId = wpt.trwpTrkId
            WHERE trkUsrId = ?
            GROUP BY t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, 
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry
            `;
        
        if (options.sort && ['asc', 'desc'].includes(options.sort.toLowerCase())) {
            //query += ' ORDER BY title ' + options.sort;                   // Sorting needs to be implemented with GRID
            }

        connection.query(query, [usrId], (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                resolve(results);
            }
        });
    });
}

function getOne(id, usrId) {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT 
                t.trkId AS id, 
                t.trkTrackName AS name, 
                t.trkRoute AS route , 
                t.trkDateBegin AS dateBegin, 
                typ.typName AS type,
                styp.typName AS subtype, 
                t.trkOrg AS org, 
                t.trkEvent AS event, 
                t.trkRemarks AS remarks, 
                t.trkDistance AS distance, 
                t.trkTimeToPeak AS timeToPeak, 
                t.trkTimeToFinish AS timeToFinish, 
                t.trkGrade AS grade, 
                t.trkMeterUp AS meterUp, 
                t.trkMeterDown AS meterDown, 
                t.trkCountry AS country, 
                GROUP_CONCAT(DISTINCT part.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT huts.waypNameLong SEPARATOR ', ') AS huts,
                GROUP_CONCAT(DISTINCT peaks.waypNameLong SEPARATOR ', ') AS peaks,
                GROUP_CONCAT(DISTINCT wpt.waypNameLong SEPARATOR ', ') AS waypoints 
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
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'hu'
                ) AS huts
            ON t.trkId = huts.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode = 'gi'
                ) AS peaks
            ON t.trkId = peaks.trwpTrkId
            LEFT OUTER JOIN (
                SELECT tw.trwpTrkId, wayp.waypNameLong
                FROM tbl_track_wayp tw 
                JOIN tbl_waypoints wayp ON tw.trwpWaypId = wayp.waypID
                JOIN tbl_types typ ON wayp.waypTypeFid = typ.typId
                WHERE typ.typCode not in ('hu','gi')
                ) AS wpt
            ON t.trkId = wpt.trwpTrkId
            WHERE t.trkId = ? AND trkUsrId = ?
            GROUP BY t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, typ.typName,
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance,
                t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry
            `; 
        connection.query(query, [id, usrId], (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                resolve(results[0]);
            }
        });
    });
}

function insert(track, usrId) {
    return new Promise((resolve, reject) => {
        const query = `
            INSERT INTO tbl_tracks 
            ( 
                trkTrackName, trkRoute, trkDateBegin, 
                trkTypeFid, 
                trkSubtypeFid, 
                trkOrg, trkEvent, trkRemarks, 
                trkDistance, trkTimeToPeak, trkTimeToFinish, trkStartEle, trkPeakEle, 
                trkPeakTime, trkLowEle, trkLowTime, trkFinishEle, trkFinishTime, trkGrade, trkMeterUp, 
                trkMeterDown, trkCountry, trkUsrId, 
                trkCoordinates, trkCoordTop, trkCoordBottom, trkCoordLeft, trkCoordRight
            )
            VALUES 
            (
                ?, ?, ?, 
                (SELECT typParentId FROM tbl_types WHERE typCode = ? AND typPurpose = 'trk' AND typType = 'subtype'), 
                (SELECT typId FROM tbl_types WHERE typCode = ? AND typPurpose = 'trk' AND typType = 'subtype'), 
                ?, ?, ?, 
                ?, ?, ?, ?, ?, 
                ?, ?, ?, ?, ?, ?, ?, 
                ?, ?, ?, 
                ?, ?, ?, ?, ?
            )`;
        connection.query(query, [
            track.name, track.route, track.dateBegin, 
            track.subtype, 
            track.subtype,                       // Required twice, once for type, once for subtype
            track.org, track.event, track.remarks, 
            track.distance, track.timeToPeak, track.timeToFinish, track.startEle, track.peakEle, 
            track.peakTime, track.lowEle, track.lowTime, track.finishEle, track.finishTime, track.grade, track.meterUp, 
            track.meterDown, track.country, usrId, 
            'none', 500000, 300000, 500000, 300000
        ], (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                track.id = results.insertId;
                resolve(track);
            }
        });
    });
}

function update(track, usrId) {
    return new Promise((resolve, reject) => {
        const query = `
            UPDATE tbl_tracks SET 
                trkTrackName = ?, trkRoute = ?, trkDateBegin = ?, 
                trkTypeFid = (SELECT typParentId FROM tbl_types WHERE typCode = ? AND typPurpose = 'trk' AND typType = 'subtype'),
                trkSubtypeFid = (SELECT typId FROM tbl_types WHERE typCode = ? AND typPurpose = 'trk' AND typType = 'subtype'), 
                trkOrg = ?, 
                trkEvent = ?, trkRemarks = ?, trkDistance = ?, trkTimeToPeak = ?, trkTimeToFinish = ?, 
                trkStartEle = ?, trkPeakEle = ?, trkPeakTime = ?, trkLowEle = ?, trkLowTime = ?, 
                trkFinishEle = ?, trkFinishTime = ?, trkGrade = ?, trkMeterUp = ?, trkMeterDown = ?, 
                trkCountry = ? 
            WHERE trkId = ? AND trkUsrId = ?`;
        connection.query(query, [
                track.name, track.route, track.dateBegin, track.subtype, track.subtype, track.org, 
                track.event, track.remarks, track.distance, track.timeToPeak, track.timeToFinish, 
                track.startEle, track.peakEle, track.peakTime, track.lowEle, track.lowTime, 
                track.finishEle, track.finishTime, track.grade, track.meterUp, track.meterDown, 
                track.country, track.id, usrId
            ],
            (error, results) => {
                if (error) {
                    console.log(error);
                    reject(error);
                } else {
                    resolve(results);
                }
            },
        );
    });
}

function remove(id, usrId) {
    return new Promise((resolve, reject) => {
        const query = 'DELETE FROM tbl_tracks WHERE trkId = ? AND trkUsrId = ?';
        connection.query(query, [id, usrId], (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                resolve(results[0]);
            }
        });
    });
}

module.exports = {
    getAll(usrId, options) {
        return getAllRecs(usrId, options);
    },
    get(id, usrId) {
        return getOne(id, usrId);
    },
    delete(id, usrId) {
        return remove(id, usrId);
    },
    save(track, usrId) {
        if (!track.id) {
            return insert(track, usrId);
        } else {
            return update(track, usrId);
        }
    },
};