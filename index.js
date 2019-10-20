// installed node packages
// -----------------------
// npm install express (web application framework for node.js)
// npm install morgan (middleware component to protocoll incoming requests) 
//     ==> not sure if required
// npm install express-jwt (Middleware that validates JsonWebTokens and sets req.user)
// npm install mysql (mysql library)

// packages to be potentially installed
// ------------------------------------
// npm install body-parser (Node.js body parsing middleware)

const express = require('express');                 // Express library expressjs.com
//const morgan = require('morgan');                   // ??? Purpose
const bodyParser = require('body-parser');          // unsure if required
const expressJwt = require('express-jwt');          // library for JSON web token
const trackRouter = require('./track');             // node assumes index.js as relevant file within ./track
const loginRouter = require('./auth');              // node assumes index.js as relevant file within ./auth

const app = express();

app.use(bodyParser.json());

//app.use(morgan('common', { immediate: true }));

app.use('/login', loginRouter);                                         // Call .auth.js which returns JWT
app.use('/track', expressJwt({ secret: 'secret' }), trackRouter);       // Gives access to trackRouter if token is valid
app.use(function(err, request, response, next) {
    if (err.name === 'UnauthorizedError') {
        response.status(401).json('unauthorized');
    } else {
        next();
    }
});

app.listen(8080, () => {
    console.log('Server is listening to http://localhost:8080');
});
