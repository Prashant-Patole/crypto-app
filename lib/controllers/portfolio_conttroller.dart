import 'dart:async';
import 'package:cripto/services/portfolio_service.dart';
import 'package:get/get.dart';
import 'package:cripto/model/porfolio_model.dart';
import 'package:cripto/services/price_service.dart';

class PortfolioController extends GetxController {
  var portfolio = <PortfolioItem>[].obs;
  var prices = <String, double>{}.obs;
  DateTime _lastFetch = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();

    // Refresh prices every 60 sec
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      refreshPrices();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadPortfolio() async {
    final list = await PortfolioService.loadPortfolio();
    portfolio.value = list;
    await refreshPrices();
  }

  Future<void> refreshPrices() async {
    if (portfolio.isEmpty) return;

    if (DateTime.now().difference(_lastFetch).inSeconds < 30) return;

    final coinIds = portfolio.map((e) => e.coinId).toList();
    final fetchedPrices = await PriceService.getCurrentPrices(coinIds);

    if (fetchedPrices.isNotEmpty) {
      prices.value = fetchedPrices;
      _lastFetch = DateTime.now();
    }
  }

  Future<void> updateQuantity(String coinId, double newQty) async {
    if (newQty <= 0) return;
    await PortfolioService.addOrUpdateCoin(coinId, newQty);
    await loadPortfolio();
  }

  Future<void> deleteCoin(String coinId) async {
    final list = await PortfolioService.loadPortfolio();
    list.removeWhere((item) => item.coinId == coinId);
    await PortfolioService.savePortfolio(list);
    portfolio.value = list;
  }

  double getTotalPortfolioValue() {
    double total = 0;
    for (var item in portfolio) {
      total += (prices[item.coinId] ?? 0) * item.quantity;
    }
    return total;
  }
}
