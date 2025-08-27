import 'package:flutter/material.dart';
import './section_title.dart';

class CuisinesSelector extends StatelessWidget {
  final List<String> allCuisines;
  final Set<String> selected;
  final void Function(Set<String>) onChanged;
  final bool showError;

  const CuisinesSelector({
    super.key,
    required this.allCuisines,
    required this.selected,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    //These are the images for all the cuisines and the images are added in github repo which is public so that in future
    // image display problem will not occur
    final cuisineImages = {
      "Indian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Indian_cuisine.jpg",
      "Italian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Italian_cuisine.jpeg",
      "Asian":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Asian_cuisine.jpg",
      "Mexican":
          "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Mexican_cuisine.jpg",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //directly using SectionTitle widget
        SectionTitle("Please select your Cuisines *"),
        const SizedBox(height: 8),
        Column(
          children: allCuisines.map((c) {
            final isSelected = selected.contains(c);
            return GestureDetector(
              onTap: () {
                final newSet = {...selected};
                if (isSelected) {
                  newSet.remove(c);
                } else {
                  newSet.add(c);
                }
                onChanged(newSet);
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        cuisineImages[c] ?? "https://via.placeholder.com/90",
                        width: 90,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 70,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.fastfood),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (v) {
                        final newSet = {...selected};
                        if (v == true) {
                          newSet.add(c);
                        } else {
                          newSet.remove(c);
                        }
                        onChanged(newSet);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (showError && selected.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Please select at least one cuisine",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
