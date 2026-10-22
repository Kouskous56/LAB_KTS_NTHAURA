# Tools: sinh schematic, mô phỏng và ảnh minh chứng từ terminal

Mọi script trong thư mục này chạy **hoàn toàn bằng terminal**, không cần mở GUI.

| Script | Việc | Kết quả |
|---|---|---|
| `logisim.py` | Sinh file `.circ` cho Logisim Evolution, chạy Logisim headless | `.circ`, bảng chân lý |
| `logisim_lab3.py` | Dựng Full Adder trong Logisim + chạy `-tty table` | `full_adder.circ`, `logisim_table.txt` |
| `spice.py` | Chạy LTspice / ngspice batch, đọc file `.raw` | dữ liệu mô phỏng |
| `spice_lab3.py` | Mô phỏng SPICE Full Adder và bộ cộng 4 bit | `*.cir`, `spice_table_*.txt`, `spice_wave.png` |
| `vcd2png.py` | Vẽ waveform VCD theo style GTKWave | `wave.png`, `spice_wave.png` |
| `schematic.py`, `draw_lab3.py` | Vẽ logic diagram / application circuit / state diagram | `logic_diagram.png`, ... |
| `render_all.py` | Chạy lại toàn bộ ảnh của 9 project | tất cả PNG |

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
python tools\logisim_lab3.py    # .circ + logisim_table.txt
python tools\spice_lab3.py      # .cir + spice_table_*.txt + spice_wave.png
python tools\render_all.py      # logic_diagram.png, wave.png, state_diagram.png
```

Kết quả SPICE được tự đối chiếu với bảng chân lý chuẩn và ghi `RESULT: PASS/FAIL`
vào cuối `spice_table_*.txt`.
