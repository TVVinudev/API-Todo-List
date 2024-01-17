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

class todoList extends StatefulWidget {
  const todoList({super.key});

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {
  Future Fetch() async {
    final response = await http.get(Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=10"));
    if (response.statusCode == 200) {
      print("successful");
      final data = jsonDecode(response.body);
      List datalist = data['items'];
      setState(() {
        fetchdata = datalist;
      });
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
      body: RefreshIndicator(
        onRefresh: Fetch,
        child: ListView.builder(
            itemCount: fetchdata.length,
            itemBuilder: (context, index) {
              final item = fetchdata[index];
              return ListTile(
                title: Text(item['title']),
                subtitle: Text(item['description']),
              );
            }),
      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (_controller.text.isNotEmpty) {
                                    data.add(_controller.text);
                                    _controller.clear();
                                  }
                                });
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
