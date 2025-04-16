import 'package:flutter/material.dart'; // For TimeOfDay

import '../../core/constants/app_colors.dart'; // For status color

enum BookingStatus { pending, confirmed, inProgress, completed, cancelled, unknown }

class Booking {
  final String id;
  final String bookingCode;
  final String serviceName;
  final BookingStatus status;
  final DateTime requestDate;
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final String? serviceProviderName;
  final String? address;
  final String? notes;
  // Add other relevant fields like price, user ID etc.

  Booking({
    required this.id,
    required this.bookingCode,
    required this.serviceName,
    required this.status,
    required this.requestDate,
    this.scheduledDate,
    this.scheduledTime,
    this.serviceProviderName,
    this.address,
    this.notes,
  });

  // Helper to get status string for display
  String get statusDisplay {
    switch (status) {
      case BookingStatus.pending: return 'قيد الانتظار';
      case BookingStatus.confirmed: return 'مؤكد';
      case BookingStatus.inProgress: return 'قيد التنفيذ';
      case BookingStatus.completed: return 'مكتمل';
      case BookingStatus.cancelled: return 'ملغي';
      default: return 'غير معروف';
    }
  }

   // Helper to get status color
   Color get statusColor {
      switch (status) {
        case BookingStatus.pending: return Colors.orange.shade700;
        case BookingStatus.confirmed: return Colors.blue.shade700;
        case BookingStatus.inProgress: return AppColors.primary;
        case BookingStatus.completed: return Colors.green.shade700;
        case BookingStatus.cancelled: return AppColors.accent;
        default: return AppColors.textSecondary;
      }
   }

   // TODO: Add fromJson/toJson if interacting with API directly with this model
}