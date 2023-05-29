import 'package:flutter/material.dart';
import 'package:learn_flutter_bloc/bloc/addImage_bloc.dart';
import 'package:learn_flutter_bloc/pages/addImagePage.dart';

class Page4 extends StatelessWidget {
  Page4({Key? key}) : super(key: key);

  final ImageHandleBloc imageHandleBloc = ImageHandleBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('page 4'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddImage()));
            },
            child: const Text('Add Image'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.amberAccent,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
