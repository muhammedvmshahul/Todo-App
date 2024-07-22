import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivetodo/models/todo_model.dart';
import 'package:hivetodo/screens/homeScreen.dart';
import 'package:hivetodo/services/todo_Services.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());

  final _todoServices = TodoServices();
  await _todoServices.openBox();
  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:   HomeScreen())
      );


}

