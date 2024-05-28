<<<<<<< HEAD
import 'package:flutter/material.dart';

Future<void> proposeNewPage(BuildContext context) async {
  showModalBottomSheet(
    context: context, 
    builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: [
            // Add your content here
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Propose a new time'),
            ),
            Text(
              "Once submitted, BuzzBuddy will share your proposed time with the Requester for their confirmation.",
            )
          ],
        ),
      );
    },
  );
}
=======
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../common/data/data.dart';
// import '../../common/values/values.dart';
// import '../../common/widgets/widgets.dart';
// import 'detail_index.dart';


// Future<void> proposeNewPage(BuildContext context) async {
//   showModalBottomSheet(
//     context: context, 
//     builder: (BuildContext bc) {
//       return SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Gallery"),
//               onTap: () {
//                 imgFromGallery(onImageSelected);
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_camera),
//               title: const Text("Camera"),
//               onTap: () {
//                 imgFromCamera(onImageSelected);
//                 Get.back();
//               },
//             )
//           ],
//         )
//       );
//     }
//   );
// }
>>>>>>> 78fc015db7f261357f60470f135dd6edc384b973
