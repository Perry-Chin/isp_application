// <<<<<<< HEAD
// // import 'package:cloud_firestore/cloud_firestore.dart';
// =======
// >>>>>>> 2b019c5a98dd10bc8e2eaa44e13f3a6ea5b5c0ec
// import 'package:flutter/material.dart';

// // import '../../common/data/service.dart';
// // import '../../common/data/user.dart';

// Future<void> proposeNewPage(BuildContext context) async {
//   showModalBottomSheet(
//     context: context, 
//     builder: (BuildContext bc) {
//       return const SafeArea(
//         child: Wrap(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Propose Time",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//                     ),
//                   ),
//                   const Text(
//                     "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Original Date & Time",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.all(16.0), // Set padding for the container
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0), // Set border radius
//                       color: Colors.grey[200], // Set background color
//                     ),
//                     child: const Text(
//                       'Your original date and time here',
//                       style: TextStyle(
//                         fontSize: 16.0, // Set font size
//                         color: Colors.black, // Set text color
//                       ),
//                     ),
//                   ),
//                  Text(
//                   "Propose Time",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                   ),
//                  ),
//                  Container(
//                    padding: const EdgeInsets.all(16.0), // Set padding for the container
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0), // Set border radius
//                       color: Colors.grey[200], // Set background color
//                     ),
//                     child: const Text(
//                       'Start',
//                       style: TextStyle(
//                         fontSize: 16.0, // Set font size
//                         color: Colors.black, // Set text color
//                       ),
//                     ),
//                  )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
