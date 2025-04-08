import 'package:flutter/material.dart';
import 'package:zaindev_application/core/routing/router_utils.dart';
import 'package:zaindev_application/presentation/screens/authentication/otp_verification.dart';
import 'package:zaindev_application/presentation/screens/authentication/reset_password_screen.dart';
import 'package:zaindev_application/presentation/screens/home/home_screen.dart';
import 'package:zaindev_application/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:zaindev_application/presentation/screens/profile/profile_screen.dart';
import 'package:zaindev_application/presentation/screens/services/services_screen.dart';
import '../../presentation/screens/authentication/change_password_screen.dart';
import '../../presentation/screens/authentication/forgot_password_screen.dart';
import '../../presentation/screens/authentication/login_screen.dart';
import '../../presentation/screens/authentication/register_screen.dart';
import '../../presentation/screens/bookings/bookings_screen.dart';
import '../../presentation/screens/home/home_navigator_screen.dart';
import '../../presentation/screens/welcome/welcome_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      // case SplashScreen.route:
      //   return buildCustomBuilder(SplashScreen(), settings);

      case WelcomeScreen.route:
        return buildCustomBuilder(WelcomeScreen(), settings);

      case ChangePasswordScreen.route:
        return buildCustomBuilder(ChangePasswordScreen(), settings);

      case LoginScreen.route:
        return buildCustomBuilder(LoginScreen(), settings);

      case RegisterScreen.route:
        return buildCustomBuilder(RegisterScreen(), settings);

      case ProfileScreen.route:
        return buildCustomBuilder(ProfileScreen(), settings);

      case OnboardingScreen.route:
        return buildCustomBuilder(OnboardingScreen(), settings);

      case HomeScreen.route:
        return buildCustomBuilder(HomeScreen(), settings);

      case BookingsScreen.route:
        return buildCustomBuilder(BookingsScreen(), settings);

      case HomeNavigatorScreen.route:
        return buildCustomBuilder(HomeNavigatorScreen(), settings);

      case ForgotPasswordScreen.route:
        return buildCustomBuilder(ForgotPasswordScreen(), settings);

      case ResetPasswordScreen.route:
        return buildCustomBuilder(ResetPasswordScreen(arguments: {},), settings);

      case OtpVerificationScreen.route:
        return buildCustomBuilder(OtpVerificationScreen(arguments: {},), settings);

      case AllServiceCategoriesScreen.route:
        return buildCustomBuilder(AllServiceCategoriesScreen(), settings);

      default:
        return buildCustomBuilder(Container(), settings);
    }
  }
}