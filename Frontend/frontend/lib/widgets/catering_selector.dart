import 'package:flutter/material.dart';

class CateringSelector extends StatelessWidget {
  final bool veg;
  final bool nonVeg;
  final void Function(bool veg, bool nonVeg) onChanged;
  final bool showError;

  const CateringSelector({
    super.key,
    required this.veg,
    required this.nonVeg,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Catering Preference *",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                //It was overflowing on the mobile when I checked, so I used contentPadding+FittedBox to solve this issue
                contentPadding: EdgeInsets.zero,
                value: veg,
                onChanged: (v) => onChanged(v ?? false, nonVeg),
                title: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.green, size: 14),
                    SizedBox(width: 6),
                    FittedBox(fit: BoxFit.scaleDown, child: Text("Veg")),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: nonVeg,
                onChanged: (v) => onChanged(veg, v ?? false),
                title: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.red, size: 14),
                    SizedBox(width: 6),
                    FittedBox(fit: BoxFit.scaleDown, child: Text("Non-Veg")),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        if (showError && !(veg || nonVeg))
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select at least one catering option",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
