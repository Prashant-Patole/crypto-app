class PortfolioItem {
  final String coinId;
  final double quantity;

  PortfolioItem({required this.coinId, required this.quantity});

  Map<String, dynamic> toJson() => {'coinId': coinId, 'quantity': quantity};

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      coinId: json['coinId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}
