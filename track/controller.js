const model = require('./model');

function getLinks(current, base) {
    const links = [
        { rel: 'base', href: base + '/' },
        { rel: 'sort-ascending', href: base + '/?sort=asc' },
        { rel: 'sort-descending', href: base + '/?sort=desc' },
    ];
    return links.map(link => {
        if (current.length > 0 && link.rel.includes(current)) {
            link.rel = 'self';
        } else if (current.length === 0 && link.rel === 'base') {
            link.rel = 'self';
        }
        return link;
    });
}

function listAction(request, response) {
    const options = {
        sort: request.query.sort ? request.query.sort : '',
    };
    model.getAll(options).then(
        tracks => {
            const tracksResponse = {
                tracks,
                links: getLinks(options.sort, request.baseUrl),
            };
            response.json(tracksResponse);
        },
        error => response.status(500).json(error),
    );
}

function detailAction(request, response) {
    model.get(request.params.id).then(
        track => {
            const tracksResponse = {
                ...track,
                links: [{ rel: 'self', href: request.baseUrl + '/' }],
            };
            response.json(tracksResponse);
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