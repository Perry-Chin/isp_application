// // custom_duration_picker.dart
// import 'package:flutter/material.dart';

// class CustomDurationPicker extends StatefulWidget {
//   final Duration initialDuration;
//   final Function(Duration) onDurationSelected;

//   const CustomDurationPicker({
//     Key? key,
//     required this.initialDuration,
//     required this.onDurationSelected,
//   }) : super(key: key);

//   @override
//   _CustomDurationPickerState createState() => _CustomDurationPickerState();
// }

// class _CustomDurationPickerState extends State<CustomDurationPicker> {
//   late Duration selectedDuration;

//   @override
//   void initState() {
//     super.initState();
//     selectedDuration = widget.initialDuration;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Duration'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text('Hours:'),
//               ),
//               Expanded(
//                 child: DropdownButton<int>(
//                   value: selectedDuration.inHours,
//                   items: List.generate(24, (index) => index).map((value) {
//                     return DropdownMenuItem<int>(
//                       value: value,
//                       child: Text(value.toString()),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedDuration = Duration(hours: value ?? 0, minutes: selectedDuration.inMinutes % 60);
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Text('Minutes:'),
//               ),
//               Expanded(
//                 child: DropdownButton<int>(
//                   value: selectedDuration.inMinutes % 60,
//                   items: List.generate(60, (index) => index).map((value) {
//                     return DropdownMenuItem<int>(
//                       value: value,
//                       child: Text(value.toString()),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedDuration = Duration(hours: selectedDuration.inHours, minutes: value ?? 0);
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             widget.onDurationSelected(selectedDuration);
//             Navigator.of(context).pop();
//           },
//           child: Text('Select'),
//         ),
//       ],
//     );
//   }
// }
