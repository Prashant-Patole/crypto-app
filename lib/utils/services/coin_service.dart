import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CoinService {
  static final CoinService _instance = CoinService._internal();
  factory CoinService() => _instance;
  CoinService._internal();

  Map<String, Map<String, String>> coinsMap = {};
  bool _isFetched = false;

  Future<void> fetchAllCoins() async {
    if (_isFetched) return;
    final url = Uri.parse("https://api.coingecko.com/api/v3/coins/list");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> coins = jsonDecode(response.body);
        for (var coin in coins) {
          coinsMap[coin['id']] = {
            'id': coin['id'],
            'name': coin['name'],
            'symbol': coin['symbol'],
          };
        }
        _isFetched = true;
        log("Fetched ${coinsMap.length} coins");
      } else {
        log("Failed to fetch coins: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching coins: $e");
    }
  }
}
