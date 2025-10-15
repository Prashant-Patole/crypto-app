class CoinServiceModel {
  final String id;
  final String name;
  final String symbol;

  CoinServiceModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory CoinServiceModel.fromJson(Map<String, dynamic> json) {
    return CoinServiceModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }

  @override
  String toString() => '$name ($symbol)';
}
