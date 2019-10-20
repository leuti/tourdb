const jwt = require('jsonwebtoken');
const Router = require('express').Router;
const userModel = require('./user/model');

const router = Router();

router.post('/', (request, response) => {
    console.log("auth.js router reached");
    userModel
        .get({
            usrLogin: request.body.login,
            usrPassword: request.body.password,
        })
        .then(
            user => {
                if (user) {
                    const payload = { ...user };
                    delete payload.usrPassword;
                    const token = jwt.sign(payload, 'secret');
                    response.json({ token });
                } else {
                    response.status(401).json('unauthorized');
                }
            },
            error => response.status(401).json('unauthorized'),
        );
});

module.exports = router;