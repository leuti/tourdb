const model = require('./model');

function listAction(request, response) {
    const options = {
        sort: request.query.sort ? request.query.sort : '',
    };
    model.getAll(request.user.usrId, options).then(
        tracks => {
            response.json(tracks);
        },
        error => response.status(500).json(error),
    );
}

function detailAction(request, response) {
    model.get(request.params.id, request.user.usrId).then(
        track => {
            response.json(track);
        },
        error => response.status(500).json(error),
    );
}

function createAction(request, response) {
    const track = {
        title: request.body.title,
        year: request.body.year,
    };
    model
        .save(track)
        .then(
            newtrack => response.status(201).json(newtrack),
            error => error => response.status(500).json(error),
        );
}

function updateAction(request, response) {
    const track = {
        id: request.params.id,
        title: request.body.title,
        year: request.body.year,
    };
    model
        .save(track)
        .then(
            track => response.json(track),
            error => error => response.status(500).json(error),
        );
}

function deleteAction(request, response) {
    const id = parseInt(request.params.id, 10);
    model
        .delete(id)
        .then(() => response.status(204).send(), error => response.send(error));
}

module.exports = {
    listAction,
    detailAction,
    createAction,
    updateAction,
    deleteAction,
};