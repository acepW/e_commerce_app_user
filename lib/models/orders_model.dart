import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId,
  title,
      userId,
      sellerId,
      sellerName,
      alamatUser,
      alamatSeller,
      status,
      pengambilan,
      pembayaran,
      productId,
      userName,
      price,
      imageUrl,
      quantity;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.title,
    required this.userId,
    required this.sellerId,
    required this.sellerName,
    required this.alamatSeller,
    required this.alamatUser,
    required this.status,
    required this.pengambilan,
    required this.pembayaran,
    required this.productId,
    required this.userName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
  });
}
