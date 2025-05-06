class SubscriptionModel {
  final String name;
  final int availableTokens;
  final int totalTokens;
  final bool unlimited;
  final DateTime endDateTime;

  SubscriptionModel({
    required this.name,
    required this.availableTokens,
    required this.totalTokens,
    required this.unlimited,
    required this.endDateTime,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> dataSubscription, Map<String, dynamic> dataToken) {
    return SubscriptionModel(
      name:  _capitalize(dataSubscription['name']),
      availableTokens: dataToken['availableTokens'],
      totalTokens: dataToken['totalTokens'],
      unlimited: dataToken['unlimited'],
      endDateTime: DateTime.parse(dataToken['date']),
    );
  }

  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
