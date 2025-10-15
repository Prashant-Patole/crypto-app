import 'package:cripto/utils/controllers/coin_list_conttroller.dart';
import 'package:cripto/utils/model/coin_service_model.dart';
import 'package:cripto/utils/view/coin_list/widgets/bottumsheet.dart';
import 'package:flutter/material.dart';

class CoinListItem extends StatelessWidget {
  final CoinServiceModel coin;
  final CoinListController controller;

  const CoinListItem({required this.coin, required this.controller});

  @override
  Widget build(BuildContext context) {
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
            coin.symbol.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(coin.name),
        subtitle: Text(coin.symbol),
        onTap: () => _showAddToPortfolioSheet(context),
      ),
    );
  }

  void _showAddToPortfolioSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          AddToPortfolioSheet(coin: coin, controller: controller),
    );
  }
}
