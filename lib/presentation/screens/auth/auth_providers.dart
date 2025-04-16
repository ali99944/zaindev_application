import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/api_helper.dart';
import '../../../data/repositories/local/cache_repository.dart';
import '../../../data/repositories/remote/auth_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/remote/auth_repository.dart';


// == Core Providers ==

// Provider for ApiHelper (if it's stateless and doesn't need ref)
final apiHelperProvider = Provider<ApiHelper>((ref) => ApiHelper()); // Adjust if needed

// Provider for CacheRepository (already setup from previous step)
// final cacheRepositoryProvider = Provider<CacheRepository>((ref) => CacheRepository.instance);

// Provider for AuthRepository Implementation
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  // Use CacheRepository.instance directly if setup as singleton
  return AuthRepositoryImpl(ref.read(apiHelperProvider), CacheRepository.instance);
});

// == Authentication State Notifier ==

// State class for authentication
class AuthState {
  final bool isLoading;
  final User? user;
  final String? token;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
  });

  bool get isAuthenticated => user != null && token != null;

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? token,
    String? error,
    bool clearError = false, // Helper to clear error easily
    bool clearUserAndToken = false, // Helper for logout
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUserAndToken ? null : user ?? this.user,
      token: clearUserAndToken ? null : token ?? this.token,
      error: clearError ? null : error ?? this.error,
    );
  }
}

// State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;
  final CacheRepository _cacheRepository;

  AuthNotifier(this._authRepository, this._cacheRepository) : super(AuthState()) {
    _checkAuthStatus(); // Check status on initialization
  }

  // Check local storage for token and validate it
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await _cacheRepository.get('token');
      if (token != null && token.isNotEmpty) {
        // Validate token by fetching user profile
        final user = await _authRepository.getUserProfile(token);
        state = state.copyWith(isLoading: false, user: user, token: token);
      } else {
        state = state.copyWith(isLoading: false, clearUserAndToken: true); // No token found
      }
    } catch (e) {
       print("Auth Check Error: $e");
      // Token might be invalid, treat as logged out
      await _cacheRepository.remove('token'); // Clean up potentially invalid token
      state = state.copyWith(isLoading: false, error: e.toString(), clearUserAndToken: true);
    }
  }

  Future<void> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _authRepository.login(identifier, password);
      final user = User.fromJson(response['user']);
      final token = response['token'] as String;
      // Token is saved by repository, update state here
      state = state.copyWith(isLoading: false, user: user, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // Re-throw for UI to handle if needed
    }
  }

  Future<void> register({
    required String name,
    required String email,
    String? phoneNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
     state = state.copyWith(isLoading: true, clearError: true);
     try {
      final response = await _authRepository.register(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          passwordConfirmation: passwordConfirmation);
      final user = User.fromJson(response['user']);
      final token = response['token'] as String;
      // Token is saved by repository, update state here
      state = state.copyWith(isLoading: false, user: user, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
     state = state.copyWith(isLoading: true, clearError: true);
     final currentToken = state.token; // Get token before clearing state
     try {
        // Update state immediately for faster UI response
        state = state.copyWith(isLoading: false, clearUserAndToken: true);
        if (currentToken != null) {
           await _authRepository.logout(currentToken); // Call API logout
        }
        // Token is removed from cache by repository/logout method
     } catch (e) {
        // State is already logged out locally, just log the error
        print("Logout API Error: $e");
        state = state.copyWith(isLoading: false, error: "Logout failed on server, logged out locally.");
     }
  }

   // Method to manually trigger profile refresh if needed
   Future<void> refreshUserProfile() async {
       if (state.token == null) return; // No token, can't refresh
       state = state.copyWith(isLoading: true, clearError: true);
       try {
           final user = await _authRepository.getUserProfile(state.token!);
           state = state.copyWith(isLoading: false, user: user);
       } catch (e) {
           print("Refresh User Profile Error: $e");
           // If unauthorized, log out
            if (e.toString().contains('Unauthorized')) {
               await logout();
           } else {
              state = state.copyWith(isLoading: false, error: e.toString());
           }
       }
   }
}

// Provider for the AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Use CacheRepository.instance directly if setup as singleton
  return AuthNotifier(ref.watch(authRepositoryProvider), CacheRepository.instance);
});


// == Screen Specific State Providers (Keep these for UI interaction) ==

// Login
final loginIdentifierProvider = StateProvider.autoDispose<String>((ref) => ''); // Changed name
final loginPasswordProvider = StateProvider.autoDispose<String>((ref) => '');
final loginPasswordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final loginLoadingProvider = StateProvider.autoDispose<bool>((ref) => false); // Or watch authNotifierProvider.isLoading

// Register
final registerNameProvider = StateProvider.autoDispose<String>((ref) => '');
final registerEmailProvider = StateProvider.autoDispose<String>((ref) => '');
final registerPhoneProvider = StateProvider.autoDispose<String>((ref) => '');
final registerPasswordProvider = StateProvider.autoDispose<String>((ref) => '');
final registerConfirmPasswordProvider = StateProvider.autoDispose<String>((ref) => '');
final registerPasswordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerConfirmPasswordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerTermsAcceptedProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerLoadingProvider = StateProvider.autoDispose<bool>((ref) => false); // Or watch authNotifierProvider.isLoading

// Forgot Password
final forgotPasswordContactProvider = StateProvider.autoDispose<String>((ref) => '');
final forgotPasswordLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

// OTP
final otpCodeProvider = StateProvider.autoDispose<String>((ref) => '');
final otpLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final otpResendTimerProvider = StateProvider.autoDispose<int>((ref) => 60);
final otpCanResendProvider = StateProvider.autoDispose<bool>((ref) => false);

// Reset Password
final newPasswordProvider = StateProvider.autoDispose<String>((ref) => '');
final confirmNewPasswordProvider = StateProvider.autoDispose<String>((ref) => '');
final newPasswordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final confirmNewPasswordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final resetPasswordLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);