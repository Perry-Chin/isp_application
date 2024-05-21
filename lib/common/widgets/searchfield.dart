// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../values/values.dart';

class MySearchField extends StatefulWidget {
  final String hinttext; // Hint text for textfield
  final String labeltext; // Label text for textfield
  final IconData prefixicon; // Prefix icon for textfield
  final List<String> suggestions;
  final FocusNode focusNode;
  final TextEditingController controller; // Controller for textfield

  // Constructor
  const MySearchField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixicon,
    required this.suggestions,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MySearchField> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        color: Colors.white,
        child: SearchField(
          controller: widget.controller, // Set controller for textfield
          suggestions: widget.suggestions
          .map((suggestion) => SearchFieldListItem(suggestion)) // Provide 'suggestion' as argument
          .toList(),
          focusNode: widget.focusNode,
          suggestionState: Suggestion.expand,
          maxSuggestionsInViewPort: 6,
          itemHeight: 36,
          suggestionStyle: const TextStyle(fontSize: 17, color: Colors.black),
          suggestionsDecoration: SuggestionDecoration(
            elevation: 8.0,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            selectionColor: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )
          ),
          searchInputDecoration: InputDecoration(
            labelText: widget.labeltext, // Set label text
            hintText: widget.hinttext, // Set hint text
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
            prefixIcon: Icon(
              widget.prefixicon, 
              color: Colors.black, 
              size: 20, 
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.secondaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color:  AppColor.secondaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            )
          )
        ),
      )
    );
  }
}