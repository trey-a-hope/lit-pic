const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    CREATE A CARD

    When you create a new credit card, you must specify a customer or recipient on which to create it.
    If the cardâ€™s owner has no default card, then the new card will become the default. However, if the owner 
    already has a default, then it will not change. To change the default, you should either update the customer 
    to have a new default_source, or update the recipient to have a new default_card.

    PARAMS 

    ?
*/

exports.create = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;
    const token = request.body.token;


    return stripe(env.stripe.live.secret_key).customers.createSource(
        customerID,
        {
            source: token,
        }, (err, charge) => {
            if (err) {
                response.send(err);
            } else {
                response.send(charge);
            }
        });

});

/*
    DELETE A CARD

    You can delete cards from a customer. If you delete a card that is currently the default source, then 
    the most recently added source will become the new default. If you delete a card that is the last remaining 
    source on the customer, then the default_source attribute will become null. For recipients: if you 
    delete the default card, then the most recently added card will become the new default. If you delete 
    the last remaining card on a recipient, then the default_card attribute will become null. Note that 
    for cards belonging to customers, you might want to prevent customers on paid subscriptions from deleting 
    all cards on file, so that there is at least one default card for the next invoice payment attempt.

    PARAMS

    ?
*/

exports.delete = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;
    const cardID = request.body.cardID;


    return stripe(env.stripe.live.secret_key).customers.deleteSource(
        customerID,
        cardID, 
        (err, charge) => {
            if (err) {
                response.send(err);
            } else {
                response.send(charge);
            }
        });

});