import 'package:cripto/utils/view/coin_list/coin_list.dart';
import 'package:cripto/utils/view/profile/portfolio_conttroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cripto/utils/constants/animations.dart';
import 'package:lottie/lottie.dart';
import 'package:cripto/utils/services/coin_service.dart';

class PortfolioScreen extends StatelessWidget {
  PortfolioScreen({super.key});

  final PortfolioController controller = Get.put(PortfolioController());

  Widget _portfolioValueCard() {
    return Obx(() {
      double totalValue = controller.getTotalPortfolioValue();

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF610BF4)),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                height: 130,
                width: 130,
                child: Lottie.asset(Animations.porfolioannimation),
              ),
              Column(
                children: [
                  const Text(
                    "Total Portfolio Value",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "\$",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                        ),
                      ),
                      Text(
                        "${totalValue.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: const BorderSide(color: Color(0xFF610BF4)),
                      ),
                    ),
                    onPressed: () async {
                      await Get.to(() => CoinList());
                      controller.loadPortfolio();
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("Add Crypto"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _portfolioListItem(int index) {
    return Obx(() {
      final item = controller.portfolio[index];
      final coin = CoinService().coinsMap[item.coinId];
      final coinName = coin?['name'] ?? item.coinId;
      final coinSymbol = coin?['symbol'] ?? '';
      final price = controller.prices[item.coinId];
      final totalValue = (price ?? 0) * item.quantity;

      return Dismissible(
        key: Key(item.coinId),
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => controller.deleteCoin(item.coinId),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
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
                coinSymbol.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text("$coinName ($coinSymbol)"),
            subtitle: Text("Qty: ${item.quantity}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price != null ? "\$${price.toStringAsFixed(2)}" : "Price N/A",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text("Total: \$${totalValue.toStringAsFixed(2)}"),
              ],
            ),
            onTap: () async {
              double newQty = item.quantity;
              TextEditingController controllerInput = TextEditingController(
                text: newQty.toString(),
              );

              await showDialog(
                context: Get.context!,
                builder: (context) => AlertDialog(
                  title: const Text("Update Quantity"),
                  content: TextField(
                    controller: controllerInput,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (val) =>
                        newQty = double.tryParse(val) ?? item.quantity,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (newQty > 0) {
                          controller.updateQuantity(item.coinId, newQty);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "My Portfolio",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF7327F5),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async => controller.loadPortfolio(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.portfolio.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _portfolioValueCard();
              return _portfolioListItem(index - 1);
            },
          ),
        ),
      ),
    );
  }
}
