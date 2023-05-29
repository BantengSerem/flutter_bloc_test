import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/main.dart';
import 'package:learn_flutter_bloc/pages/homepage.dart';
import 'package:learn_flutter_bloc/pages/page2.dart';
import 'package:learn_flutter_bloc/pages/page3.dart';
import 'package:learn_flutter_bloc/pages/page4.dart';

class Number5 extends StatelessWidget {
  const Number5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text('page 5'),
      ),
    );
  }
}



class AppBottomNavBar extends StatelessWidget {
  AppBottomNavBar({Key? key}) : super(key: key);

  final List<Widget> pages = [
    // const HomePage(
    //   key: PageStorageKey<String>('homePage'),
    // ),
    Page2(
      key: const PageStorageKey<String>('page2'),
    ),
    Page3(
      key: const PageStorageKey<String>('page3'),
    ),
    Page4(
      key: const PageStorageKey<String>('pageNumber4'),
    ),
    // const Number5(
    //   key: PageStorageKey<String>('number5'),
    // )
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
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.red,
            onTap: (index) {
              abnb.update(index);
            },
            currentIndex: abnb.currentTab,
            items: const [
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Page 2'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.abc_sharp), label: 'Page 3'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_alarm_sharp), label: 'Page 4'),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.home_rounded), label: 'number 5'),
            ],
          );
        },
      ),
    );
  }
}
