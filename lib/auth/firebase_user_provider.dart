import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class CollableFirebaseUser {
  CollableFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

CollableFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<CollableFirebaseUser> collableFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<CollableFirebaseUser>(
            (user) => currentUser = CollableFirebaseUser(user));
