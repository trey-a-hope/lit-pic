const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const admin = require('firebase-admin');

exports.payments = functions.https.onRequest(async (request, response) => {
    let sig = request.headers['stripe-signature'];

    const ADMIN_DOC_ID = '5ztYxwc2L9ZbM8UCDRnVmGC1J6N2';

    try {
        let event = stripe.webhooks.constructEvent(request.rawBody, sig, env.webhooks.payments.endpoint_secret);

        switch (event['type']) {
            case 'payment_intent.succeeded':
                //Add new order document to firebase.
                //TODO: Add customer and order data here.
                var data = { orderID: 'fjaiefa', firstName: 'Trey', lastName: 'Hope', };
                // doc: FirebaseFirestore.DocumentReference = await admin.firestore().collection('Orders').add(data);
                await admin.firestore().collection('Orders').add(data);

                //TODO: Clear shopping cart for this user.

                //Send notification to admin of new order.
                var adminDoc = await admin.firestore().collection('Users').doc(ADMIN_DOC_ID).get();

                var payload = {
                    notification: {
                        title: 'You have been invited to a trip.',
                        body: 'Tap here to check it out!',
                    }
                };

                await admin.messaging().sendToDevice(adminDoc.data()['fcmToken'], payload);

                //Return success message.
                return response.json({ type: 'payment_intent.succeeded', admin: adminDoc.data()['fcmToken'], event: event });
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