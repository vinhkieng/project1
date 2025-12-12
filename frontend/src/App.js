import React, { useEffect, useState } from "react";

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");

  // Lấy danh sách tasks
  const fetchTasks = async () => {
    const res = await fetch("http://127.0.0.1:8000/api/tasks");
    const data = await res.json();
    setTasks(data);
  };

  // Tự động load khi mở trang
  useEffect(() => {
    fetchTasks();
  }, []);

  // Thêm task
  const addTask = async () => {
    const res = await fetch("http://127.0.0.1:8000/api/tasks", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        title,
        description,
        completed: false,
      }),
    });

    if (res.ok) {
      setTitle("");
      setDescription("");
      fetchTasks();
    }
  };

  // Xóa task
  const deleteTask = async (id) => {
    const res = await fetch(`http://127.0.0.1:8000/api/tasks/${id}`, {
      method: "DELETE",
    });

    if (res.ok) {
      fetchTasks();
    }
  };

  return (
    <div style={{ padding: "20px" }}>
      <h2>Task Manager (React + Laravel API)</h2>

      <div style={{ marginBottom: "20px" }}>
        <input
          type="text"
          placeholder="Nhập tiêu đề..."
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          style={{ marginRight: "10px" }}
        />
        <input
          type="text"
          placeholder="Nhập mô tả..."
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          style={{ marginRight: "10px" }}
        />
        <button onClick={addTask}>Thêm Task</button>
      </div>

      <ul>
        {tasks.map((task) => (
          <li key={task.id} style={{ marginBottom: "10px" }}>
            <b>{task.title}</b> — {task.description}
            <button
              onClick={() => deleteTask(task.id)}
              style={{ marginLeft: "10px", color: "red" }}
            >
              Xóa
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
