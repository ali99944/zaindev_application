import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LegalContentScreen extends ConsumerWidget {
  final String title;
  final String content; // Changed from assetPath

  const LegalContentScreen({
    super.key,
    required this.title,
    required this.content, // Pass content directly
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text( // Display content directly
            content,
            style: textTheme.bodyMedium,
            // textDirection: TextDirection.rtl, // Apply if needed based on content language
          ),
        ),
      ),
    );
  }
}