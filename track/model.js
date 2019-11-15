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
                tracks.id AS id, 
                tracks.name AS name, 
                tracks.route AS route , 
                tracks.dateBegin AS dateBegin, 
                types.name AS type,
                subtypes.name AS subtype, 
                tracks.org AS org, 
                tracks.event AS event, 
                tracks.remarks AS remarks, 
                tracks.distance AS distance, 
                tracks.peakTime AS timeToPeak, 
                tracks.dateFinish AS timeToFinish, 
                grades.code AS grade, 
                tracks.meterUp AS meterUp, 
                tracks.meterDown AS meterDown, 
                countries.code AS country, 
                GROUP_CONCAT(DISTINCT part.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT huts.name SEPARATOR ', ') AS huts,
                GROUP_CONCAT(DISTINCT peaks.name SEPARATOR ', ') AS peaks,
                GROUP_CONCAT(DISTINCT wpt.name SEPARATOR ', ') AS waypoints 
            FROM tracks
            -- Subtypes
            JOIN types subtypes ON tracks.fk_subtypeId = subtypes.id
            -- Types
            JOIN types ON subtypes.fk_parentId = types.id
            -- participants
            LEFT OUTER JOIN (
                SELECT track_part.fk_participantId, CONCAT(participants.firstName, ' ', participants.lastName) AS part
                FROM track_part 
                JOIN participants ON track_part.fk_participantId = participants.id
                ) AS part
            ON tracks.id = part.fk_participantId
            -- waypoints as huts
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code = 'hu'
                ) AS huts
            ON tracks.id = huts.fk_trackId
            -- waypoints as peaks
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp 
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code = 'gi'
                ) AS peaks
            ON tracks.id = peaks.fk_trackId
            -- waypoints as waypoints
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp 
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code not in ('hu','gi')
                ) AS wpt
            ON tracks.id = wpt.fk_trackId
            -- grades
            LEFT OUTER JOIN grades ON tracks.fk_gradeId = grades.id
            -- countries
            LEFT OUTER JOIN countries ON tracks.fk_countryId = countries.id
            -- WHERE Clause
            WHERE tracks.fk_userId = ?
            GROUP BY tracks.id, tracks.name, tracks.route, tracks.dateBegin, types.name,
                subtypes.name, tracks.org, tracks.event, tracks.remarks, tracks.distance, 
                tracks.peakTime, tracks.dateFinish, grades.code, tracks.meterUp, 
                tracks.meterDown, countries.code
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
                tracks.id AS id, 
                tracks.name AS name, 
                tracks.route AS route , 
                tracks.dateBegin AS dateBegin, 
                types.name AS type,
                subtypes.name AS subtype, 
                tracks.org AS org, 
                tracks.event AS event, 
                tracks.remarks AS remarks, 
                tracks.distance AS distance, 
                tracks.peakTime AS timeToPeak, 
                tracks.dateFinish AS timeToFinish, 
                grades.code AS grade, 
                tracks.meterUp AS meterUp, 
                tracks.meterDown AS meterDown, 
                countries.code AS country, 
                GROUP_CONCAT(DISTINCT part.part SEPARATOR ', ') AS participants, 
                GROUP_CONCAT(DISTINCT huts.name SEPARATOR ', ') AS huts,
                GROUP_CONCAT(DISTINCT peaks.name SEPARATOR ', ') AS peaks,
                GROUP_CONCAT(DISTINCT wpt.name SEPARATOR ', ') AS waypoints 
            FROM tracks
            -- Subtypes
            JOIN types subtypes ON tracks.fk_subtypeId = subtypes.id
            -- Types
            JOIN types ON subtypes.fk_parentId = types.id
            -- participants
            LEFT OUTER JOIN (
                SELECT track_part.fk_participantId, CONCAT(participants.firstName, ' ', participants.lastName) AS part
                FROM track_part 
                JOIN participants ON track_part.fk_participantId = participants.id
                ) AS part
            ON tracks.id = part.fk_participantId
            -- waypoints as huts
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp 
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code = 'hu'
                ) AS huts
            ON tracks.id = huts.fk_trackId
            -- waypoints as peaks
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp 
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code = 'gi'
                ) AS peaks
            ON tracks.id = peaks.fk_trackId
            -- waypoints as waypoints
            LEFT OUTER JOIN (
                SELECT track_wayp.fk_trackId, waypoints.name
                FROM track_wayp
                JOIN waypoints ON track_wayp.fk_waypointId = waypoints.id
                JOIN types ON waypoints.fk_typeId = types.id
                WHERE types.code not in ('hu','gi')
                ) AS wpt
            ON tracks.id = wpt.fk_trackId
            -- grades
            LEFT OUTER JOIN grades ON tracks.fk_gradeId = grades.id
            -- countries
            LEFT OUTER JOIN countries ON tracks.fk_countryId = countries.id
            -- WHERE Clause
            WHERE tracks.id = ? AND tracks.fk_userId = ?
            GROUP BY tracks.id, tracks.name, tracks.route, tracks.dateBegin, types.name,
                subtypes.name, tracks.org, tracks.event, tracks.remarks, tracks.distance,
                tracks.peakTime, tracks.dateFinish, grades.code, tracks.meterUp, 
                tracks.meterDown, countries.code
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