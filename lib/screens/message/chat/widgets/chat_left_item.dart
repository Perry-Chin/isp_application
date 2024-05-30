import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          child: Container(
            margin: EdgeInsets.only(right: 10.w, top: 0.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE1D9D1),
              borderRadius: BorderRadius.all(Radius.circular(10.w))
            ),
            child: item.type == "text" ? Text(item.content ?? ""):
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
        )
      ],
    ),
  );
}