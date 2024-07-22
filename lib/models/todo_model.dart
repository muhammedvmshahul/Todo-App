



import 'package:hive/hive.dart';

part 'todo_model.g.dart';



@HiveType(typeId: 0)
class Todo{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String lastDate;
  @HiveField(3)
  late bool completed;

  Todo({
    required this.title,
    required this.description,
    required this.lastDate,
    required this.completed
});
}