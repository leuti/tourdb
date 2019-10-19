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
        let query = `SELECT 
            trkId,
            trkTrackName,
            trkRoute,
            trkDateBegin,
            trkDateFinish,
            trkTypeFid,
            trkSubtypeFid,
            trkOrg,
            trkEvent,
            trkRemarks,
            trkDistance,
            trkTimeOverall,
            trkTimeToPeak,
            trkTimeToFinish,
            trkGrade,
            trkMeterUp,
            trkMeterDown,
            trkCountry,
            trkUsrId
        FROM tbl_tracks 
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