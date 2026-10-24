# Substrate Manual — Nền tảng thiết kế số, SystemVerilog và FPGA

## 1. Mục đích và cách dùng

Đây là tài liệu nền tảng dùng xuyên suốt các bài Digital Design trong workspace: Lab 1 (Boolean/cổng/MUX/decoder), Lab 2 (RTL và Nexys A7), Lab 3 (IC rời, arithmetic, flip-flop, counter, FSM), Lab 4 (ALU, 7-segment, counter và FSM), Lab 5 (traffic light, Pmod và hệ thống tích hợp).

Tài liệu đi từ khái niệm cơ bản đến các vấn đề triển khai nâng cao. Nó giúp trả lời ba câu hỏi trước mỗi thiết kế:

1. **Mạch phải làm gì?** Viết đặc tả, bảng chân trị hoặc bảng trạng thái.
2. **Mạch được mô tả thế nào?** Chọn cổng, IC hay RTL; quản lý độ rộng, thời gian và cực tính.
3. **Làm sao biết đúng?** Kiểm tra bằng lập luận, mô phỏng, báo cáo tổng hợp và đo trên phần cứng.

Các manual theo từng Lab vẫn là nguồn quyết định yêu cầu bài cụ thể; datasheet, Reference Manual và Master XDC quyết định đặc tính linh kiện/board. Khi tài liệu mâu thuẫn hoặc thiếu chi tiết, ghi giả định và xác nhận với giảng viên thay vì đoán âm thầm.

## 2. Tư duy thiết kế số: từ yêu cầu đến mạch

Mạch số được xây từ tín hiệu có các mức logic rời rạc. Một tín hiệu Boolean có hai trạng thái logic 0 và 1; trong phần cứng, mỗi trạng thái tương ứng một khoảng điện áp chứ không phải một giá trị điện áp lý tưởng duy nhất.

Một thiết kế thường gồm các tầng:

```
Yêu cầu → mô hình toán/trạng thái → logic → RTL hoặc IC
       → mô phỏng → tổng hợp/đi dây → quan sát phần cứng
```

Không nhảy trực tiếp từ mô tả tiếng Việt sang code hoặc dây nối. Trước tiên cần xác định:

- Input/Output, độ rộng từng bus và đơn vị của giá trị.
- Thứ tự bit: MSB/LSB, thứ tự trường khi nối bus.
- Combinational hay sequential; nếu sequential, cạnh clock nào cập nhật.
- Reset polarity, reset value, đồng bộ hay bất đồng bộ.
- Cực tính đầu ra: active-high hay active-low.
- Hành vi mọi trường hợp, kể cả mã không hợp lệ, input đồng thời và reset.
- Điều kiện thời gian: bao lâu một trạng thái/giá trị được giữ, lúc nào được lấy mẫu.

Một sơ đồ hoặc RTL tốt làm cho các giả định này nhìn thấy được, không giấu trong cách cắm dây.

## 3. Số nhị phân, độ rộng và biểu diễn

### 3.1 Giá trị không dấu

Với bus n bit `b[n-1:0]`, giá trị unsigned là:

```
U = Σ b[i]·2^i,    0 ≤ U ≤ 2^n − 1
```

Bit 0 là LSB; bit `n−1` là MSB. Ví dụ `101101₂ = 32+8+4+1 = 45₁₀ = 2D₁₆`. Một chữ số hexadecimal biểu diễn đúng bốn bit.

### 3.2 Bù hai có dấu

Với n bit two's complement:

```
−2^(n−1) ≤ S ≤ 2^(n−1)−1
```

Cùng một bit pattern có cách hiểu khác nhau theo signedness: `1111₂` là 15 unsigned nhưng −1 signed trên 4 bit. Đổi dấu trong cùng độ rộng bằng đảo bit rồi cộng 1. Ví dụ `+5=0101`, `−5=1011` trên 4 bit.

Mở rộng unsigned thêm 0 ở trái; mở rộng signed lặp lại bit dấu. Khi trộn độ rộng hoặc signedness trong RTL, viết phép mở rộng rõ ràng thay vì dựa vào ép kiểu ngầm.

### 3.3 Carry, borrow và overflow

Ba khái niệm cần phân biệt:

- **Carry-out**: bit vượt khỏi độ rộng khi cộng unsigned.
- **Borrow/no-borrow**: phép trừ unsigned; với bù hai `A+~B+1`, carry-out thường bằng 1 khi không borrow.
- **Signed overflow**: kết quả toán học vượt miền signed, không tương đương carry. Ví dụ 4-bit `0111+0001=1000`: carry-out 0 nhưng signed overflow 1.

Nếu cần cờ overflow phép cộng signed:

```
V = ~(Amsb xor Bmsb) & (Smsb xor Amsb)
```

Nêu rõ cờ nào được xuất và cách hiểu trong từng mode của ALU.

### 3.4 BCD, Gray và mã hiển thị

BCD mã hóa từng chữ số thập phân bằng 4 bit; `25₁₀` thành `0010 0101` BCD, khác `0001 1001` nhị phân thuần. Mã 1010–1111 không đại diện chữ số BCD; decoder phải quy định blank hoặc báo lỗi.

Gray code sắp các giá trị kề nhau sao cho chỉ một bit thay đổi, hữu ích cho Karnaugh map và một số ứng dụng giao tiếp. Gray hai bit theo thứ tự `00,01,11,10`.

## 4. Boolean và mạch tổ hợp

### 4.1 Cổng cơ bản

| A | B | AND | OR | NAND | NOR | XOR | XNOR |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
| 0 | 1 | 0 | 1 | 1 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 1 | 0 | 1 | 0 |
| 1 | 1 | 1 | 1 | 0 | 0 | 0 | 1 |

`XOR=1` khi các đầu vào khác nhau; `XNOR=1` khi chúng giống nhau. Chấm/bubble tại chân cổng biểu thị đảo hoặc tác động tích cực mức thấp.

### 4.2 Các luật Boolean hữu dụng

```
A + 0 = A             A·1 = A
A + A = A             A·A = A
A + A̅ = 1             A·A̅ = 0
A + AB = A            A(A+B) = A
(AB)̅ = A̅ + B̅         (A+B)̅ = A̅B̅
```

Hai luật cuối là De Morgan. Chúng giải thích cách đổi AND/OR khi đảo cực tính, và cách dựng logic chỉ NAND hoặc chỉ NOR. NAND/NOR là cổng phổ quát: có thể tạo NOT bằng cách nối hai input của NAND/NOR chung; tuy vậy phải tính cả số cổng, fan-out và cực tính đầu ra.

### 4.3 Truth table, minterm và maxterm

Với ba biến `x,y,z`, chọn quy ước `x` MSB, `z` LSB:

```
index = 4x + 2y + z
```

Minterm `m_k` bằng 1 chỉ tại dòng k. Ví dụ `m5=x·y̅·z` vì dòng 101 có index 5. `Σm(1,3,6)` có nghĩa hàm HIGH tại ba địa chỉ đó. Maxterm `M_k` bằng 0 ở dòng k; do đó một hàm có thể viết bằng tập minterm HIGH hoặc tập maxterm LOW.

Luôn ghi thứ tự bit của bảng/vector. Chuỗi output `0101...` thường có thể đọc từ địa chỉ tăng dần, nhưng literal `[7:0]` trong Verilog đặt bit 7 ở bên trái; không đồng nhất hai cách viết này nếu không nêu quy ước.

### 4.4 SOP, POS và Karnaugh map

- **SOP** (sum of products): OR các hạng AND; thích hợp nhóm ô 1.
- **POS** (product of sums): AND các hạng OR; thích hợp nhóm ô 0.
- Trong Karnaugh map, thứ tự hàng/cột là Gray, hai mép đối diện cũng kề nhau. Nhóm có kích thước lũy thừa của 2; nhóm càng lớn thường cho ít biến hơn.
- Mọi ô 1 phải được phủ trong SOP. Có thể chồng nhóm; không nhóm đường chéo. Đừng loại một minterm chỉ vì biểu thức "trông có vẻ đúng".

Quy trình tự kiểm: lập truth table từ biểu thức rút gọn rồi so từng dòng với đặc tả. Với hàm vài biến, đây thường là cách phát hiện lỗi nhanh nhất.

### 4.5 Mạch tổ hợp thường gặp

- **MUX**: chọn một trong nhiều đầu vào dữ liệu theo select. MUX không lưu dữ liệu. Với MUX 8:1, select 3 bit xác định `D[index]`; phải để ý bit select thấp nhất và chân enable.
- **Decoder**: biến mã nhị phân thành một đường được chọn. Output có thể active-high one-hot hoặc active-low one-cold; polarity làm thay đổi phép kết hợp output.
- **Tri-state buffer**: khi enable tắt, output ở trở kháng cao `Z`, không phải logic 0. Nhiều driver chỉ được chia sẻ bus nếu chỉ một driver hoạt động tại một thời điểm.
- **Adder**: full-adder có `S=A⊕B⊕Ci`, `Co=AB+ACi+BCi`; mắc ripple bằng cách nối carry ra tầng kế tiếp.
- **Adder/subtractor**: two's complement thực hiện `A−B=A+~B+1`; conditional invert: `B'=B xor SUB`, `C0=SUB`.
- **ALU**: tính các phép toán rồi chọn theo opcode. Bảng opcode phải xác định cả result lẫn flags.

## 5. Phần cứng IC rời và breadboard

### 5.1 Đọc datasheet trước khi cắm

Với mỗi IC cần tìm: mã đầy đủ/hậu tố, package, sơ đồ chân nhìn từ trên, VCC/GND, function table, input thresholds, output current/drive, polarity của enable/reset, giới hạn điện áp và chân không dùng. Cùng số họ logic có thể khác pinout hoặc đặc tính theo package/nhà sản xuất; không lấy hình "na ná" thay datasheet.

DIP nhìn từ trên: xác định notch/chấm định vị; chân 1 ở góc cạnh notch, số tăng ngược chiều kim đồng hồ. DIP đặt bắc qua rãnh giữa breadboard để hai hàng chân không nối chung.

### 5.2 Breadboard, nguồn và tín hiệu

- Các lỗ trong cùng dải tiếp xúc được nối điện nội bộ; các thanh nguồn có thể bị ngắt giữa đường. Kiểm tra continuity thay vì giả định.
- Mọi IC cần nguồn và GND đúng. Tín hiệu phát từ thiết bị ngoài và mạch phải chung GND.
- Tắt nguồn trước khi đổi dây. Tránh nối trực tiếp hai output với nhau. Không để input TTL/CMOS thả nổi; buộc mức xác định theo datasheet/quy định lab.
- Dùng điện trở hạn dòng LED; không lấy output logic làm nguồn công suất. Xác nhận polarity LED và logic indicator.
- TTL LS thường dùng 5 V, FPGA Nexys A7 dùng I/O 3.3 V. **Không nối trực tiếp mức 5 V sang FPGA/Pmod**; kiểm tra chuyển mức khi hai miền điện áp khác nhau.

### 5.3 Lắp từng khối và debug

Lắp theo chuỗi: nguồn → input đơn giản → một cổng → output indicator → net trung gian → toàn hệ thống. Mỗi bước kiểm continuity và mức logic. Nếu sai, khoanh vùng theo thứ tự: nguồn/GND → định hướng chân → pinout → input/pull-up → logic trung gian → enable/polarity → LED/probe. Tắt nguồn trước khi sửa dây.

## 6. SystemVerilog: mô tả phần cứng, không phải chương trình tuần tự

### 6.1 Module và hierarchy

Module mô tả một khối phần cứng có cổng. Nhiều module/block hoạt động đồng thời; gọi module là nối các khối, không phải gọi hàm phần mềm. Nên tách:

1. **Core**: logic chức năng, không biết chân board.
2. **Wrapper/top**: ánh xạ core tới SW, LED, button, clock, display, Pmod.
3. **Testbench**: chỉ mô phỏng, không tổng hợp lên FPGA.

### 6.2 Kiểu tín hiệu và toán tử

```systemverilog
logic       one_bit;
logic [3:0] value;
logic [4:0] extended_sum;
```

`& | ^ ~` là phép bitwise; `&& || !` là logical. Trong biểu thức 1-bit, `~a` đảo bit, nhưng với vector nó đảo mọi bit. Hằng có kích thước rõ: `4'b1010`, `8'hA5`, `5'd17`. Phép nối `{carry,sum}` và slice `[3:0]` phải khớp độ rộng.

### 6.3 Mạch tổ hợp

Dùng `assign` hoặc `always_comb`. Mọi đường thực thi trong `always_comb` phải gán output; thiếu nhánh thường suy ra latch ngoài ý muốn.

```systemverilog
module and_or_core (
    input  logic x, y, z,
    output logic f
);
    assign f = ((~x) & y) | (y & z);
endmodule
```

Ví dụ `case` nên có default:

```systemverilog
always_comb begin
    result = '0;
    case (opcode)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        2'b11: result = a | b;
        default: result = '0;
    endcase
end
```

Ở `always_comb`, dùng blocking `=` theo quy ước. Đặt giá trị mặc định trước case giúp mọi nhánh đều định nghĩa output.

### 6.4 Phép cộng/trừ có độ rộng

Một mẫu unsigned 4-bit có carry:

```systemverilog
logic [4:0] add_ext;
assign add_ext = {1'b0, a} + {1'b0, b};
assign sum     = add_ext[3:0];
assign carry   = add_ext[4];
```

Mẫu cộng/trừ bù hai:

```systemverilog
logic [3:0] b_adjusted;
logic [4:0] arithmetic_ext;
assign b_adjusted    = b ^ {4{subtract}};
assign arithmetic_ext = {1'b0, a} + {1'b0, b_adjusted} + subtract;
assign result         = arithmetic_ext[3:0];
assign carry_out      = arithmetic_ext[4];
```

Khi `subtract=1`, carry-out thường diễn giải là no-borrow. Với phép toán logic, quy định `carry_out` (thường 0) thay vì để không xác định. Kiểm tra độ rộng RHS và signedness; literal unsized đôi khi tạo kết quả khác dự định.

### 6.5 Mạch tuần tự

Dùng `always_ff` và nonblocking `<=` cho thanh ghi. Mạch chỉ cập nhật tại sự kiện clock/reset mô tả.

```systemverilog
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        q <= '0;
    else
        q <= d;
end
```

Đoạn trên reset bất đồng bộ active-high. Reset đồng bộ sẽ kiểm tra `rst` chỉ tại cạnh clock; polarity cũng phải nhất quán với nút board.

Không gán cùng thanh ghi từ nhiều khối `always_ff`. Tránh dùng delay `#` trong RTL tổng hợp; delay thích hợp trong testbench, không tạo phần cứng theo cách ta thường mong đợi.

### 6.6 Core và wrapper

```systemverilog
module boolean_core (
    input  logic x, y, z,
    output logic f
);
    assign f = ((~x) & y) | (y & z);
endmodule

module top_wrapper (
    input  logic [2:0] SW,
    output logic [0:0] LED
);
    boolean_core u_core (
        .x(SW[2]), .y(SW[1]), .z(SW[0]), .f(LED[0])
    );
endmodule
```

Giữ quy ước `SW[2]=x` MSB, `SW[0]=z` LSB nhất quán với truth table. Với output bus nhiều bit, gán mọi bit hoặc slice; không để port top-level thiếu kết nối.

## 7. Mô phỏng và kiểm chứng

### 7.1 Testbench tổ hợp

Với 3 input chỉ có 8 vector; duyệt hết và so với expected vector. Delay testbench chỉ tạo thời gian cho mô phỏng cập nhật, không biểu thị delay mạch tổng hợp.

```systemverilog
module tb;
    logic [2:0] sw;
    logic f;
    localparam logic [7:0] EXPECTED = 8'b00101110;

    dut u_dut (.x(sw[2]), .y(sw[1]), .z(sw[0]), .f(f));

    initial begin
        for (int i = 0; i < 8; i++) begin
            sw = i[2:0];
            #1;
            if (f !== EXPECTED[i])
                $error("Mismatch: xyz=%b, got=%b", sw, f);
        end
        $finish;
    end
endmodule
```

`EXPECTED[i]` nghĩa bit index i chứa giá trị cho minterm i; xây expected vector với quy ước rõ. Với bốn input, có 16 pattern; với ALU 4+4+2 input là 1024 tổ hợp, cần chọn exhaustive hoặc phân lớp test có chủ đích.

### 7.2 Testbench tuần tự

Mạch tuần tự cần reset, clock và trình tự input. Kiểm tra:

- trạng thái reset sau khi assert/deassert;
- giá trị trước và sau cạnh clock;
- không đổi ở cạnh không tác động;
- chuỗi hợp lệ, chuỗi sai, rollover, trạng thái biên;
- timer đúng số tick và đầu ra không lệch một chu kỳ.

Ưu tiên scoreboard: tính output mong đợi từ mô hình độc lập, so từng chu kỳ. Testbench không nên chỉ in waveform để người dùng tự nhìn hết mọi trường hợp.

### 7.3 Đọc waveform

Trước mỗi cạnh, input cần ổn định setup-time; sau cạnh, output có thể đổi sau clock-to-Q/delta cycles. Zoom fit, chọn radix phù hợp (binary/decimal/hex), đưa state, timer, tick, input/output lên cùng waveform. `X`/`Z` thường chỉ ra reset chưa khởi tạo, bus chưa lái hoặc nhiều driver, không phải giá trị logic hợp lệ.

## 8. Đồng bộ, timing và clocking

### 8.1 Clock và clock enable

Clock 100 MHz có chu kỳ 10 ns. Để tạo tick 1 Hz dạng một chu kỳ clock, đếm 100,000,000 cạnh; để tạo square wave 1 Hz, toggle mỗi 50,000,000 cạnh. Hai khái niệm khác nhau:

- **1 Hz pulse/enable**: thường chỉ HIGH một chu kỳ 10 ns mỗi giây.
- **1 Hz square wave**: chu kỳ 1 s, HIGH 0.5 s và LOW 0.5 s; có một cạnh lên mỗi giây.

Trên FPGA, ưu tiên giữ một clock chuẩn và dùng clock enable cho bộ đếm/FSM chậm. Logic clock chia tự tạo có thể gây clock-routing/timing issues nếu dùng không đúng clocking resources/constraints.

### 8.2 Setup, hold và propagation

D phải ổn định trước cạnh lấy mẫu đủ setup time và sau cạnh đủ hold time. Q đổi sau `tCQ`; cổng tổ hợp gây `t_comb`. Đường đồng bộ khái niệm cần:

```
Tclk ≥ tCQ(max) + tcomb(max) + tsetup + uncertainty/skew
```

Hold là kiểm tra đường ngắn nhất; tăng chu kỳ clock không tự sửa lỗi hold. Trên FPGA, dựa vào timing report và constraints, không kết luận chỉ từ behavioral simulation.

### 8.3 Input bất đồng bộ, synchronizer và debounce

Nút nhấn, switch và tín hiệu ngoài không đồng bộ với clock FPGA. Có ba bài toán riêng:

1. **Synchronize**: thường hai FF nối tiếp giảm xác suất metastability lan vào logic.
2. **Debounce**: chỉ chấp nhận mức mới sau khi ổn định đủ lâu.
3. **Edge detect**: biến mức nhấn kéo dài thành một sự kiện một chu kỳ.

Synchronizer không debounce; debounce không đồng nghĩa edge detect. Không lấy từng bit của bus bất đồng bộ qua các synchronizer độc lập rồi giả định cả bus nhất quán; bus CDC cần handshake/FIFO/encoding thích hợp. Mọi reset deassertion cũng cần xem xét đồng bộ theo hướng dẫn thiết kế.

### 8.4 Reset

Xác định reset assert/deassert polarity và hành vi state/output/timer. Reset bất đồng bộ có thể assert nhanh nhưng deassert gần cạnh clock có rủi ro; trong thiết kế FPGA thường đồng bộ hóa deassertion nếu reset đi vào logic đồng bộ. Không để reset switch thả nổi. Khi đổi reset style, update testbench và constraints.

## 9. Bộ đếm, timer và FSM

### 9.1 Counter modulo

Counter n bit tự nhiên quay vòng modulo `2^n`. Bộ đếm modulo M dùng ít nhất `ceil(log2(M))` bit và phải chỉ rõ next-state tại M−1 cùng các mã còn lại.

Ví dụ counter 3-bit tăng:

```
000→001→010→011→100→101→110→111→000
```

Down counter 3-bit modulo 8 đi ngược vòng: `000→111→110→…→001→000`. Nếu yêu cầu reset về 0 nhưng chu trình từ 5 đến 14, phải định nghĩa state sau reset và lần cập nhật đầu tiên; không để 15 tự nhiên quay về 0 nếu yêu cầu 14→5.

### 9.2 Timer

Một timer gồm counter và điều kiện terminal. Tính tần số tick trước; không giảm timer mỗi chu kỳ 100 MHz nếu ý định là mỗi giây. Quy định rõ:

- timer load bao nhiêu khi vào state;
- event nào giảm timer;
- khi count bằng 0 thì chuyển ngay hay sau tick kế;
- số hiển thị là số giây còn lại hay số giây đã trôi;
- timer có reset khi state/mode đổi không.

Bốn nhãn số `3,2,1,0` mỗi nhãn giữ đủ một giây tương đương bốn giây. Nếu pha cần đúng ba giây, phải định nghĩa 0 ở ranh giới hoặc chỉ hiển thị 3,2,1 mỗi giây.

### 9.3 FSM có phương pháp

Quy trình:

1. Xác định thông tin quá khứ cần nhớ; lịch sử nào dẫn tới tương lai khác nhau thì cần state phân biệt.
2. Liệt kê trạng thái và output; chọn Moore (output chỉ theo state) hay Mealy (output theo state+input).
3. Xác định reset state và mọi chuyển trạng thái với tất cả inputs.
4. Lập state transition table, output table; xử lý state encoding không hợp lệ.
5. Suy ra RTL và test tất cả cạnh/chuỗi biên.

Ví dụ Moore FSM đếm số bit 1 modulo 3: states R0,R1,R2; khi X=0 giữ state, khi X=1 tăng residue; output HIGH tại R0. Nếu thêm điều kiện "đã nhận ít nhất một zero", cần nhớ thêm thông tin đã thấy zero; nếu không, reset state có thể phát output HIGH sai.

Ví dụ traffic light nên có state NS_GREEN, NS_YELLOW, EW_GREEN, EW_YELLOW; timer điều khiển pha; không nối output đèn trực tiếp theo switch để bỏ qua vàng. Khi mode đổi giữa pha, cần quy tắc an toàn và reset timer nhất quán.

### 9.4 Moore/Mealy và mã hóa state

Moore output đổi sau khi state register cập nhật, thường ổn định dễ kiểm tra. Mealy output có thể đổi ngay khi input đổi giữa hai cạnh, phản ứng nhanh hơn nhưng dễ glitch và cần input ổn định. Binary encoding tiết kiệm FF; one-hot dùng nhiều FF hơn nhưng có thể đơn giản hóa logic/đạt timing tốt tùy công cụ. Không tối ưu mã hóa trước khi thiết kế đúng chức năng.

## 10. Thiết bị hiển thị và liên kết ngoài

### 10.1 7-segment

Chốt thứ tự bit trước khi dùng bảng mã. Với `{g,f,e,d,c,b,a}` active-low, số 0 bật a–f, tắt g nên mã `1000000`. Nếu dùng `{a,b,c,d,e,f,g}`, pattern phải đảo thứ tự. Nexys A7 có anode digit và cathode segment tích cực thấp; kiểm tra đúng XDC/board documentation.

Một digit: decode BCD → cathode segments, bật đúng một anode. Nhiều digit: time multiplex, tắt digit trước khi đổi cathode để tránh ghosting; quét đủ nhanh để mắt thấy ổn định nhưng tránh tần số gây nhấp nháy. Driver display nên độc lập FSM/timer.

### 10.2 Pmod, LED và mức điện áp

XDC dùng tên port logic như JA1, không phải chân FPGA package pin. Copy chính xác `PACKAGE_PIN` và `IOSTANDARD` từ Master XDC board cụ thể. Nexys A7 Pmod dùng I/O mức 3.3 V. Không giả định board đã có điện trở hạn dòng phù hợp; vẫn lắp resistor ngoài theo yêu cầu lab. Khi nối LED breadboard, lắp resistor cho mỗi LED, dùng GND chung và không đưa 5 V vào FPGA I/O.

Nếu điện áp logic hai bên khác nhau, dùng level shifter phù hợp. Không coi chân Pmod VCC là ngõ output. Không nối output push-pull của FPGA với output khác.

## 11. Vivado: từ source đến board

1. Tạo project và chọn đúng part/board (ví dụ Nexys A7-100T khác 50T).
2. Thêm design source `.sv` và testbench vào Simulation Sources; chọn đúng file type/SystemVerilog.
3. Đặt wrapper làm synthesis top; chọn testbench làm simulation top khi chạy behavioral simulation.
4. Chạy simulation, kiểm tra waveform/scoreboard.
5. Thêm đúng Master XDC; mở constraint và uncomment/chỉnh `get_ports` cho đúng tên top-level.
6. Chạy synthesis, đọc warnings/latches/unconnected ports; mở RTL Viewer để hiểu cấu trúc suy ra.
7. Chạy implementation, kiểm tra timing/DRC, tạo bitstream.
8. Kết nối board qua Hardware Manager, program device và thử input/output vật lý.

RTL Viewer là biểu diễn sau elaboration/synthesis; nó có thể khác sơ đồ cổng nguồn vì logic được tối ưu hoặc đóng gói vào LUT. Sự tương đương chức năng phải được chứng minh bằng testbench và phép đo, không bằng hình dạng sơ đồ.

XDC là constraint gắn tên port tới pin và I/O standard; nó không thay thế RTL. Mọi port dùng trên board phải có mapping đúng. Sai tên port, chọn nhầm 50T/100T, hoặc bỏ sót clock constraint có thể làm thiết kế không chạy/không đạt timing.

## 12. Đo lường, báo cáo và truy vết lỗi

### 12.1 Ba mức xác minh

- **Lý thuyết**: bảng, phương trình, state trace dự đoán.
- **Simulation**: RTL tạo hành vi gì với test inputs/clocks.
- **Hardware**: board/IC thực quan sát gì.

Ghi riêng ba kết quả này. Khi khác nhau, xác định tầng sai: đặc tả/logic, testbench, synthesis/constraint, wiring/pinout, hoặc giới hạn quan sát/timing.

### 12.2 Debug theo triệu chứng

| Triệu chứng | Kiểm tra theo thứ tự |
|---|---|
| Output tổ hợp sai | thứ tự biến/bus → truth table → biểu thức → polarity → gán output đủ nhánh |
| Counter nhảy nhiều | bounce, clock edge, reset, divider ratio, rollover |
| FSM đi sai state | state encoding, input sampling edge, state table đủ hàng, reset value |
| 7-seg sai số/đảo | gfedcba mapping, active-low, AN enable, digit order, XDC ports |
| Board không phản ứng nhưng simulation đúng | synthesis top, constraints/pin map, bitstream/device, I/O voltage, button polarity |
| Waveform có X | reset chưa assert, signal không driven, thiếu assignment, nhiều driver |
| Vivado báo latch | thiếu assignment trong nhánh `always_comb` |

### 12.3 Ghi báo cáo có thể tái hiện

Báo cáo nên nêu phiên bản manual/board/tool, module top, clock/reset polarity, mapping input/output, test vectors, expected vs simulation vs measured, pinout/sơ đồ, ảnh waveform/RTL Viewer/board và mọi giả định. Không ghi kết quả đo dựa trên giá trị lý thuyết.

## 13. Bộ câu hỏi tự kiểm tra

1. Bus `4'b1111` có giá trị nào? Trả lời cần nêu unsigned hay signed.
2. Vì sao carry-out không thể thay cho signed overflow?
3. Với `xyz=101`, minterm index là mấy theo quy ước x MSB?
4. MUX khác thanh ghi ở điểm nào? Decoder active-low làm đổi phép ghép output ra sao?
5. Vì sao `A−B` qua adder cần cộng thêm 1 sau khi đảo B?
6. Vì sao D input phải ổn định quanh cạnh clock? Setup/hold khác propagation delay thế nào?
7. Clock square 1 Hz cần toggle bao lâu một lần? Khác pulse enable 1 Hz thế nào?
8. Synchronizer có debounce không? Một nút giữ lâu có thể tạo nhiều sự kiện ra sao?
9. Vì sao một FSM cần transition table trước khi code? Điều gì xảy ra khi thiếu default trong logic tổ hợp?
10. Vì sao một digit 7-segment có thể hiển thị đúng nhưng hai digit multiplex lại ghosting?
11. Simulation đúng nhưng board sai: kể ít nhất năm điểm cần kiểm.
12. Pmod 3.3 V có thể nối thẳng với mạch TTL 5 V không? Cần kiểm gì trước?

## 14. Lộ trình học gợi ý

- **Nền tảng**: hệ đếm, bit-width, Boolean, truth table, minterm/K-map.
- **Tổ hợp**: cổng, NAND/NOR, MUX, decoder, adder, ALU.
- **HDL**: module, bus, operators, `assign`, `always_comb`, độ rộng/signedness.
- **Kiểm chứng**: testbench exhaustive nhỏ, scoreboard, waveform.
- **Tuần tự**: DFF, reset, counter, timer, FSM, setup/hold.
- **FPGA**: clock enable, CDC/debounce, display multiplex, XDC, synthesis/implementation, timing.
- **Tích hợp**: core-wrapper, PMOD, breadboard, đo lường, báo cáo.

Mỗi cấp nên hoàn tất bài nhỏ, mô phỏng và kiểm tra trên phần cứng trước khi thêm tính năng. Giữ phiên bản hoạt động đã kiểm chứng để có thể quay lại khi tích hợp bị lỗi.

## 15. Tài liệu liên quan trong workspace

- `manual_1.md` đến `manual_5.md`: yêu cầu và diễn giải từng Lab.
- `tutorial.tex`: giáo trình nền sâu hơn về số học, Boolean, IC, WaveForms, FSM, SystemVerilog, Vivado, clock/reset, debounce, 7-segment và tích hợp.
- `Digital_Design_CC_Laboratory_Manual_NexysA7_S261.pdf`: manual gốc của học phần.
- AMD, *Vivado Design Suite User Guide: Synthesis (UG901)*: hỗ trợ SystemVerilog và cấu trúc tổng hợp.
- Digilent, *Nexys A7 Reference Manual* và `Nexys-A7-100T-Master.xdc`: phần cứng board, connector, chân và I/O standard.

Tài liệu này là bản tổng hợp học tập, không thay thế datasheet IC, schematic board, XDC chính thức hay timing constraints của thiết kế cụ thể.