# PREP 2 — Adder/Subtractor 4 bit

## Đặc tả

A, B 4-bit; `sel=0` chọn A+B, `sel=1` chọn A−B.

## Hai phương pháp

1. Instantiate bốn full-adder từ Prep 1 và mắc carry ripple.
2. Dùng phép toán dữ liệu SystemVerilog, chẳng hạn chọn giữa A+B và A−B bằng mux/if/toán tử điều kiện.

## Điểm cần làm rõ trong code

Kết quả S rộng 4 bit nên là modulo 16. Nếu Ci/Co được xem như cỗ, manual không định nghĩa chính xác cách chúng hoạt động khi trừ.
Một triển khai bù hai chuẩn đặt `B'=B XOR {4{sel}}` và `C0=sel`; khi sel=1, C4=1 thường nghĩa là không mượn.
Nếu viết `A-B` trực tiếp, phép trừ 4-bit bị cắt; cần tính borrow/no-borrow riêng nếu muốn cỗ nhất quán.

**Lỗi trong hint:** đoạn instantiation trên PDF có tên dây Ci/Co bị gõ sai/trùng, và ví dụ `A([1])`, `B([1])` thiếu chỉ số bus. Không chép nguyên xi.
Mỗi FA tầng i nên nhận `A[i]`, `B[i]`, carry-in từ tầng i−1, xuất `S[i]` và carry-out tới tầng i+1.

## Kiểm tra

Để kiểm tra phép trừ và carry, dùng ví dụ `A=3`, `B=5`: kết quả modulo 16 là `1110`; về số nguyên có dấu 4-bit là −2.
Tách rõ "bit pattern kết quả" và "giá trị unsigned/signed".

## Code SystemVerilog (phương pháp 2)

```systemverilog
module addsub_4bit_m2 (
    input  logic [3:0] A, B,
    input  logic       sel,
    output logic [3:0] S,
    output logic       Co
);
    logic [4:0] res;
    assign res = sel ? ({1'b0, A} + {1'b0, ~B} + 5'd1) : ({1'b0, A} + {1'b0, B});
    assign S  = res[3:0];
    assign Co = res[4];  // carry-out of underlying adder
endmodule
```

Ghi rõ quy ước cỗ trong bài nộp và kiểm tra với giảng viên.
