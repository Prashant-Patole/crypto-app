import 'package:cripto/constants/animations.dart';
import 'package:cripto/controllers/portfolio_conttroller.dart';
import 'package:cripto/view/coin_list/coin_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// ignore: unused_element
class PortfolioValueCard extends StatelessWidget {
  final PortfolioController controller;
  const PortfolioValueCard({required this.controller});

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Portfolio Value",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTotalAmount(totalValue),
                    const SizedBox(height: 16),
                    _buildAddCryptoButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTotalAmount(double value) {
    return Row(
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
        const SizedBox(width: 8),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAddCryptoButton(BuildContext context) {
    return ElevatedButton.icon(
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
    );
  }
}
