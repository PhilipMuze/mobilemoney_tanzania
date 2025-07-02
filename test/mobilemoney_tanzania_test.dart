import 'package:flutter_test/flutter_test.dart';
import 'package:mobilemoney_tanzania/mobilemoney_tanzania.dart';

//Fundamental test for MobilemoneyTanzania package
void main() {
  test('adds one to input values', () {
    final calculator = MobilemoneyTanzania(isProduction: false, apiKey: "");
    expect(calculator.airtelPaymentCollect(), isA<Map<String, dynamic>>());
  });
}
