import 'package:flutter/material.dart';

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}