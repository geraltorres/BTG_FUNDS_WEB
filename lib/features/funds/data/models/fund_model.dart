import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';

class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.minAmount,
    required super.category,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json["id"],
      name: json["name"],
      minAmount: json["minAmount"],
      category: json["category"],
    );
  }
}
