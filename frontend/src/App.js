import React, { useEffect, useState } from "react";

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);

  // Cấu hình URL
  const API_URL = process.env.REACT_APP_API_URL || "http://127.0.0.1:8000/api";

  // Lấy danh sách tasks
  const fetchTasks = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_URL}/tasks`);
      const data = await res.json();
      setTasks(data);
    } catch (error) {
      console.error("Lỗi:", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  // Thêm task
  const addTask = async (e) => {
    e.preventDefault(); // Ngăn reload form
    if (!title) return alert("Vui lòng nhập tiêu đề!");

    const res = await fetch(`${API_URL}/tasks`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ title, description, completed: false }),
    });

    if (res.ok) {
      setTitle("");
      setDescription("");
      fetchTasks();
    }
  };

  // Xóa task
  const deleteTask = async (id) => {
    if(!window.confirm("Bạn chắc chắn muốn xóa chứ?")) return;
    
    const res = await fetch(`${API_URL}/tasks/${id}`, {
      method: "DELETE",
    });

    if (res.ok) {
      fetchTasks();
    }
  };

  // Toggle trạng thái (Giả lập update để đổi màu badge - nếu backend hỗ trợ)
  // Hiện tại backend bạn chưa có route PUT update status nên mình để logic UI thôi
  
  return (
    <div className="container py-5">
      <div className="row justify-content-center">
        <div className="col-md-8">
          
          {/* Header */}
          <div className="text-center mb-5">
            <h1 className="fw-bold text-primary">📝 Task Manager</h1>
            <p className="text-muted">Quản lý công việc và ghi chú của bạn</p>
          </div>

          {/* Form thêm mới */}
          <div className="card shadow-sm mb-4 border-0">
            <div className="card-body p-4">
              <h5 className="card-title mb-3">Thêm ghi chú mới</h5>
              <form onSubmit={addTask}>
                <div className="mb-3">
                  <input
                    type="text"
                    className="form-control form-control-lg"
                    placeholder="Tiêu đề (Ví dụ: Học Docker...)"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                  />
                </div>
                <div className="mb-3">
                  <textarea
                    className="form-control"
                    rows="2"
                    placeholder="Mô tả chi tiết..."
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                  ></textarea>
                </div>
                <div className="d-grid">
                  <button type="submit" className="btn btn-primary btn-lg">
                    ➕ Thêm công việc
                  </button>
                </div>
              </form>
            </div>
          </div>

          {/* Danh sách công việc */}
          {loading ? (
            <div className="text-center">
              <div className="spinner-border text-primary" role="status"></div>
            </div>
          ) : (
            <div className="row">
              {tasks.length === 0 && (
                <p className="text-center text-muted mt-3">Chưa có công việc nào.</p>
              )}
              
              {tasks.map((task) => (
                <div key={task.id} className="col-12 mb-3">
                  <div className="card shadow-sm border-start border-4 border-primary h-100">
                    <div className="card-body d-flex justify-content-between align-items-center">
                      <div>
                        <h5 className="card-title fw-bold mb-1">{task.title}</h5>
                        <p className="card-text text-muted mb-0 small">
                          {task.description || "Không có mô tả"}
                        </p>
                        <small className="text-secondary" style={{fontSize: '0.8rem'}}>
                           Ngày tạo: {new Date(task.created_at).toLocaleDateString()}
                        </small>
                      </div>
                      
                      <div className="ms-3">
                        <button
                          onClick={() => deleteTask(task.id)}
                          className="btn btn-outline-danger btn-sm"
                          title="Xóa"
                        >
                          🗑️
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
          
        </div>
      </div>
    </div>
  );
}

export default App;