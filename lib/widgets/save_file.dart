import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/luminaid.txt');
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

  // Novo método público para excluir o arquivo de ID
  Future<void> deleteCounter() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}