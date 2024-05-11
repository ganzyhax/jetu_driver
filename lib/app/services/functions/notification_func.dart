import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationHelper {
  Future<void> sendPushNotification(
      String token, String title, String body) async {
    const String serverKey =
        'AAAAIOvJNSk:APA91bEvKFJXZ6YGP1nKcsMVMgTT4qIgOFSGepBHli4FMiQOVEumHHhy9fQvhvNZ8E2cDOKIvCDwiJC25SEJKwz9yEW-Y2SlnS4T2KLcNYJfjaPyRxPELZHCcyWSqkqlAGJowr2oof_W';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final payload = jsonEncode({
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
    });

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: payload,
    );

    if (response.statusCode == 200) {
      // Handle successful request

      print('Notification sent successfully to ' + token.toString());
    } else {
      // Handle error
      print('Failed to send notification to ' + token.toString());
    }
  }
}
