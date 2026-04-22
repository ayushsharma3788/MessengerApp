import 'dart:developer';
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';
      const serviceAccountJson = String.fromEnvironment(
        'FIREBASE_SERVICE_ACCOUNT_JSON',
      );

      if (serviceAccountJson.isEmpty) {
        throw Exception(
          'Missing FIREBASE_SERVICE_ACCOUNT_JSON dart-define value.',
        );
      }

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
          jsonDecode(serviceAccountJson) as Map<String, dynamic>,
        ),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
