import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: todoList(),
    debugShowCheckedModeBanner: false,
  ));
}

List data = [];
List fetchdata = [];

final _controller = TextEditingController();
final _controller1 = TextEditingController();

class todoList extends StatefulWidget {
  const todoList({super.key});

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {
  //get function in API
  Future Fetch() async {
    try {
      final response = await http.get(Uri.parse("https://api.nstack.in/v1/todos"));
      if (response.statusCode == 200) {
        //print("successful");
        final data = jsonDecode(response.body);
        List datalist = data['items'];
        setState(() {
          fetchdata = datalist;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //POST Function in API

  Future Post() async {
    final uri = Uri.parse('https://api.nstack.in/v1/todos');
    final body = {"title": _controller.text, "description": _controller1.text, "is_completed": false};
    try {
      final response = await http.post(uri, body: json.encode(body), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        print('successfull ');
        Fetch();
      }
    } catch (e) {
      print(e);
    }
  }

  Future Delete(String id) async{
    try{
      final response = await http.delete(Uri.parse('https://api.nstack.in/v1/todos/$id'));
      if(response.statusCode == 200){
        print('deleted');
      }
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    Fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
          itemCount: fetchdata.length,
          itemBuilder: (context, index) {
            final item = fetchdata[index];
            return ListTile(
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: IconButton(onPressed: (){
                Delete(item['_id']);
                Fetch();
              }, icon: Icon(Icons.delete)),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: [
                      Container(
                        child: TextField(
                          controller: _controller,
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: _controller1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Post();
                                Navigator.pop(context);
                              },
                              child: Text('Add'))
                        ],
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
