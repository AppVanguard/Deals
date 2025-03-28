// A single item that visually replicates the shape of NotificationTile
// but uses grey placeholders that Skeletonizer can shimmer over.

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildNotificationSkeletonItem() {
  return Skeletonizer(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Circle placeholder for the avatar
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Middle column of 2 lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right side placeholder (time text line)
          Container(
            width: 40,
            height: 10,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
