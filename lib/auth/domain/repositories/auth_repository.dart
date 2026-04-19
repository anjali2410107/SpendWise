abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> signUp(String email, String password);
  Future<void> logout();
  String? getCurrentUserId();
  Future<String> signInWithGoogle();

}