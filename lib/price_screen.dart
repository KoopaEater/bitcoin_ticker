import 'dart:io' show Platform;
import 'package:bitcoin_ticker/custom_widgets/nice_card.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  APIHelper api = APIHelper();

  String selectedCurrency = 'USD';
  List<String> exchangeRates = List.filled(cryptoList.length, '');

  @override
  void initState() {
    super.initState();
    updateUI(selectedCurrency);
  }

  void updateUI(String? currency) async {

    List<String> temp = List.filled(cryptoList.length, '');

    for (int i = 0; i < cryptoList.length; i++) {
      temp[i] = await api.getExchangeRate(cryptoList[i], currency ?? 'USD');
    }

    setState(() {
      selectedCurrency = currency ?? 'USD';
      exchangeRates = temp;
    });

  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> items = [];

    for (String currency in currenciesList) {
      items.add(
        DropdownMenuItem<String>(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) async {
        updateUI(value);
      }
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> items = [];

    for (String currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        updateUI(currenciesList[index]);
      },
      children: items,
    );
  }

  List<NiceCard> getAllCards() {

    List<NiceCard> cards = [];

    for (int i = 0; i < cryptoList.length; i++) {

      String crypto = cryptoList[i];

      cards.add(
          NiceCard(
            text: '1 $crypto = ${exchangeRates[i]} ${selectedCurrency}',
          ),
      );
    }

    return cards;

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getAllCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
