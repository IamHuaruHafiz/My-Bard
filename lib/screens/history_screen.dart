import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Confirm Deletion"),
                        content: const Text(
                            "Are you sure you want to delete all history items?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await Future.value(Provider.of<DBProvider>(
                                            context,
                                            listen: false)
                                        .deleteAllResponses())
                                    .then((_) => Navigator.of(context).pop());
                              },
                              child: const Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No")),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.clear_all_rounded))
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<DBProvider>(context).responsesList(),
          builder: (context, snapshot) {
            final responses = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: responses!.length,
                  itemBuilder: (context, index) {
                    return ResponseItem(
                      id: responses[index].id,
                      content: responses[index].content,
                      question: responses[index].question,
                      date: responses[index].date,
                    );
                  });
            }
            return const Center(
              child: Text("No data"),
            );
          }),
    );
  }
}

class ResponseItem extends StatelessWidget {
  const ResponseItem({
    super.key,
    required this.id,
    required this.content,
    required this.question,
    required this.date,
  });

  final String id;
  final String content;
  final String question;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                content: content,
              ),
            ),
          );
        },
        isThreeLine: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                question,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: IconButton(
                  onPressed: () {
                    Provider.of<DBProvider>(context, listen: false)
                        .deleteResponse(id, context);
                  },
                  icon: const Icon(Icons.delete_outlined)),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat.yMEd().format(DateTime.parse(date))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}