import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PriceService {
  static Future<Map<String, double>> getCurrentPrices(
    List<String> coinIds,
  ) async {
    if (coinIds.isEmpty) return {};

    // Join IDs for API
    final ids = coinIds.join(',');

    final url = Uri.parse(
      "https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Flutter App)',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          log("No data received from CoinGecko");
          return {};
        }

        Map<String, double> prices = {};
        data.forEach((key, value) {
          final price = value['usd'];
          if (price != null) {
            prices[key] = (price as num).toDouble();
          }
        });

        log(" Prices fetched: $prices");
        return prices;
      } else if (response.statusCode == 429) {
        log(" Rate limit exceeded (429). Try again later.");
        return {};
      } else {
        log(
          " Failed to fetch prices: ${response.statusCode} - ${response.body}",
        );
        return {};
      }
    } catch (e) {
      log(" Error fetching prices: $e");
      return {};
    }
  }
}
