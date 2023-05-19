import 'dart:convert';

import 'package:http/http.dart' as http;
const String APIKEY = 'EA7F0948-5C79-4CCE-BE7D-5E40B1D36AF5';

class APIHelper {

  Future<String> getExchangeRate(String crypto, String currency) async {
    
    Uri apiCall = Uri(
      scheme: 'https',
      host: 'rest.coinapi.io',
      path: '/v1/exchangerate/$crypto/$currency',
      queryParameters: {'apiKey': APIKEY}
    );

    http.Response response = await http.get(apiCall);

    print(response.body);

    if (response.statusCode != 200) {
      return '?';
    }

    return jsonDecode(response.body)['rate'].toStringAsFixed(2);
    
  }
  
}