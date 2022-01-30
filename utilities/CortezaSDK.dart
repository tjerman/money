import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Transaction.dart';
import '../models/User.dart';
import '../models/ComposeRecord.dart';
import '../utilities/State.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

CortezaSDK csdk = CortezaSDK(dotenv.env['API_DOMAIN']!);

class CortezaSDK {
  String _baseURL;

  CortezaSDK(this._baseURL);

  Future<List<Transaction>> fetchTransactions() async {
    var raw = await http.get(
      composeRecordListURL(
        dotenv.env['COMPOSE_NAMESPACE_ID']!,
        dotenv.env['COMPOSE_MODULE_TRANSACTION_ID']!,
      ),
      headers: baseHeaders(),
    );

    var response = parseResponse(raw);
    List<Transaction> transactions = [];
    for (var r in response['set']) {
      var record = ComposeRecord.fromJson(r);
      var t = Transaction(
        record.values['kind'] ?? '',
        record.values['label'] ?? '',
        double.parse(record.values['amount'] ?? '0'),
      );

      if (record.values['note'] != null) {
        t.note = record.values['note'];
      }
      transactions.add(t);
    }

    return transactions;
  }

  Future<User> fetchUser() async {
    var raw = await http.get(
      userURL(
        state.userID,
      ),
      headers: baseHeaders(),
    );

    var response = parseResponse(raw);

    return User(
      response['email']!, 
      response['username']!, 
      response['handle']!, 
      response['name']!,
    );
  }

  Uri composeRecordListURL(String namespaceID, String moduleID) {
    return Uri.parse("https://$_baseURL/api/compose/namespace/$namespaceID/module/$moduleID/record/");
  }

  Uri userURL(String userID) {
    return Uri.parse("https://$_baseURL/api/system/users/$userID");
  }
}

dynamic parseResponse(http.Response rsp) {
  if (rsp.statusCode == 200) {
    var raw = jsonDecode(rsp.body);
    if (raw['error'] != null) {
      throw new Exception(raw['error']);
    }
    return raw['response'];
  } else {
    throw Exception('failed to fetch');
  }
}

Map<String, String> baseHeaders() {
  return {
    'Content-Type': 'application/json',
    'Accept': ' application/json',
    'Authorization': 'Bearer ${state.accessToken}',
  };
}
