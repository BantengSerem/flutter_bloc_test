import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/main.dart';
import 'package:learn_flutter_bloc/pages/homepage.dart';
import 'package:learn_flutter_bloc/pages/page2.dart';

class AppBottomNavBar extends StatelessWidget {
  AppBottomNavBar({Key? key}) : super(key: key);

  final List<Widget> pages = [
    const HomePage(
      key: PageStorageKey<String>('homePage'),
    ),
    const Page2(
      key: PageStorageKey<String>('page2'),
    ),
  ];

  // int currentTab;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final abnb = BlocProvider.of<BottomNavBarCubit>(context);
    print("build abnp");
    return Scaffold(
      body: BlocBuilder(
        bloc: abnb,
        builder: (context, state) {
          print("build page storage");
          return PageStorage(
            bucket: _bucket,
            child: pages[abnb.currentTab],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder(
        bloc: abnb,
        builder: (context, state) {
          print('build bottom');
          return BottomNavigationBar(
            onTap: (index) {
              abnb.update(index);
            },
            currentIndex: abnb.currentTab,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Page 2'),
            ],
          );
        },
      ),
    );
  }
}
