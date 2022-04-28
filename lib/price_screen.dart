import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  int? selectedIndexCurrency = 0;
  List<int> cryptoPrice = [];

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      updateUIPrice(selectedIndexCurrency.toString());
    } else {
      updateUIPrice(selectedCurrency);
    }
  }

  List<Widget> getCryptoList() {
    List<Widget> cryptoListWidget = [];

    for (int i = 0; i < cryptoList.length; i++) {
      var item = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              "1 ${cryptoList[i]} = ${cryptoPrice.isEmpty ? '?' : cryptoPrice[i].toString()} ${currenciesList[int.parse(selectedIndexCurrency.toString())]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      cryptoListWidget.add(item);
    }

    return cryptoListWidget;
  }

  void updateUIPrice(String currency) async {
    CoinData coinData = CoinData();
    List<int> data = await coinData.getCoinData(currency);

    setState(() {
      cryptoPrice = data;
    });

    print(cryptoPrice);
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownlist = [];

    for (String currency in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownlist.add(item);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownlist,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItem = [];

    for (String currency in currenciesList) {
      var item = Text(currency);
      pickerItem.add(item);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: pickerItem,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedIndexCurrency = selectedIndex;
          updateUIPrice(selectedIndexCurrency.toString());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: getCryptoList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
