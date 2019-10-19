const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'tourdb2_prod',
});

connection.connect();

function getAll(options) {
    return new Promise((resolve, reject) => {

        // Select track main data
        let query = `SELECT t.trkId, t.trkTrackName, t.trkRoute, t.trkDateBegin, t.trkTypeFid,
            t.trkSubtypeFid, t.trkOrg, t.trkEvent, t.trkRemarks, t.trkDistance, t.trkTimeOverall, 
            t.trkTimeToPeak, t.trkTimeToFinish, t.trkGrade, t.trkMeterUp, t.trkMeterDown, t.trkCountry,
            GROUP_CONCAT(CONCAT(p.prtFirstName, ' ', p.prtLastName)  SEPARATOR ', ') as participants, 
            GROUP_CONCAT(wayp.waypNameLong SEPARATOR ', ') as peaks 
        FROM tbl_tracks t
        JOIN tbl_track_part tp ON t.trkId = tp.trpaTrkId
        JOIN tbl_part p ON tp.trpaPartId = p.prtId
        JOIN tbl_track_wayp tw ON t.trkId = tw.trwpTrkId
        JOIN tbl_waypoints wayp ON tw.trwpWaypID = wayp.waypID
        GROUP BY t.trkId 
        LIMIT 20`;

        if (options.sort && ['asc', 'desc'].includes(options.sort.toLowerCase())) {
            query += ' ORDER BY title ' + options.sort;
            }

        connection.query(query, (error, results) => {
            if (error) {
                console.log(error);
                reject(error);
            } else {
                resolve(results);
            }
        });
    });
}

function getOne(id) {
    return new Promise((resolve, reject) => {
        const query = 'SELECT * FROM movies WHERE id = ?';
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

function insert(movie) {
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
                console.log("db statement done OK")
                resolve(results[0]);
            }
        });
    });
}

module.exports = {
    getAll,
    get(id) {
        return getOne(id);
    },
    delete(id) {
        return remove(id);
    },
    save(movie) {
        if (!movie.id) {
            return insert(movie);
        } else {
            return update(movie);
        }
    },
};