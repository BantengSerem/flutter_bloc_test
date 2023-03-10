import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/models/testModel.dart';

class Page2Bloc {
  late FirebaseCubit firebaseCubit;

  Page2Bloc() {
    firebaseCubit = FirebaseCubit();
  }
}

class FirebaseCubit extends Cubit<String> {
  FirebaseCubit({this.state = 'running'}) : super(state);

  String state;
  List<StreamSubscription<QuerySnapshot>> streamList = [];
  List<TestModel> listItem = [];
  final fireStoreInstance = FirebaseFirestore.instance;
  static int count = 0;
  Map<String, dynamic> mapOfIndex = {};
  late DocumentSnapshot? currDoc = null;
  bool firstTime = true;

  void refresh() {
    for (var element in streamList) {
      element.cancel();
    }
    streamList.clear();
    print('streamList : ${streamList}');
    listItem.clear();
    currDoc = null;
    firstTime = true;
  }

  Future<void> addNewData() async {
    emit(state = 'loading');
    await fireStoreInstance
        .collection('testList')
        .doc(count.toString())
        .set({'id': count, 'date': DateTime.now().toString()}).whenComplete(() {
      emit(state = 'done');
      count += 1;
    }).catchError((error) {
      print('error : $error');
    });
    emit(state = 'running');
  }

  void showList() {
    print('List size : ${listItem.length}');
    print('Stream size : ${streamList.length}');
    print('currDoc : $currDoc');
    // for (var i in listItem) {
    //   print('==============================');
    //   print(i.id);
    //   print(i.date);
    //   print('==============================');
    // }
  }

  Future<void> test() async {
    emit(state = 'loading');
    // await fireStoreInstance.collection('testList').get().then((value) {
    //   value.docs.toList().forEach((element) {
    //     print(element.data());
    //   });
    // });
    if (firstTime) {
      var snapshot = fireStoreInstance
          .collection('testList')
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .listen((event) {
        event.docChanges.asMap().forEach((key, value) {
          switch (value.type) {
            case DocumentChangeType.added:
              print("added : ${TestModel.fromMap(value.doc).id}");
              // When a data is deleted in the database
              // it will trigger changes (type = added) to retrieve more data
              // and it will retrieve data after the last one of this snapshot initial retrieve
              // thus, there'll be duplication inside the list
              // so it has to be removed
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              listItem.add(TestModel.fromMap(value.doc));
              break;
            case DocumentChangeType.modified:
              print("modified : ${TestModel.fromMap(value.doc).id}");
              int i = listItem.indexWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              listItem[i] = TestModel.fromMap(value.doc);
              break;
            case DocumentChangeType.removed:
              print("removed : ${TestModel.fromMap(value.doc).id}");
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              break;
          }
        });

        listItem.sort((a, b) => b.date.compareTo(a.date));
        //
        print('event.size : ${event.size}');
        if (event.size < 10) {
          currDoc = null;
          print('event.size : null');
        } else {
          currDoc = event.docs[event.size - 1];
          print('event.size : not null');
        }
        // orderList.refresh();
      });

      streamList.add(snapshot);
      firstTime = false;
    } else if (currDoc != null) {
      var snapshot = fireStoreInstance
          .collection('testList')
          .orderBy('date', descending: false)
          .limit(10)
          .startAfterDocument(currDoc!)
          .snapshots()
          .listen((event) {
        event.docChanges.asMap().forEach((key, value) {
          switch (value.type) {
            case DocumentChangeType.added:
              print("added : ${TestModel.fromMap(value.doc).id}");
              // When a data is deleted in the database
              // it will trigger changes (type = added) to retrieve more data
              // and it will retrieve data after the last one of this snapshot initial retrieve
              // thus, there'll be duplication inside the list
              // so it has to be removed
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              listItem.add(TestModel.fromMap(value.doc));
              break;
            case DocumentChangeType.modified:
              print("modified : ${TestModel.fromMap(value.doc).id}");
              int i = listItem.indexWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              listItem[i] = TestModel.fromMap(value.doc);
              break;
            case DocumentChangeType.removed:
              print("removed : ${TestModel.fromMap(value.doc).id}");
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              break;
          }
        });

        listItem.sort((a, b) => b.date.compareTo(a.date));
        //
        print('event.size : ${event.size}');
        if (event.size < 10) {
          currDoc = null;
        } else {
          currDoc = event.docs[event.size - 1];
        }
        // orderList.refresh();
      });

      streamList.add(snapshot);
    }

    emit(state = 'done');
    emit(state = 'running');
  }
}
