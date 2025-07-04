import 'package:mobilemoney_tanzania/mobilemoney_tanzania.dart';

void main() {
  final mobileMoney = MobilemoneyTanzania(
    isProduction: false, //Change to true for production environment
    apiKey: "", // Get Public Apikey from Vodacom Developer dashboard.
  );

//Vodacom Mobile money collection
  mobileMoney.vodacomPaymentCollect(
    "amount", //Input Amount
    2557452320043, //Input Integer Phone Number
    "Input Organization Short Code", //Input Organization Short Code
    "Input transaction Reference", //Input transaction Reference
    "customertranRef!", //Input Customer Transaction Reference
    "description,", //Input Description
  );

// Example call to Airtel payment collect
  mobileMoney.airtelPaymentCollect(
    "clientIdAirtel", // Input your Airtel client ID
    "clientSecretAirtel", // Input your Airtel client secret
    "referenceAirtel", // Input reference
    "phonenumberAirtel", // Input phone number
    "amountAirtel", // Input amount
    "transactionIdAirtel", // Input transaction ID
  );
  mobileMoney.mixxPaymentCollect();

  mobileMoney.ttclPaymentCollect();

  mobileMoney.halotelPaymentCollect();
}
