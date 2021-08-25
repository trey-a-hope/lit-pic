const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const admin = require('firebase-admin');

exports.payments = functions.https.onRequest(async (request, response) => {
    let sig = request.headers['stripe-signature'];

    const ADMIN_DOC_ID = 'wwiQQDkGoFN3mzDm664JW8NrT6B3';

    try {
        let event = stripe.webhooks.constructEvent(request.rawBody, sig, env.webhooks.payments.endpoint_secret);

        switch (event['type']) {
            case 'checkout.session.completed':
                var session = event.data.object;

                var sessionID = session['id'];
                var customerID = session['customer'];

                var customer = await stripe(env.stripe.test.secret_key).customers.retrieve(customerID);

                var order = {
                    sessionID: sessionID,
                    customerID: customerID,
                    status: 'created',
                    carrier: null,
                    trackingNumber: null,
                    shipping: customer['shipping'],
                    created: Date.now(),
                    modified: Date.now(),
                };

                var orderDoc = await admin.firestore().collection('orders').doc();
                order['id'] = orderDoc.id;
                await admin.firestore().collection('orders').doc(order['id']).set(order);

                //Clear shopping cart for this user.
                var usersDB = admin.firestore().collection('users');

                var customerQuerySnap = await usersDB.where('customerID', '==', customerID).get();

                var customerDocID = customerQuerySnap.docs[0].id;

                var batch = admin.firestore().batch();

                var cartItemsQuerySnap = await usersDB.doc(customerDocID).collection('cartItems').get();

                cartItemsQuerySnap.docs.forEach((doc) => {
                    batch.delete(doc.ref);
                });

                await batch.commit();

                //Send notification to admin of new order.
                var adminDoc = await admin.firestore().collection('users').doc(ADMIN_DOC_ID).get();

                var payload = {
                    notification: {
                        title: 'New Order',
                        body: `Get to it bro!`,
                    }
                };

                await admin.messaging().sendToDevice(adminDoc.data()['fcmToken'], payload);

                return response.json({ event: event });
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