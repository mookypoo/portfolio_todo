const express = require("express"),
    app = express(),
    functions = require("firebase-functions"),
    admin = require("firebase-admin"),
    uuid = require("uuid"),
    { verifyUser } = require("./auth");

app.post("/add", async (req, res) => {
    const todoUid = uuid.v1();
    const createdTime = new Date().toISOString();
    const title = req.body.title;
    const isChecked = false;
    const todo = { todoUid, createdTime, title, isChecked };
    try {
        const _verified = await verifyUser(req)
        if (_verified) {
            await admin.database().ref(`/todos/${req.body.userUid}`).child(todoUid).set(todo);
            res.send({ todo });
        } else {
            res.send({ error: "user not verified" });
        }
    } catch (e) {
        console.log(e);
        res.send({ error: e });
    }
});

app.post("/get", async (req, res) => {
    try {
        const _verified = await verifyUser(req);
        if (_verified) {
            const _dataSnapshot = await admin.database().ref(`/todos/${req.body.userUid}`).orderByChild("createdTime").get();
            let todos = [];
            if (_dataSnapshot.val() != null) todos = Object.values(_dataSnapshot.val());
            res.send({ todos });
        } else {
            res.send({ error: "user not verified" });
        }
    } catch (e) {
        console.log(e);
        res.send({ error: e });
    }
});

app.post("/update", async (req, res) => {
    try {
        const _verified = await verifyUser(req);
        if (_verified) {
            let updateInfo = {};
            req.body.updatedTodos.forEach(info => updateInfo[info.path] = info.title);
            console.log(updateInfo);
            await admin.database().ref(`/todos/${req.body.userUid}`).update(updateInfo);
            res.send({ data: "success" });
        } else {
            res.send({ error: "user not verified" });
        }
    } catch (e) {
        console.log(e);
        res.send({ error: e });
    }
});

app.post("/delete", async (req, res) => {
    try {
        const _verified = await verifyUser(req);
        if (_verified) {
            await admin.database().ref(`/todos/${req.body.userUid}`).child(req.body.todoUid).remove();
            res.send({ data: "success" });
        } else {
            res.send({ error: "user not verified" });
        }
    } catch (e) {
        console.log(e);
        res.send({ error: e });
    }
});

app.post("/check", async (req, res) => {
    try {
        const _verified = await verifyUser(req);
        if (_verified) {
            await admin.database().ref(`/todos/${req.body.userUid}`).child(req.body.todoUid).update({ isChecked: req.body.isChecked });
            res.send({ data: "success" });
        } else {
            res.send({ error: "user not verified" });
        }
    } catch (e) {
        console.log(e);
        res.send({ error: e });
    }
});

exports.todos = functions.https.onRequest(app);