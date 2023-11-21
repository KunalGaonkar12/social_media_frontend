import 'dart:io';

//To check internet connection
class ConnectionManager {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('Not Connected');
      return false;
    }
    return false;
  }
}
