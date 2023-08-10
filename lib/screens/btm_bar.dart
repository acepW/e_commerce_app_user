import 'package:badges/badges.dart' as badges;
import 'package:e_commerce_app_user/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_user/providers/user_provider.dart';
import 'package:e_commerce_app_user/screens/categories.dart';
import 'package:e_commerce_app_user/screens/chat_screen/chat_page.dart';
import 'package:e_commerce_app_user/screens/home_screen.dart';
import 'package:e_commerce_app_user/screens/user.dart';
import 'package:e_commerce_app_user/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const HalamanChatPage(), 'title': 'Cahat Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    Provider.of<UserProvider>(context).refreshUser();

    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      /* appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ), */
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 2 ? IconlyBold.message : IconlyLight.message),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (_, myCart, ch) {
                return 
                 badges.Badge(
                  
                    
                    badgeStyle: badges.BadgeStyle(

                      
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    ),
                    position: badges.BadgePosition.topEnd(top: -7, end: -7),
                    badgeContent: FittedBox(
                        child: TextWidget(
                            text: myCart.getCartItems.length.toString(),
                            color: Colors.white,
                            textSize: 15)),
                    child: Icon(_selectedIndex == 3
                        ? IconlyBold.buy
                        : IconlyLight.buy));
              },
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 4 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
