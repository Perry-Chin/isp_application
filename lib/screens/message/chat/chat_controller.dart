// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/data/data.dart';
import '../../../common/storage/storage.dart';
import 'chat_index.dart';

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();
  var doc_id;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  File? _photo;

  final ImagePicker _picker = ImagePicker();
  final user = Rxn<UserData>();

  // Future<void> imgFromGallery() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     _photo = File(pickedFile.path);
  //     uploadFile();
  //   } else {
  //     print("No image selected");
  //   }
  // }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str;
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
      uid: user_id,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );
    await db.collection("message").doc(doc_id).collection("msglist")
      .withConverter(
        fromFirestore: Msgcontent.fromFirestore, 
        toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore()
      ).add(content).then((DocumentReference doc) {
        print("Document snapshot added with id, ${doc.id}");
        textController.clear();
        Get.focusScope?.unfocus();
      });
    await db.collection("message").doc(doc_id).update({
      "last_msg": " [image] ",
      "last_time": Timestamp.now(),
      "msg_num": 1
    });
  }

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = getRandomString(15) + extension(_photo!.path);
  //   try {
  //     final ref = FirebaseStorage.instance.ref("chat").child(fileName);
  //     await ref.putFile(_photo!).snapshotEvents.listen((event) async {
  //       switch (event.state) {
  //         case TaskState.running:
  //           break;
  //         case TaskState.paused:
  //           break;
  //         case TaskState.success:
  //           String imgUrl = await getImgUrl(fileName);
  //           print(imgUrl + "this is");
  //           sendImageMessage(imgUrl);
  //           break;
  //         case TaskState.canceled:
  //           break;
  //         case TaskState.error:
  //           break;
  //       }
  //     });
  //   } catch (e) {
  //     print("There's an error $e");
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];
    state.toUserid.value = data['to_uid'] ?? "";
    state.toName.value = data['to_name'] ?? "";
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );
    await db.collection("message").doc(doc_id).collection("msglist")
      .withConverter(
        fromFirestore: Msgcontent.fromFirestore, 
        toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore()
      ).add(content).then((DocumentReference doc) {
        print("Document snapshot added with id, ${doc.id}");
        textController.clear();
        Get.focusScope?.unfocus();
      });
    await db.collection("message").doc(doc_id).update({
      "last_msg": sendContent,
      "last_time": Timestamp.now(),
      "msg_num": 1
    });
  }

  @override
  void onReady() {
    super.onReady();
    var messages = db.collection("message").doc(doc_id).collection("msglist")
      .withConverter(
        fromFirestore: Msgcontent.fromFirestore, 
        toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore()
      ).orderBy("addtime", descending: false);
    state.msgcontentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.msgcontentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    },
    onError: (error) => print("Listen failed:  $error"));
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}