import 'package:flutter/material.dart';
import '../widgets/Profile.dart';
import '../widgets/Transactions.dart';
import '../widgets/Loader.dart';
import '../models/Transaction.dart';
import '../models/User.dart';
import '../utilities/CortezaSDK.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TLDRScreen extends StatefulWidget {
  const TLDRScreen({Key? key}) : super(key: key);

  @override
  _TLDRScreenState createState() => _TLDRScreenState();
}

class _TLDRScreenState extends State<TLDRScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(dotenv.env["APP_NAME"]!),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
              child: Column(
                children: <Widget>[
                  FutureBuilder<User>(
                    future: csdk.fetchUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Profile(snapshot.data!, dotenv.env['DEFAULT_PROFILE_PICTURE']!);
                      }

                      return Loader();
                    }
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 35, 25, 5),
                    child: FutureBuilder<List<Transaction>>(
                      future: csdk.fetchTransactions(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Transactions(snapshot.data ?? []);
                        }

                        if (snapshot.error != null) {
                          return Text(snapshot.error.toString());
                        }

                        return Loader();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
