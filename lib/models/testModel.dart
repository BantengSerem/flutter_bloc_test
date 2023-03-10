import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  late int id;
  late String date;

  TestModel({required this.id, required this.date});

  TestModel.fromMap(DocumentSnapshot data){
    id = data['id'];
    date = data['date'];
  }
}