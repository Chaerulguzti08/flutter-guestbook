import 'package:flutter/material.dart';
import 'package:guestbook/controller.dart';
import 'package:guestbook/create.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  List _listData = [];
  List _listDataGuest = [];
  var selectedEventId;

  @override
  void initState() {
    _eventData();
    super.initState();
  }

  Future<void> _eventData() async {
    try {
      final data = await ApiController.eventGet();
      setState(() {
        _listData = data;
        // Fetch guest details for the initial event
        if (_listData.isNotEmpty) {
          selectedEventId = _listData.first['id'];
          _guestDetail();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _guestDetail() async {
    try {
      if (selectedEventId != null) {
        final data1 = await ApiController.guestDetail(selectedEventId! as int);
        setState(() {
          _listDataGuest = data1;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset(
                  'assets/logob.png',
                  width: 300,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Guest Book',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonFormField<int>(
                  hint: Text('Select Event'),
                  value: selectedEventId,
                  items: _listData.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item['name'].toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      selectedEventId = newVal ?? -1;
                      _guestDetail();
                    });
                  },
                ),
              ),
            ),
          ),

          // List of Guests
          Expanded(
            child: ListView.builder(
              itemCount: _listDataGuest.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_listDataGuest[index]['name']),
                    subtitle: Text(_listDataGuest[index]['email']),
                    trailing: Icon(
                      _listDataGuest[index]['name'] != null
                          ? Icons.person
                          : _listDataGuest[index]['name'] == null
                              ? Icons.check_circle
                              : Icons.close,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   ),
      // ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: home(),
  ));
}
