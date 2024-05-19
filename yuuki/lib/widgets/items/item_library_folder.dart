import 'package:flutter/material.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/screens/folder_detail_screen.dart';

import '../../models/my_user.dart';
import '../customs/custom_delete_dialog.dart';

class ItemLibraryFolder extends StatelessWidget {
  final MyUser myUser;
  final Folder folder;
  final VoidCallback onRemove;

  const ItemLibraryFolder({
    super.key,
    required this.myUser,
    required this.folder,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => FolderDetailScreen(myUser: myUser, folder: folder,),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Container(
          width: 500,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 28,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      folder.folderName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<int>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 28,
                  ),
                  onSelected: (int result) {
                    switch (result) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => FolderDetailScreen(myUser: myUser, folder: folder,),
                          ),
                        );
                        break;
                      case 1:
                        _showDeleteConfirmationDialog(context, folder.folderName);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('View'),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text('Delete'),
                    ),
                  ],
                  color: Colors.white, // Background color of the popup menu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String folderName){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CustomDeleteDialog(
              title: "Confirm Delete",
              message: "Are you sure you want to delete folder \"$folderName\"?",
              onFunction: () {
                onRemove();
              }
          );
        }
    );
  }

}