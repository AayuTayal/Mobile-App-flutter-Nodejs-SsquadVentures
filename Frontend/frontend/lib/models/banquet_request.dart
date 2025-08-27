class BanquetRequest {
  final String eventType;
  final String country;
  final String state;
  final String city;
  final List<String> eventDates;
  final int? numberOfAdults;
  final List<String> cateringPreference;
  final List<String> cuisines;
  final Map<String, dynamic>? budget;
  final int? getOfferWithin;

  BanquetRequest({
    required this.eventType,
    required this.country,
    required this.state,
    required this.city,
    required this.eventDates,
    required this.numberOfAdults,
    required this.cateringPreference,
    required this.cuisines,
    this.budget,
    this.getOfferWithin = 48,
  });

  Map<String, dynamic> toJson() => {
    'eventType': eventType,
    'country': country,
    'state': state,
    'city': city,
    'eventDates': eventDates,
    'numberOfAdults': numberOfAdults,
    'cateringPreference': cateringPreference,
    'cuisines': cuisines,
    'budget': budget,
    'getOfferWithin': getOfferWithin,
  };
}
