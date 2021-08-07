const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const admin = require('firebase-admin');

exports.payments = functions.https.onRequest((request, response) => {
    let sig = request.headers['stripe-signature'];

    const endpointSecret = 'whsec_k1BZvAONL5R65ZyeRM7yt7Pgggl0QBhZ';//TODO: Make environment variable.

    try {
        let event = stripe.webhooks.constructEvent(request.rawBody, sig, endpointSecret);

        switch (event['type']) {
            case 'payment_intent.succeeded':
                //Add new order document to firebase.
                return admin.firestore().collection('Orders').add({ orderID: 'fjaiefa', firstName: 'Trey', lastName: 'Hope', }).then((val) => {
                    //TODO: Send notification to admin of new order.
                    return response.json({ type: 'payment_intent.succeeded' });
                }).catch((err) => {
                    print(err);
                });
            case 'payment_intent.payment_failed':
                return response.json({ type: 'payment_intent.payment_failed' });
            default:
                return response.json({ type: 'default' });
        }
    }
    catch (err) {
        return response.status(400).end();
    }
});