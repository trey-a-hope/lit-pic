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
                //Extract receipt url and customer ID from event object.
                var receiptUrl = event['data']['object']['charges']['data'][0]['receipt_url'];
                var customerID = event['data']['object']['customer'];
                var paymentIntentID = event['data']['object']['id'];

                //Fetch customer from ID.
                var customer = await stripe(env.stripe.test.secret_key).customers.retrieve(customerID);

                //Create order data.
                var order = {
                    receiptUrl: receiptUrl,
                    paymentIntentID: paymentIntentID,
                    customerID: customerID,
                    created: Date.now(),
                    modified: Date.now(),
                    status: 'created',
                    carrier: null,
                    trackingNumber: null,
                    shipping: customer['shipping'],
                };

                //Add new order document to firebase.
                await admin.firestore().collection('Orders').add(order);

                //TODO: Clear shopping cart for this user.

                //Send notification to admin of new order.
                var adminDoc = await admin.firestore().collection('Users').doc(ADMIN_DOC_ID).get();

                var payload = {
                    notification: {
                        title: 'New Order',
                        body: `${paymentIntentID}`,
                    }
                };

                await admin.messaging().sendToDevice(adminDoc.data()['fcmToken'], payload);

                //Return success message.
                return response.json({
                    type: 'payment_intent.succeeded',
                    admin: adminDoc.data()['fcmToken'],
                    event: event,
                    customer: customer,
                    paymentIntentID: paymentIntentID,
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