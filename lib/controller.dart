import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  static Future<List> projectData() async {
    final response =
        await http.get(Uri.parse("https://prupa.id/dem/guestbook/api/guest/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List> eventGet() async {
    final response =
        await http.get(Uri.parse("https://prupa.id/dem/guestbook/api/event/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<int> guestPost(int event_id, String name, String email,
      String phone_number, String froms) async {
    final response = await http.post(
      Uri.parse("https://prupa.id/dem/guestbook/api/guest/create/"),
      body: jsonEncode({
        'event_id': event_id,
        'name': name,
        'email': email,
        'phone_number': phone_number,
        'froms': froms,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return event_id;
    } else {
      print('Gagal mengirim data 2: ${response.statusCode}');
      throw Exception('Failed to send data');
    }
  }

  static Future<List> guestDetail(int id) async {
    final response = await http.get(Uri.parse(
        "https://prupa.id/dem/guestbook/api/guest/detail/event/$id/"));
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'] as List<dynamic>;
      return responseData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
