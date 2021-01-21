import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:feedApp/screen/post.dart';
import 'package:feedApp/screen/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Post(),
      ),
      client: client,
    );
  }
}
