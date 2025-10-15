import 'dart:convert';
import 'dart:developer';
import 'package:cripto/utils/model/coin_service_model.dart';
import 'package:http/http.dart' as http;

class CoinService {
  static final CoinService _instance = CoinService._internal();
  factory CoinService() => _instance;
  CoinService._internal();

  List<CoinServiceModel> coinsList = [];
  bool _isFetched = false;

  Future<void> fetchAllCoins() async {
    if (_isFetched) return;

    final url = Uri.parse("https://api.coingecko.com/api/v3/coins/list");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> coinsJson = jsonDecode(response.body);
        coinsList = coinsJson
            .map((json) => CoinServiceModel.fromJson(json))
            .toList();
        _isFetched = true;
        log("Fetched ${coinsList.length} coins");
      } else {
        log("Failed to fetch coins: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching coins: $e");
    }
  }
}
