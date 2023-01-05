const mysql = require('mysql');
const conn = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "Ninunimal@2",
    database: "fresco_db",
});

conn.connect();
module.exports = conn;