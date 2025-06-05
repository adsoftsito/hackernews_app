import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String createVoteMutation = """
mutation CreateVote(\$linkId : Int!) {
  createVote(
    linkId: \$linkId 
  ) {
  link {
      url
      description
    }
  }
}
""";

class BlogRow extends StatelessWidget {
  final String id;
  final String url;
  final String description;


  const BlogRow({
    Key? key,
    required this.id,
    required this.url,
    required this.description,
     }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        children: [
          
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'url : $url',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'description: $description',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54, fontSize: 10),
                ),

                Mutation(
                options: MutationOptions(
                  document: gql(createVoteMutation),
                  // ignore: void_checks
                  update: (cache, result) {
                      return cache;
                  },
                  onCompleted: (result) {
                  if (result == null) {
                       print('Completed with errors ');
                  }
                  else {
                      print('${id} Votted');
                      print(result);
                      
                     // print(result["tokenAuth"]["token"]);
                     /*
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
                      */

                    }
                  },
                  onError: (error)  {
                    print('error :');
                    //appState.error = error!.graphqlErrors[0].message.toString();
                    print(error?.graphqlErrors[0].message);
                    /*
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
                      */

                  },

                ),
                builder: ( runMutation,  result) {

                  return ElevatedButton(
                  onPressed: ()  {

                   // if (_formKey1.currentState!.validate()) {
                        runMutation({ "linkId": int.parse(id),
                                  });

                        
                   // }
                  },
                  child: const Text('like!' ),
                   );
                }           
            ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}