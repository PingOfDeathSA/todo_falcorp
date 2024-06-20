import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:todo_web_falcorp/main.dart';
import 'package:todo_web_falcorp/todoUi.dart';

class sidemenu extends StatefulWidget {
  @override
  _sidemenuState createState() => _sidemenuState();
}

class _sidemenuState extends State<sidemenu> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              backgroundColor: Color(0xffD8EFD3),
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              openSideMenuWidth: MediaQuery.of(context).size.width * 0.13,
              showHamburger: true,
              hoverColor: Color(0xff95D2B3),
              selectedHoverColor: Color(0xff95D2B3),

              selectedColor: Color(0xff95D2B3),
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Color(0xff55AD9B),
              unselectedIconColor: Color(0xff55AD9B),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.grey[200]
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/2387/2387679.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                todoUI(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
