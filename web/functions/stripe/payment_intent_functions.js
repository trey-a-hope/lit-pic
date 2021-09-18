const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

exports.retrieve = functions.https.onRequest(async (request, response) => {
    const paymentIntentID = request.body.paymentIntentID;

    try {
        const paymentIntent = await stripe(env.stripe.live.secret_key).paymentIntents.retrieve(
            paymentIntentID,
        );
        response.send(paymentIntent);
    } catch (error) {
        response.send(error);
    }
});
