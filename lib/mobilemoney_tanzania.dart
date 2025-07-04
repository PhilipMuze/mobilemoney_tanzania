library mobilemoney_tanzania;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// A Calculator.
class MobilemoneyTanzania {
  final bool isProduction;
  final String apiKey;
  String? _sessionKey;

  //User Required Parameters
  MobilemoneyTanzania({required this.isProduction, required this.apiKey});

  //Vodacom Payment collection
  Future<dynamic> vodacomPaymentCollect(
    String amount,
    int phonenumber,
    String orgShortCode,
    String tranRef,
    String customertranRef,
    String description,
  ) async {
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

  Future<String?> getAirtelSession(String clientId, String clientSecret) async {
    String baseurl = isProduction
        ? "https://openapiuat.airtel.africa/auth/oauth2/token"
        : "https://openapi.airtel.africa/auth/oauth2/token";

    Uri url = Uri.https(baseurl);

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "client_id": clientId,
          "client_secret": clientSecret,
          "grant_type": "client_credentials"
        }));
    if (response.statusCode == 200) {
      final body = response.body;
      // Decode the response body
      final Map<String, dynamic> data = jsonDecode(body);
      _sessionKey = data['data']['access_token'];
    } else {
      debugPrint('${response.statusCode} 	Session Creation Failed');
    }

    return _sessionKey;
  }

  //Airtel payment collection
  Future<dynamic> airtelPaymentCollect(
    String clientIdAirtel,
    String clientSecretAirtel,
    String referenceAirtel,
    String phonenumberAirtel,
    String amountAirtel,
    String transactionIdAirtel,
  ) async {
    //Base url
    String baseurl = isProduction
        ? "https://openapi.airtel.africa/merchant/v2/payments/"
        : " https://openapiuat.airtel.africa/merchant/v2/payments/";

    //Get Session Key
    _sessionKey ??= await getAirtelSession(clientIdAirtel, clientSecretAirtel);

    //Create the Uri
    Uri url = Uri.parse(baseurl);

    //Create the request
    final response = await http.post(url, headers: {
      'Accept': '*/*',
      "Content-Type": "application/json",
      'X-Country': 'TZ',
      'X-Currency': 'TZS',
      "Authorization": "Bearer $_sessionKey",
      'x-signature': "Encrypted payload",
      "x-key": "Encrypted AES key and iv."
    }, body: {
      "reference": referenceAirtel,
      "subscriber": {
        "country": "TZ",
        "currency": "TZS",
        "msisdn": phonenumberAirtel
      },
      "transaction": {
        "amount": amountAirtel,
        "country": "TZ",
        "currency": "TZS",
        "id": transactionIdAirtel
      }
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      debugPrint('${response.statusCode} 	Payment Collection Failed');
      return null;
    }
  }

  //Tigo payment collection
  Future<dynamic> mixxPaymentCollect() async {}

//TTCL payment collection
  Future<dynamic> ttclPaymentCollect() async {}

//Halotel payment collection
  Future<dynamic> halotelPaymentCollect() async {}
}
