class CartItem {
  final String goodsId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  bool isChosen; // Updated to non-nullable bool

  CartItem({
    required this.goodsId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    this.isChosen = false,
  });
}
