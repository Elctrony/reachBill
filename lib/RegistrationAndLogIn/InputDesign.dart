import 'package:flutter/material.dart';
import 'package:auto_direction/auto_direction.dart';

class fieldInput extends StatelessWidget {

  final TextEditingController controller;
  final bool obscure;
  final String hint;
  final Icon myIcon;
  TextInputType textInputType = TextInputType.text;
  Function iconOnPressed = (){};
  bool enable;

  fieldInput({this.controller,this.obscure,this.hint,this.myIcon,
    this.iconOnPressed,this.textInputType,this.enable=true});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoDirection(
            text: controller.text,
            child: TextFormField(
              enabled: enable,
              obscureText: obscure,
              //textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              controller: controller,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                      icon: myIcon,
                      onPressed: iconOnPressed
                  ),
                  border: InputBorder.none,
                  //filled: true,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  fillColor:Colors.white,alignLabelWithHint: true
              ),
              textCapitalization: TextCapitalization.words,
              maxLines: 1,
              keyboardType: textInputType,
              style: TextStyle(fontSize: 15,
                  color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
