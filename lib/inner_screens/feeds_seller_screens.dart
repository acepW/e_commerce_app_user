import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_commerce_app_user/models/user_model.dart';
import 'package:e_commerce_app_user/providers/user_provider.dart';
import 'package:e_commerce_app_user/widgets/back_widget.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/empty_products_widget.dart';

import '../widgets/seller_name_widget.dart';
import '../widgets/text_widget.dart';
import 'package:e_commerce_app_user/models/products_model.dart';
import 'package:e_commerce_app_user/providers/products_provider.dart';

class FeedsSellerScreen extends StatefulWidget {
  static const routeName = "/FeedsSellerScreenState";
  const FeedsSellerScreen({Key? key}) : super(key: key);

  @override
  State<FeedsSellerScreen> createState() => _FeedsSellerScreenState();
}

class _FeedsSellerScreenState extends State<FeedsSellerScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<UserModel> listSellerSearch = [];
  List<UserModel> allProducts = UserProvider().getUsers;
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
  //   productsProvider.fetchProducts();
  //   super.initState();
  // }

  // void didChangeDependencies() {

  // }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final userProviders = Provider.of<UserProvider>(context);
    List<UserModel> allProducts = userProviders.getUsers;

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Products',
          color: color,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
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
                    listSellerSearch = UserProvider().searchQuerySeller(valuee);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
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
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),

          _searchTextController!.text.isNotEmpty && listSellerSearch.isEmpty
              ? const EmptyProdWidget(
                  text: 'No products found, please try another keyword')
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('role', isEqualTo: 'seller')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: _searchTextController!.text.isNotEmpty
                              ? listSellerSearch.length
                              : snapshot.data.docs.length,
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
          // : GridView.count(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     crossAxisCount: 2,
          //     padding: EdgeInsets.zero,
          //     // crossAxisSpacing: 10,
          //     childAspectRatio: size.width / (size.height * 0.61),
          //     children: List.generate(
          //         _searchTextController!.text.isNotEmpty
          //             ? listProductSearch.length
          //             : allProducts.length, (index) {
          //       return ChangeNotifierProvider.value(
          //         value: _searchTextController!.text.isNotEmpty
          //             ? listProductSearch[index]
          //             : allProducts[index],
          //         child: const FeedsWidget(),
          //       );
          //     }),
          //   ),
        ]),
      ),
    );
  }
}
