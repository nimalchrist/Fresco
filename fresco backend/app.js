const express = require("express");
const cors = require("cors");
const AppError = require("./utils/appError");
const router = require("./routes/index");
const api = require("./controllers/index");
const errorHandler = require("./utils/errorHandler");


const app = express();
const PORT = 3000;

app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`);
});

app.use(api, router);

app.all("*", (req, res, next) => {
 next(new AppError(`The URL ${req.originalUrl} does not exists`, 404));
});
app.use(errorHandler);

module.exports = app;