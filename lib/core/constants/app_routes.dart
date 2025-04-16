class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login'; // Add later
  static const String register = '/register'; // Add later
  static const String home = '/home'; // Main app screen after login/guest
  static const String guestHome = '/guest-home'; // Or reuse home with different state


  // Main Navigation Container
  static const String homeNavigator = '/home-navigator'; // Hosts bottom nav

  // Tabs within Home Navigator (might not be directly navigated to via name)
  static const String servicesCategories = '/services-categories';
  static const String more = '/more';

  // Other Screens accessible from Drawer or More page
  static const String aboutUs = '/about-us';
  static const String projects = '/projects';
  static const String projectDetails = '/project-details'; // Add if needed
  static const String store = '/store'; // Main product categories/brands
  static const String productDetails = '/product-details'; // Add if needed
  static const String serviceList = '/service-list'; // Services within a category
  static const String requestService = '/request-service';
  static const String trackOrder = '/track-order'; // Mentioned for guest/login
  static const String support = '/support';
  static const String settings = '/settings';
  static const String profile = '/profile'; // Add later with auth
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String contactUs = '/contact-us';
  static const String consultation = '/consultation';

  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password'; // Placeholder route
  static const String notificationsSettings = '/notifications-settings'; // Placeholder route
  static const String languageSettings = '/language-settings'; // Placeholder route
  static const String requestConsultation = '/requestConsultation'; // Placeholder route
  static const String consultationPackages = '/consultationPackages'; // Placeholder route


  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String subServices = '/sub-services'; // Needs category ID argument
  static const String subServiceDetails = '/sub-service-details'; // Needs service ID argument
  static const String bookingSuccess = '/booking-success'; // Needs booking code argument
  static const String bookingDetails = '/booking-details'; // Needs booking code argument
  static const String bookings = '/bookings'; // Needs booking code argument
  
  static const String authWrapper = '/authWrapper'; // Needs booking code argument
}