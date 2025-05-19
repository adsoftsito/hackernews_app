import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'LoginPage.dart';
import 'LogsPage.dart';
import "SeguimientoPage.dart";
//import "RecomendacionesPage.dart";
//import "PerfilPage.dart";
import "MyAppState.dart";



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context) => MyAppState(),

      


      child: MaterialApp(
        title: 'innSalud',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    //selectedIndex = appState.selectedIndex;

    final AuthLink authLink = AuthLink(
    getToken: () async {
        print ('token ${appState.token} OK');
        return 'JWT ${appState.token}';
        },
    );

    // final Link httpLink = authLink.concat(HttpLink('https://adsoftsito-api.onrender.com/graphql/'));
    final Link httpLink = authLink.concat(HttpLink('http://localhost:8000/graphql/'));
    
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    var colorScheme = Theme.of(context).colorScheme;
    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = LoginPage();
        break;

      case 1:
       
        page =  SeguimientoPage();
                break;

      case 2:
       // page = LoginPage();

        page = LogsPage(); 
                break;

      case 3:
        page = LoginPage();

       // page = PerfilPage();
                break;


      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.

 // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.onError,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return GraphQLProvider (
      client: client, 
      child : Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Login',
                        backgroundColor: Color.fromRGBO(0, 0, 255, 0)
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_card),
                        label: 'Seguimiento',
                        backgroundColor: Color.fromRGBO(0, 0, 255, 0)

                      ),
            /*          BottomNavigationBarItem(
                        icon: Icon(Icons.heart_broken),
                        label: 'Recomendaciones',
                        backgroundColor: Color.fromRGBO(0, 0, 255, 0)

                      ),*/

                      BottomNavigationBarItem(
                        icon: Icon(Icons.abc_sharp),
                        label: 'Historial',
                        backgroundColor: Color.fromRGBO(0, 0, 255, 0)

                      ),
                      
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_box),
                        label: 'Perfil',
                        backgroundColor: Color.fromRGBO(0, 0, 255, 0)

                      ),
       
                    ],
                    currentIndex: appState.selectedIndex,
                    onTap: (value) {
                      setState(() {
                        appState.selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Login'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.add_card),
                        label: Text('Seguimiento'),
                      ),
                    /*  NavigationRailDestination(
                        icon: Icon(Icons.heart_broken),
                        label: Text('Recomendaciones'),
                      ),*/

                      NavigationRailDestination(
                        icon: Icon(Icons.abc_sharp),
                        label: Text('Historial'),
                      ),
                      
                      NavigationRailDestination(
                        icon: Icon(Icons.add_box),
                        label: Text('Perfil'),
                      ),
                      
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        appState.selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
     ),
    );
  }
}






