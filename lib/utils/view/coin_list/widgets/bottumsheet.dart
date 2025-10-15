import 'package:cripto/utils/controllers/coin_list_conttroller.dart';
import 'package:cripto/utils/model/coin_service_model.dart'
    show CoinServiceModel;
import 'package:flutter/material.dart';

class AddToPortfolioSheet extends StatefulWidget {
  final CoinServiceModel coin;
  final CoinListController controller;

  const AddToPortfolioSheet({required this.coin, required this.controller});

  @override
  State<AddToPortfolioSheet> createState() => _AddToPortfolioSheetState();
}

class _AddToPortfolioSheetState extends State<AddToPortfolioSheet> {
  final TextEditingController inputController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            "Add ${widget.coin.name} (${widget.coin.symbol})",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Quantity: "),
              Expanded(
                child: TextField(
                  controller: inputController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter quantity",
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                    suffixIcon: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: const Color(0xFF610BF4),
                      ),
                      onPressed: _addToPortfolio,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    if (errorText != null) setState(() => errorText = null);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _addToPortfolio() async {
    double? quantity = double.tryParse(inputController.text);
    if (quantity == null || quantity <= 0) {
      setState(() {
        errorText = "Enter a valid non-negative value";
      });
      return;
    }
    await widget.controller.addToPortfolio(widget.coin, quantity);
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.coin.name} added to portfolio")),
    );
  }
}
