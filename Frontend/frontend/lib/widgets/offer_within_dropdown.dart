import 'package:flutter/material.dart';

class OfferWithinDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;
  final Map<int, String> options;

  const OfferWithinDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: "Get Offer Within",
        border: OutlineInputBorder(),
      ),
      items: options.entries
          .map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
