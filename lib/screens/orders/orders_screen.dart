import 'package:e_commerce_app_user/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderList.isEmpty
              ? const EmptyScreen(
                  title: 'You didnt place any order yet!',
                  subtitle: 'Order something, dude',
                  buttonText: 'Shop Now',
                  imagePath: 'assets/images/cart.png',
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: const BackWidget(),
                    elevation: 0,
                    centerTitle: false,
                    title: TextWidget(
                      text: 'Your orders (${orderList.length})',
                      color: color,
                      textSize: 24.0,
                      isTitle: true,
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  body: ListView.separated(
                    itemCount: orderList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: orderList[index],
                          child: const OrderWidget(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: color,
                        thickness: 1,
                      );
                    },
                  ));
        });
  }
}
