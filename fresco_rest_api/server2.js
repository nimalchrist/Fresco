//used modules
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');
const fileUpload = require('express-fileupload');
require("dotenv").config();
const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator')

// db connection configurations
var dbConn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Ninunimal@2',
    database: 'fresco_db'
});

dbConn.connect();
//otp generator
let generatedOtp = otpGenerator.generate(4, {
    algorithm: 'SHA1',
    digits: true,
    lowerCaseAlphabets: false,
    upperCaseAlphabets: false,
    specialChars: false,
});


//mail transporter
let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: 'selvanimal0@gmail.com',
        pass: 'hgtdeekqowaqlkuv'
    }
});

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


//static accessing of images and videos
app.use(express.static('public'));
app.use('/post_contents', express.static(__dirname + '/post_contents'));
app.use('/profile_pics', express.static(__dirname + '/profile_pics'));


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
            res.status(400).json({body: "Error with fetching...try again later..."});
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
    let values = [req.body.username, req.body.email, req.body.password, generatedOtp];
    let email = req.body.email;
    dbConn.query("select email from users where email = ?",[email], function(error, result){
        if (error) {
            throw error
        }
        if (result.length != 0) {
            res.status(409).json({message: "Email already exist"});
        }else{
            dbConn.query("Insert into users(user_name, email, password, otp_generated) values(?)",[values], function(error, result){
                if (error) throw (error);
                dbConn.query("Select user_id from users where email = ?",[email],function(error, result){
                    if (error) {
                        throw error;
                    }
                    res.status(200).json({message: "registered successfully",user_id: result[0].user_id});
                    let mailOptions = {
                      from: 'selvanimal0@gmail.com',
                      to: req.body.email,
                      subject: 'OTP for verification',
                      html: `<html>
                                <head>
                                    <style>
                                        h1 {
                                            color: #5E9CA0;
                                            text-align: center;
                                        }
                                        p {
                                            font-family: Arial, sans-serif;
                                            font-size: 16px;
                                            line-height: 1.5;
                                            text-align: justify;
                                            margin-bottom: 1em;
                                        }
                                    </style>
                                </head>
                                <body>
                                    <h1>Title</h1>
                                    <p>We are excited to have you here.</p>
                                    <p>Thank you for visiting.</p>
                                    <h2>Your OTP is ${generatedOtp}</h2>
                                </body>
                            </html>`
                    };
                    transporter.sendMail(mailOptions, function(error){
                      if (error) {
                        console.log(error);
                        res.status(500).send({message: 'Error while sending OTP'});
                      }
                    });
                })
            });
        }
    });
});


app.post('/otp', (req, res) => {
    let entered_otp = req.body.otp;
    let authorised_user_id = req.body.id;
    dbConn.query("select user_id,otp_generated from users where user_id = ?", [authorised_user_id], function(err, result){
        if (err) throw (err);
        if (entered_otp == result[0].otp_generated) {
            res.status(200).json({user_id: result[0].user_id, message: "email verified successfully"});
        }
        else{
            res.status(400).json({message: "Invalid otp"});
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
                    let mailOptions = {
                        from: 'selvanimal0@gmail.com',
                        to: req.body.email,
                        subject: 'OTP for verification',
                        html: `<html>
                                  <head>
                                    <style>
                                        h1 {
                                            color: white;
                                            font-weight: bold;
                                            text-align: center;
                                        }
                                        p {
                                            font-family: Arial, sans-serif;
                                            font-size: 14px;
                                            line-height: 1.0;
                                            text-align: justify;
                                            margin-bottom: 1em;
                                        }
                                    </style>
                                  </head>
                                  <body>
                                    <h1>Fresco</h1>
                                    <h2>Your OTP is ${generatedOtp}</h2>
                                    <p>We are excited to have you here.</p>
                                    <p>Thank you for visiting.</p>
                                  </body>
                              </html>`
                    };
                    dbConn.query("update users set otp_generated = ? where email = ?",[generatedOtp, email]);
                    transporter.sendMail(mailOptions, function(error){
                        if (error) {
                          console.log(error);
                          res.status(500).send({message: 'Error while sending OTP'});
                        }
                    });  
                });
            }else{
                res.status(400).send({message: "sorry wrong password"});
            }
        }
    });
});

// set port
app.listen(8000, function () {
    console.log('Node app is running on port 8000');
});
module.exports = app;