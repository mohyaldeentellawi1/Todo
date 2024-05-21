import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.isDarkMode
              ? Colors.white54
              : const Color.fromRGBO(48, 25, 52, 1),
        ),
        width: 100,
        height: 45,
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? const Color.fromRGBO(48, 25, 52, 1)
                  : Colors.white54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
