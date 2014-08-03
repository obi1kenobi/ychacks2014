/* login.js */

var LOGIN = LOGIN || {};

$(function() {
  var FIREBASE_URL = "https://ychacks.firebaseio.com/";

  var rootRef = new Firebase(FIREBASE_URL);
  var sessionRef = null

  LOGIN.pair = function(pairingCode, cb) {
    rootRef.child('tokens').child(pairingCode).once('value', function(snap) {
      var token = snap.val();
      if (typeof token === 'string') {
        sessionStorage.firebaseToken = token;
        cb(null, true);
      } else {
        console.log("Got weird token " + token);
        sessionStorage.firebaseToken = token;
        cb(null, false);
      }
    });
  };

  /* cb(err, uid) */
  LOGIN.auth = function(cb) {
    rootRef.auth(sessionStorage.firebaseToken, function(err, user) {
      if (err !== undefined) {
        console.log("Error on auth: ", err);
        cb(err);
      } else {
        console.log("Logged in with user " + JSON.stringify(user));
        sessionStorage.uid = user.auth.uid;
        sessionRef = rootRef.child('sessions').child(sessionStorage.uid)
        cb(err, user.auth.uid);
      }
    });
  };

  LOGIN.registerForUnauth = function(unauth) {
    sessionRef.on('value', function(snap) {
      if (snap.val() === null) {
        unauth();
      }
    });
  };

  LOGIN.executeCommand = function(type, name) {
    sessionRef.child('events').push({type: type, name: name});
  };

  LOGIN.onServerDisconnect = function(cb) {
    sessionRef.on('value', function(snap) {
      if (snap.val() === null) {
        sessionStorage.removeItem('uid');
        sessionStorage.removeItem('firebaseToken');
        cb();
      }
    });
  };

  LOGIN.setCurrentApp = function(name) {
    sessionRef.child('current_app').set(name);
  };

  LOGIN.onAddedRunningApp = function(cb) {
    sessionRef.child('running_apps').on('child_added', function(snap, prevChild) {
      cb(snap.name());
    });
  };

  LOGIN.onRemovedRunningApp = function(cb) {
    sessionRef.child('running_apps').on('child_removed', function(snap) {
      cb(snap.name());
    });
  };

});