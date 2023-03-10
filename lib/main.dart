import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/bloc/home_bloc.dart';
import 'package:learn_flutter_bloc/inheritedWidget/home_bloc_inherited_widget.dart';
import 'package:learn_flutter_bloc/pages/appBottomNavBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var hb = HomeBloc();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InheritedHomeBloc(
        hb: hb,
        child: BlocProvider(
          create: (_) => BottomNavBarCubit(),
          child: AppBottomNavBar(),
        ),
      ),
    );
  }
}

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit({this.currentTab = 0}) : super(currentTab);

  int currentTab;

  void update(int index) {
    emit(currentTab = index);
  }
}
