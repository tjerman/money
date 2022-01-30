import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final String _label;

  Loader([this._label = 'loading']) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitPulse(
            color: Colors.blue[600],
            size: 50.0,
          ),
          SizedBox(height: 10.0),
          Text(
            _label,
            style: TextStyle(fontSize: 10),
          )
        ]);
  }
}
