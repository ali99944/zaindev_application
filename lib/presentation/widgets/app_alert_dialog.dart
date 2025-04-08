import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'primary_button.dart'; // Import custom button

enum DialogType { success, error, warning, info }

class AppAlertDialog extends StatelessWidget {
  final DialogType dialogType;
  final String title;
  final String message;
  final String okButtonText;
  final VoidCallback? onOkPressed; // Optional specific action

  const AppAlertDialog({
    super.key,
    required this.dialogType,
    required this.title,
    required this.message,
    this.okButtonText = 'حسناً', // Default OK text
    this.onOkPressed,
  });

  IconData _getIconForType(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.warning:
        return Icons.warning_amber_outlined;
      case DialogType.info:
        return Icons.info_outline;
    }
  }

  Color _getColorForType(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.info:
        return AppColors.primary; // Or AppColors.grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getColorForType(dialogType);
    final iconData = _getIconForType(dialogType);
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)), // Low radius
      icon: Icon(iconData, color: iconColor, size: 48), // Icon above title
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.center, // Center the button
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // Adjust padding
      actions: <Widget>[
        PrimaryButton( // Use the custom button
          text: okButtonText,
          isLoading: false, // Dialog buttons are rarely in loading state
          minWidth: 120, // Give button a decent minimum width
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onOkPressed?.call(); // Call optional callback after closing
          },
        ),
      ],
    );
  }
}

// Helper function to show the dialog easily
Future<void> showAppDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  required String message,
  String okButtonText = 'حسناً',
  VoidCallback? onOkPressed,
}) {
  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // Prevent dismissing by tapping outside if needed
    builder: (BuildContext context) {
      return AppAlertDialog(
        dialogType: dialogType,
        title: title,
        message: message,
        okButtonText: okButtonText,
        onOkPressed: onOkPressed,
      );
    },
  );
}