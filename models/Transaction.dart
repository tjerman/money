const TransactionInbound = 'in';
const TransactionOutbound = 'out';

class Transaction {
  String kind;
  String label;
  String? note;
  double amount;

  Transaction(
    this.kind,
    this.label,
    this.amount,
  );
}