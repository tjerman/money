
class ComposeRecord {
  String recordID = '0';
  String moduleID = '0';
  String namespaceID = '0';

  Map<String,String> values = {};

  ComposeRecord(
    this.recordID,
    this.moduleID,
    this.namespaceID,
    this.values,
  );

  factory ComposeRecord.fromJson(Map<String,dynamic> json) {
    Map<String,String> values = {};
    for (var v in json['values']) {
      values[v['name']] = v['value'];
    }

    return ComposeRecord(json["recordID"], json["moduleID"], json["namespaceID"], values);
  }
}
