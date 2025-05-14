
//import 'dart:convert';

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
//import 'package:innsalud/main.dart';
//import 'package:innsalud/main.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import "MyAppState.dart";
//import 'LoginResponse.dart';

String loginPostMutation = """
mutation TokenAuth(\$username : String!,  \$password : String!) {
  tokenAuth(
    username: \$username 
    password: \$password 
  ) {
    token
  }
}
""";

String createPostMutation = """
mutation CreateUser(\$email : String!,  \$password : String!, \$username : String!) {
  createUser(
    email: \$email 
    password: \$password 
    username: \$username 
  ) {
    user {
      id
      email
      password
      username
    }
  }
}
""";

/*
class LoginPage extends StatefulWidget {
  @override
  LoginWidget createState() => LoginWidget();
}
*/

//class LoginWidget extends State<LoginPage> {

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //final _formKey = GlobalKey<FormState>();

//class LoginPage extends StatelessWidget {

//StatefulWidget {
// StatelessWidget {
//class _LoginWidgetState extends State<LoginWidget> {

//final String _email = '';
//final String _password = '';

/*
Future<QueryResult> _login() async {
    final mutation = gql(r'''
      mutation LoginUser($email: String!, $password: String!) {
        login(email: $email, password: $password) {
          token
        }
      }
    ''');

    final variables = {'email': _email, 'password': _password};

    return runMutation(mutation, variables);
  }

*/

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController createEmailController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController createUserController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

    if (appState.token.isNotEmpty) {
      return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

              Text(
                  "Welcome ${appState.username}",
                ),
                SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {

                  Alert(context: context, 
                            type: AlertType.info,
                            title: appState.username, 
                            desc: "Tu sesion  se ha cerrado correctamente.",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();

                  setState(() {
                      appState.username = "";
                      appState.token = "";
                  });

                },
                child: Text('Logout'),
              ),

        ]
      )
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Form(
            key: _formKey1,
            child: Column(
              children: [
                 Text(
                  "Ingrese credenciales",
                ),
                SizedBox(height: 20),
TextFormField(
                keyboardType: TextInputType.text,
                controller: userNameController,
                decoration: InputDecoration(
                   labelText: 'Usuario',
                    border: OutlineInputBorder(),
                    hintText: 'usuario',

                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
            TextFormField(
                keyboardType: TextInputType.text,
                controller: passwordController,

                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),

                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(loginPostMutation),
                  // ignore: void_checks
                  update: (cache, result) {
                      return cache;
                  },
                  onCompleted: (result) {
                  if (result == null) {
                       print('Completed with errors ');
                      /*
                       Alert(context: context, 
                            type: AlertType.error,
                            title: "Error ", 
                            desc:  "Ocurrio un error al intentar hacer login",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();

*/

                    }
                    else {
                      print('ok ...');


                      print(result["tokenAuth"]["token"]);
                      setState(() {
                         appState.username = userNameController.text;
                         appState.token = result["tokenAuth"]["token"].toString();
                         appState.selectedIndex  = 1;
                      });

                      Alert(context: context, 
                            type: AlertType.info,
                            title: appState.username, 
                            desc: "Bienvenido a innsalud, ahora puedes dar click  en Seguimiento",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();


                    }
                  },
                  onError: (error)  {
                    print('error :');
                    appState.error = error!.graphqlErrors[0].message.toString();
                    print(error?.graphqlErrors[0].message);

                     Alert(context: context, 
                            type: AlertType.error,
                            title: appState.username, 
                            desc:  appState.error,
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();

                  },

                ),
                builder: ( runMutation,  result) {

                  return ElevatedButton(
                  onPressed: ()  {

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey1.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                                            // ignore: await_only_futures
                        runMutation({ "username": userNameController.text,
                                   "password": passwordController.text
                                  });

                        /*
                        ScaffoldMessenger.of(context).showSnackBar(

                          const SnackBar(content: Text('Processing Data')),

                          
                        );*/
                    }
                  },
                  child: const Text('Login'),
                   );
                }           
            ),
                // Form 1 fields (e.g., TextFormField, CheckboxListTile, etc.)
              ],
            ),
          ),
          Form(
            key: _formKey2,
            child: Column(
              children: [
                 Text(
                  "Crear Usuario nuevo",
                ),
            SizedBox(height: 20),

            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: createEmailController,
                decoration: InputDecoration(
                   labelText: 'email',
                    border: OutlineInputBorder(),
                    hintText: 'email',

                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: createUserController,
                decoration: InputDecoration(
                   labelText: 'username',
                    border: OutlineInputBorder(),
                    hintText: 'username',

                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: createPasswordController,

                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),

                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),

 Mutation(
                options: MutationOptions(
                  document: gql(createPostMutation),
                  // ignore: void_checks
                  update: (cache, result) {
                      return cache;
                  },
                  onCompleted: (result) {
                  if (result == null) {
                       print('Completed with errors ');
                    
                    }
                    else {
                      print('ok ...');
                      appState.username = createUserController.text;
                      userNameController.text  = appState.username;

                      createEmailController.text = '';
                      createUserController.text = '';
                      createPasswordController.text = '';

                      //appState.token = result["tokenAuth"]["token"].toString();
                      print(result);
                      Alert(context: context, 
                            type: AlertType.info,
                            title: appState.username, 
                            desc: "Te has registrado satisfactoriamente en innsalud, ahora puedes hacer login",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();

                    }
                  },
                  onError: (error)  {
                    print('error :');
                    appState.error = error!.graphqlErrors[0].message.toString();
                    print(error?.graphqlErrors[0].message);


                     Alert(context: context, 
                            type: AlertType.error,
                            title: "Error al crear el usuario", 
                            desc:  appState.error,
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Aceptar",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )]
                      ).show();

                  },

                ),
                builder: ( runMutation,  result) {

                  return ElevatedButton(
                  onPressed: ()  {

                    if (_formKey2.currentState!.validate()) {

                    // ignore: await_only_futures
                    runMutation({ 
                                  "email":    createEmailController.text, 
                                  "password": createPasswordController.text,
                                  "username": createUserController.text
                                });
                                        }
                  },
                  child: const Text('Create User'),
                   );
                }           
            ),
                // Form 2 fields (e.g., TextFormField, CheckboxListTile, etc.)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

