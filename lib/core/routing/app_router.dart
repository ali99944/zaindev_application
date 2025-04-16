import 'package:flutter/material.dart';
import 'package:zaindev_application/core/constants/app_routes.dart';
import 'package:zaindev_application/core/routing/router_utils.dart';
import 'package:zaindev_application/presentation/screens/bookings/booking_details_screen.dart';
import 'package:zaindev_application/presentation/screens/legal/privacy_policy_screen.dart';
import 'package:zaindev_application/presentation/screens/legal/terms_condition_screen.dart';
import 'package:zaindev_application/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:zaindev_application/presentation/screens/projects/project_details_screen.dart';
import 'package:zaindev_application/presentation/screens/projects/projects_screen.dart';
import 'package:zaindev_application/presentation/screens/settings/settings_screen.dart';
import 'package:zaindev_application/presentation/screens/welcome/welcome_screen.dart';
import 'package:zaindev_application/presentation/screens/zaindev/about_us.dart';
import 'package:zaindev_application/presentation/screens/zaindev/contact_us.dart';
import 'package:zaindev_application/presentation/wrappers/auth_wrapper.dart';

import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_verification_screen.dart';
import '../../presentation/screens/auth/profile_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/reset_password_screen.dart';
import '../../presentation/screens/consultation/consultation_packages_screen.dart';
import '../../presentation/screens/consultation/request_consultation_screen.dart';
import '../../presentation/screens/navigator/home_navigator_screen.dart';
import '../../presentation/screens/services/booking_success_screen.dart';
import '../../presentation/screens/services/request_service_screen.dart';
import '../../presentation/screens/services/sub_service_details_screen.dart';
import '../../presentation/screens/services/sub_services_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/support/support_screen.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case AppRoutes.splash:
        return buildCustomBuilder(SplashScreen(), settings);

      case AppRoutes.onboarding:
        return buildCustomBuilder(OnboardingScreen(), settings);

      case AppRoutes.welcome:
        return buildCustomBuilder(WelcomeScreen(), settings);


      case AppRoutes.homeNavigator: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const HomeNavigatorScreen(), settings);


      case AppRoutes.contactUs: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const ContactUsScreen(), settings);


      case AppRoutes.aboutUs: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const AboutUsScreen(), settings);


      case AppRoutes.privacyPolicy: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const PrivacyPolicyScreen(), settings);


      case AppRoutes.termsConditions: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const TermsConditionsScreen(), settings);

      case AppRoutes.authWrapper: // Entry point after login/guest/onboarding
      return buildCustomBuilder(const AuthWrapper(), settings);


      case AppRoutes.login:
        return buildCustomBuilder(const LoginScreen(), settings);
      case AppRoutes.register:
        return buildCustomBuilder(const RegisterScreen(), settings);
      case AppRoutes.settings:
        return buildCustomBuilder(const SettingsScreen(), settings);


      case AppRoutes.support:
        return buildCustomBuilder(const SupportScreen(), settings);
        
      case AppRoutes.requestConsultation:
        return buildCustomBuilder(RequestConsultationScreen(), settings);
      case AppRoutes.consultationPackages:
        return buildCustomBuilder(const ConsultationPackagesScreen(), settings);


      case AppRoutes.projects:
        return buildCustomBuilder(ProjectsScreen(), settings);
      case AppRoutes.projectDetails:
        return buildCustomBuilder(ProjectDetailsScreen(
          projectId: 2,
        ), settings);


      case AppRoutes.forgotPassword:
        return buildCustomBuilder(const ForgotPasswordScreen(), settings);

      case AppRoutes.otpVerification:
        // Expecting settings.arguments like {'contact': 'email@example.com', 'type': 'password_reset'}
        if (settings.arguments is Map<String, String>) {
           return buildCustomBuilder(OtpVerificationScreen(contactInfo: 'alitarek99944@gmail.com', verificationType: 'password_reset'), settings);
        }
        return buildCustomBuilder(const OtpVerificationScreen(contactInfo: '', verificationType: 'error'), settings); // Error case

      case AppRoutes.resetPassword:
         // Expecting settings.arguments like {'contact': 'email@example.com', 'otp': '123456'} or token
         if (settings.arguments is Map<String, String>) {
            return buildCustomBuilder(ResetPasswordScreen(contactInfo: 'alitarek99944@gmail.com', otpOrToken: '1234'), settings);
         }
          return buildCustomBuilder(const ResetPasswordScreen(contactInfo: '', otpOrToken: ''), settings); // Error case


      case AppRoutes.profile:
        return buildCustomBuilder(const ProfileScreen(), settings);


        case AppRoutes.changePassword:
        // For logged-in users, might need a different flow (current pass + new pass)
        // Or reuse ResetPasswordScreen if flow is similar but needs auth check first
        return buildCustomBuilder(const ResetPasswordScreen(isChangePassword: true, contactInfo: '', otpOrToken: ''), settings); // Example reuse

      case AppRoutes.subServices:
        // Expecting category ID/Name as argument
        if (settings.arguments is String) {
            return buildCustomBuilder(SubServicesScreen(categoryId: 'cat1'), settings);
        }
         return buildCustomBuilder(const SubServicesScreen(categoryId: 'error'), settings); // Error case

      case AppRoutes.subServiceDetails:
          // Expecting sub-service ID/Name as argument
         if (settings.arguments is String) {
            return buildCustomBuilder(SubServiceDetailsScreen(serviceId: 'sub1_2'), settings);
        }
         return buildCustomBuilder(const SubServiceDetailsScreen(serviceId: 'error'), settings); // Error case

      case AppRoutes.requestService:
          // Expecting sub-service ID/Name as argument
          if (settings.arguments is String) {
            return buildCustomBuilder(RequestServiceScreen(serviceId: 'cat1'), settings);
         }
          return buildCustomBuilder(const RequestServiceScreen(serviceId: 'error'), settings); // Error case

       case AppRoutes.bookingSuccess:
           // Expecting booking details map as argument
           if (settings.arguments is Map<String, String>) {
              return buildCustomBuilder(BookingSuccessScreen(bookingCode: 'SB154555', serviceName: 'تكييفات'), settings);
           }
            return buildCustomBuilder(const BookingSuccessScreen(bookingCode: 'N/A', serviceName: 'N/A'), settings); // Error case

       case AppRoutes.bookingDetails:
           // Expecting booking details map as argument
           if (settings.arguments is String) {
              return buildCustomBuilder(BookingDetailsScreen(bookingId: settings.arguments as String), settings);
           }
            return buildCustomBuilder(const BookingSuccessScreen(bookingCode: 'N/A', serviceName: 'N/A'), settings); // Error case

      default:
        return buildCustomBuilder(Container(), settings);
    }
  }
}