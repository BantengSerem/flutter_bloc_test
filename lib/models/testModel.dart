import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  late int id;
  late String date;

  TestModel({required this.id, required this.date});

  TestModel.fromMap(DocumentSnapshot<Object> data) {
    id = data['id'];
    date = data['date'];
  }

  TestModel.detailMap(dynamic data) {
    id = data['id'];
    date = data['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
    };
  }
}
