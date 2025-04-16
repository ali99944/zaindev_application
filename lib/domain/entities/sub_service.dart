import 'service_provider.dart'; // Import provider info

class SubService {
  final int id;
  final String name;
  final String? icon; // Keep as String identifier or make nullable
  final double? price; // Now double for numeric price
  final bool priceIsFixed; // Flag for price type
  final int serviceCategoryId;
  final int? serviceProviderId;
  final String? providerName; // Optional: Direct provider name from index API
  // Optional: Add provider details object for details API
  final ServiceProviderInfo? providerInfo;

  SubService({
    required this.id,
    required this.name,
    this.icon,
    this.price,
    required this.priceIsFixed,
    required this.serviceCategoryId,
    this.serviceProviderId,
    this.providerName,
    this.providerInfo,
  });

  // Factory constructor for list items (index API response)
   factory SubService.fromListJson(Map<String, dynamic> json) {
    return SubService(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      price: (json['price'] as num?)?.toDouble(), // Handle potential null and convert num
      priceIsFixed: json['price_is_fixed'] as bool? ?? true, // Default if missing
      serviceCategoryId: json['service_category_id'] as int,
      serviceProviderId: json['service_provider_id'] as int?,
      providerName: json['provider_name'] as String?, // Added field
    );
  }

   // Factory constructor for detail items (show API response)
   factory SubService.fromDetailJson(Map<String, dynamic> json) {
     return SubService(
       id: json['id'] as int,
       name: json['name'] as String,
       icon: json['icon'] as String?,
       price: (json['price'] as num?)?.toDouble(),
       priceIsFixed: json['price_is_fixed'] as bool? ?? true,
       serviceCategoryId: json['service_category_id'] as int,
       serviceProviderId: json['service_provider_id'] as int?,
       // Reconstruct providerInfo if present in details
       providerInfo: json['provider'] != null
           ? ServiceProviderInfo.fromJson(json['provider'] as Map<String, dynamic>)
           : null,
        // Include other detail fields if needed (description, duration)
     );
   }

   // Helper to format price for display
   String? get displayPrice {
      if (price == null) return null;
      final formattedPrice = price!.toStringAsFixed(2); // Format to 2 decimal places
      return priceIsFixed ? '$formattedPrice ريال' : 'يبدأ من $formattedPrice ريال';
   }
}

// Add SubServiceDetails entity if needed (to hold description, duration etc.)
class SubServiceDetails extends SubService {
    final String? description;
    final String? estimatedDuration;
    // Inherit fields from SubService

    SubServiceDetails({
      required super.id,
      required super.name,
      super.icon,
      super.price,
      required super.priceIsFixed,
      required super.serviceCategoryId,
      super.serviceProviderId,
      super.providerName,
      super.providerInfo,
      this.description,
      this.estimatedDuration,
    });

     factory SubServiceDetails.fromJson(Map<String, dynamic> json) {
       return SubServiceDetails(
         id: json['id'] as int,
         name: json['name'] as String,
         icon: json['icon'] as String?,
         price: (json['price'] as num?)?.toDouble(),
         priceIsFixed: json['price_is_fixed'] as bool? ?? true,
         serviceCategoryId: json['service_category_id'] as int,
         serviceProviderId: json['service_provider_id'] as int?,
         providerInfo: json['provider'] != null
             ? ServiceProviderInfo.fromJson(json['provider'] as Map<String, dynamic>)
             : null,
         description: json['description'] as String?,
         estimatedDuration: json['estimated_duration'] as String?,
       );
     }
}