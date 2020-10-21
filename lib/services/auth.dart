import 'package:firebase_auth/firebase_auth.dart';
import 'package:shortblogapp/models/newUser.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  NewUser _userFromFirebase({User user}) {
    return user != null ? NewUser(uid: user.uid) : null;
  }

  // Register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User _user = result.user;
      return _user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<NewUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebase(user: user));
  }

  // Sign In
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signOut
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
