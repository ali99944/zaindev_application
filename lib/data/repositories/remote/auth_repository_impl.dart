import 'dart:convert'; // For jsonDecode in error parsing

import '../../../core/utils/api_helper.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/remote/auth_repository.dart';
import '../local/cache_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ApiHelper _apiHelper;
  final CacheRepository _cacheRepository;

  AuthRepositoryImpl(this._apiHelper, this._cacheRepository); // Inject dependencies

  // --- Authentication ---

  @override
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _apiHelper.postData<Map<String, dynamic>>( // Expect Map
        'auth/login',
        {'identifier': identifier, 'password': password},
      );
      // Assuming response structure: {'user': {...}, 'token': '...'}
      if (response.containsKey('token') && response.containsKey('user')) {
        // Save token upon successful login
        await _cacheRepository.set('token', response['token']);
        return response; // Return the full map including user and token
      } else {
        throw 'Login response missing token or user data.';
      }
    } catch (e) {
      perror("Login Error: $e");
      // Re-throw a more specific or user-friendly error if needed
      throw _parseApiError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    String? phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
       final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        data['phone_number'] = phoneNumber;
      }

      final response = await _apiHelper.postData<Map<String, dynamic>>(
        'auth/register',
        data,
      );
      // Assuming response structure: {'user': {...}, 'token': '...'}
       if (response.containsKey('token') && response.containsKey('user')) {
        // Save token upon successful registration
        await _cacheRepository.set('token', response['token']);
        return response;
      } else {
        throw 'Register response missing token or user data.';
      }
    } catch (e) {
      perror("Register Error: $e");
      throw _parseApiError(e);
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      // Invalidate local token first for immediate UI update
      await _cacheRepository.remove('token');
      // Then call the API to invalidate the token on the server
      // ApiHelper needs token passed explicitly or read internally
      // Modify ApiHelper if needed, or assume it reads from cache
      await _apiHelper.postData<dynamic>('auth/logout', {}); // Pass empty body
    } catch (e) {
      perror("Logout Error: $e - Proceeding with local logout.");
      // Don't block logout if API fails, but log it
      await _cacheRepository.remove('token'); // Ensure local token is removed
      // Optionally re-throw or handle differently
    }
  }

  @override
  Future<User> getUserProfile(String token) async {
    try {
      // Assume ApiHelper's getData reads the token from cache
      final response = await _apiHelper.getData<Map<String, dynamic>>('auth/user');
      return User.fromJson(response);
    } catch (e) {
      perror("Get User Profile Error: $e");
      // If token is invalid (e.g., 401 Unauthorized), handle it
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
          await _cacheRepository.remove('token'); // Clean up invalid local token
          throw 'Unauthorized. Please login again.';
      }
      throw _parseApiError(e);
    }
  }

  // --- Password Reset ---

  @override
  Future<void> sendPasswordResetOtp(String identifier) async {
    try {
      await _apiHelper.postData<dynamic>(
        'auth/password/send-otp',
        {'identifier': identifier},
      );
    } catch (e) {
      perror("Send OTP Error: $e");
      throw _parseApiError(e);
    }
  }

  @override
  Future<void> verifyPasswordResetOtp(String identifier, String code) async {
     try {
      await _apiHelper.postData<dynamic>(
        'auth/password/verify-otp',
        {'identifier': identifier, 'code': code, 'type': 'password_reset'},
      );
    } catch (e) {
      perror("Verify OTP Error: $e");
      throw _parseApiError(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
     try {
      await _apiHelper.postData<dynamic>(
        'auth/password/reset',
        {
          'identifier': identifier,
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation
        },
      );
    } catch (e) {
      perror("Reset Password Error: $e");
      throw _parseApiError(e);
    }
  }

  // --- Helper to parse potential API errors ---
  String _parseApiError(Object error) {
      if (error is String) {
          // Try to decode if it looks like JSON, otherwise return as is
          try {
              final decoded = jsonDecode(error);
              if (decoded is Map && decoded.containsKey('message')) {
                  // Check for Laravel validation errors
                  if (decoded.containsKey('errors') && decoded['errors'] is Map) {
                     final errors = decoded['errors'] as Map;
                     // Combine validation messages
                     return errors.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('\n');
                  }
                  return decoded['message'];
              }
          } catch (_) {
             // Ignore decoding error, return original string
          }
          // If it's a simple string error from ApiHelper or elsewhere
          if (error.contains("Unauthorized") || error.contains("401")) return "غير مصرح به أو الجلسة انتهت.";
          if (error.contains("Failed host lookup") || error.contains("Network is unreachable")) return "لا يوجد اتصال بالإنترنت.";
          return error; // Return original error string
      }
      return error.toString(); // Fallback
  }
}