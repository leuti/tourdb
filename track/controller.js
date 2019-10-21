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
        name: request.body.name,
        route: request.body.route,
        dateBegin: request.body.dateBegin,
        subtype: request.body.subtype,
        org: request.body.org,
        event: request.body.event,
        remarks: request.body.remarks,
        distance: request.body.distance,
        timeToPeak: request.body.timeToPeak,
        timeToFinish: request.body.timeToFinish,
        startEle: request.body.startEle, 
        peakEle: request.body.peakEle,
        peakTime: request.body.peakTime, 
        lowEle: request.body.lowEle,
        lowTime: request.body.lowTime, 
        finishEle: request.body.finishEle, 
        finishTime: request.body.finishTime, 
        grade: request.body.grade,
        meterUp: request.body.meterUp,
        meterDown: request.body.meterDown,
        country: request.body.country,
    };
    model
        .save(track, request.user.usrId)
        .then(
            newtrack => response.status(201).json(newtrack),
            error => error => response.status(500).json(error),
        );
}

function updateAction(request, response) {
    const track = {
        id: request.params.id,
        name: request.body.name,
        route: request.body.route,
        dateBegin: request.body.dateBegin,
        subtype: request.body.subtype,
        org: request.body.org,
        event: request.body.event,
        remarks: request.body.remarks,
        distance: request.body.distance,
        timeToPeak: request.body.timeToPeak,
        timeToFinish: request.body.timeToFinish,
        startEle: request.body.startEle, 
        peakEle: request.body.peakEle,
        peakTime: request.body.peakTime, 
        lowEle: request.body.lowEle,
        lowTime: request.body.lowTime, 
        finishEle: request.body.finishEle, 
        finishTime: request.body.finishTime, 
        grade: request.body.grade,
        meterUp: request.body.meterUp,
        meterDown: request.body.meterDown,
        country: request.body.country,
    };
    model
        .save(track, request.user.usrId)
        .then(
            track => response.json(track),
            error => error => response.status(500).json(error),
        );
}

function deleteAction(request, response) {
    const id = parseInt(request.params.id, 10);
    model
        .delete(id, request.user.usrId)
        .then(() => response.status(204).send(), error => response.send(error));
}

module.exports = {
    listAction,
    detailAction,
    createAction,
    updateAction,
    deleteAction,
};