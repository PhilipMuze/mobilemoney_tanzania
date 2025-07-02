library mobilemoney_tanzania;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// A Calculator.
class MobilemoneyTanzania {
  final bool isProduction;
  final String apiKey;
  String? _sessionKey;
  String? amount;
  //User Required Parameters
  MobilemoneyTanzania({required this.isProduction, required this.apiKey});

  //Vodacom Payment collection
  Future<dynamic> vodacomPaymentCollect(
      String amount,
      int phonenumber,
      String orgShortCode,
      String tranRef,
      String customertranRef,
      String description) async {
        
    //Get Session Key
    _sessionKey ??= await getVodacomSession();

    String apiEndpoint = isProduction
        ? "openapi.m-pesa.com/openapi/ipg/v2/vodacomTZN/c2bPayment/singleStage/"
        : "openapi.m-pesa.com/sandbox/ipg/v2/vodacomTZN/c2bPayment/singleStage/";

    Uri url = Uri.parse(apiEndpoint);

    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_sessionKey",
      "Origin": "*", //todo change to value that matches in the dashboard
    }, body: {
      "input_Amount": amount, //String
      "input_CustomerMSISDN": phonenumber, //int
      "input_Country": "TZN",
      "input_Currency": "TZS",
      "input_ServiceProviderCode": orgShortCode,
      "input_TransactionReference": tranRef, //String
      "input_ThirdPartyConversationID": customertranRef, //String
      "input_PurchasedItemsDesc": description, //String
    });

    return response;
  }

  // Get Vodacom Session Key.
  Future<String> getVodacomSession() async {
    String baseUrl = 'openapi.m-pesa.com';

    String path = isProduction
        ? "/openapi/ipg/v2/vodacomTZN/getSession/"
        : '/sandbox/ipg/v2/vodacomTZN/getSession/';

    Map<String, String> queryParams = {
      'key': apiKey,
    };
    Uri url = Uri.https(baseUrl, path, queryParams);

    final response = await http.get(url, headers: {'Origin': '*'});

    if (response.statusCode == 200) {
      _sessionKey = response.body;
    } else {
      debugPrint('${response.statusCode} 	Session Creation Failed');
    }

    //Update the SessionKey.
    return _sessionKey!;
  }

  //Airtel payment collection
  Future<dynamic> airtelPaymentCollect() async {}

  //Tigo payment collection
  Future<dynamic> mixxPaymentCollect() async {}

//TTCL payment collection
  Future<dynamic> ttclPaymentCollect() async {}

//Halotel payment collection
  Future<dynamic> halotelPaymentCollect() async {}
}
