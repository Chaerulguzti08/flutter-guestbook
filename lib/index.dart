import 'package:flutter/material.dart';
import 'package:guestbook/controller.dart';
import 'package:guestbook/create.dart';

class index extends StatefulWidget {
  const index({Key? key}) : super(key: key);
  @override
  State<index> createState() => _indexState();
}

class _indexState extends State<index> {
  // List<Map<String, dynamic>> _listData = [];
  List _listData = [];

  @override
  void initState() {
    _projectData();
    super.initState();
  }

  Future<void> _projectData() async {
    try {
      final data = await ApiController.projectData();
      setState(() {
        _listData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guest List"),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _listData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_listData[index]['name']),
              subtitle: Text(_listData[index]['email']),
              trailing: Icon(
                _listData[index]['name'] != null
                    ? Icons.hourglass_bottom
                    : _listData[index]['name'] == null
                        ? Icons.check_circle
                        : Icons.close,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => create(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Add functionality for menu list
                // You can use a Drawer or show a list of options
              },
            ),
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                // Add functionality for create
                // This could also open a new screen or show a dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
