import 'package:ai_chat/services/subscription_service.dart';
import 'package:flutter/material.dart';

import '../models/subscription_model.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  SubscriptionModel _subscription = SubscriptionModel(
    name: "Basic",
    availableTokens: 30,
    totalTokens: 30,
    unlimited: false,
    endDateTime: DateTime.now(),
  );

  SubscriptionModel get subscription => _subscription;

  Future<bool> getSubscription() async {
    try {
      final dataSubscription = await _subscriptionService.getSubscription();
      final dataToken = await _subscriptionService.getToken();
      print(dataSubscription);
      print(dataToken);
      _subscription = SubscriptionModel.fromJson(dataSubscription, dataToken);
      notifyListeners();
      return true;
    } on Exception catch (e) {
      debugPrint("Failed to get subscription: $e");
      return false;
    }
  }
}