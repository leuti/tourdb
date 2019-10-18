const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'movies-db',
});

connection.connect();

function get(query = {}) {
    console.log(query);
    return new Promise((resolve, reject) => {
        let queryElements = [];
        if (query) {
            for (let key in query) {
                queryElements.push(`${key} = ?`);
            }
        }

        const queryString = 
            `SELECT * FROM users WHERE ` + queryElements.join(' AND ');

        connection.query(queryString, [query.username, query.password], (error, results) => {
            if (error) {
                console.log(error);
                console.log("db query not ok")
                reject(error);
            } else {
                console.log("db query OK");
                resolve(results[0]);
            }
        });
    });
}

module.exports = {
    get,
};