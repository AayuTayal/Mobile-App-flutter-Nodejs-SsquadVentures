import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/filters.dart';
import '../models/country.dart';
import '../models/state_item.dart';
import '../models/banquet_request.dart';
import '../services/api.dart';
import '../widgets/section_title.dart';
import '../widgets/catering_selector.dart';
import '../widgets/cuisines_selector.dart';
import '../widgets/budget_input.dart';
import '../widgets/offer_within_dropdown.dart';
import '../main.dart';

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({super.key});

  @override
  State<BanquetFormScreen> createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  //This is storing the filters present in the Banquet&Venue screen which includes eventtype, country, even dates, budget etc, fetch fom API
  Filters? filters;
  Country? selectedCountry;
  StateItem? selectedState;

  final TextEditingController _adultsCtrl = TextEditingController();
  final TextEditingController _budgetCtrl = TextEditingController();

  //These are all the state variables of the form fields present inside Banquet&Venue screen
  String? eventType, country, state, city, currency;
  List<DateTime> dates = [];
  int? adults;
  int? getOfferWithin;
  bool veg = false, nonVeg = false;
  Set<String> cuisines = {};
  int? budget;

  //state variables of UI
  bool _submitting = false;
  bool _showSectionErrors = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    //disposing controllers to free memory
    _adultsCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  //fetching filters from API
  Future<void> _load() async {
    final f = await Api.fetchFilters();
    setState(() => filters = f);
  }

  //This is the function to format the dates
  String _fmt(DateTime d) => DateFormat("d MMM yyyy").format(d);

  //This is the Event Dates section of adding the dates from calendar
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (d != null) setState(() => dates.add(d));
  }

  @override
  Widget build(BuildContext context) {
    final f = filters;
    return Scaffold(
      appBar: AppBar(title: const Text("Banquets & Venues")),
      body: f == null
          //showing loading spinner when fetching filters
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SectionTitle("Tell Us Your Venue Requirements"),
                    const SizedBox(height: 12),

                    /*-----------Event Type dropdown------------*/
                    DropdownButtonFormField<String>(
                      key: ValueKey(eventType),
                      initialValue: eventType,
                      decoration: const InputDecoration(
                        labelText: "Event Type *",
                        border: OutlineInputBorder(),
                      ),
                      items: f.eventTypes
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => eventType = v),
                      validator: (v) => v == null ? "Select event type" : null,
                    ),
                    const SizedBox(height: 12),

                    /*---------Country dropdown-----------*/
                    DropdownButtonFormField<String>(
                      initialValue: country,
                      decoration: const InputDecoration(
                        labelText: "Country *",
                        border: OutlineInputBorder(),
                      ),
                      items: f.countries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          country = v;
                          selectedCountry = f.countries.firstWhere(
                            (c) => c.name == v,
                          );
                          state = null;
                          city = null;
                          selectedState = null;
                        });
                      },
                      validator: (v) => v == null ? "Select country" : null,
                    ),
                    const SizedBox(height: 12),

                    /*----------------State dropdown-----------------*/
                    DropdownButtonFormField<String>(
                      initialValue: state,
                      decoration: const InputDecoration(
                        labelText: "State *",
                        border: OutlineInputBorder(),
                      ),
                      items: (selectedCountry?.states ?? [])
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.name,
                              child: Text(s.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          state = v;
                          selectedState = selectedCountry?.states.firstWhere(
                            (s) => s.name == v,
                          );
                          city = null;
                        });
                      },
                      validator: (v) => v == null ? "Select state" : null,
                    ),
                    const SizedBox(height: 12),

                    /*------------City dropdown--------------*/
                    DropdownButtonFormField<String>(
                      initialValue: city,
                      decoration: const InputDecoration(
                        labelText: "City *",
                        border: OutlineInputBorder(),
                      ),
                      items: (selectedState?.cities ?? [])
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => city = v),
                      validator: (v) => v == null ? "Select city" : null,
                    ),
                    const SizedBox(height: 12),

                    /*------------Event Dates-----------------*/
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionTitle("Event Dates *"),
                        const SizedBox(height: 8),
                        ...dates.map(
                          (d) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: _fmt(d),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () =>
                                      setState(() => dates.remove(d)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.add),
                          label: const Text("Add more dates"),
                        ),
                      ],
                    ),
                    //showing message to select at least one date if no dates are added
                    if (_showSectionErrors && dates.isEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please add at least one date",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 12),

                    /*----------Number of Adults input box---------------*/
                    TextFormField(
                      controller: _adultsCtrl,
                      decoration: const InputDecoration(
                        labelText: "Number of Adults *",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          adults = v.isEmpty ? null : int.tryParse(v),
                      validator: (v) {
                        final num = int.tryParse(v ?? '');
                        if (num == null || num <= 0) {
                          return "Enter valid number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    /*--------------Catering Preference checkboxes--------------*/
                    CateringSelector(
                      veg: veg,
                      nonVeg: nonVeg,
                      onChanged: (v, nv) {
                        setState(() {
                          veg = v;
                          nonVeg = nv;
                        });
                      },
                      showError: _showSectionErrors,
                    ),
                    const SizedBox(height: 12),

                    /*----------Cuisines selection-------------*/
                    CuisinesSelector(
                      allCuisines: f.cuisines,
                      selected: cuisines,
                      onChanged: (s) => setState(() => cuisines = s),
                      showError: _showSectionErrors,
                    ),
                    const SizedBox(height: 12),

                    /*-----------Budget Section--------------*/
                    BudgetInput(
                      budgetCtrl: _budgetCtrl,
                      onBudgetChanged: (b) => budget = b,
                      onCurrencyChanged: (c) => currency = c,
                      currency: currency,
                    ),
                    const SizedBox(height: 12),

                    /*----------Offer Within Dropdown------------*/
                    OfferWithinDropdown(
                      value: getOfferWithin,
                      onChanged: (v) => setState(() => getOfferWithin = v),
                      options: offerWithinOptions,
                    ),
                    const SizedBox(height: 16),

                    /*--------------Submit Button-------------*/
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitting ? null : _confirmBeforeSubmit,
                        child: _submitting
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Text("Submit Request"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  //After pressing submit, I added a confirm functionality to confirm are all details correct and you finally want to submit
  Future<void> _confirmBeforeSubmit() async {
    setState(() => _showSectionErrors = true);

    //validating form fields
    final fieldsValid = _formKey.currentState!.validate();
    final sectionsValid =
        dates.isNotEmpty && cuisines.isNotEmpty && (veg || nonVeg);

    //showing error if validation fails
    if (!fieldsValid || !sectionsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required details")),
      );
      return;
    }

    //asking for confirmation before submission
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm submission"),
        content: const Text("Are you sure you want to submit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes, submit"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _submit();
    }
  }

  // Submitting form
  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final catering = <String>[];
      if (veg) catering.add("Veg");
      if (nonVeg) catering.add("Non-Veg");

      Map<String, dynamic>? budgetObj;
      if (budget != null && currency != null) {
        budgetObj = {
          'amount': budget is int
              ? budget
              : int.tryParse(budget.toString()) ?? 0,
          'currency': currency,
        };
      }

      //creating BanquetRequest object
      final req = BanquetRequest(
        eventType: eventType!,
        country: country!,
        state: state!,
        city: city!,
        // making date in correct format
        eventDates: dates
            .map((d) => DateFormat("yyyy-MM-dd").format(d))
            .toList(),
        numberOfAdults: adults,
        cateringPreference: catering,
        cuisines: cuisines.toList(),
        budget: budgetObj,
        getOfferWithin: getOfferWithin,
      );

      //submitting request to api, which is basically the post api to save venue requirements in the database
      await Api.submitRequest(req);

      if (mounted) {
        // if there is success submitting the request, we are showing it through Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request submitted successfully"),
            backgroundColor: Colors.green,
          ),
        );

        //resetting form after submission
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        // showing error Snackbar if request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  //------This is the reset form to clear all the form fields after request submission
  void _resetForm() {
    setState(() {
      eventType = null;
      country = null;
      state = null;
      city = null;

      selectedCountry = null;
      selectedState = null;

      dates = [];
      cuisines.clear();

      _adultsCtrl.clear();
      adults = null;

      veg = false;
      nonVeg = false;

      _budgetCtrl.clear();
      budget = null;

      currency = null;
      getOfferWithin = null;

      _showSectionErrors = false;
    });

    _formKey.currentState?.reset();
  }
}
