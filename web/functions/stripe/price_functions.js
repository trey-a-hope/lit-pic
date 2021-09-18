const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    RETRIEVE A PRICE
    https://stripe.com/docs/api/prices?lang=node
*/
exports.retrieve = functions.https.onRequest((request, response) => {
    const priceID = request.body.priceID;

    return stripe(env.stripe.live.secret_key).prices.retrieve(
        priceID, (err, price) => {
            if (err) {
                response.send(err);
            } else {
                response.send(price);
            }
        });

});