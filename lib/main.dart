import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static final HttpLink httpLink = HttpLink(
    uri: 'https://api.spacex.land/graphql/',
  );

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: MyApp.httpLink,
    ),
  );

  @override
  Widget build(BuildContext context) {

    String query = 
    """
      {
        rockets {
          name
          id
        }
      }
    """;

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'SpaceX missions',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Spacex'),
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Query(
                  options: QueryOptions (
                    documentNode: gql(query),
                  ),
                  builder: ( QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                    if ( result.hasException ) {
                      return Text(result.exception.toString());
                    }
                    
                    if ( result.loading ) {
                      return Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5951c9))
                        )
                      );
                    }
                    
                    List rockets = result.data['rockets'];
                    
                    return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),                      
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: rockets.length,
                      itemBuilder: ( context, index ) {
                        final rocket = rockets[index];
                        return Material(
                          child: InkWell(
                            onTap: () {
                              print(rocket);
                            },
                            child: Container(
                              height: ( MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight ) / rockets.length - 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black26,
                                    Colors.black12,
                                    Colors.black26,
                                  ]
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(rocket['name']),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(
                                        Icons.visibility
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
