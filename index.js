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

const express = require('express');
const morgan = require('morgan');
const bodyParser = require('body-parser');          // unsure if required
const expressJwt = require('express-jwt');
//const swaggerUi = require('swagger-ui-express');
const movieRouter = require('./movie');             // node assumes index.js as relevant file within ./movie
const loginRouter = require('./auth');
//const swaggerSpec = require('./swagger');   

const app = express();

app.use(bodyParser.json());

//app.get('/', (request, response) => response.redirect('/movie'));

app.use(morgan('common', { immediate: true }));

app.use('/login', loginRouter);
app.use('/movie', expressJwt({ secret: 'secret' }), movieRouter);
app.use(function(err, request, response, next) {
    if (err.name === 'UnauthorizedError') {
        response.status(401).json('unauthorized');
    } else {
        next();
    }
});
//app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.listen(8080, () => {
    console.log('Server is listening to http://localhost:8080');
});
