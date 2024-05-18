import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/results/folder_list_result.dart';
import 'package:yuuki/services/folder_service.dart';
import 'package:yuuki/widgets/items/item_library_folder.dart';

import '../models/my_user.dart';
import '../utils/const.dart';
import '../utils/demension.dart';

class LibraryFolders extends StatefulWidget {
  const LibraryFolders({super.key, required this.myUser});
  final MyUser myUser;

  @override
  State<LibraryFolders> createState() => _LibraryFoldersState();
}

class _LibraryFoldersState extends State<LibraryFolders> {
  late MyUser _myUser;
  final FolderService _folderService = FolderService();
  final TextEditingController _nameController = TextEditingController();
  final _formFolderKey = GlobalKey<FormState>();

  bool _isSubmit = false;
  late Future<FolderListResult> _futureFolders;

  @override
  void initState() {
    super.initState();
    _myUser = widget.myUser;
    _futureFolders = _folderService.getAllFoldersOfUser(_myUser);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formFolderKey,
              child: TextFormField(
                controller: _nameController,
                onChanged: (_) {
                  setState(() {
                    if (_isSubmit) {
                      _formFolderKey.currentState!.validate();
                    }
                  });
                },
                keyboardType: TextInputType.text,
                cursorColor: Colors.blue,
                maxLines: null,
                cursorErrorColor: Colors.red,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: _isSubmit && _nameController.text.isEmpty
                          ? Colors.red
                          : Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  labelText: 'Folder name',
                  hintText: 'Enter a folder name',
                  hintStyle: TextStyle(
                    color: _isSubmit && _nameController.text.isEmpty
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter folder name';
                  }
                  return null;
                },
              ),
            ),
          ),
          Center(
            child: _buildAddButton(),
          ),
          SizedBox(height: Dimensions.height(context, 20)),
          _buildFolders(),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Folder added successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCreate() async {
    setState(() {
      _isSubmit = true;
    });

    if (_formFolderKey.currentState?.validate() ?? false) {
      String folderName = _nameController.text.trim();

      _showLoadingDialog();
      await _folderService.addFolderToUser(widget.myUser, folderName);
      Navigator.pop(context); // Close the loading dialog

      // Update the folder list
      setState(() {
        _isSubmit = false;
        _futureFolders = _folderService.getAllFoldersOfUser(_myUser);
      });

      _nameController.clear();
      _showSuccessDialog();
    }
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _handleCreate,
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        "Add Folder",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }

  Widget _buildFolders() {
    return FutureBuilder<FolderListResult>(
      future: _futureFolders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 24),
                  color: Colors.red,
                ),
              ),
            ),
          );
        } else {
          if (snapshot.data!.success && snapshot.data!.folders!.isNotEmpty) {
            List<Folder> folders = snapshot.data!.folders!;
            return Expanded(
              child: ListView.builder(
                itemCount: folders.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemLibraryFolder(
                      myUser: _myUser,
                    folder: folders[index],
                    onRemove: () {
                        setState(() {
                          _folderService.deleteFolder(widget.myUser, folders[index].id!);
                          _futureFolders = _folderService.getAllFoldersOfUser(_myUser);
                        });
                    },
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'The folder list is empty!',
                  style: TextStyle(
                    fontSize: Dimensions.fontSize(context, 24),
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}



