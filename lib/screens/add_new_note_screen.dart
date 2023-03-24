import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:provider/provider.dart';

class AddNewNoteScreen extends StatefulWidget {
  static const routeName = 'add_notes';

  @override
  State<AddNewNoteScreen> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  var _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showErrorDialog('Missing Fields');
      return;
    } else if (_descriptionController.text.length <= 10) {
      _showErrorDialog('Description is Less');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Notes>(context, listen: false).addNote(Note(
          id: DateTime.now().toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          dateTime: DateTime.now()));
      Navigator.of(context).pop();
    } catch (error) {
      throw error;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
          actions: [
            IconButton(onPressed: _submit, icon: const Icon(Icons.done))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 28,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                // Padding(
                //   padding: const EdgeInsets.all(8),
                //   child: Column(
                //     children: <Widget>[
                //       TextField(
                //         controller: _titleController,
                //         autofocus: true,
                //         decoration: const InputDecoration(
                //           label: Text('Title'),
                //           border: OutlineInputBorder(),
                //         ),
                //       ),
                //       const SizedBox(height: 10),
                //       TextField(
                //         maxLength: 300,
                //         maxLines: 28,
                //         controller: _descriptionController,
                //         decoration: const InputDecoration(
                //             label: Text('Description'),
                //             border: OutlineInputBorder()),
                //       ),
                //     ],
                //   ),
                // ),
                ));
  }
}
