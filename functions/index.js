const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const db = admin.database();
const fcm = admin.messaging();

exports.sendToDevice = functions.database
  .ref('books/{any}')
  .onUpdate(async (change, context) => {
    // Grab the current value of what was written to the Realtime Database.

    const authorId = change.after.val().authorId;
    const comment = change.after.val().comments.last;

    const querySnapshotWriter = await db.ref("users").child(comment.userId).once('value');

    const querySnapshotTokens = await db.ref("users").child(authorId).once('value');

    const tokens = querySnapshotTokens.val().token;

    const name = querySnapshotWriter.val().firstName;

    const payload =  {
      notification: {
        title: name + ' commented on your book!',
        body: comment.commentDesc,
        icon: "assets/logo_white.png",
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
