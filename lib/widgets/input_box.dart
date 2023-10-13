import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controler;
  final bool isPass;
  final String hintText;
  final TextInputType type;
  final double height;
  final double width;
  final double fontSize;

  const InputBox({
    super.key,
    this.isPass = false,
    required this.controler,
    required this.hintText,
    required this.type,
    required this.height,
    required this.width,
    required this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).copyWith();
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.width;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular((fullWidth+fullHeight) * 0.01),
      borderSide: Divider.createBorderSide(context),
    );
    
    return FractionallySizedBox(
        widthFactor: width,
        heightFactor: height,
            child: TextField(
                textAlign: TextAlign.center,
                controller: controler,
                keyboardType: type,
                obscureText: isPass,
                style: TextStyle(
                  fontSize: fullWidth * fontSize,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: fullWidth * fontSize,
                  ),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  filled: true,
                  contentPadding: EdgeInsets.all(fullHeight * 0.003),
                ),
              ),
          );
  }
}
