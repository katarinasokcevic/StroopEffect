import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';

void filterDataAndSave() {
  String jsonData = File('../backup.json').readAsStringSync();
  Map<String, dynamic> json = jsonDecode(jsonData);
  Map<String, dynamic> filteredData = {};
  Set<String> processedUserIds = {};

  json['__collections__']['results'].forEach((key, value) {
    String userId = value['userId'];

    if (!processedUserIds.contains(userId)) {
      processedUserIds.add(userId);
      filteredData[key] = value;
    }
  });

  String filteredJson = jsonEncode(filteredData);
  File('filtered_data.json').writeAsStringSync(filteredJson);
}

void main() {
  filterDataAndSave();
}