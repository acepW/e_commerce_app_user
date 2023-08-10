import 'package:e_commerce_app_user/inner_screens/cat_screen.dart';
import 'package:e_commerce_app_user/inner_screens/prod_seller_screens.dart';
import 'package:e_commerce_app_user/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_user/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerNameWidget extends StatelessWidget {
  const SellerNameWidget(
      {Key? key,
      required this.nameSeller,
      required this.sellerId,
      required this.passedColor})
      : super(key: key);
  final String nameSeller, sellerId;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductSellerScreen.routeName,
            arguments: sellerId);
      },
      child: Container(
        //height: _screenWidth * 0.6,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: passedColor.withOpacity(0.7), width: 2),
        ),
        child: Column(
          children: [
            TextWidget(
              text: nameSeller,
              color: color,
              textSize: 20,
              isTitle: true,
            ),
          ],
        ),
      ),
    );
  }
}
