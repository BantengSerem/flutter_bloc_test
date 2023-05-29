import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter_bloc/models/testModel.dart';

class Page2Bloc {
  late FirebaseCubit firebaseCubit;
  late StateHandler stateHandler;

  static final Page2Bloc _singleton = Page2Bloc._internal();

  factory Page2Bloc() {
    return _singleton;
  }

  Page2Bloc._internal() {
    firebaseCubit = FirebaseCubit([]);
    stateHandler = StateHandler();
  }

  void retrieveData() async {
    stateHandler.loadingState();
    await firebaseCubit
        .test()
        .catchError((onError) => stateHandler.errorState());
    stateHandler.runningState();
  }

  void addNewData() async {
    stateHandler.loadingState();
    await firebaseCubit
        .addNewData()
        .catchError((onError) => stateHandler.errorState());
  }
}

class StateHandler extends Cubit<String> {
  StateHandler({this.state = 'running'}) : super(state);
  @override
  String state;

  void loadingState() {
    emit(state = 'loading');
  }

  void runningState() {
    emit(state = 'running');
  }

  void errorState() {
    emit(state = 'error');
  }
}

class FirebaseCubit extends Cubit<List<TestModel>> {
  FirebaseCubit(this.listItem) : super(listItem);

  // @override
  // String state;
  List<StreamSubscription<QuerySnapshot>> streamList = [];
  List<TestModel> listItem = [];
  final fireStoreInstance = FirebaseFirestore.instance;

  // final firebaseMessaging = FirebaseMessaging;
  static int count = 0;
  Map<String, dynamic> mapOfIndex = {};
  late DocumentSnapshot? currDoc = null;
  bool firstTime = true;

  void listenLastStreamList() {
    final ls = streamList.last;
    ls.onData((data) {
      print('last listener data : $data');
    });
  }

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

  void checkStream() {
    streamList.last.cancel();
    streamList.removeLast();
    getLastDocSnapshots();
    print('streamList : ${streamList}');
  }

  void getLastDocSnapshots() async {
    var query = fireStoreInstance
        .collection('testList')
        .doc(listItem.last.id.toString());
    currDoc = await query.get();
  }

  Future<void> addNewData({String url = ''}) async {
    // emit(state = 'loading');
    await fireStoreInstance.collection('testList').doc(count.toString()).set({
      'id': count,
      'date': DateTime.now().toString(),
      'testOfMap': [
        <String, dynamic>{'a': 123, 'b': 'asdf1'},
        <String, dynamic>{'a': 123, 'b': 'asdf2'},
        <String, dynamic>{'a': 123, 'b': 'asdf3'},
      ],
      'imgURL': url,
    }).whenComplete(() {
      // emit(state = 'done');
      count += 1;
    }).catchError((error) {
      print('error : $error');
    });
    // emit(state = 'running');
  }

  void showList() {
    print('List size : ${listItem.length}');
    print('Stream size : ${streamList.length}');
    print('current last : ${listItem.last}');
    print('currDoc : $currDoc');
    // for (var i in listItem) {
    //   print('==============================');
    //   print(i.id);
    //   print(i.date);
    //   print('==============================');
    // }
  }

  void detail() {
    print(
        'currDoc : ${currDoc == null ? 'none' : TestModel.detailMap(currDoc!).toMap()}');
  }

  Future<void> paginate() async {
    Query query;
    if (firstTime) {
      query = fireStoreInstance
          .collection('testList')
          .orderBy('date', descending: false)
          .limit(10);
    } else if (currDoc != null) {
      query = fireStoreInstance
          .collection('testList')
          .orderBy('date', descending: false)
          .limit(10)
          .startAfterDocument(currDoc!);
    }
  }

  void deleteData() async {
    var a = await fireStoreInstance.collection('testList').get();
    for (var element in a.docs) {
      element[''];
    }
  }

  Future<void> test() async {
    // emit(state = 'loading');
    // await fireStoreInstance.collection('testList').get().then((value) {
    //   value.docs.toList().forEach((element) {
    //     print(element.data());
    //   });
    // });

    var index = streamList.length + 1;

    if (firstTime) {
      var snapshot = fireStoreInstance
          .collection('testList')
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .listen((event) {
        // print('ini adalah stream ke-$index');
        // print("event.size : ${event.size} ${event.size.isNaN}");
        if (event.size == 0) {
          checkStream();

          return;
        }
        // bool newItem = false;
        //
        // bool addData = false;
        // bool removeData = false;

        event.docChanges.asMap().forEach((key, value) {
          switch (value.type) {
            case DocumentChangeType.added:
              // if (addData == false) addData = true;
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
              // if (removeData == false) removeData = true;
              print("removed : ${TestModel.fromMap(value.doc).id}");
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              break;
          }
        });

        // print('is active = {addData : $addData, removeData : $removeData}');
        listItem.sort((a, b) => b.date.compareTo(a.date));
        //
        // print('event.size : ${event.size}');
        // if (event.size < 10) {
        //   currDoc = null;
        //   // print('event.size : null');
        // } else {
        //   currDoc = event.docs[event.size - 1];
        //   // print('event.size : not null');
        // }
        // orderList.refresh();

        // if(addData && !removeData){
        //   currDoc = event.docs[event.size - 1];
        // }
        print(
            'index : $index, streamList.length : ${streamList.length}, event.size : ${event.size}');
        if (index == streamList.length && event.size == 10) {
          currDoc = event.docs.last;
          print(
              'change the currDoc on stream : $index, with the streamList.length : ${streamList.length}');
        } else if (index == streamList.length && event.size < 10) {
          currDoc = null;
        }
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
        // print('ini adalah stream ke-$index');
        // print("event.size : ${event.size} ${event.size.isNaN}");
        if (event.size == 0) {
          checkStream();
          return;
        }

        // bool addData = false;
        // bool removeData = false;
        // var a = event.docChanges;
        // var contains =
        //     a.contains([DocumentChangeType.added, DocumentChangeType.removed]);
        // print('is active : ${contains}');
        // print('docChanges : ${a.asMap()}');

        event.docChanges.asMap().forEach((key, value) {
          switch (value.type) {
            case DocumentChangeType.added:
              // if (addData == false) addData = true;
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
              // if (removeData == false) removeData = true;
              print("removed : ${TestModel.fromMap(value.doc).id}");
              listItem.removeWhere(
                  (element) => element.id == TestModel.fromMap(value.doc).id);
              break;
          }
        });

        // event.docs.asMap().forEach((key, value) {
        //   print('object : ${TestModel.fromMap(value.data())}');
        // });

        // print('is active = {addData : $addData, removeData : $removeData}');
        listItem.sort((a, b) => b.date.compareTo(a.date));
        //

        print(
            'index : $index, streamList.length : ${streamList.length}, event.size : ${event.size}');
        if (index == streamList.length && event.size == 10) {
          currDoc = event.docs.last;
          print(
              'change the currDoc on stream : $index, with the streamList.length : ${streamList.length}');
        } else if (index == streamList.length && event.size < 10) {
          currDoc = null;
        }
        // if (event.size < 10) {
        //   currDoc = null;
        // } else {
        //   currDoc = event.docs[event.size - 1];
        // }
        // orderList.refresh();

        // if(addDataata && !removeData){
        //   currDoc = event.docs[event.size - 1];
        // }
        // else if(removeData){
        //   if(event.size < 10) currDoc = null;
        //
        // }
        // else if(addData){
        //   if(event.size == 10) {
        //     currDoc = event.docs[event.size - 1];
        //   } else {
        //     currDoc = null;
        //   }
        // }
      });

      streamList.add(snapshot);
    }

    // emit(state = 'done');
    // emit(state = 'running');
  }
}
