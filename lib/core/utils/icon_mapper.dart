import 'package:flutter/material.dart';

IconData mapServiceIcon(String iconName) {
  switch (iconName.toLowerCase()) {
    case 'ac_unit':
      return Icons.ac_unit_outlined;
    case 'build_circle':
      return Icons.build_circle_outlined;
    case 'electrical_services':
      return Icons.electrical_services_outlined;
    case 'water_damage':
      return Icons.water_damage_outlined;
    case 'cleaning_services':
      return Icons.cleaning_services_outlined;
    case 'support_agent':
      return Icons.support_agent_outlined;
    case 'construction':
      return Icons.construction_outlined;
    // Add mappings for any other icons you use
    case 'default':
    default:
      return Icons.design_services_outlined; // Default fallback icon
  }
}