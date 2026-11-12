import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage_temp {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath; 
    return File('$path/luminaid_temp.txt'); 
  }
  Future<String> readCounter_temp() async {
    try {
      final file = await _localFile; 
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }
  Future<File> writeCounter_temp(String counter) async {
    final file = await _localFile; 
    return file.writeAsString(counter);
  }
}