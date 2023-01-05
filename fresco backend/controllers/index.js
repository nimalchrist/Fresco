const AppError = require("../utils/appError");
const conn = require("../services/db");

exports.getAllPosts = (req, res, next) => {
    conn.query("SELECT * FROM posts", function (err, data, fields) {
      if(err) return next(new AppError(err))
      res.status(200).json({
        status: "success",
        length: data?.length,
        data: data,
      });
    });
   };