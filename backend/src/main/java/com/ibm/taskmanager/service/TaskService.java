package com.ibm.taskmanager.service;

import com.ibm.taskmanager.model.Task;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

// タスクのCRUD操作を管理するサービス（データベース不使用・インメモリ）
@Service
public class TaskService {

    private final Map<Long, Task> store = new ConcurrentHashMap<>();
    private final AtomicLong idCounter = new AtomicLong();

    public List<Task> findAll() {
        return new ArrayList<>(store.values());
    }

    public Task create(String title) {
        Long id = idCounter.incrementAndGet();
        Task task = new Task(id, title);
        store.put(id, task);
        return task;
    }

    public Optional<Task> toggleComplete(Long id) {
        Task task = store.get(id);
        if (task == null) return Optional.empty();
        task.setCompleted(!task.isCompleted());
        return Optional.of(task);
    }

    public boolean delete(Long id) {
        return store.remove(id) != null;
    }
}
