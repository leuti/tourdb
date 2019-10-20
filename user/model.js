const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'tourdb2_prod',
});

connection.connect();

function get(query = {}) {
    return new Promise((resolve, reject) => {
        let queryElements = [];
        if (query) {
            for (let key in query) {
                queryElements.push(`${key} = ?`);
            }
        }

        const queryString = 
            `SELECT * FROM tbl_users WHERE ` + queryElements.join(' AND ');

        connection.query(queryString, [query.usrLogin, query.usrPassword], (error, results) => {
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
    get,
};