import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  
  // Handle test directory
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('\\test')) {
    dir = dir.replaceAll('\\test', '');
  }
  
  // Construct the full path
  final path = '$dir/test/$name';
  
  // Check if file exists
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('File not found: $path');
  }
  
  return file.readAsStringSync();
}
