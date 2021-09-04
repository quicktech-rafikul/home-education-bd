import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/SQFLite/DatabaseHelper.dart';
import 'package:educationbd/Models/OfflineVideoModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DBQueries {

  final dbHelper = DatabaseHelper.instance;

  insert(OfflineVideoModel model) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : model.id,
      DatabaseHelper.columnTitle : model.title,
      DatabaseHelper.columnLink : model.videoLink,
    };
    try{
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
      Get.snackbar(model.title, "Download Complete", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
    }catch(e){
      Get.snackbar(model.title, "Already Downloaded", backgroundColor: UIColors.primaryColor2, colorText: Colors.white);
    }
  }

  Future<List<OfflineVideoModel>>query() async {
    List<OfflineVideoModel> videos = [];
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) {
      OfflineVideoModel model = new OfflineVideoModel(
        id: row[DatabaseHelper.columnId],
        title: row[DatabaseHelper.columnTitle],
        videoLink: row[DatabaseHelper.columnLink]
      );
      videos.add(model);
    });
    return videos;
  }

  // update() async {
  //   // row to update
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.columnId   : 1,
  //     DatabaseHelper.columnName : 'Mary',
  //     DatabaseHelper.columnAge  : 32
  //   };
  //   final rowsAffected = await dbHelper.update(row);
  //   print('updated $rowsAffected row(s)');
  // }

  delete(String id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}