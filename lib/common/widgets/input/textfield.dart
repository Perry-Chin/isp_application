import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextField extends GetView {
  final String hinttext;
  final String labeltext;
  final IconData prefixicon;
  final TextEditingController textController;
  final bool? obscuretext;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  MyTextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixicon,
    required this.textController,
    this.obscuretext,
    this.readOnly,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onTap,
    this.validator,
  }) : super(key: key);

  final RxBool isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: obscuretext != null ? 
        Obx(
          () => TextFormField(
            controller: textController,
            obscureText: isPasswordVisible.value,
            readOnly: readOnly ?? false,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: keyboardType,
            onTap: onTap,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(prefixicon),
              labelText: labeltext,
              hintText: hinttext,
              suffixIcon: obscuretext != null
                ? IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility
                    ),
                  )
                : null
            ),
          )
        )
      :
      TextFormField(
        controller: textController,
        readOnly: readOnly ?? false,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixicon),
          labelText: labeltext,
          hintText: hinttext
        ),
      )
    );
  }
}
