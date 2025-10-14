import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// lib/utils/model/porfolio_model.dart

class PortfolioItem {
  final String coinId;
  final double quantity;

  PortfolioItem({required this.coinId, required this.quantity});

  Map<String, dynamic> toJson() => {'coinId': coinId, 'quantity': quantity};

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      coinId: json['coinId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}

class PortfolioService {
  static const String _portfolioKey = 'user_portfolio';

  static Future<void> savePortfolio(List<PortfolioItem> portfolio) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      portfolio.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_portfolioKey, jsonString);
  }

  static Future<List<PortfolioItem>> loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_portfolioKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => PortfolioItem.fromJson(e)).toList();
  }

  static Future<void> addOrUpdateCoin(String coinId, double quantity) async {
    List<PortfolioItem> portfolio = await loadPortfolio();
    final index = portfolio.indexWhere((item) => item.coinId == coinId);
    if (index >= 0) {
      portfolio[index] = PortfolioItem(coinId: coinId, quantity: quantity);
    } else {
      portfolio.add(PortfolioItem(coinId: coinId, quantity: quantity));
    }
    await savePortfolio(portfolio);
  }

  static Future<void> removeCoin(String coinId) async {}
}
