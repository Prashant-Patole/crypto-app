import 'package:cripto/utils/constants/animations.dart';
import 'package:cripto/utils/controllers/coin_list_conttroller.dart';
import 'package:cripto/utils/view/coin_list/widgets/coin_list_items.dart';
import 'package:cripto/utils/view/coin_list/widgets/scerchbar.dart';
import 'package:cripto/utils/view/portfolio/portfolio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CoinList extends StatelessWidget {
  CoinList({super.key});

  final CoinListController controller = Get.put(CoinListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.filteredCoins.isEmpty) {
          return const Center(child: Text("No coins found"));
        }

        return Column(
          children: [
            CoinListSearchBar(controller: controller),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadCoins,
                child: ListView.builder(
                  itemCount: controller.filteredCoins.length,
                  itemBuilder: (context, index) {
                    final coin = controller.filteredCoins[index];
                    return CoinListItem(coin: coin, controller: controller);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
          child: const Column(
            children: [
              Icon(Icons.account_circle_rounded, size: 25, color: Colors.white),
              Text(
                "Portfolio",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
