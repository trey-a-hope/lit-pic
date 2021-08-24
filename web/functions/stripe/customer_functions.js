const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();

/*
    RETRIEVE A CUSTOMER
    Retrieves the details of an existing customer. You need only supply the unique customer identifier that was returned upon customer creation.
    PARAMS
    String customerID;
*/
exports.retrieve = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;

    return stripe(env.stripe.test.secret_key).customers.retrieve(customerID, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });
});

/*
    LIST ALL CUSTOMERS
    Retrieves the details of an existing customer. You need only supply the unique customer identifier that was returned upon customer creation.
    PARAMS
    String customerID;
*/
exports.list = functions.https.onRequest(async (request, response) => {
    const limit = request.body.limit;

    try {
        var params = {};

        if (limit !== null) {
            params['limit'] = limit;
        }

        const customersData = await stripe(env.stripe.test.secret_key).customers.list(params);

        response.send(customersData);
    } catch (err) {
        response.send(err);
    }
});

/*
    CREATE A CUSTOMER
    Creates a new customer.
    PARAMS
    String email, String description.
*/
exports.create = functions.https.onRequest((request, response) => {
    const email = request.body.email;
    const description = request.body.description;
    const name = request.body.name;

    var data = {};

    if (email !== undefined) {
        data['email'] = email
    }

    if (description !== undefined) {
        data['description'] = description
    }

    if (name !== undefined) {
        data['name'] = name
    }

    return stripe(env.stripe.test.secret_key).customers.create(data, (err, customer) => {
        if (err) {
            response.send(err);
        } else {
            response.send(customer);
        }
    });
});

/*
    UPDATE A CUSTOMER
    Update a customer.
    PARAMS
    ?
*/
exports.update = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;
    const token = request.body.token;
    const line1 = request.body.line1;
    const city = request.body.city;
    const country = request.body.country;
    const postal_code = request.body.postal_code;
    const state = request.body.state;
    const name = request.body.name;
    const email = request.body.email;
    const default_source = request.body.default_source;

    var data = {};

    //Add shipping details only if updating shipping.
    if (name !== undefined && line1 !== undefined && city !== undefined && country !== undefined && postal_code !== undefined && state !== undefined) {

        var addressData = {
            line1: line1,
            city: city,
            country: country,
            postal_code: postal_code,
            state: state
        }

        data['shipping'] = {
            name: name,
            address: addressData
        }
    }

    if (token !== undefined) {
        data['source'] = token
    }

    if (email !== undefined) {
        data['email'] = email
    }

    if (name !== undefined) {
        data['name'] = name
    }

    if (default_source !== undefined) {
        data['default_source'] = default_source
    }

    return stripe(env.stripe.test.secret_key).customers.update(customerID,
        data, (err, customer) => {
            if (err) {
                response.send(err);
            } else {
                response.send(customer);
            }
        });
});

/*
    DELETE A CUSTOMER
    Permanently deletes a customer. It cannot be undone. Also immediately cancels any active subscriptions on the customer.
    PARAMS
    String customerID;
*/
exports.delete = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;

    return stripe(env.stripe.test.secret_key).customers.del(customerID, (err, confirmation) => {
        if (err) {
            response.send(err);
        } else {
            response.send(confirmation);
        }
    });
});

/*
    DELETE ALL CUSTOMERS
    Permanently deletes all customers. It cannot be undone. Also immediately cancels any active subscriptions on the customer.
    PARAMS
*/
exports.deleteBulk = functions.https.onRequest(async (request, response) => {
    const limit = request.body.limit;
    const customerIdOfAdmin = request.body.customerIdOfAdmin;

    try {
        var params = {};

        if (limit !== null) {
            params['limit'] = limit;
        }

        const customersData = await stripe(env.stripe.test.secret_key).customers.list(params);

        var promises = [];

        for (var i = 0; i < customersData['data'].length; i++) {
            var customer = customersData['data'][i];
            if (customer['id' !== customerIdOfAdmin])
                promises.push(stripe(env.stripe.test.secret_key).customers.del(customer['id']));
        }

        await Promise.all(promises);

        response.send('Deleted customers.');
    } catch (err) {
        response.send(err);
    }
});