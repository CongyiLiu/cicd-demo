package com.ibm.taskmanager.model;

import java.time.LocalDateTime;

// タスクエンティティ（インメモリ保存用）
public class Task {

    private Long id;
    private String title;
    private boolean completed;
    private LocalDateTime createdAt;

    public Task() {}

    public Task(Long id, String title) {
        this.id = id;
        this.title = title;
        this.completed = false;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
