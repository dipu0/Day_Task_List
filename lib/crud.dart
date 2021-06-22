import 'database_table_creator.dart';
import 'daytasklist.dart';

class dayDayTaskList{
  static Future<List<DayTaskList>> getAllCRUDdata() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.daytasklistTable}
    WHERE ${DatabaseCreator.isDeleted} = 0''';
    final data = await db.rawQuery(sql);
    List<DayTaskList> task = List();

    for (final node in data) {
      final daytasklist = DayTaskList.fromJson(node);
      task.add(daytasklist);
    }
    return task;
  }

  static Future<DayTaskList> getCRUDdata(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.daytasklistTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final task = DayTaskList.fromJson(data.first);
    return task;
  }

  static Future<void> addCRUDdata(DayTaskList daytasklist) async {

    final sql = '''INSERT INTO ${DatabaseCreator.daytasklistTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name},
      ${DatabaseCreator.info},
      ${DatabaseCreator.isDeleted}
    )
    VALUES (?,?,?,?)''';
    List<dynamic> params = [daytasklist.id, daytasklist.name, daytasklist.info, daytasklist.isDeleted ? 1 : 0];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add daytasklist', sql, null, result, params);
  }

  static Future<void> deleteCRUDdata(DayTaskList daytasklist) async {
    final sql = '''UPDATE ${DatabaseCreator.daytasklistTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [daytasklist.id];
    final result = await db.rawUpdate(sql, params);


    DatabaseCreator.databaseLog('Delete Task', sql, null, result, params);
  }

  static Future<void> deleteAllCRUDdata() async {

    db.delete(DatabaseCreator.daytasklistTable);

    //DatabaseCreator.databaseLog('All task cleared', sql, null, result, params);
  }



  static Future<void> updateCRUDdata(DayTaskList daytasklist) async {
    final sql = '''UPDATE ${DatabaseCreator.daytasklistTable}
    SET ${DatabaseCreator.name} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [daytasklist.name, daytasklist.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update todo', sql, null, result, params);
  }

  static Future<int> tasksCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.daytasklistTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
