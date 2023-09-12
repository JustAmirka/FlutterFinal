import 'package:login/model/goods.dart';

class Favorite {
  final Good goods;
  final DateTime createdAt;

  Favorite({
    required this.goods,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      goods: Good.fromJson(json['goods']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
