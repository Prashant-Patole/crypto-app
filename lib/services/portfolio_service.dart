// lib/utils/services/shared_preferences/porfolio_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/porfolio_model.dart';

class PortfolioService {
  static const String _portfolioKey = 'user_portfolio';

  // Load portfolio from SharedPreferences
  static Future<List<PortfolioItem>> loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_portfolioKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      await prefs.remove(_portfolioKey);
      return [];
    }
  }

  // Save portfolio to SharedPreferences
  static Future<void> savePortfolio(List<PortfolioItem> portfolio) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      portfolio.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_portfolioKey, jsonString);
  }

  // Add or update coin
  static Future<void> addOrUpdateCoin(String coinId, double quantity) async {
    final portfolio = await loadPortfolio();
    final index = portfolio.indexWhere((p) => p.coinId == coinId);
    if (index >= 0) {
      portfolio[index] = PortfolioItem(coinId: coinId, quantity: quantity);
    } else {
      portfolio.add(PortfolioItem(coinId: coinId, quantity: quantity));
    }
    await savePortfolio(portfolio);
  }

  // Remove coin permanently from SharedPreferences
  static Future<void> removeCoin(String coinId) async {
    final portfolio = await loadPortfolio();
    portfolio.removeWhere((item) => item.coinId == coinId);

    // save updated portfolio correctly in JSON format
    await savePortfolio(portfolio);
  }

  // Clear entire portfolio
  static Future<void> clearPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_portfolioKey);
  }
}
