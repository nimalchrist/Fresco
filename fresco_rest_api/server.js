//used modules
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');
const fileUpload = require('express-fileupload');
const jwt = require('jsonwebtoken');
require("dotenv").config();


//middle wares
app.use(bodyParser.json());
app.use(express.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

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


// connection configurations
var dbConn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Ninunimal@2',
    database: 'fresco_db'
});

// connect to database
dbConn.connect(); 


//routes of the app

// default route
app.get('/', function (req, res) {
    return res.send({ error: true, message: 'hello' })
    });

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

//Retrieve other users with the id
app.get('/users/:id', function(req, res){
    let user_id = req.params.id;
    if(!user_id){
        return res.status(400).json("Error no user found");
    }
    dbConn.query('Select profile_pic, user_name, email, profile_text, registered_at from users where user_id = ?', user_id, function(error, result){
        if(error) return res.status(500).send("Server error");
        return res.status(200).json(result);
    });
});

//Create user API
app.post('/register', function(req, res){
    let values = [req.body.username, req.body.email, req.body.password];
    let email = req.body.email;
    dbConn.query("select email from users where email = ?",[email], function(error, result){
        if (error) {
            throw error
        }
        if (result.length != 0) {
            res.status(409).json({message: "Email already exist"});
        }else{
            dbConn.query("Insert into users(user_name, email, password) values(?)",[values], function(error, result){
                if (error) throw (error);
                dbConn.query("Select user_id from users where email = ?",[email],function(error, result){
                    if (error) {
                        throw error;
                    }
                    res.status(200).json({message: "registered successfully",user_id: result[0].user_id});
                })
            });
        }
    });
});

//login authentication
app.post('/login', (req, res)=>{
    const {email, password} = req.body;
    dbConn.query("Select email,password from users where email = ?", [email], function(error, results){
        if(error){
            throw error;
        }
        if(results.length == 0){
            res.status(404).json({message: "Invalid Login Credentials"});
        }
        else{
            let check_pass = results[0].password;
            if(password == check_pass){
                dbConn.query("Select user_id from users where email = ?",[email],function(error, result){
                    if (error) {
                        throw error;
                    }
                    res.status(200).json({message: "Login successful",user_id: result[0].user_id});
                })
            }else{
                res.status(400).send({message: "sorry wrong password"});
            }
        }
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