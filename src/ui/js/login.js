/* login.js */

var LOGIN = LOGIN || {};

$(function() {
  var FIREBASE_URL = "https://ychacks.firebaseio.com/";

  var rootRef = new Firebase(FIREBASE_URL);

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
        cb(err, user.auth.uid);
      }
    });
  };

  LOGIN.registerForUnauth = function(unauth) {
    rootRef.child('sessions').child(sessionStorage.uid).on('value', function(snap) {
      if (snap.val() === null) {
        unauth();
      }
    });
  };

});