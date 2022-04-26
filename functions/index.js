const express = require("express"),
    app = express(),
    functions = require("firebase-functions"),
    serviceAccount = require("./service_account_key.json"),
    admin = require("firebase-admin"),
    { auth } = require("./auth"),
    { todos } = require("./todos"); // think I need to do { todos } --> right now it is /todos-todos 

admin.initializeApp({
    projectId: "mooky-todo",
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://mooky-todo-default-rtdb.asia-southeast1.firebasedatabase.app",
});

module.exports = {
    auth, todos
};

//app.listen(3000, _ => console.log("connected to server"));