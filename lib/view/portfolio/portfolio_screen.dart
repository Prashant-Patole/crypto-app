import 'package:cripto/controllers/portfolio_conttroller.dart';
import 'package:cripto/view/portfolio/widgets/portfolio_list_items.dart';
import 'package:cripto/view/portfolio/widgets/portfolio_valu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioScreen extends StatelessWidget {
  PortfolioScreen({super.key});

  final PortfolioController controller = Get.put(PortfolioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async => controller.loadPortfolio(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.portfolio.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return PortfolioValueCard(controller: controller);
              return PortfolioListItem(
                controller: controller,
                index: index - 1,
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        "My Portfolio",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xFF7327F5),
    );
  }
}
