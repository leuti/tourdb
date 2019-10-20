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
                t.trkTimeOverall AS timeOverall, 
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
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
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
                t.trkTimeOverall AS timeOverall, 
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
                styp.typName, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
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

function insert(track) {
    // Challange: I need to get the typId of the type (e.g. 'gi') from a first query, then I need to get
    //            the subtypeId and then I need to perform the insert
    //
    // This page shows how my problem could be resolved
    // https://stackoverflow.com/questions/46893736/node-mysql-how-to-execute-more-queries-based-on-another-query
    //
    // Alternative: Perform all these actions in one INSERT statement

    return new Promise((resolve, reject) => {
        const query = 'INSERT INTO movies (title, year) VALUES (?, ?)';
        connection.query(query, [movie.title, movie.year], (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                movie.id = this.lastID;
                resolve(movie);
            }
        });
    });
}

function update(movie) {
    return new Promise((resolve, reject) => {
        const query = 'UPDATE movies SET title = ?, year = ? WHERE id = ?';
        connection.query(
            query,
            [movie.title, movie.year, movie.id],
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

function remove(id) {
    return new Promise((resolve, reject) => {
        const query = 'DELETE FROM movies WHERE id = ?';
        connection.query(query, [id], (error, results) => {
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
    save(track) {
        if (!track.id) {
            return insert(track);
        } else {
            return update(track);
        }
    },
};