import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(
      MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');
    final client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      child: HomeView(),
      client: client,
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String readRepositories = r"""
  query GetContinent($code: ID!){
    continent(code:$code){
      name
      countries{
        name
      }
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Query(
          options: QueryOptions(
            document: gql(readRepositories),
            variables: <String, dynamic>{
              "code": "AS",
            },
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.data == null) {
              return Center(
                child: Text('Data no Found'),
              );
            }
            return ListView.builder(
              itemCount: result.data['continent']['countries'].length,
              itemBuilder: (context, index) => ListTile(
                title: Text(result.data['continent']['countries'][index]['name']),
              ),
            );
          },
        ),
      ),
    );
  }
}
