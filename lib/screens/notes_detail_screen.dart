import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:provider/provider.dart';

class NotesDetailScreen extends StatelessWidget {
  final int existingIndex;
  NotesDetailScreen(this.existingIndex);
  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<Notes>(context);
    return Scaffold(
      appBar: AppBar(title: Text(noteData.notes[existingIndex].title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 3, color: Theme.of(context).primaryColor)),
            height: MediaQuery.of(context).size.height,
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      DateFormat.yMMMEd()
                          .format(noteData.notes[existingIndex].dateTime!),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      noteData.notes[existingIndex].description,
                    ),
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
