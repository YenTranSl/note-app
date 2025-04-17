package com.example.note_app.controller;

import com.example.note_app.model.Note;
import com.example.note_app.service.NoteService;
import java.util.List;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notes")
public class NoteController {
  private final NoteService noteService;

  public NoteController(NoteService noteService) {
    this.noteService = noteService;
  }

  @GetMapping
  public List<Note> getNotes() {
    return noteService.getAllNotes();
  }

  @PostMapping
  public Note createNote(@RequestBody Note note) {
    return noteService.createNote(note);
  }

  @GetMapping("/{id}")
  public Note getById(@PathVariable Long id) {
    return noteService.findById(id);
  }

  @PutMapping("/{id}")
  public Note update(@PathVariable Long id, @RequestBody Note note) {
    note.setId(id); return noteService.updateNote(note);
  }

  @DeleteMapping("/{id}")
  public void delete(@PathVariable Long id) { noteService.deleteNote(id); }


}
