import 'package:flutter/foundation.dart';

class TotalPriceValue with ChangeNotifier {

  String totalPrice = "0.0";

  String get count => totalPrice;

  void setTotalPrice(newValue) {
    totalPrice = newValue;
    notifyListeners();
  }
}