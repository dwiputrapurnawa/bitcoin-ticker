import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = 'D4BD5BB9-E66D-4EC6-BF9A-BA6B945ACE7F';

class CoinData {
  Future getCoinData(String currency) async {
    String selectedCurrency;
    List<int> exchangeRate = [];

    if (Platform.isIOS) {
      int index = int.parse(currency);
      selectedCurrency = currenciesList[index];
    } else {
      selectedCurrency = currency;
    }

    for (String crypto in cryptoList) {
      var url = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/${selectedCurrency.toString()}?apikey=$apiKey');

      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        final dataJson = jsonDecode(data);
        double rateData = dataJson['rate'];
        int rateDataInt = rateData.round();

        exchangeRate.add(rateDataInt);
      } else {
        print(response.statusCode);
      }
    }

    return exchangeRate;
  }
}
