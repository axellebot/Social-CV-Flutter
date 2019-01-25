import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;

/// From https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69

class SecretService {
  static const secretPath = "secrets.json";

  static Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(
      secretPath,
      (jsonStr) async {
        final secret = Secret.fromJson(json.decode(jsonStr));
        return secret;
      },
    );
  }
}

class Secret {
  Secret({
    this.clientId = "",
    this.clientSecret = "",
  })  : assert(clientId != null),
        assert(clientSecret != null);

  final String clientId;
  final String clientSecret;

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
      clientId: jsonMap["clientId"],
      clientSecret: jsonMap["clientSecret"],
    );
  }
}
