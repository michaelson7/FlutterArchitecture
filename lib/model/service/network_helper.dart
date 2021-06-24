import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final Uri uriPath;
  final requestBody;
  NetworkHelper({required this.uriPath, this.requestBody});

  Future getResponse() async {
    try {
      http.Response response = await http.get(uriPath);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedJson = jsonDecode(responseBody);
        return decodedJson;
      } else {
        throw Exception('Network Error [statuscode]: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error [failure]:  $e');
    }
  }

  Future postResponse() async {
    try {
      http.Response response = await http.post(uriPath, body: requestBody);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        // print('error daddy: $responseBody');
        final decodedJson = jsonDecode(responseBody);
        return decodedJson;
      } else {
        throw Exception('Error while getting response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while getting response: $e');
    }
  }
}
