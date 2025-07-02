import 'package:mobilemoney_tanzania/mobilemoney_tanzania.dart';

void main() {
  final mobileMoney = MobilemoneyTanzania(
    isProduction: false, //Change to true for production environment
    apiKey: "", // Get Public Apikey from Vodacom Developer dashboard.
  );

  String? amount;
  int? phonenumber;
  String? orgShortCode;
  String? tranRef;
  String? customertranRef;
  String? description;

//Vodacom Mobile money collection
  mobileMoney.vodacomPaymentCollect(
    amount = amount!, //Input|| Pass value
    phonenumber = phonenumber!, //Input|| Pass value
    orgShortCode = orgShortCode!, //Input|| Pass value
    tranRef = tranRef!, //Input|| Pass value
    customertranRef = customertranRef!, //Input|| Pass value
    description = description!, //Input|| Pass value
  );

  mobileMoney.airtelPaymentCollect();

  mobileMoney.mixxPaymentCollect();

  mobileMoney.ttclPaymentCollect();

  mobileMoney.halotelPaymentCollect();
}
