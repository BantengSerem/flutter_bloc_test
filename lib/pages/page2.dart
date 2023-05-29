import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/bloc/page2_bloc.dart';
import 'package:learn_flutter_bloc/inheritedWidget/home_bloc_inherited_widget.dart';

class Page2 extends StatelessWidget {
  Page2({Key? key}) : super(key: key);

  final Page2Bloc page2bloc = Page2Bloc();

  @override
  Widget build(BuildContext context) {
    final InheritedHomeBloc ihb = InheritedHomeBloc.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('page 2'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder(
              bloc: page2bloc.stateHandler,
              builder: (context, state) {
                return Text('$state');
              },
            ),
            ElevatedButton(
              onPressed: () {
                page2bloc.firebaseCubit.addNewData();
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                page2bloc.firebaseCubit.refresh();
              },
              child: const Text('Refresh'),
            ),
            ElevatedButton(
              onPressed: () {
                page2bloc.firebaseCubit.test();
              },
              child: const Text('Get'),
            ),
            ElevatedButton(
              onPressed: () {
                page2bloc.firebaseCubit.showList();
              },
              child: const Text('List'),
            ),
            ElevatedButton(
              onPressed: () {
                page2bloc.firebaseCubit.detail();
              },
              child: const Text('detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2Card extends StatelessWidget {
  Page2Card({Key? key, required this.page2bloc}) : super(key: key);
  Page2Bloc page2bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 50,
        color: Colors.green,
      ),
    );
  }
}
