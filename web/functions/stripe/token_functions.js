const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    CREATE A TOKEN

    Creates a single-use token that represents a credit cardâ€™s details. 
    This token can be used in place of a credit card object with any API method. 
    These tokens can be used only once: by creating a new Charge object, or by attaching 
    them to a Customer object.

    PARAMS 

    String number, cvc
    Int exp_month, exp_year
*/

exports.create = functions.https.onRequest((request, response) => {
    const number = request.body.number;
    const exp_month = request.body.exp_month;
    const exp_year = request.body.exp_year;
    const cvc = request.body.cvc;

    return stripe(env.stripe.live.secret_key).tokens.create(
        {
            card: {
                number: number,
                exp_month: exp_month,
                exp_year: exp_year,
                cvc: cvc
            }
        }, (err, charge) => {
            if (err) {
                response.send(err);
            } else {
                response.send(charge);
            }
        });

});