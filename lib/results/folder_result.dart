import 'package:yuuki/models/folder.dart';

class FolderResult {
  final bool success;
  final Folder? folder;
  final String? errorMessage;

  FolderResult({required this.success, this.folder, this.errorMessage,});
}