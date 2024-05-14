import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';

class CustomItemProfile extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool more;
  final VoidCallback? onTap; // Thêm thuộc tính onTap kiểu VoidCallback

  const CustomItemProfile({
    required this.icon,
    required this.text,
    required this.more,
    this.onTap, // Thêm onTap vào danh sách các tham số của constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Thêm GestureDetector để bắt sự kiện nhấn
      onTap: onTap, // Sử dụng onTap được chuyền vào từ constructor
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "Quicksand",
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(more ? Icons.chevron_right_outlined : null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
