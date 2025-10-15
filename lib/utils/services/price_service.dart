import 'dart:convert';
import 'dart:developer';
import 'package:cripto/utils/model/price_service_model.dart';
import 'package:http/http.dart' as http;

class PriceService {
  static Future<Map<String, double>> getCurrentPrices(
    List<String> coinIds,
  ) async {
    if (coinIds.isEmpty) return {};

    final url = Uri.parse(
      "https://api.coingecko.com/api/v3/simple/price?ids=${coinIds.join(',')}&vs_currencies=usd",
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'User-Agent': 'FlutterApp'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          log("No data received from CoinGecko");
          return {};
        }

        final Map<String, double> prices = {};
        data.forEach((key, value) {
          final coin = PriceServiceModel.fromJson(key, value);
          prices[coin.id] = coin.usd;
        });

        return prices;
      }

      if (response.statusCode == 429) {
        log("Rate limit exceeded (429). Try again later.");
      } else {
        log("Failed to fetch prices: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching prices: $e");
    }

    return {};
  }
}
