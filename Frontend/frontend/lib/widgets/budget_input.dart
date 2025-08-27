import 'package:flutter/material.dart';
import './section_title.dart';

//Making this as a reusable widget because the budget field will be required in most of the services serve by each category
class BudgetInput extends StatelessWidget {
  final TextEditingController budgetCtrl;
  final String? currency;
  final void Function(String?) onCurrencyChanged;
  final void Function(int) onBudgetChanged;

  const BudgetInput({
    super.key,
    required this.budgetCtrl,
    required this.currency,
    required this.onCurrencyChanged,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //using the SectionTitle widget directly
        SectionTitle("Budget *"),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: budgetCtrl,
                decoration: const InputDecoration(
                  labelText: "Amount *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    onBudgetChanged(parsed);
                  }
                },
                validator: (v) =>
                    (int.tryParse(v ?? '') ?? 0) <= 0 ? "Enter budget" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: currency,
                decoration: const InputDecoration(
                  labelText: "Currency *",
                  border: OutlineInputBorder(),
                ),
                items: const ["INR", "USD", "EUR"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onCurrencyChanged,
                validator: (v) => v == null ? "Select currency" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
