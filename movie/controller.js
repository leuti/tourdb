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
        movies => {
            const moviesResponse = {
                movies,
                links: getLinks(options.sort, request.baseUrl),
            };
            response.json(moviesResponse);
        },
        error => response.status(500).json(error),
    );
}

function detailAction(request, response) {
    model.get(request.params.id).then(
        movie => {
            const moviesResponse = {
                ...movie,
                links: [{ rel: 'self', href: request.baseUrl + '/' }],
            };
            response.json(moviesResponse);
        },
        error => response.status(500).json(error),
    );
}

function createAction(request, response) {
    const movie = {
        title: request.body.title,
        year: request.body.year,
    };
    model
        .save(movie)
        .then(
            newMovie => response.status(201).json(newMovie),
            error => error => response.status(500).json(error),
        );
}

function updateAction(request, response) {
    const movie = {
        id: request.params.id,
        title: request.body.title,
        year: request.body.year,
    };
    model
        .save(movie)
        .then(
            movie => response.json(movie),
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