import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PriceService {
  static Future<Map<String, double>> getCurrentPrices(
    List<String> coinIds,
  ) async {
    if (coinIds.isEmpty) return {};
    final ids = coinIds.join(',');
    final url = Uri.parse(
      "https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, double> prices = {};
        data.forEach((key, value) {
          prices[key] = (value['usd'] as num).toDouble();
        });
        return prices;
      } else if (response.statusCode == 429) {
        log("Rate limit exceeded. Try later.");
        return {};
      } else {
        log("Failed to fetch prices: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      log("Error fetching prices: $e");
      return {};
    }
  }
}
