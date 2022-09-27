import 'package:blog_app/core/constant/text_styles.dart';
import 'package:blog_app/core/firebase/firebase_functions.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/singletone.dart';
import 'package:blog_app/ui_components/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogsScreen extends StatefulWidget {
  BlogsScreen({Key? key}) : super(key: key);

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blogs')
            // .where('userId', isEqualTo: Singleton.instance.getUser().id)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          log.info('snapshot $snapshot');
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          } else {
            var data = snapshot.data?.docs;

            log.info('data ${data?.toList()}');

            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => _buildBlogCard(data!, index),
              itemCount: snapshot.data?.docs.length,
            );
          }
        },
      );

  Widget _buildBlogCard(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data, int index) =>
      Card(
        borderOnForeground: true,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data.toList()[index].data()["imageUrl"] != null &&
                          data.toList()[index].data()["imageUrl"] != ""
                      ? Container(
                          height: 130,
                          width: double.infinity,
                          child: Image.network(
                            data.toList()[index].data()["imageUrl"],
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  Text(
                    data.toList()[index].data()["title"],
                    style: TextStyles.getH3(
                        Colors.black, FontWeight.bold, FontStyle.normal),
                  ),
                  SizedBox(height: 2),
                  Text(
                    data.toList()[index].data()["description"],
                    style: TextStyles.getH5(
                        Colors.black, FontWeight.normal, FontStyle.normal),
                  ),
                  Chip(
                    label: Text(
                      data.toList()[index].data()["category"],
                      style: TextStyles.getH4(
                          Colors.black, FontWeight.bold, FontStyle.normal),
                    ),
                  ),
                ],
              ),
              Singleton.instance.getUser().id ==
                      data.toList()[index].data()["userId"]
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () {
                          FirebaseFunctions()
                              .deleteMyBlog(data.toList()[index].id, context);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
}
