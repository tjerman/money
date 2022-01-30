import 'package:flutter/material.dart';
import '../models/User.dart';

class Profile extends StatelessWidget {
  final User _user;
  final String _picture;

  Profile(this._user, this._picture): super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4.0),
            shape: BoxShape.circle,
            image: DecorationImage(
              scale: 1.5,
              image: NetworkImage(_picture),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Text('Hello, ${_user.name}', style: TextStyle(fontSize: 20)),
        Text(_user.email, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
