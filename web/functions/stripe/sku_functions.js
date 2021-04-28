const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    RETRIEVE A SKU
    https://stripe.com/docs/api/coupons/retrieve
*/

exports.retrieve = functions.https.onRequest((request, response) => {
    const skuID = request.body.skuID;

    return stripe(env.stripe.test.secret_key).skus.retrieve(
        skuID,
        (err, sku) => {
            if (err) {
                response.send(err);
            } else {
                response.send(sku);
            }
        }
    );
});