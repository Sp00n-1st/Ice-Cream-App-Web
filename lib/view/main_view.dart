import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_navigation/side_navigation.dart';
import 'dashboard_main.dart';
import 'order_page.dart';
import 'transaction_page.dart';
import 'product_page.dart';
import 'upload_page.dart';
import 'user_page.dart';
import '../service/database.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  int? position = 0;
  MainView({Key? key, this.position}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    int selectedIndex = position ?? 0;

    List<Widget> views = [
      const DashboardMain(),
      Center(
        child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: 50, left: sizeWidth / 20, right: sizeWidth / 4),
                child: const UploadPage())),
      ),
      const ProductPage(),
      UserPage(),
      OrderPage(),
      Transaction()
    ];

    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        backgroundColor: const Color(0xffEAEAEA),
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(
                            'Are Sure To Logout ?',
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                          content: const Icon(
                            Icons.logout_rounded,
                            size: 50,
                          ),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                DataBaseServices().logoutAuth();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Yes',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout)),
            )
          ],
          title: Text(
            'Sweet Dream Admin Control',
            style: GoogleFonts.poppins(),
          ),
        ),
        body: Row(
          children: [
            SideNavigationBar(
              theme: SideNavigationBarTheme(
                backgroundColor: const Color(0xff5872f5),
                togglerTheme: SideNavigationBarTogglerTheme.standard(),
                itemTheme: const SideNavigationBarItemTheme(
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.white),
                dividerTheme: SideNavigationBarDividerTheme.standard(),
              ),
              selectedIndex: selectedIndex,
              items: const [
                SideNavigationBarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                ),
                SideNavigationBarItem(
                  icon: Icons.add_circle_outline,
                  label: 'Add Product',
                ),
                SideNavigationBarItem(
                  icon: Icons.icecream,
                  label: 'Product',
                ),
                SideNavigationBarItem(
                  icon: CupertinoIcons.person_crop_circle_fill,
                  label: 'User',
                ),
                SideNavigationBarItem(
                  icon: CupertinoIcons.cart_fill,
                  label: 'Order',
                ),
                SideNavigationBarItem(
                  icon: CupertinoIcons.square_list_fill,
                  label: 'Transaction',
                ),
              ],
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            selectedIndex == 2
                ? Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: sizeWidth / 1.99,
                        height: sizeHeight,
                        child: views.elementAt(selectedIndex)),
                  )
                : Expanded(
                    child: views.elementAt(selectedIndex),
                  )
          ],
        ),
      ),
    );
  }
}
