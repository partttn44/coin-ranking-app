import 'package:coin_ranking_data/domain/entities/coin_entity.dart';
import 'package:equatable/equatable.dart';

import '../../core/utils/number_formatter.dart';

class CoinModel extends Equatable {
  const CoinModel({
    required this.uuid,
    required this.symbol,
    required this.name,
    required this.iconUrl,
    required this.marketCap,
    required this.price,
    required this.change,
    required this.rank,
    required this.marketCapText,
    required this.priceText,
    required this.changeText,
    required this.isPositive,
    this.color,
    this.description,
    this.websiteUrl,
  });

  final String uuid;
  final String symbol;
  final String name;
  final String iconUrl;

  final double marketCap;
  final double price;
  final double change;

  final int rank;
  final String? color;
  final String? description;
  final String? websiteUrl;

  final String marketCapText;
  final String priceText;
  final String changeText;
  final bool isPositive;

  factory CoinModel.fromEntity(Coin entity) {
    return CoinModel(
      uuid: entity.uuid,
      symbol: entity.symbol,
      name: entity.name,
      iconUrl: entity.iconUrl,
      marketCap: entity.marketCap,
      price: entity.price,
      change: entity.change,
      rank: entity.rank,
      color: entity.color,
      description: entity.description,
      websiteUrl: entity.websiteUrl,
      marketCapText: '\$${formatMarketCap(entity.marketCap)}',
      priceText: '\$${formatCurrency(entity.price)}',
      changeText: '${entity.change.abs().toStringAsFixed(2)}%',
      isPositive: entity.change >= 0,
    );
  }

  bool get isNegative => !isPositive;

  bool get hasDescription {
    return description?.trim().isNotEmpty ?? false;
  }

  bool get hasWebsite {
    return websiteUrl?.trim().isNotEmpty ?? false;
  }

  @override
  List<Object?> get props => [
    uuid,
    symbol,
    name,
    iconUrl,
    marketCap,
    price,
    change,
    rank,
    color,
    description,
    websiteUrl,
    marketCapText,
    priceText,
    changeText,
    isPositive,
  ];
}
