# EXP_5 — Z=1 theo điều kiện số bit nhận

## Đặc tả
Z=1 khi (a) tổng số bit 1 đã nhận chia hết cho 3 (modulo-3 residue = 0),
và (b) tổng số bit 0 là số chẵn **lớn hơn 0**.
Input X được lấy mẫu theo clock 1 Hz, X=SW[0], Z=LED[0].
Không có `valid`; do đó mỗi clock là một bit nhận được.
Sau reset chưa nhận bit nào: số zero là 0, nên Z=0 do điều kiện "greater than 0".

## State (r, p, v)
- `r ∈ {0,1,2}` là số bit 1 modulo 3.
- `p ∈ {even,odd}` là parity số bit 0.
- `v` cho biết đã nhận ít nhất một bit 0.

Với X=1: `r←(r+1) mod 3`, p và v giữ. Với X=0: r giữ, p đảo, v←1.
Moore output: Z = 1 iff r=0 AND p=even AND v=1.

Reset đặt `r=0,p=even,v=0`, nên Z=0 tại reset. Đây cần tối đa 12 tổ hợp tuple
nhưng chỉ 9 trạng thái reachable.

## Lưu ý đặc tả
Nếu bỏ `v`, trạng thái reset có r=0 và parity-even sẽ phát Z=1 ngay,
trái điều kiện số zero phải lớn hơn 0.
Kiểm tra chuỗi: reset; `111` (ba bit 1, chưa zero → Z=0); thêm `0` (zero count lẻ → Z=0);
thêm `0` nữa (zero count chẵn dương, số bit 1 vẫn chia hết cho 3 → Z=1).

## Pin (Nexys A7)
- CLK100MHZ, BTNC (reset), SW[0]=x, LED[0]=z.

## Bình luận
- Testbench kiểm tra chuỗi hợp lệ, sai thứ tự, reset và biên.
