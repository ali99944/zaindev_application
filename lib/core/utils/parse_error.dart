import 'dart:convert';

String parseApiError(Object error) {
    // Reuse or adapt the error parsing logic from AuthRepositoryImpl
      if (error is String) {
          try {
              final decoded = jsonDecode(error);
              if (decoded is Map && decoded.containsKey('message')) { return decoded['message']; }
          } catch (_) { /* Ignore */ }
          if (error.contains("Failed host lookup") || error.contains("Network is unreachable")) return "لا يوجد اتصال بالإنترنت.";
          return error;
      }
      return error.toString();
  }