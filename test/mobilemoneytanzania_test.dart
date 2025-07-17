import 'package:flutter_test/flutter_test.dart';
import 'package:mobilemoneytanzania/mobilemoneytanzania.dart';

void main() {
  group('MobilemoneyTanzania Tests', () {
    late MobilemoneyTanzania mobileMoney;

    setUp(() {
      // Initialize with test (non-production) environment and dummy API key
      mobileMoney = MobilemoneyTanzania(
        isProduction: false,
        apiKey: "test_api_key",
      );
    });

    test('Vodacom payment collection returns a valid response map', () async {
      final response = await mobileMoney.vodacomPaymentCollect(
        "1000", // Amount as string
        2557452320043, // Valid phone number
        "ORG123", // Organization short code
        "TXN123456", // Transaction reference
        "CUSTREF789", // Customer transaction reference
        "Test payment", // Description
      );

      expect(response, isA<Map<String, dynamic>>());
      expect(response.containsKey("status"), isTrue);
    });

    test('Airtel payment collection returns a valid response map', () async {
      final response = await mobileMoney.airtelPaymentCollect(
        "clientIdAirtel", // Airtel client ID
        "clientSecretAirtel", // Airtel client secret
        "referenceAirtel", // Reference
        "07452320043", // Phone number
        "1500", // Amount
        "transactionId123", // Transaction ID
      );

      expect(response, isA<Map<String, dynamic>>());
      expect(response.containsKey("status"), isTrue);
    });
  });
}
