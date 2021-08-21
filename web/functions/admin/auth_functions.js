const admin = require('firebase-admin');
const functions = require('firebase-functions');

exports.deleteUsers = functions.https.onRequest(async (request, response) => {
  const adminDocId = request.body.adminDocId;

  try {
    var result = await admin.auth().listUsers();

    var promises = [];

    result.users.forEach((user) => {
      if (user.uid !== adminDocId)
        promises.push(admin.auth().deleteUser(user.uid));
    });

    await Promise.all(promises);

    response.send(success);
  } catch (e) {
    response.send(e);
  }
});
