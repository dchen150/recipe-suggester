const functions = require("firebase-functions");
const vision = require("@google-cloud/vision");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

/**
 * HELPERS
 */

const findFoodHelper = async (request, response) => {
  const imageBase64 = request.body.image;
  const client = new vision.ImageAnnotatorClient();

  const [result] = await client.objectLocalization({
    image: {
      content: imageBase64,
    },
  });
  // array of objects found in the image
  const objects = result.localizedObjectAnnotations;
  const output = [];

  for (let i = 0; i < objects.length; ++i) {
    if (objects[i].score > 0.50) {
      output.push(objects[i].name);
    }
  }

  functions.logger.info("findFood logs!", {structuredData: true});
  response.send(200, {
    objects: output,
  });
};


const readReceiptHelper = async (request, response) => {
  const imageBase64 = request.body.image;
  const client = new vision.ImageAnnotatorClient();

  const [result] = await client.textDetection({
    image: {
      content: imageBase64,
    },
  });
  let detections = result.textAnnotations[0].description;
  detections = detections.replace(/\n/g, ",");
  const arrayOfDetections = detections.split(",");
  const output = [];

  arrayOfDetections.forEach((str) => {
    // if doesn't contain digits, is a grocery,
    // has not already been added, and is not an empty string
    if (!/\d/.test(str) &&
    isGrocery(str) &&
    !output.includes(str) &&
    str !== "") {
      output.push(str);
    }
  });

  response.send(200, {
    objects: output,
  });
};

const isGrocery = (str) => {
  const nonGroceryWords = [
    "Auth",
    "AMOUNT",
    "$",
    "TOT",
    "ITEM",
    "AID",
    "TVR",
    "IAD",
    "TSI",
    "TAX",
    "FA",
  ];
  for (let i = 0; i < nonGroceryWords.length; ++i) {
    if (str.includes(nonGroceryWords[i])) {
      return false;
    }
  }
  return true;
};

/**
 * Exported Functions
 */

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.findFood = functions.https.onRequest(findFoodHelper);

exports.readReceipt = functions.https.onRequest(readReceiptHelper);
