package com.example.note_app.service;

import com.example.note_app.model.Note;
import com.example.note_app.repository.NoteRepository;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class NoteService {

  private final NoteRepository noteRepository;

  public NoteService(NoteRepository noteRepository) {
    this.noteRepository = noteRepository;
  }

  public List<Note> getAllNotes() {
    return noteRepository.findAll();
  }

  public Note createNote(Note note) {
    return noteRepository.save(note);
  }

  public Note findById(Long id) {
    return noteRepository.findById(id)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
  }

  public Note updateNote(Note note) {
    var noteToUpdate = noteRepository.findById(note.getId())
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    noteToUpdate.setTitle(note.getTitle());
    noteToUpdate.setContent(note.getContent());
    return noteRepository.save(note);
  }

  public void deleteNote(Long id) {
    noteRepository.deleteById(id);
  }
}
