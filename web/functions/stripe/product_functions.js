const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    CREATE A PRODUCT
    https://stripe.com/docs/api/service_products/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const name = request.body.name;
    const type = request.body.type;

    return stripe(env.stripe.test.secret_key).products.create(
        {
            name: name,
            type: type,
        }, (err, product) => {
            if (err) {
                response.send(err);
            } else {
                response.send(product);
            }
        });

});


exports.retrieve = functions.https.onRequest((request, response) => {
    const prodID = request.body.prodID;

    return stripe(env.stripe.test.secret_key).products.retrieve(
        prodID, (err, product) => {
            if (err) {
                response.send(err);
            } else {
                response.send(product);
            }
        });

});