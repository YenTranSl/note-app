package com.example.note_app.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.Data;

@Entity
@Data
@Table (name = "notes")
public class Note {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String title;

  private String content;

  private LocalDateTime createdAt = LocalDateTime.now();
}
