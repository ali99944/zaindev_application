import 'package:flutter/material.dart';
import 'package:zaindev_application/presentation/widgets/input.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchBox({
    super.key,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ZainInputField(
        prefixIcon: Icon(Icons.search),
        hintText: "ابحث عن خدمات",
      ),
    );
  }
}