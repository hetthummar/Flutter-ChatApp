import 'package:firebase_auth/firebase_auth.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/services/socket_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SocketService _socketService = locator<SocketService>();

  Future<String> signInWithOTP(smsCode, verId) async {
    AuthCredential authCred = PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    String signInResponse = await signIn(authCred);
    return signInResponse;
  }

  Future<String> signIn(AuthCredential authCred) async {
    String returnResult = "error";
    try {
      UserCredential authRes =
      await FirebaseAuth.instance.signInWithCredential(authCred);

      User? _user =  authRes.user;
      if (_user != null) {
        returnResult = "noError";
      }

      return returnResult;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> logOut() async {
    await _auth.signOut();
    return true;
  }

  Future<String?> getUserid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.uid;
  }

  Future<String?> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.getIdToken();
    // return user.uid;
  }

  Future<String?> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.displayName;
  }

  Future<bool> isUserLoggedIn() async {
    String? userId = await getUserid();
    if (userId == null) return false;
    return true;
  }

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

}
