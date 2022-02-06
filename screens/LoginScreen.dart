import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/Loader.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../utilities/State.dart';
import '../utilities/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription<String> _wwURLChange;
  late FlutterWebviewPlugin _ww;
  late String _stateKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loader('logging in...'),
    );
  }

  void auth() async {
    _wwURLChange = _ww.onUrlChanged.listen(exchangeTokens);
    initFlow();
  }

  void initFlow() {
    _ww.launch(
      'https://${dotenv.env['API_DOMAIN']}/auth/oauth2/authorize' +
          '?response_type=code' +
          '&client_id=${dotenv.env['AUTH_CLIENT_ID']}' +
          '&state=$_stateKey' +
          '&scope=profile+api' +
          '&redirect_uri=${dotenv.env['AUTH_REDIRECT_URL']}',
      ignoreSSLErrors: true,
    );
  }

  void exchangeTokens(String url) async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    if (url.indexOf("oauthredirect") <= -1) {
      return;
    }

    flutterWebviewPlugin.close();

    // Get the required params from the url
    var parsed = parseRedirect(url);

    if (parsed.state != _stateKey) {
      throw new Exception("request and response states don't match");
    }

    // Exchange OAuth2 bits
    var rsp =
        await http.post('https://${dotenv.env['API_DOMAIN']}/auth/oauth2/token',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': ' application/json',
              // This indicates what auth client Corteza should use
              'Authorization': 'Basic ' +
                  base64Encode(utf8.encode(
                      '${dotenv.env['AUTH_CLIENT_ID']}:${dotenv.env['AUTH_CLIENT_SECRET']}')),
            },
            encoding: Encoding.getByName('utf-8'),
            body: {
              "code": parsed.code,
              "grant_type": "authorization_code",
              "redirect_uri": dotenv.env['AUTH_REDIRECT_URL'],
            });

    // Don't do this in production; have errors make more sense
    if (rsp.statusCode >= 400) {
      throw new Exception("something went wrong");
    }

    var c = Creds.fromJson(jsonDecode(rsp.body));
    state.accessToken = c.accessToken;
    state.refreshToken = c.refreshToken;
    state.userID = c.userID;

    dispose();
    Navigator.pushReplacementNamed(context, '/tldr');
  }

  void dispose() {
    _wwURLChange.cancel();
    FlutterWebviewPlugin().dispose();
    super.dispose();
  }

  RDRUrl parseRedirect(String url) {
    String code = "";
    String state = "";

    var r = RegExp(r'error=([\w]+)');
    if (r.hasMatch(url)) {
      var m = r.firstMatch(url);
      throw new Exception(m!.group(1));
    }

    r = RegExp(r'code=([\w]+)');
    if (!r.hasMatch(url)) {
      throw new Exception("missing expected code parameter");
    }
    var m = r.firstMatch(url);
    code = m!.group(1)!;

    r = RegExp(r'state=([\w]+)');
    if (!r.hasMatch(url)) {
      throw new Exception("missing expected state parameter");
    }
    m = r.firstMatch(url);
    state = m!.group(1)!;

    return RDRUrl(code, state);
  }

  void initState() {
    super.initState();
    _ww = FlutterWebviewPlugin();
    // 34 is what Corteza uses so might as well
    _stateKey = getRandomString(34);
    auth();
  }
}

class Creds {
  String accessToken = "";
  String email = "";
  int expiresIn = 0;
  String handle = "";
  String name = "";
  String refreshToken = "";
  int refreshTokenExpiresIn = 0;
  String roles = "";
  String scope = "";
  String userID = "";
  String tokenType = "";

  Creds();

  factory Creds.fromJson(Map<String, dynamic> json) {
    var out = Creds();

    if (json.containsKey('access_token')) {
      out.accessToken = json['access_token'];
    }
    if (json.containsKey('email')) {
      out.email = json['email'];
    }
    if (json.containsKey('expires_in')) {
      out.expiresIn = json['expires_in'];
    }
    if (json.containsKey('handle')) {
      out.handle = json['handle'];
    }
    if (json.containsKey('name')) {
      out.name = json['name'];
    }
    if (json.containsKey('refresh_token')) {
      out.refreshToken = json['refresh_token'];
    }
    if (json.containsKey('refresh_token_expires_in')) {
      out.refreshTokenExpiresIn = json['refresh_token_expires_in'];
    }
    if (json.containsKey('roles')) {
      out.roles = json['roles'];
    }
    if (json.containsKey('scope')) {
      out.scope = json['scope'];
    }
    if (json.containsKey('sub')) {
      out.userID = json['sub'];
    }
    if (json.containsKey('token_type')) {
      out.tokenType = json['token_type'];
    }

    if (out.accessToken == "") {
      throw new Exception('accessToken not provided');
    }
    if (out.refreshToken == "") {
      throw new Exception('refreshToken not provided');
    }
    if (out.userID == "" || out.userID == "0") {
      throw new Exception('userID not provided');
    }

    return out;
  }
}

class RDRUrl {
  String code;
  String state;

  RDRUrl(this.code, this.state);
}
