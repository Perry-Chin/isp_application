import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/data/data.dart';

Widget chatLeftItem(Msgcontent item) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 230.w,
            minHeight: 35.w
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w, top: 0.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1D9D1),
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: item.type == "text" ? Text(
                  item.content ?? "", 
                    style: GoogleFonts.poppins(
                      fontSize: 14
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
                padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
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