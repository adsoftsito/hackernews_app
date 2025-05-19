import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import "MyAppState.dart";
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

String linkPostMutation = """
mutation CreateLink(  \$url : String!,  
                      \$description : String!,
                      ) {
  createLink(
    url: \$url 
    description: \$description
  ) {
    id
    url
    description
  }
}
""";

class SeguimientoPage extends StatelessWidget {

  TextEditingController urlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    var appState = context.watch<MyAppState>();

    if (appState.token.isEmpty) {
      return Center(
        child: Text('No login yet.'),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

                Text(
                   "Bienvenido :${appState.username}",

                ),
          SizedBox(height: 20),

            Text(
                  "Links Mutation",
            ),
          SizedBox(height: 20),

            TextFormField(
                keyboardType: TextInputType.url,
                controller: urlController,
                inputFormatters: [
                   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), // Allow only digits
                ],
                validator: (value) {
                if (value!.isEmpty || value.length < 1) {
                    return 'Please enter a url';
                }
                    return null;
                },


                decoration: InputDecoration(
                   labelText: 'git url',
                    border: OutlineInputBorder(),
                    hintText: 'git url',

                  ),
              ),
               SizedBox(height: 20),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: descriptionController,
                inputFormatters: [
                   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), // Allow only digits
                ],
                validator: (value) {
                if (value!.isEmpty || value.length < 1) {
                    return 'Please enter a valid description';
                }
                    return null;
                },

                decoration: InputDecoration(
                   labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'Description',

                  ),
              ),
                      SizedBox(height: 20),

           Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             Mutation(
               options: MutationOptions(
                 document: gql(linkPostMutation),
                 // ignore: void_checks
                 update: (cache, result) {
                     return cache;
                 },
                 onCompleted: (result) {
                 if (result == null) {
                      print('Completed with errors ');
                   }  else {
                     print('ok ...');
                     print(result);

                    Alert(context: context, 
                            type: AlertType.info,
                            title: appState.username, 
                            desc: "Tu repo se ha guardado correctamente",
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
                   // ignore: await_only_futures
                   runMutation({  
                                  "url": int.tryParse(urlController.text),
                                  "description": double.tryParse(descriptionController.text),
                               });
                 },
                 child: const Text('Guardar registro'),
                  );
               }          
              ),

             
            ],
          ),
        ],
      ),
    );
  }
} 