# System-Report
Các chữ tiếng Việt có dấu đã bị biến dạng thành các ký tự rác (ví dụ: chữ "Số luồng", "Tốc độ" biến thành SÃ³ luá»“ng, TÃ³c Ä‘á»™). Khi hệ thống đọc các ký tự bị lỗi này, nó làm hỏng cấu trúc chuỗi và nuốt mất các dấu ngoặc kép ("), dấu ngoặc nhọn (}), dẫn đến việc PowerShell báo lỗi thiếu dấu đóng chuỗi (missing the terminator).

Cách khắc phục

Nhấn chuột phải vào file code (đuôi .ps1), chọn Open with > Notepad.

Trên thanh menu của Notepad, chọn File > Save As....

Trong cửa sổ lưu file, nhìn xuống góc dưới cùng bên phải sẽ có mục Encoding.

Bấm vào mũi tên xổ xuống và chọn UTF-8 with BOM (Nếu Notepad của bạn không có tùy chọn này, hãy chọn UTF-8).

Nhấn Save để ghi đè lên file cũ.

Chạy lại lệnh đóng gói ps2exe hoặc chạy lại script, lỗi sẽ hoàn toàn biến mất.
