import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/data/data.dart';
import '../../../../common/values/values.dart';

Widget chatRightItem(Msgcontent item) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 230.w,
            minHeight: 35.w
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColor.accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: item.type == "text" ? Text(
                  item.content ?? "", 
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white
                    ),
                  ):
                  ConstrainedBox(constraints: BoxConstraints(
                    maxWidth: 90.w
                  ),
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: CachedNetworkImage (
                      imageUrl: "${item.content}"
                    )
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('hh:mm a').format((item.addtime as Timestamp).toDate()),
                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}