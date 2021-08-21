// const admin = require('firebase-admin');
// const functions = require('firebase-functions');

// admin.initializeApp(functions.config().firebase);

// exports.deleteUsers = functions.https.onRequest((request, response) => {
//     const customerID = request.body.customerID;
//     const token = request.body.token;


// // Lookup user accounts by uid, email, phone number of IdP-assigned uid.
// // List up to 100 identifiers to lookup.
// const uids = [
//   {uid: 'sample-uid-1'},
//   {uid: 'sample-uid-2'},
//   {email: 'user1@example.org'},
//   {phoneNumber: '+1234567890'},
//   {providerId: 'google.com', providerUid: 'user2@google.com'},
// ];

// const markedForDelete = [];

// // Retrieve a batch of user accounts.
// admin.auth().getUsers(uids)
//   .then((result) => {
//     // Mark disabled accounts for deletion.
//     result.users.forEach((user) => {
//       if (user.disabled) {
//         markedForDelete.push(user.uid);
//       }
//     });

//     result.notFound.forEach((uid) => {
//       console.log(`No user found for identifier: ${JSON.stringify(uid)}`)
//     });
//   })
//   .then(() => {
//     // Delete all marked user accounts in a single API call.
//     return admin.auth().deleteUsers(markedForDelete);
//   }).c


// //    return stripe(env.stripe.test.secret_key).customers.createSource(
// //        customerID,
// //        {
// //            source: token,
// //        }, (err, charge) => {
// //            if (err) {
// //                response.send(err);
// //            } else {
// //                response.send(charge);
// //            }
// //        });

// });
