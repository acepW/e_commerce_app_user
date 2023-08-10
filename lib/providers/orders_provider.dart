import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_user/models/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // ordersList.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              title: element.get('title'),
              sellerId: element.get('sellerId'),
              sellerName: element.get('sellerName'),
              alamatSeller: element.get('alamatSeller'),
              alamatUser: element.get('alamatUser'),
              status: element.get('status'),
              pengambilan: element.get('pengambilan'),
              pembayaran : element.get('pembayaran'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ));
      });
    });
    notifyListeners();
  }
}
