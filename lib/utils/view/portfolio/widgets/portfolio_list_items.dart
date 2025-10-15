import 'package:cripto/utils/controllers/portfolio_conttroller.dart';
import 'package:cripto/utils/model/coin_service_model.dart';
import 'package:cripto/utils/services/coin_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

// ignore: unused_element
class PortfolioListItem extends StatelessWidget {
  final PortfolioController controller;
  final int index;

  const PortfolioListItem({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.portfolio[index];
      final coin = CoinService().coinsList.firstWhere(
        (c) => c.id == item.coinId,
        orElse: () =>
            CoinServiceModel(id: item.coinId, name: item.coinId, symbol: ''),
      );

      final price = controller.prices[item.coinId];
      final totalValue = (price ?? 0) * item.quantity;

      return Dismissible(
        key: Key(item.coinId),
        direction: DismissDirection.endToStart,
        background: _buildDismissBackground(),
        onDismissed: (_) => controller.deleteCoin(item.coinId),
        child: _buildListTile(item, coin, price, totalValue, context),
      );
    });
  }

  Widget _buildDismissBackground() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildListTile(item, coin, price, totalValue, BuildContext context) {
    return Container(
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
            coin.symbol.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text("${coin.name} (${coin.symbol})"),
        subtitle: Text("Qty: ${item.quantity}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price != null ? "\$${price.toStringAsFixed(2)}" : "Price N/A",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text("Total: \$${totalValue.toStringAsFixed(2)}"),
          ],
        ),
        onTap: () => _showUpdateQuantityDialog(item, context),
      ),
    );
  }

  void _showUpdateQuantityDialog(item, BuildContext context) {
    double newQty = item.quantity;
    TextEditingController controllerInput = TextEditingController(
      text: newQty.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Quantity"),
        content: TextField(
          controller: controllerInput,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) => newQty = double.tryParse(val) ?? item.quantity,
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
  }
}
