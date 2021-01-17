# Wish A Dish
## Inspiration
The average home wastes $2000 worth of food a year! As a result of COVID, many individuals were panic buying which led to poor planning and even more money wasted. Another inspiration to this project is the social restrictions that now exist across the globe because of COVID. Hopefully this project can encourage people to cook at home instead of dining out.

## What it does
Wish a Dish is a 2 part solution - mobile app and Google Assistant App. Using the mobile app, users can keep track of what groceries/ingredients they have by adding via 1 of the 3 following methods: upload a photo of the food, upload a photo of a receipt of groceries, or upload by text.

Users can then speak to their Google Assistant (powered by Voiceflow) and specify their dietary, which will then figure out a few recipes that you can make with whatever ingredients you currently have. This recipe is uploaded to a Firestore database which updates to the mobile app in real time - the user can then follow along with their Google Assistant or mobile app to whip up a delicious dish!

## How I built it
The mobile app is built with Flutter, Dart, and is hooked up to a few Firebase tools. We used Firestore as our database to store user's ingredients and chosen recipes. To upload to Firestore, we used Firebase Cloud Functions to deploy endpoints for us which allowed us to upload images to Google's Cloud Vision API which uses Object Detection and OCR tools to scan groceries/receipts to add to the virtual kitchen. 

The Snapshot feature in Firebase was especially convenient to maintain a real time connection between the database, which allowed us to immediately reflect the recipe selection made with Google Assistant in the mobile app. 

Voiceflow was used to deploy our application to Google Assistant. In Voiceflow, we were able to identify their user, confirm dietary concerns, and connect to Cloud Firestore through REST APIs and retrieve the ingredients that a user has in their virtual kitchen as well as upload their chosen recipe to Firestore so that they can view it on their mobile device. 

## Challenges I ran into
We spent a lot of time trying to get the frontend Flutter mobile app to call Google Cloud Vision API, but after speaking to Alex (mentor from firebase), we found that hosting that functionality on Firebase Cloud Functions was a lot easier. 

## Accomplishments that I'm proud of
Connecting Voiceflow to REST APIs and syncing it with the mobile app!

## What I learned
Learned several firebase tools, flutter, and voiceflow

## What's next for Wish a Dish
Google Authentication for user IDs
