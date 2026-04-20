import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  AuthRepositoryImpl(this.auth);

  @override
  Future<String> signUp(String email, String password) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }

  @override
  Future<String> login(String email, String password) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  await GoogleSignIn().signOut();
  }

  @override
  String? getCurrentUserId() {
    return auth.currentUser?.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) throw Exception("Google sign-in cancelled");

    final GoogleSignInAuthentication authTokens = await account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: authTokens.accessToken,
      idToken: authTokens.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) throw Exception("User is null");

    return user.uid;
  }
}