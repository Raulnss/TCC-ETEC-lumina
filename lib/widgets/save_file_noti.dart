import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage_noti {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath; 
    return File('$path/luminaid_notifi.txt');
  }
  Future<String> readCounter() async {
    try {
      final file = await _localFile; 
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }
  Future<File> writeCounter(String counter) async {
    final file = await _localFile; 
    return file.writeAsString(counter);
  }
}