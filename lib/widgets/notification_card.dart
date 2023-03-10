import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/post_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:intl/intl.dart';

import '../screens/profile_screen.dart';

enum NotificationTypes {
  follow,
  likePost,
  likeComment,
}

class NotificationCard extends StatelessWidget {
  NotificationCard({
    super.key,
    required this.snap,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  late final NotificationTypes notificationType;
  void setNotificationType() {
    switch (snap['notificationType']) {
      case 'follow':
        notificationType = NotificationTypes.follow;
        break;
      case 'likePost':
        notificationType = NotificationTypes.likePost;
        break;
      case 'likeComment':
        notificationType = NotificationTypes.likeComment;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    setNotificationType();
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                snap['profImage'],
              ),
              radius: 22,
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  uid: snap['uid'],
                ),
              ),
            ),
            child: Text(
              snap['username'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          if (notificationType == NotificationTypes.follow)
            const Text(" started following you."),
          if (notificationType == NotificationTypes.likePost)
            Row(
              children: [
                const Text(" liked your post."),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostScreen(
                          postId: snap['postId'],
                        ),
                      ),
                    ),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              snap['postUrl'],
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (notificationType == NotificationTypes.likeComment)
            const Text(" liked your comment."),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
