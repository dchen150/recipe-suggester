"use strict";

Object.defineProperty(exports, "__esModule", {value: true});
exports.goodBye = exports.helloWorld = void 0;
const functions = require("firebase-functions");

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.goodBye = functions.https.onRequest((request, response) => {
  functions.logger.info("GOODBYE");
  response.send("GOODBYE FROM FIREBASE");
});
// # sourceMappingURL=index.js.map
