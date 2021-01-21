import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:feedApp/screen/comment.dart';
import 'package:feedApp/screen/services.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Widget profile;
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Feed")),
      body: Query(
        options: QueryOptions(documentNode: gql(query)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          List post = result.data["posts"]["edges"];

          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: post.length,
                itemBuilder: (context, index) {
                  if (index < 2) {
                    name = post[index]["post"]["added_by"]["name"];
                    profile = SvgPicture.network(
                      post[index]["post"]["added_by"]["profile_picture"],
                    );
                  } else {
                    name = post[index]["post"]["added_by"]["family_name"];
                    profile = CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        post[index]["post"]["added_by"]["profile_picture"],
                      ),
                    );
                  }

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            leading: profile,
                            title: Text(
                              name,
                              style: TextStyle(fontSize: 18.0),
                            ),
                            subtitle: Text(post[index]["post"]["type"]
                                .toString()
                                .toLowerCase()),
                          ),
                          Container(
                            width: double.maxFinite,
                            child: Text(
                              post[index]["post"]["text"],
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Divider(thickness: 1.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_up),
                                label: Text("Like"),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Comment(index, post[index])));
                                },
                                icon: Icon(Icons.comment),
                                label: Text("Comment"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
