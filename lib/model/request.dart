import 'package:login/model/goods.dart';
import 'package:login/model/user.dart';

class Request {
  final String requestId;
  final User user;
  final Good goods;
  final int quantity;

  Request({
    required this.requestId,
    required this.user,
    required this.goods,
    required this.quantity,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      requestId: json['requestId'],
      user: User.fromJson(json['user']),
      goods: Good.fromJson(json['goods']),
      quantity: json['quantity'],
    );
  }
}
