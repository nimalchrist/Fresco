//used modules
var express = require('express');
var bodyParser = require('body-parser');
var mysql2 = require('mysql2');
var mysql2 = require('mysql2/promise');
const fileUpload = require('express-fileupload');
const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator')


var app = express();
//
let dbConn;
async function connectToDb() {
    try {
        dbConn = await mysql2.createConnection({
            host: 'localhost',
            user: 'root',
            password: 'Ninunimal@2',
            database: 'fresco_db'
        });
        await dbConn.connect();
        console.log("Successfully connected to the database.");

    } catch (err) {
        console.log(`Error connecting to the database: ${err.message}`);
    }
}


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

app.get('/users', async (req, res) => {
    try {
        await connectToDb();
        [result] = await dbConn.query('SELECT * FROM users');
        res.status(200).json(result);
        dbConn.end();
        console.log("Disconnected");
    } catch (error) {
        res.status(400).json(error);
    }
});

app.get('/posts', async (req, res) => {
    try {
        await connectToDb();
        [results] = await dbConn.query('select  posts.post_id, users.user_id, users.user_name, users.profile_pic, posts.post_title, posts.post_content, posts.post_summary, posts.time_posted from posts inner join users on posts.user_id = users.user_id;');
        res.status(200).json(results);
    } catch (error) {
        console.log(error);
        res.status(400).json({body: "Error with fetching...try again later..."});
    }
});

app.get('/users/:id', async (req, res) => {
    try {
        await connectToDb();
        const user_id = req.params.id;
        if (!user_id) {
            return res.status(400).json("Error no user found");
        }
        [result] = await dbConn.query("Select profile_pic, user_name, email, profile_text, registered_at from users where user_id = ?", [user_id]);
        return res.status(200).json(result);
    } catch (error) {
        return res.status(500).send("Server error");
    }
});


app.post('/register', async (req, res) => {
    try {
        await connectToDb();
        const email = req.body.email;
        const [result] = await dbConn.query("SELECT email FROM users WHERE email = ?", [email]);
        if (result.length != 0) {
            res.status(409).json({message: "Email already exist"});
        } else {
            const values = [req.body.username, email, req.body.password, generatedOtp];
            await dbConn.query("INSERT INTO users(user_name, email, password, otp_generated) values(?)", [values]);
            const [user] = await dbConn.query("SELECT user_id FROM users WHERE email = ?", [email]);
            res.status(200).json({message: "registered successfully", user_id: user[0].user_id});
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
              await transporter.sendMail(mailOptions);
        }
    }
    catch(Exception){
        console.log(error);
        res.status(500).send({message: 'Error while sending OTP'});
    }
});

app.post('/otp', async (req, res) => {
    try {
        await connectToDb();
        let entered_otp = req.body.otp;
        let authorised_user_id = req.body.id;
        [result] = await dbConn.query("select user_id,otp_generated from users where user_id = ?", [authorised_user_id]);
        if (entered_otp == result[0].otp_generated) {
            res.status(200).json({user_id: result[0].user_id, message: "email verified successfully"});
        }else{
            res.status(200).json({message: "Invalid otp"});
        }
    } catch (error) {
        res.status(400).json({error});
    }
})


app.post('/login', async (req, res) => {
    await connectToDb();
    try {
        const {email, password} = req.body;
        const [results] = await dbConn.query("Select email,password from users where email = ?", [email]);
        if(results.length == 0){
            res.status(404).json({message: "Invalid Login Credentials"});
        }
        else{
            let check_pass = results[0].password;
            if(password == check_pass){
                const [result] = await dbConn.query("Select user_id from users where email = ?",[email]);
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
                await transporter.sendMail(mailOptions);
                await dbConn.query("update users set otp_generated = ? where email = ?",[generatedOtp, email]);
            }
            else{
                res.status(400).send({message: "sorry wrong password"});
            }
        }
    } catch (error) {
        console.log(error);
        res.status(500).send({message: 'Error while sending OTP'});
    }
});

// set port
app.listen(8000, function () {
    console.log('Node app is running on port 8000');
});
module.exports = app;