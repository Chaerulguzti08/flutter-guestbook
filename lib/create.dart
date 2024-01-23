import 'package:flutter/material.dart';
import 'package:guestbook/controller.dart';
import 'package:guestbook/home.dart';

class create extends StatefulWidget {
  const create({Key? key}) : super(key: key);
  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController event_id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController froms = TextEditingController();

  List _listData = [];

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
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _sendData(int event_id) async {
    try {
      await ApiController.guestPost(
          event_id, name.text, email.text, phoneNumber.text, froms.text);
    } catch (e) {
      print(e);
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thank You'),
          content: Text('Input Data Success.'),
          actions: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => home(),
                    ),
                  );
                },
                child: Text('Back'),
              ),
            )
          ],
        );
      },
    );
  }

  var selectedEventId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Guest'),
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              margin: EdgeInsets.all(16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: const Color.fromARGB(255, 91, 55, 55), width: 1.0),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                "Data Guest",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 14, 14, 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          DropdownButtonFormField(
                            hint: Text('Select Event'),
                            items: _listData.map((item) {
                              return DropdownMenuItem(
                                value: item['id'],
                                child: Text(item['name'].toString()),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selectedEventId =
                                    newVal; // Simpan nilai dropdown ke variabel
                              });
                            },
                            value:
                                selectedEventId, // Gunakan variabel ini sebagai value
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: phoneNumber,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0), // Beri jarak vertikal
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address.';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.0), // Beri jarak vertikal
                          TextFormField(
                            controller: froms,
                            decoration: InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'From is Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _sendData(selectedEventId);
                            }
                          },
                          child: Icon(Icons.send),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
