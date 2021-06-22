import 'database_table_creator.dart';

class DayTaskList {
  int id;
  String name;
  String info;
  bool isDeleted;

  DayTaskList(this.id, this.name, this.info, this.isDeleted);

  DayTaskList.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.info = json[DatabaseCreator.info];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}
