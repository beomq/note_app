import 'package:flutter/cupertino.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/use_case/use_cases.dart';
import 'package:flutter_note_app/domain/util/note_order.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_state.dart';

class NotesViewModel with ChangeNotifier {
  final UseCases useCases;

  NotesState _state = const NotesState();

  NotesState get state => _state;

  Note? _recentlyDeleteNote;

  NotesViewModel(
    this.useCases,
  ) {
    _loadNotes();
  }

  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNotes,
      restoreNote: _restoreNotes,
      changeOrder: (NoteOrder noteOrder) {
        _state = state.copyWith(
          noteOrder: noteOrder,
        );
        _loadNotes();
      },
      toggleOrderSection: () {
        _state = state.copyWith(
          isOrderSectionVisible: !state.isOrderSectionVisible,
        );
        notifyListeners();
      },
    );
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await useCases.getNotes.call(state.noteOrder);
    _state = state.copyWith(notes: notes);
    notifyListeners();
  }

  Future<void> _deleteNotes(Note note) async {
    await useCases.deleteNote(note);
    _recentlyDeleteNote = note;
    await _loadNotes();
  }

  Future<void> _restoreNotes() async {
    if (_recentlyDeleteNote != null) {
      await useCases.addNote(_recentlyDeleteNote!);
      _recentlyDeleteNote = null;
      await _loadNotes();
    }
  }
}
