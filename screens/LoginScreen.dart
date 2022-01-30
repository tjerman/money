import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/Loader.dart';

import '../utilities/State.dart';

final FlutterAppAuth _appAuth = FlutterAppAuth();
TextEditingController _accessTokenTextController = TextEditingController();
TextEditingController _refreshTokenTextController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loader('logging in...'),
    );
  }

  void auth() async {
    var result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            dotenv.env['AUTH_CLIENT_ID'], dotenv.env['AUTH_REDIRECT_URL'],
            serviceConfiguration: AuthorizationServiceConfiguration(
                'https://${dotenv.env['API_DOMAIN']}/auth/oauth2/authorize',
                'https://${dotenv.env['API_DOMAIN']}/auth/oauth2/token'),
            scopes: ['profile', 'api'],
            clientSecret: dotenv.env['AUTH_CLIENT_SECRET'],
            promptValues: ['login']));

    state.accessToken = _accessTokenTextController.text = result.accessToken;
    state.refreshToken = _refreshTokenTextController.text = result.refreshToken;
    state.userID = jsonDecode(
        utf8.fuse(base64).decode(state.accessToken.split(".")[1]))["sub"]!;

    Navigator.pushReplacementNamed(context, '/tldr');
  }

  void initState() {
    super.initState();
    auth();
  }
}
