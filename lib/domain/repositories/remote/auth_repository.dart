import '../../entities/user.dart';

abstract class IAuthRepository {
  Future<Map<String, dynamic>> login(String identifier, String password);
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    String? phoneNumber,
    required String password,
    required String passwordConfirmation,
  });
  Future<void> logout(String token); // Pass token for potential server-side invalidation if needed
  Future<User> getUserProfile(String token); // Needs token
  Future<void> sendPasswordResetOtp(String identifier);
  Future<void> verifyPasswordResetOtp(String identifier, String code); // Optional
  Future<void> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  });
}