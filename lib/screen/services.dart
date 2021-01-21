import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

HttpLink _httpLink = HttpLink(uri: "https://api-dev.farmai.co/graphql");
AuthLink _authLink = AuthLink(
  getToken: () async =>
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1ZTY1YzFiYmEyNmEyOTAw MTI4OTg2NzUiLCJuYW1lIjoiQWRtaW4tQ0lBVCIsInBob25lX251bWJlciI6IjgzMTgzMTMzO CIsImVtYWlsIjoibGlzdGVuZmllbGRAbGlzdGVuZmllbGQuY29tIiwiaWF0IjoxNjA1NTMxO TkwLCJleHAiOjE2MTU4OTk5OTB9.gMKIH8AqhSAmMeLl_65OMLUmCZhIVVBafd9BW 0nXIUM',
);
Link _link = _authLink.concat(_httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: _link,
  ),
);

final String query = r""" query posts{
  posts(page: { limit: 5, offset: 0 }) {
    page_info {
      has_more
      total_count
    }
    edges {
      _id
      community {
        _id
        name
      }
      users_involved {
        _id
        name
        family_name
        profile_picture
      }
      created_at
      updated_at
      deleted
      comments {
        comments {
          _id
          text
          status
          type
          added_by {
            _id
            name
            family_name
            profile_picture
          }
        }
        post {
          _id
          text
          status
          type
          added_by {
            _id
            name
            family_name
            profile_picture
          }
          attachment {
            pictures
            location {
              text
              coords {
                type
                coordinates
              }
            }
          }
        }
      }
      post {
        _id
        text
        status
        type
        added_by {
          _id
          name
          family_name
          profile_picture
        }
        attachment {
          pictures
          location {
            text
            coords {
              type
              coordinates
            }
          }
        }
      }
    }
  }
}

""";
