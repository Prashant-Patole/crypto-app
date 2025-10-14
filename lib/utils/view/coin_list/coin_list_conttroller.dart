import 'package:get/get.dart';
import 'package:cripto/utils/services/coin_service.dart';
import 'package:cripto/utils/services/portfolio_service.dart';

class CoinListController extends GetxController {
  var allCoins = <Map<String, String>>[].obs;
  var filteredCoins = <Map<String, String>>[].obs;
  var loading = true.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCoins();
  }

  Future<void> loadCoins() async {
    try {
      loading.value = true;
      await CoinService().fetchAllCoins();
      allCoins.value = CoinService().coinsMap.values.toList();
      filteredCoins.value = allCoins;
    } catch (e) {
      print("Error fetching coin data: $e");
    } finally {
      loading.value = false;
    }
  }

  void filterCoins(String query) {
    searchText.value = query.toLowerCase();
    filteredCoins.value = allCoins.where((coin) {
      final name = coin['name']?.toLowerCase() ?? '';
      final symbol = coin['symbol']?.toLowerCase() ?? '';
      return name.contains(searchText.value) ||
          symbol.contains(searchText.value);
    }).toList();
  }

  Future<void> addToPortfolio(Map<String, String> coin, double quantity) async {
    final coinId = coin['id'] ?? '';
    if (coinId.isNotEmpty && quantity > 0) {
      await PortfolioService.addOrUpdateCoin(coinId, quantity);
    }
  }
}
