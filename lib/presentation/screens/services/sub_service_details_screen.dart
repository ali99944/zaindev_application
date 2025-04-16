import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

// Dummy Model for Service Details (Replace with actual)
class ServiceDetails {
  final String id;
  final String name;
  final String description;
  final String? imageUrl; // Optional image
  final String? priceDetails; // e.g., "Starts from 150 SAR" or "Per hour"
  final String? estimatedDuration;

  ServiceDetails({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.priceDetails,
    this.estimatedDuration,
  });
}

// Provider to fetch service details (Replace with API)
final serviceDetailsProvider = FutureProvider.family<ServiceDetails?, String>((ref, serviceId) {
  // TODO: Implement API call to fetch details for serviceId
  print("Fetching details for service: $serviceId");
  // Dummy Data:
  if (serviceId == 'sub1_2') { // Example: AC Maintenance
     return ServiceDetails(
        id: serviceId,
        name: 'صيانة دورية للمكيف',
        description: 'تشمل فحص شامل لوحدة التكييف، تنظيف الفلاتر والمبخر والمكثف، فحص مستوى الفريون، التأكد من سلامة التوصيلات الكهربائية، وتقديم تقرير عن حالة المكيف. يساعد على إطالة عمر الجهاز وتحسين كفاءته.',
        imageUrl: 'https://via.placeholder.com/600x300/E0F7FA/006064?text=AC+Maintenance',
        priceDetails: 'تبدأ من 150 ريال (حسب نوع الوحدة)',
        estimatedDuration: '45-60 دقيقة',
     );
  }
  if (serviceId == 'sub1_1') {
     return ServiceDetails(id: serviceId, name: 'تركيب مكيف سبليت', description: 'تركيب احترافي لوحدات التكييف السبليت الجديدة.', priceDetails: 'يبدأ من 250 ريال');
  }
  return null; // Service not found
});


class SubServiceDetailsScreen extends ConsumerWidget {
  final String serviceId;

  const SubServiceDetailsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsyncValue = ref.watch(serviceDetailsProvider(serviceId));
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
         // Use SliverAppBar for collapsing effect if desired
        appBar: AppBar(
           // Title will be set based on data loading
           backgroundColor: AppColors.primary,
           elevation: 0,
        ),
        body: detailsAsyncValue.when(
          data: (details) {
            if (details == null) {
              return const Center(child: Text('تفاصيل الخدمة غير متاحة.'));
            }
            return CustomScrollView( // Allows mixing AppBar behavior with content
              slivers: [
                 SliverAppBar( // Invisible SliverAppBar to hold title space after real AppBar
                    pinned: true, // Keep title visible when scrolling
                    automaticallyImplyLeading: false, // Remove back button here
                    backgroundColor: AppColors.primary,
                    title: Text(details.name, style: const TextStyle(color: Colors.white)), // Show title when collapsed
                    expandedHeight: details.imageUrl != null ? 250.0 : 0, // Height for image
                    flexibleSpace: details.imageUrl != null
                        ? FlexibleSpaceBar(
                            background: Image.network(
                              details.imageUrl!,
                              fit: BoxFit.cover,
                               errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.image_not_supported_outlined, color: AppColors.disabled, size: 50)),
                            ),
                          )
                        : null,
                 ),
                 SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                       delegate: SliverChildListDelegate([
                          Text(details.name, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 16),
                           if (details.priceDetails != null || details.estimatedDuration != null)
                              _buildInfoRow(context, details),
                          const SizedBox(height: 16),
                          Text('الوصف', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                           Text(details.description, style: textTheme.bodyLarge?.copyWith(height: 1.6, color: AppColors.textSecondary)),
                           const SizedBox(height: 100), // Space for the button at the bottom
                       ]),
                    ),
                 ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('خطأ: $error')),
        ),
        // --- Request Service Button ---
        bottomSheet: detailsAsyncValue.maybeWhen(
          data: (details) => details != null ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
               color: AppColors.background,
               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, -2))],
               // border: Border(top: BorderSide(color: AppColors.divider))
            ),
            child: ElevatedButton(
              onPressed: () {
                 Navigator.pushNamed(context, AppRoutes.requestService, arguments: details.id);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: const Text('اطلب الخدمة الآن'),
            ),
          ) : null,
          orElse: () => null, // Don't show button on loading/error
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, ServiceDetails details) {
     final textTheme = Theme.of(context).textTheme;
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         if (details.priceDetails != null)
           Expanded(
             child: Row(children: [
               const Icon(Icons.attach_money_outlined, size: 18, color: AppColors.accent),
               const SizedBox(width: 4),
               Text(details.priceDetails!, style: textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w500)),
             ]),
           ),
         if (details.estimatedDuration != null)
           Expanded(
             child: Row(children: [
                const Icon(Icons.timer_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(details.estimatedDuration!, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
             ]),
           ),
      ],
     );
  }
}