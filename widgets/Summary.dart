import 'package:flutter/material.dart';
import '../models/Stats.dart';

class Summary extends StatelessWidget {
  final Stats _summary;

  Summary(this._summary) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(

        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.blue[300],
                  size: 15,
                ),
              ),
              Container(
                width: 70,
                child: Text(
                  '${_summary.byIn}€',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                width: 6,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.red[400],
                  size: 15,
                ),
              ),
              Container(
                width: 70,
                child: Text(
                  '${_summary.byOut}€',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                width: 6,
                child: Icon(
                  Icons.horizontal_rule,
                  color: Colors.green[700],
                  size: 15,
                ),
              ),
              Container(
                width: 70,
                child: Text(
                  '${_summary.total}€',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
