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
    const comment = await change.after.val().comments;
    const keys =  Object.keys(comment)
    var lastId;
    for (const key of keys){
      lastId = key
    }
    const lastestComment = comment[lastId]
    const desc = lastestComment['commentDesc']
    const commenterid = lastestComment ['userId']
    const commentDate = lastestComment ['dateCreated']

    console.log(commenterid);
    // console.log(comment['-MB8ZNs7kwJyoewAVMnj']);

    // const querySnapshotWriter = await db.ref("books").child(bookId).once('value');
    // console.log(querySnapshotWriter);
    const querySnapshotTokens = await db.ref("users").child(authorId).once('value');

    const tokens = querySnapshotTokens.val().token;

    //const name = querySnapshotWriter.val().firstName;

    const payload =  {
      notification: {
        title: 'Someone commented on your book!',
        body: desc,
        icon: "assets/logo_white.png",
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
        // click_action: 'FCM_PLUGIN_ACTIVITY'
      },
      data: {
        commentUserId: commenterid,
        commentDate : commentDate.toString(),
        commentId: lastId
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
