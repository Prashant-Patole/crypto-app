import 'dart:ui';

import 'package:cripto/controllers/coin_list_conttroller.dart';
import 'package:flutter/material.dart';

class CoinListSearchBar extends StatelessWidget {
  final CoinListController controller;

  const CoinListSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
