import 'package:e_commerce_app_user/consts/contss.dart';
import 'package:e_commerce_app_user/models/products_model.dart';
import 'package:e_commerce_app_user/providers/products_provider.dart';
import 'package:e_commerce_app_user/widgets/back_widget.dart';
import 'package:e_commerce_app_user/widgets/empty_products_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class ProductSellerScreen extends StatefulWidget {
  static const routeName = "/ProductSellerScreenState";
  const ProductSellerScreen({Key? key}) : super(key: key);

  @override
  State<ProductSellerScreen> createState() => _ProductSellerScreenState();
}

class _ProductSellerScreenState extends State<ProductSellerScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    final sellerId = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat = productProviders.findBySellerId(sellerId);
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        // title: TextWidget(
        //   text: catName,
        //   color: color,
        //   textSize: 20.0,
        //   isTitle: true,
        // ),
      ),
      body: productByCat.isEmpty
          ? const EmptyProdWidget(
              text: 'No products belong to this category',
            )
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: TextField(
                      focusNode: _searchTextFocusNode,
                      controller: _searchTextController,
                      onChanged: (valuee) {
                        setState(() {
                          listProductSearch =
                              productProviders.searchQuery(valuee);
                        });
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.greenAccent, width: 1),
                        ),
                        hintText: "What's in your mind",
                        prefixIcon: const Icon(Icons.search),
                        suffix: IconButton(
                          onPressed: () {
                            _searchTextController!.clear();
                            _searchTextFocusNode.unfocus();
                          },
                          icon: Icon(
                            Icons.close,
                            color: _searchTextFocusNode.hasFocus
                                ? Colors.red
                                : color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _searchTextController!.text.isNotEmpty &&
                        listProductSearch.isEmpty
                    ? const EmptyProdWidget(
                        text: 'No products found, please try another keyword')
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        padding: EdgeInsets.zero,
                        // crossAxisSpacing: 10,
                        childAspectRatio: size.width / (size.height * 0.61),
                        children: List.generate(
                            _searchTextController!.text.isNotEmpty
                                ? listProductSearch.length
                                : productByCat.length, (index) {
                          return ChangeNotifierProvider.value(
                            value: _searchTextController!.text.isNotEmpty
                                ? listProductSearch[index]
                                : productByCat[index],
                            child: const FeedsWidget(),
                          );
                        }),
                      ),
              ]),
            ),
    );
  }
}