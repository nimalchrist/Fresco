var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');
const fileUpload = require('express-fileupload');


//middle wares
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(express.static('public'));

app.use('/post_contents', express.static(__dirname + '/post_contents'));

app.use(
    fileUpload({
        limits: {
            fileSize: 10000000,
        },
        abortOnLimit: true,
    }),
);

app.use(express.static('public'));
app.use('/post_contents', express.static(__dirname + '/post_contents'));
app.use('/profile_pics', express.static(__dirname + '/profile_pics'));

// default route
app.get('/', function (req, res) {
return res.send({ error: true, message: 'hello' })
});


// connection configurations
var dbConn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Ninunimal@2',
    database: 'fresco_db'
});



// connect to database
dbConn.connect(); 



// Retrieve all users 
app.get('/users', function (req, res) {
    dbConn.query('SELECT * FROM users', function (error, results, fields) {
        if (error) 
            throw error;
        return res.json(results);
    });
});


// Retrieve all posts
app.get('/posts', function(req, res){
    dbConn.query('select  posts.post_id, users.user_id, users.user_name, users.profile_pic, posts.post_title, posts.post_content, posts.post_summary, posts.time_posted from posts inner join users on posts.user_id = users.user_id;', function(error, results, fields){
        if(error)
            res.json({body: "Error with fetching...try again later..."});
        return res.json(results);
    });
});


// // Retrieve user with id 
// app.get('/user/:id', function (req, res) {
//     let user_id = req.params.id;
//     if (!user_id) {
//         return res.status(400).send({ error: true, message: 'Please provide user_id' });
//     }
//     dbConn.query('SELECT * FROM users where id=?', user_id, function (error, results, fields) {
//         if (error) throw error;
//         return res.send({ error: false, data: results[0], message: 'users list.' });
//     });
// });


// Add a new user  
// app.post('/user', function (req, res) {
//     let user = req.body.user;
//     if (!user) {
//         return res.status(400).send({ error:true, message: 'Please provide user' });
//     }
//     dbConn.query("INSERT INTO users SET ? ", { user: user }, function (error, results, fields) {
//         if (error) throw error;
//         return res.send({ error: false, data: results, message: 'New user has been created successfully.' });
//     });
// });

// Add a new user  
// app.post('/posts', function (req, res) {
//     let user = req.body.user;
//     if (!user) {
//         return res.status(400).json({ error:true, message: 'Please provide user' });
//     }
//     dbConn.query("INSERT INTO posts (user_id, post_title, post_content) ? ", [], function (error, results, fields) {
//         if (error) throw error;
//         return res.send({ error: false, data: results, message: 'New user has been created successfully.' });
//     });
// });


// //  Update user with id
// app.put('/user', function (req, res) {
//     let user_id = req.body.user_id;
//     let user = req.body.user;
//     if (!user_id || !user) {
//         return res.status(400).send({ error: user, message: 'Please provide user and user_id' });
//     }
//     dbConn.query("UPDATE users SET user = ? WHERE id = ?", [user, user_id], function (error, results, fields) {
//         if (error) throw error;
//         return res.send({ error: false, data: results, message: 'user has been updated successfully.' });
//     });
// });


// //  Delete user
// app.delete('/user', function (req, res) {
//     let user_id = req.body.user_id;
//     if (!user_id) {
//         return res.status(400).send({ error: true, message: 'Please provide user_id' });
//     }
//     dbConn.query('DELETE FROM users WHERE id = ?', [user_id], function (error, results, fields) {
//         if (error) throw error;
//         return res.send({ error: false, data: results, message: 'User has been updated successfully.' });
//     });
// }); 


// set port
app.listen(8000, function () {
    console.log('Node app is running on port 8000');
});
module.exports = app;