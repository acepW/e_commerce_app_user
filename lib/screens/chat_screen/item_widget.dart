import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_user/services/global_methods.dart';
import 'package:e_commerce_app_user/services/utils.dart';
import 'package:e_commerce_app_user/widgets/price_widget.dart';
import 'package:e_commerce_app_user/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ItemProductNego extends StatefulWidget {
  final String imageUrl;
  final int salePrice;
  final String title;
  final int price;
  final bool isOnSale;
  final String uid;
  final String productId;
  final String sellerId;
  final String sellerName;
  final String totalPrice;
  final String displayName;
  const ItemProductNego(
      {super.key,
      required this.imageUrl,
      required this.salePrice,
      required this.title,
      required this.price,
      required this.isOnSale,
      required this.uid,
      required this.productId,
      required this.sellerId,
      required this.sellerName,
      required this.totalPrice,
      required this.displayName});

  @override
  State<ItemProductNego> createState() => _ItemProductNegoState();
}

class _ItemProductNegoState extends State<ItemProductNego> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: Column(children: [
          FancyShimmerImage(
            imageUrl: widget.imageUrl,
            height: size.width * 0.21,
            width: size.width * 0.2,
            boxFit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextWidget(
                    text: widget.title,
                    color: color,
                    maxLines: 1,
                    textSize: 18,
                    isTitle: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: PriceWidget(
                    salePrice: widget.salePrice,
                    price: widget.price,
                    textPrice: _quantityTextController.text,
                    isOnSale: widget.isOnSale,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Row(
                  children: [
                    TextFormField(
                      controller: _quantityTextController,
                      key: const ValueKey('10'),
                      style: TextStyle(color: color, fontSize: 18),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      enabled: true,
                      onChanged: (valueee) {
                        setState(() {
                          if (valueee.isEmpty) {
                            _quantityTextController.text = '1';
                          } else {}
                        });
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9.]'),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                final orderId = const Uuid().v4();
                try {
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(orderId)
                      .set({
                    'orderId': orderId,
                    'userId': widget.uid,
                    'productId': widget.productId,
                    'sellerId': widget.sellerId,
                    'sellerName': widget.sellerName,
                    'status': "Di proses",
                    'deliverName': "-",
                    'price':
                        (widget.isOnSale ? widget.salePrice : widget.price) * 1,
                    'totalPrice': widget.totalPrice,
                    'quantity': 1,
                    'imageUrl': widget.imageUrl,
                    'userName': widget.displayName,
                    'orderDate': Timestamp.now(),
                  });

                  await Fluttertoast.showToast(
                    msg: "Your order has been placed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                } catch (error) {
                  GlobalMethods.errorDialog(
                      subtitle: error.toString(), context: context);
                } finally {}
              },
              child:
                  TextWidget(text: "Beli Sekarang", color: color, textSize: 20),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).cardColor),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                  )),
            ),
          )
          // SizedBox(
          //   width: double.infinity,
          //   child: TextButton(
          //     onPressed: _isInCart
          //         ? null
          //         : () async {
          //             // if (_isInCart) {
          //             //   return ;
          //             // }
          //             final User? user = authInstance.currentUser;
          //             if (user == null) {
          //               GlobalMethods.errorDialog(
          //                   subtitle: 'No user found, Please login first',
          //                   context: context);
          //               return;
          //             }
          //             await GlobalMethods.addToCart(
          //               productId: productModel.id,
          //               quantity: int.parse(_quantityTextController.text),
          //               context: context,
          //             );
          //             await cartProvider.fetchCart();
          //             // cartProvider.addProductsToCart(
          //             //     productId: productModel.id,
          //             //     quantity: int.parse(
          //             //       _quantityTextController.text,
          //             //     ));
          //           },
          //     child: productModel.stock == true
          //         ? TextWidget(
          //             text: _isInCart ? 'In Cart' : 'Add to cart',
          //             maxLines: 1,
          //             color: color,
          //             textSize: 20,
          //           )
          //         : TextWidget(
          //             text: 'Stock Habis',
          //             maxLines: 1,
          //             color: color,
          //             textSize: 20,
          //           ),
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStateProperty.all(Theme.of(context).cardColor),
          //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //           const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(12.0),
          //               bottomRight: Radius.circular(12.0),
          //             ),
          //           ),
          //         )),
          //   ),
          // )
        ]),
      ),
    );
  }
}
