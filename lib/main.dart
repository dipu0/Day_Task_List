import 'dart:math';

import 'package:flutter/material.dart';

import 'crud.dart';
import 'database_table_creator.dart';
import 'daytasklist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day Task List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SqfLiteCrud(title: 'Day Task List'),
    );
  }
}

class SqfLiteCrud extends StatefulWidget {
  SqfLiteCrud({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SqfLiteCrudState createState() => _SqfLiteCrudState();
}

class _SqfLiteCrudState extends State<SqfLiteCrud> {
  final _formKey = GlobalKey<FormState>();
  Future<List<DayTaskList>> future;
  String name,daytask;
  int id;

  @override
  initState() {
    super.initState();
    future = dayDayTaskList.getAllCRUDdata();
  }

  void readData() async {
    final DayTaskList = await dayDayTaskList.getCRUDdata(id);
    print(DayTaskList.name);
  }

  updateData(DayTaskList daytasklist) async {
    daytasklist.name = daytasklist.name + ' ✅';
    await dayDayTaskList.updateCRUDdata(daytasklist);
    setState(() {
      future = dayDayTaskList.getAllCRUDdata();
    });
  }

  deleteData(DayTaskList daytasklist) async {
    await dayDayTaskList.deleteCRUDdata(daytasklist);
    setState(() {
      id = null;
      future = dayDayTaskList.getAllCRUDdata();
    });
  }

  deleteAllData() async {
    dayDayTaskList.deleteAllCRUDdata();
    setState(() {
      id = null;
      future = dayDayTaskList.getAllCRUDdata();
    });
  }
  final _random = Random();
  Card buildItem(DayTaskList daytasklist) {
    return Card(
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
      [_random.nextInt(5) * 100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${daytasklist.name}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Day task: ${daytasklist.info}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(daytasklist),
                  child: Text('Task Complete', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(daytasklist),
                  child: Text('Delete'),
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      controller: TextEditingController(text: name),
      keyboardType: TextInputType.multiline,
     // maxLines: null,
      //expands: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), ),
        labelText: 'Name',
        fillColor: Colors.green.shade100,
        filled: true,

      ),
      textAlign: TextAlign.start,
     /* ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter name of the task';
        }
      },
      */
      onSaved: (value) => {
        if(value.isEmpty)
          name=('Task#'+"")
        else name = value,
      }

    );
  }


  TextFormField buildTextFormField2() {
    return TextFormField(
      controller: TextEditingController(text: daytask),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      expands: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),  ),
        labelText: 'Task',
        fillColor: Colors.blue.shade100,
        //hoverColor: Colors.green.shade100,
        filled: true,

      ),
      textAlign: TextAlign.left,
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter task';
        }
      },
      onSaved: (value) => daytask = value,
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int count = await dayDayTaskList.tasksCount();
      final daytasklist = DayTaskList(count, name, daytask, false);
      await dayDayTaskList.addCRUDdata(daytasklist);
      setState(() {

        id = daytasklist.id;
        future = dayDayTaskList.getAllCRUDdata();
        name='';
        daytask='';
      });
      print(daytasklist.id);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Center(child: Text('Day Task List',style: TextStyle(color: Colors.teal),)),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
      children: <Widget>[
          Form(
            key: _formKey,
            child:Column(
              children: <Widget>[
                //buildTextFormField(),
               // SizedBox(height: 10,),
                //buildTextFormField2(),

                SizedBox(height: 80,child: buildTextFormField(),),
                SizedBox(height: 10,),
                SizedBox(height: 150,child: buildTextFormField2(),),

              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: createData,
                child: Text('Add Task', style: TextStyle(color: Colors.white)),
                color: Colors.deepPurple,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: deleteAllData,
                child: Text('Clear Task', style: TextStyle(color: Colors.white)),
                color: Colors.deepOrangeAccent,
              ),
            ],
          ),
          FutureBuilder<List<DayTaskList>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.map((data) => buildItem(data)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
  
}

