import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_new_note_screen.dart';
import 'package:notes_app/screens/edit_notes_screen.dart';
import 'package:notes_app/screens/notes_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = 'notes_screen';

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Future<void> _refreshNotes() async {
    await Provider.of<Notes>(context, listen: false).fetchandSetNotes();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _refreshNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    print('building');
    // final _notesData = Provider.of<Notes>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewNoteScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshNotes(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: RefreshIndicator(
                  onRefresh: () => _refreshNotes(),
                  color: Theme.of(context).primaryColor,
                  child: Consumer<Notes>(
                    builder: (context, value, child) => value.notes.isEmpty
                        ? const Center(
                            child: Text('No Notes Added Yet'),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) => Card(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        NotesDetailScreen(index),
                                  ));
                                },
                                child: ListTile(
                                  title: Text(value.notes[index].title),
                                  subtitle: Text(DateFormat.yMMMEd()
                                      .format(value.notes[index].dateTime!)),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EditNotesScreen(index,
                                                        value.notes[index].id),
                                              ));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              try {
                                                await value.deleteNote(
                                                    value.notes[index].id);
                                                Fluttertoast.showToast(
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    msg: 'Deleted Successfully',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                        Colors.black45,
                                                    textColor: Theme.of(context)
                                                        .primaryColor);
                                              } catch (error) {
                                                scaffold.showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                  'Deletion Failed! Try again.',
                                                  textAlign: TextAlign.center,
                                                )));
                                              }
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color:
                                                  Theme.of(context).errorColor,
                                            )),
                                      ]),
                                ),
                              ),
                            ),
                            itemCount: value.notes.length,
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
