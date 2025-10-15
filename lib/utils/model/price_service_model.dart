class PriceServiceModel {
  final String id;
  final double usd;

  PriceServiceModel({required this.id, required this.usd});

  factory PriceServiceModel.fromJson(String id, Map<String, dynamic> json) {
    return PriceServiceModel(
      id: id,
      usd: (json['usd'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() => '$id: $usd';
}
