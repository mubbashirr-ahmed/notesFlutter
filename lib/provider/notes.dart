import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Note {
  String id;
  String title;
  String description;
  DateTime? dateTime;
  Note(
      {required this.id,
      required this.title,
      required this.description,
      required this.dateTime});
}

class Notes with ChangeNotifier {
  static const String link =
      'https://notesflutter-40106-default-rtdb.firebaseio.com/';
  final authToken;
  final userId;
  Notes(this.authToken, this.userId, this._notes);
  List<Note> _notes = [];

  List<Note> get notes {
    return [..._notes];
  }

  Future<void> addNote(Note note) async {
    final url = Uri.parse('$link.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': note.title,
            'description': note.description,
            'dateTime': note.dateTime!.toIso8601String(),
            'createrId': userId,
          }));
      final newNote = Note(
          id: json.decode(response.body)['name'],
          title: note.title,
          description: note.description,
          dateTime: note.dateTime);
      _notes.add(newNote);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchandSetNotes() async {
    final filterString = 'orderBy="createrId"&equalTo="$userId"';
    final url = Uri.parse('$link.json?auth=$authToken&$filterString');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty || extractedData['error'] != null) {
      return;
    }
    final List<Note> loadedNotes = [];
    extractedData.forEach((noteId, noteData) {
      loadedNotes.add(Note(
          id: noteId,
          title: noteData['title'],
          description: noteData['description'],
          dateTime: DateTime.tryParse(noteData['dateTime'])));
    });
    _notes = loadedNotes;
    notifyListeners();
  }

  Future<void> deleteNote(String existingId) async {
    final url = Uri.parse('$link/$existingId.json?auth=$authToken');
    final existingNoteIndex =
        _notes.indexWhere((note) => note.id == existingId);
    Note? existingNote = _notes[existingNoteIndex];
    _notes.removeAt(existingNoteIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _notes.insert(existingNoteIndex, existingNote);
      notifyListeners();
      throw const HttpException('Could not Delete Note');
    } else {
      existingNote = null;
    }
    notifyListeners();
  }

  Future<void> updateNotes(Note note, String existingId) async {
    final noteIndex = _notes.indexWhere((note) => note.id == existingId);
    if (noteIndex >= 0) {
      final url = Uri.parse('$link/$existingId.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': note.title,
            'description': note.description,
            'dateTime': note.dateTime!.toIso8601String(),
          }));
      _notes[noteIndex] = note;
      notifyListeners();
    }
  }
}
