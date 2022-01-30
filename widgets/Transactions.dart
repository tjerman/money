import 'package:flutter/material.dart';
import '../models/Transaction.dart';

class Transactions extends StatelessWidget {
  final List<Transaction> _transactions;
  Transactions(this._transactions) : super();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        var transaction = _transactions[index];

        IconData ico = Icons.arrow_upward;
        Color? col = Colors.red[400];
        if (transaction.kind == TransactionInbound) {
          ico = Icons.arrow_downward;
          col = Colors.blue[300];
        }

        var cc = [
            Row(
              children: <Widget>[
                Container(
                  width: 6,
                  child: Icon(ico, color: col, size: 15,),
                ),
                Container(
                  width: 70,
                  child: Text(
                    '${transaction.amount.toString()}€',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(transaction.label),
                  ),
                ),
              ],
            ),
          ];

          if (transaction.note != null) {
            cc.add(Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(76, 0, 0, 5),
                      child: Text(transaction.note ?? '', style: TextStyle(fontSize: 10),),
                    ),
                  ),
                ),
              ],
            ));
          }

        return Column(
          children: cc,
        );
      },
    );
  }
}
