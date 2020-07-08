import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.database();
const fcm = admin.messaging();

export const sendToDevice = functions.database
  .ref('books/{bookId}/comments/{commentId}')
  .onCreate(async snapshot => {
    // Grab the current value of what was written to the Realtime Database.
    const comment = snapshot.val();

    const querySnapshotWriter = await db.ref("users/{comment.userId}").once('value');

    const querySnapshotUser = await db.ref("books/{bookId}/authorId").once('value');

    const querySnapshotTokens = await db.ref("users/{querySnapshotUser.val()}").once('value');

    const tokens = querySnapshotTokens.val().token;

    const name = querySnapshotWriter.val().firstName;

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: '{name} commented on your book!',
        body: comment.commentDesc,
        icon: "assets/logo_white.png",
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload)
      .then(function(result){
        console.log("Notification sent successfully");
        return null;
      })
      .catch(function(error){
          console.log('Notification sent failed', error);
          return null;
      });
  });
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
