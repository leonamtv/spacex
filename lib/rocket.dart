import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex/constants..dart';
import 'package:intl/intl.dart';

class Rocket extends StatefulWidget {

  final dynamic id;

  Rocket({ Key key, @required this.id }) : super( key : key );

  @override
  _RocketState createState() => _RocketState();
}

class _RocketState extends State<Rocket> {

  final formt = new NumberFormat("#,##0.00", "en_US");

  String query = 
  """
    query data(\$identificador: ID!){
      rocket(id: \$identificador) {
        name
        mass {
          kg
        }
        landing_legs {
          material
          number
        }
        height {
          meters
        }
        first_flight
        first_stage {
          burn_time_sec
          engines
          fuel_amount_tons
          reusable
          thrust_sea_level {
            kN
          }
          thrust_vacuum {
            kN
          }
        }
        diameter {
          meters
        }
        description
        country
        cost_per_launch
        company
        boosters
        active
        payload_weights {
          kg
        }
        second_stage {
          engines
          burn_time_sec
          fuel_amount_tons
          thrust {
            kN
          }
        }
        stages
        success_rate_pct
        type
        wikipedia
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding (
            padding: const EdgeInsets.all(15.0),
            child: Query (
              options: QueryOptions(
                documentNode: gql(query),
                variables: {
                  'identificador' : widget.id
                }
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
                
                Map<String, dynamic> rocket = result.data['rocket'];

                return ListView(
                  physics: NeverScrollableScrollPhysics(),                      
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          rocket['name'],
                          style: h1
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Description:',
                                style: h2
                              )
                            ),
                          ),
                          Text(
                            rocket['description'],
                            style: h4
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Specs:',
                                style: h2
                              )
                            ),
                          ),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Text('Mass (kg)', style: h3),
                                  Text(rocket['mass']['kg'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Height (m)', style: h3),
                                  Text(rocket['height']['meters'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Diameter (m)', style: h3),
                                  Text(rocket['diameter']['meters'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Cost per launch (\$)', style: h3),
                                  Text("${formt.format(rocket['cost_per_launch'])}")
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Nº of stages', style: h3),
                                  Text(rocket['stages'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                            ],
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Stage 1 specs:',
                                style: h2
                              )
                            ),
                          ),
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(2.0), 
                              1: FlexColumnWidth(1.0),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Text('Burn time (s)', style: h3),
                                  Text(rocket['first_stage']['burn_time_sec'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Nº of engines', style: h3),
                                  Text(rocket['first_stage']['engines'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Tons of fuel', style: h3),
                                  Text(rocket['first_stage']['fuel_amount_tons'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Thrust at sea level (kN)', style: h3),
                                  Text(rocket['first_stage']['thrust_sea_level']['kN'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Thrust at vacuum (kN)', style: h3),
                                  Text(rocket['first_stage']['thrust_vacuum']['kN'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Reusable', style: h3),
                                  Text(rocket['first_stage']['reusable'] ? "Yes" : "No")
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                            ],
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Stage 2 specs:',
                                style: h2
                              )
                            ),
                          ),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Text('Burn time (s)', style: h3),
                                  Text(rocket['second_stage']['burn_time_sec'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Nº of engines', style: h3),
                                  Text(rocket['second_stage']['engines'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Tons of fuel', style: h3),
                                  Text(rocket['second_stage']['fuel_amount_tons'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                              TableRow(
                                children: [
                                  Text('Thrust (kN)', style: h3),
                                  Text(rocket['second_stage']['thrust']['kN'].toString())
                                ],
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Theme.of(context).dividerColor)
                                  )
                                )
                              ),
                            ],
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: new Text('Wikipedia page'),
                    )
                  ],
                );
              },
            )
          ),
        ),
      ),
    );
  }
}


