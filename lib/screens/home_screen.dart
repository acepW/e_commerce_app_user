import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_user/inner_screens/feeds_screen.dart';
import 'package:e_commerce_app_user/inner_screens/feeds_seller_screens.dart';
import 'package:e_commerce_app_user/inner_screens/on_sale_screen.dart';
import 'package:e_commerce_app_user/services/global_methods.dart';
import 'package:e_commerce_app_user/services/utils.dart';
import 'package:e_commerce_app_user/widgets/feed_items.dart';
import 'package:e_commerce_app_user/widgets/seller_name_widget.dart';
import 'package:e_commerce_app_user/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/contss.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.offerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.red)),
                //control: const SwiperControl(color: Colors.amber),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            // TextButton(
            //     onPressed: () {
            //       GlobalMethods.navigateTo(
            //           ctx: context, routeName: OnSaleScreen.routeName);
            //     },
            //     child: TextWidget(
            //       text: 'View all',
            //       maxLines: 1,
            //       color: Colors.blue,
            //       textSize: 20,
            //     )),
            // const SizedBox(
            //   height: 6,
            // ),
            // Row(
            //   children: [
            //     RotatedBox(
            //       quarterTurns: -1,
            //       child: Row(
            //         children: [
            //           TextWidget(
            //             text: 'On Sale'.toUpperCase(),
            //             color: Colors.red,
            //             textSize: 22,
            //             isTitle: true,
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           const Icon(
            //             IconlyLight.discount,
            //             color: Colors.red,
            //           )
            //         ],
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //     Flexible(
            //       child: SizedBox(
            //         height: size.height * 0.24,
            //         child: ListView.builder(
            //           itemCount: productsOnSale.length < 10
            //               ? productsOnSale.length
            //               : 10,
            //           scrollDirection: Axis.horizontal,
            //           itemBuilder: (ctx, index) {
            //             return ChangeNotifierProvider.value(
            //                 value: productsOnSale[index],
            //                 child: const OnSaleWidget());
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Our Seller',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: FeedsSellerScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      )),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where('role', isEqualTo: 'seller')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SellerNameWidget(
                              nameSeller: snapshot.data.docs[index]['name'],
                              sellerId: snapshot.data.docs[index]['id'],
                              passedColor: Colors.red);
                        });
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.purple,
                  ));
                }),

            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Our Products',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      )),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              //crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.61),
              children: List.generate(
                  allProducts.length < 4 ? allProducts.length : 4, (index) {
                return ChangeNotifierProvider.value(
                  value: allProducts[index],
                  child: FeedsWidget(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
