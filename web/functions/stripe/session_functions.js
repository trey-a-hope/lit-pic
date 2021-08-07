const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();


exports.create = functions.https.onRequest((request, response) => {
    const success_url = request.body.success_url;
    const cancel_url = request.body.cancel_url;
    const customer = request.body.customer;
    // const line_items = request.body.line_items;

    return stripe(env.stripe.test.secret_key).checkout.sessions.create(
        {
            success_url: success_url,
            cancel_url: cancel_url,
            payment_method_types: ['card'],
            mode: 'payment',
            line_items: [
                {
                    'price': 'price_1JKcEpGQvSy9RLmzKGyqcqy1',
                    'quantity': 2,
                },
            ],
            customer: customer,
        }, (err, session) => {
            if (err) {
                response.send(err);
            } else {
                response.send(session);
            }
        });
});


exports.retrieve = functions.https.onRequest((request, response) => {
    const sessionID = request.body.sessionID;

    return stripe(env.stripe.test.secret_key).checkout.sessions.retrieve(
        sessionID, (err, session) => {
            if (err) {
                response.send(err);
            } else {
                response.send(session);
            }
        });

});

exports.list = functions.https.onRequest((request, response) => {
    const limit = request.body.limit;

    return stripe(env.stripe.test.secret_key).checkout.sessions.list(
        {
            limit: limit,
        }, (err, sessions) => {
            if (err) {
                response.send(err);
            } else {
                response.send(sessions);
            }
        });

});