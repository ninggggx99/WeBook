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
    const bookId = change.after.val().bookId;
    console.log("hi");
    console.log(authorId);
    const comment = change.after.val().comments[0];
    // console.log(comment[0]);
    // console.log(comment);
    

    //const querySnapshotWriter = await db.ref("users").child(comment.userId).once('value');

    const querySnapshotTokens = await db.ref("users").child(authorId).once('value');

    const tokens = querySnapshotTokens.val().token;

    //const name = querySnapshotWriter.val().firstName;

    const payload =  {
      notification: {
        title: 'Someone commented on your book!',
        body: "this is it",
        icon: "assets/logo_white.png",
        click_action: 'FCM_PLUGIN_ACTIVITY'
      },
      data: {
        orderId:"123",
        pickLocation:"g10",
        dropLocation:"f10",
        orderType:"Posted"
        }
    };

    return admin.messaging().sendToDevice(tokens, payload)
      .then((response) => {
        console.log("Successfully sent message:", response);
        console.log(response.results[0].error);
        console.log("token :"+ tokens);
        return null;
      }).catch((error) => {
        console.log("Error sending message:", error);
        return null;
      });
  });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
