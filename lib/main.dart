import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);

  await Hive.openBox<String>("Friends");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<String> friendsBox;
  int _counter = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<String>("Friends");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: friendsBox.listenable(),
              builder: (context, Box<String> friends, _) {
                return ListView.separated(
                  itemBuilder: (context, index) {

                    final key = friends.keys.toList()[index];
                    final _value = friends.get(key);

                    return ListTile(
                      title: Text("$key"),
                      subtitle: Text(_value),
                    );
                  }, 
                  separatorBuilder: (_, index) => Divider(
                    thickness: 1.0,
                    color: Color.fromARGB(255, 7, 185, 255),
                  ), 
                  itemCount: friends.keys.toList().length
                );
              },
            )
          ),

          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                
                FlatButton(
                  child: Text('Add New'),
                  color: Color.fromARGB(255, 61, 164, 242),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Add New'),
                          content: Container(
                            height: 200,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                  controller: _nameController,
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Contents',
                                  ),
                                  controller: _contentsController,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Submit'),
                              onPressed: (){
                                friendsBox.put(_nameController.text, _contentsController.text);
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                    );
                  }, 
                ),

                FlatButton(
                  child: Text('Update'),
                  color: Color.fromARGB(255, 61, 164, 242),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Update Existing'),
                          content: Container(
                            height: 200,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                  controller: _nameController,
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Contents',
                                  ),
                                  controller: _contentsController,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Submit'),
                              onPressed: (){
                                friendsBox.keys.toList().contains(_nameController.text) ? friendsBox.put(_nameController.text, _contentsController.text) : Fluttertoast.showToast(
                                  msg: "Such name does not exist",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.black
                                );
                                // friendsBox.put(_nameController.text, _contentsController.text);
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                    );
                  }, 
                ),

                FlatButton(
                  child: Text('Delete'),
                  color: Color.fromARGB(255, 61, 164, 242),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Delete Existing'),
                          content: Container(
                            height: 200,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                  controller: _nameController,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Submit'),
                              onPressed: (){
                                friendsBox.keys.contains(_nameController.text) ? friendsBox.delete(_nameController.text) : Fluttertoast.showToast(
                                    msg: "No such name exists in the Data Base",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                // friendsBox.delete(_nameController.text);
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                    );
                  }, 
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
