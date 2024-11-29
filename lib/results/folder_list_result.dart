import '../models/folder.dart';

class FolderListResult {
  final bool success;
  final List<Folder>? folders;
  final String? errorMessage;

  FolderListResult({required this.success, this.folders, this.errorMessage,});
}