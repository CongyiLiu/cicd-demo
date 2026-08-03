package com.ibm.taskmanager.service;

import com.ibm.taskmanager.model.Task;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

// TaskServiceの単体テスト
class TaskServiceTest {

    private TaskService service;

    @BeforeEach
    void setUp() {
        // テストごとに新しいインスタンスを生成してデータを初期化
        service = new TaskService();
    }

    @Test
    @DisplayName("タスクを作成できること")
    void createTask() {
        Task task = service.create("テストタスク");

        assertThat(task.getId()).isNotNull();
        assertThat(task.getTitle()).isEqualTo("テストタスク");
        assertThat(task.isCompleted()).isFalse();
    }

    @Test
    @DisplayName("全タスクを取得できること")
    void findAllTasks() {
        service.create("タスク1");
        service.create("タスク2");

        List<Task> tasks = service.findAll();

        assertThat(tasks).hasSize(2);
    }

    @Test
    @DisplayName("タスクの完了状態を切り替えられること")
    void toggleComplete() {
        Task task = service.create("タスク");
        assertThat(task.isCompleted()).isFalse();

        Optional<Task> toggled = service.toggleComplete(task.getId());

        assertThat(toggled).isPresent();
        assertThat(toggled.get().isCompleted()).isTrue();
    }

    @Test
    @DisplayName("タスクを削除できること")
    void deleteTask() {
        Task task = service.create("削除対象タスク");

        boolean result = service.delete(task.getId());

        assertThat(result).isTrue();
        assertThat(service.findAll()).isEmpty();
    }

    @Test
    @DisplayName("存在しないタスクの削除はfalseを返すこと")
    void deleteNonExistentTask() {
        boolean result = service.delete(999L);

        assertThat(result).isFalse();
    }
}
