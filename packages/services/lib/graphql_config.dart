import 'package:graphql_flutter/graphql_flutter.dart';

//For graphql config
class GraphQLConfig {
  static HttpLink httpLink = HttpLink(
    "https://ruby-uninterested-cormorant.cyclic.app/",
  );

  GraphQLClient clientToQuery() => GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );
}