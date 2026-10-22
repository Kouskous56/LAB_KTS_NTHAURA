# Tools: sinh schematic, mô phỏng và ảnh minh chứng từ terminal

Mọi script trong thư mục này chạy **hoàn toàn bằng terminal**, không cần mở GUI.

| Script | Việc | Kết quả |
|---|---|---|
| `logisim.py` | Sinh file `.circ` cho Logisim Evolution, chạy Logisim headless | `.circ`, bảng chân lý |
| `logisim_lab2.py` | Dựng 5 mạch Lab 2 trong Logisim + chạy `-tty table` | `*.circ`, `logisim_table.txt` |
| `logisim_lab3.py` | Dựng Full Adder và bộ cộng 4 bit trong Logisim | `*.circ`, `logisim_table.txt` |
| `spice.py` | Chạy LTspice / ngspice batch, đọc file `.raw` | dữ liệu mô phỏng |
| `spice_lab2.py` | Mô phỏng SPICE cho 5 bài Lab 2 | `*.cir`, `spice_table_*.txt`, `spice_wave.png` |
| `spice_lab3.py` | Mô phỏng SPICE cho Full Adder và bộ cộng 4 bit | `*.cir`, `spice_table_*.txt`, `spice_wave.png` |
| `verify_all.py` | Kiểm tra 14 project (iverilog + Logisim + SPICE + `.bit` + ảnh) | bảng tổng hợp, `REPORT_EVIDENCE.md` |
| `vcd2png.py` | Vẽ waveform VCD theo style GTKWave | `wave.png`, `spice_wave.png` |
| `schematic.py`, `draw_lab3.py` | Vẽ logic diagram / application circuit / state diagram | `logic_diagram.png`, ... |
| `render_all.py` | Chạy lại toàn bộ ảnh của 14 project | tất cả PNG |

## 1. Logisim Evolution (headless)

Logisim Evolution 5.0.0 nằm ở `C:\Program Files\logisim-evolution\app\logisim-evolution-5.0.0-all.jar`.

```powershell
java -jar "C:\Program Files\logisim-evolution\app\logisim-evolution-5.0.0-all.jar" `
     -tty table --toplevel-circuit main full_adder.circ
```

Lệnh in bảng chân lý do chính Logisim mô phỏng (không phải tính tay).

```powershell
python tools\logisim_lab3.py
```

### Những gì đã học được về định dạng `.circ`

- Component: `<comp lib="1" loc="(x,y)" name="AND Gate">` — `lib` là số thứ tự trong
  khối `<lib desc="#Gates" name="1"/>`, `name` là tên factory. Pin là `name="Pin"` ở lib 0
  (Wiring), Tunnel là `name="Tunnel"`.
- Hình học cổng (đo thực nghiệm, Logisim 5.0.0): cổng vào nằm ở `x - size`, cách đường
  ngang `±10` (size 30) hoặc `±20` (size 50/70). **Cổng XOR rộng thêm 10 px** do nét
  cong bên trái, nên cổng vào của XOR nằm ở `x - size - 10`.
- **Dây chéo làm Logisim treo máy** (`OutOfMemoryError` trong `WireRepair.doOverlaps`):
  mọi dây phải song song trục và không được trùng nhau. Script tự cắt dây chéo và bỏ
  phần dây trùng.
- **Hai dây cắt nhau sẽ bị nối vào nhau** → chập mạch. Dùng **Tunnel** để nối các net
  thay vì kéo dây dài.
- Pin đầu ra phải có `<a name="output" val="true"/>`; nếu để trống Logisim tự sinh tên
  `x`, `y` trong bảng.
- **Cổng NOT không có thuộc tính `size`**: nếu ghi thuộc tính này, Logisim bỏ hẳn component
  và ngõ ra báo `U`. Cổng NOT luôn rộng 30 px, cổng vào ở `x − 30`.
- **Cổng 4 ngõ vào không đều nhau**: Logisim đặt cổng vào ở `−20, −10, +10, +20` (với size 50),
  không phải chia đều. Script `logisim.py` dùng đúng công thức của Logisim cho mọi số ngõ vào.
- **NAND/NOR rộng thêm 10 px** do bong bóng đảo ở ngõ ra, nên cổng vào nằm ở `x − size − 10`
  (giống XOR).
- Bảng chân lý liệt kê tổ hợp theo thứ tự **ngược cột**: ngõ vào cuối cùng đổi nhanh nhất
  (`Ci` trong Full Adder, `Ci` trong bộ cộng 4 bit). Script kiểm tra phải dựng bảng kỳ vọng
  theo đúng quy tắc này.
- **Pin có nhãn `Y` bị Logisim đổi tên** trong bảng (thành `u`) – nên đặt tên ngõ ra theo tín
  hiệu của testbench (`f`, `F`).
- Nhiều ngõ ra làm thứ tự cột của bảng khó đọc: chỉ để **một pin đầu ra** cho bảng chân lý,
  các ngõ ra khác dùng **Probe** (Probe không xuất hiện trong bảng).
- Chế độ `-tty table` chỉ phân tích được **mạch tổ hợp**; mạch tuần tự (bộ đếm, máy trạng thái)
  không kiểm được bằng headless, phải mở GUI Logisim để xác nhận bằng mắt.

## 2. LTspice (headless)

```powershell
& "C:\Users\ACER\AppData\Local\Programs\ADI\LTspice\LTspice.exe" -b -ascii deck.cir
```

- `-b` chạy batch, `-ascii` ép file `.raw` dạng chữ (dễ đọc bằng Python).
- File `.raw` (ASCII): khối `Variables:` liệt kê tên biến, khối `Values:` chứa dữ liệu.
  Với LTspice **mỗi giá trị nằm trên một dòng**, dòng đầu của mỗi điểm có dạng
  `<index>\t<time>`.
- Cờ dòng lệnh đầy đủ: `-b`, `-ascii`, `-netlist`, `-Run`, `-FastAccess`, `-alt`,
  `-norm`, `-I<path>` (xem trang *Command Line Switches* trong help của LTspice).

## 3. ngspice (headless)

Bản ngspice trong máy: `D:\megatools\Qucs-S\bin\ngspice.exe` (ngspice 46).

```powershell
& "D:\megatools\Qucs-S\bin\ngspice.exe" -D filetype=ascii -b -o deck.log -r deck.raw deck.cir
```

- **Bắt buộc dùng `-o logfile`**: bản build này không ghi ra stdout (PE subsystem = 0),
  nếu không có `-o` thì không thấy lỗi.
- `-b` chạy batch, `-r` ghi raw file, `-D filetype=ascii` ép raw dạng chữ,
  `-a` chạy luôn như có `.control run`.
- Trong `.control` có thể dùng `run`, `write`, `wrdata file.txt v(a) v(b)`.
- **ngspice không có hàm `if()`** trong B-source: phải dùng toán tử ba ngôi
  `cond ? a : b` (LTspice dùng được cả hai). Script dùng đúng cú pháp chung cho hai
  simulator: chỉ số học và toán tử ba ngôi.

## 4. Chạy lại toàn bộ

```powershell
python tools\logisim_lab2.py    # .circ + logisim_table.txt (5 bài Lab 2)
python tools\logisim_lab3.py    # .circ + logisim_table.txt (Lab 3)
python tools\spice_lab2.py      # .cir + spice_table_*.txt + spice_wave.png (Lab 2)
python tools\spice_lab3.py      # .cir + spice_table_*.txt + spice_wave.png (Lab 3)
python tools\render_all.py      # wave.png cho 14 project
python tools\verify_all.py -o REPORT_EVIDENCE.md   # kiểm tra toàn bộ
```

Kết quả SPICE được tự đối chiếu với bảng chân lý chuẩn và ghi `RESULT: PASS/FAIL`
vào cuối `spice_table_*.txt`.
