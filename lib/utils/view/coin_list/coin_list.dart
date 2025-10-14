import 'package:cripto/utils/view/coin_list/coin_list_conttroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cripto/utils/constants/animations.dart';
import 'package:cripto/utils/view/profile/portfolio_screen.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final CoinListConttroller controller = Get.put(CoinListConttroller());

  void _showAddToPortfolioSheet(
    BuildContext context,
    Map<String, String> coin,
  ) {
    final TextEditingController _controllerInput = TextEditingController();
    RxString? errorText = RxString('');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add ${coin['name']} (${coin['symbol']})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Quantity: "),
                    Expanded(
                      child: TextField(
                        controller: _controllerInput,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter quantity",
                          border: const OutlineInputBorder(),
                          errorText: errorText.value.isEmpty
                              ? null
                              : errorText.value,
                          suffixIcon: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: const Color(0xFF610BF4),
                            ),
                            onPressed: () async {
                              double? quantity = double.tryParse(
                                _controllerInput.text,
                              );
                              if (quantity == null || quantity <= 0) {
                                setState(() {
                                  errorText.value =
                                      "Enter a valid non-negative value";
                                });
                                return;
                              }
                              await controller.addToPortfolio(coin, quantity);
                              if (Get.isBottomSheetOpen!) Get.back();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${coin['name']} added to portfolio",
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (errorText.value.isNotEmpty) {
                            setState(() => errorText.value = '');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _coinListItem(BuildContext context, Map<String, String> coin) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF610BF4), width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Text(
            (coin['symbol'] ?? '').toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(coin['name'] ?? ''),
        subtitle: Text(coin['symbol'] ?? ''),
        onTap: () => _showAddToPortfolioSheet(context, coin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Lottie.asset(Animations.coinlistannimation),
            ),
            const Text(
              "Coins List",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7327F5),
        actions: [
          TextButton(
            onPressed: () => Get.to(() => PortfolioScreen()),
            child: Column(
              children: const [
                Icon(
                  Icons.account_circle_rounded,
                  size: 25,
                  color: Colors.white,
                ),
                Text(
                  "Portfolio",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value)
          return const Center(child: CircularProgressIndicator());
        if (controller.filteredCoins.isEmpty)
          return const Center(child: Text("No coins found"));

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: controller.filterCoins,
                decoration: InputDecoration(
                  hintText: "Search by name or symbol...",
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF610BF4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF610BF4)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadCoins,
                child: ListView.builder(
                  itemCount: controller.filteredCoins.length,
                  itemBuilder: (context, index) {
                    final coin = controller.filteredCoins[index];
                    return _coinListItem(context, coin);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
