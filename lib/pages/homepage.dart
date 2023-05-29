import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/inheritedWidget/home_bloc_inherited_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InheritedHomeBloc ihb = InheritedHomeBloc.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ini title (app bar)'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: BlocBuilder(
                bloc: ihb.hb.counterCubit,
                builder: (context, state) {
                  return Text("count :  $state");
                },
              ),
            ),
            Center(
              child: BlocBuilder(
                bloc: ihb.hb.counterInteractionCubit,
                builder: (context, state) {
                  return Text("total interaction :  $state");
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ihb.hb.counterCubit.subtract();
                    ihb.hb.counterInteractionCubit.add();
                  },
                  child: const Text("subtract"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ihb.hb.counterCubit.add();
                    ihb.hb.counterInteractionCubit.add();
                  },
                  child: const Text("add"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ihb.hb.counterCubit.reset();
                  },
                  child: const Text("reset counter"),
                ),
                ElevatedButton(
                  onPressed: () {
                    ihb.hb.counterInteractionCubit.reset();
                    ihb.hb.counterCubit.reset();
                  },
                  child: const Text("reset all"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
