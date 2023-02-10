class OrderReady {
  List<bool?> available;
  String uidUser;
  List<String> idProduct;
  List<int> qty;
  List<num> total, discount, subTotal, price;
  bool isReady;
  OrderReady(
      {required this.uidUser,
      required this.idProduct,
      required this.qty,
      required this.isReady,
      required this.total,
      required this.discount,
      required this.subTotal,
      required this.price,
      required this.available});

  OrderReady.fromJson(Map<String, dynamic>? json)
      : this(
            uidUser: json!['uid_user'] as String,
            idProduct: (json['id_product'] as List).cast<String>(),
            qty: (json['qty'] as List).cast<int>(),
            available: (json['available'] as List).cast<bool?>(),
            isReady: json['isReady'] as bool,
            total: (json['total'] as List).cast<num>(),
            subTotal: (json['subTotal'] as List).cast<num>(),
            price: (json['price'] as List).cast<num>(),
            discount: (json['discount'] as List).cast<num>());

  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'idProduct': idProduct,
      'qty': qty,
      'isReady': isReady,
      'total': total,
      'subTotal': subTotal,
      'discount': discount,
      'price': price,
      'available': available
    };
  }
}
