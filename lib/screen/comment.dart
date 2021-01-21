import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Comment extends StatefulWidget {
  final int index;
  final Map<String, dynamic> post;

  Comment(this.index, this.post);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  List<Asset> images = List<Asset>();
  Widget profile;
  String name;
  String type;
  String text;
  String error = 'No Error Dectected';

  Widget gridView() {
    if (images != null)
      return Expanded(
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        ),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadImage() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index < 2) {
      name = widget.post["post"]["added_by"]["name"];
      profile = SvgPicture.network(
        widget.post["post"]["added_by"]["profile_picture"],
      );
    } else {
      name = widget.post["post"]["added_by"]["family_name"];
      profile = CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          widget.post["post"]["added_by"]["profile_picture"],
        ),
      );
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: ListTile(
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              leading: profile,
              title: Text(name, style: TextStyle(fontSize: 18.0)),
              subtitle:
                  Text(widget.post["post"]["type"].toString().toLowerCase()),
            ),
            titleSpacing: 0.0,
            actions: [],
          )),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post["post"]["text"],
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Divider(thickness: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.0,
                        child: FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_up),
                          label: Text("Like"),
                        ),
                      ),
                      Container(
                        width: 150.0,
                        child: FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.comment),
                          label: Text("Comment"),
                        ),
                      )
                    ],
                  ),
                  Divider(thickness: 1.0),
                  gridView(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50.0,
                      width: 300.0,
                      margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0.0),
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                loadImage();
                              }),
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 13.0),
                                border: InputBorder.none,
                                hintText: 'Write a comment...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                      iconSize: 30.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
