package com.ibm.taskmanager.controller;

import com.ibm.taskmanager.model.Task;
import com.ibm.taskmanager.service.TaskService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// TaskControllerの統合テスト（MockMvc使用）
@WebMvcTest(TaskController.class)
class TaskControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private TaskService taskService;

    @Test
    @DisplayName("GET /api/tasks - タスク一覧を返すこと")
    void getTasks() throws Exception {
        when(taskService.findAll()).thenReturn(List.of(new Task(1L, "テストタスク")));

        mockMvc.perform(get("/api/tasks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title").value("テストタスク"));
    }

    @Test
    @DisplayName("POST /api/tasks - タスクを作成できること")
    void createTask() throws Exception {
        when(taskService.create("新しいタスク")).thenReturn(new Task(1L, "新しいタスク"));

        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"新しいタスク\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("新しいタスク"));
    }

    @Test
    @DisplayName("POST /api/tasks - タイトルが空の場合400を返すこと")
    void createTaskWithEmptyTitle() throws Exception {
        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("PUT /api/tasks/{id}/toggle - 完了状態を切り替えられること")
    void toggleTask() throws Exception {
        Task task = new Task(1L, "タスク");
        task.setCompleted(true);
        when(taskService.toggleComplete(1L)).thenReturn(Optional.of(task));

        mockMvc.perform(put("/api/tasks/1/toggle"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true));
    }

    @Test
    @DisplayName("DELETE /api/tasks/{id} - タスクを削除できること")
    void deleteTask() throws Exception {
        when(taskService.delete(1L)).thenReturn(true);

        mockMvc.perform(delete("/api/tasks/1"))
                .andExpect(status().isNoContent());
    }
}
