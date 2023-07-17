USE migishop;
select * from khachhang;
select * from nhacungcap;
select * from mathang;
select * from chitietdathang;
select * from nhanvien;
select * from dondathang;
select * from loaihang;
-- 1. Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
-- câu lệnh truy vấn thông tin về các công ty khách hàng(kh), nhà cung cấp và sản phẩm mà họ đặt hàng
-- SELECT DISTINCT
-- -- cụ thể em lấy các trường thông tin sau : 
--     kh.makhachhang AS 'Mã cty khách hàng',
--     kh.tencongty AS 'Tên cty khách hàng',
--     ncc.tengiaodich AS 'Tên giao dịch'
-- FROM
--     khachhang kh
--         JOIN
--     dondathang ddh ON kh.makhachhang = ddh.makhachhang
--         JOIN
--     chitietdathang ccdh ON ddh.sohoadon = ccdh.sohoadon
-- 		JOIN
--     mathang mh ON ccdh.mahang = mh.mahang
-- 		JOIN
--     nhacungcap ncc ON mh.macongty = ncc.macongty
-- WHERE
-- -- lọc kết quả khách hàng có tên giao dịch trùng với tên giao dịch của nhà cung cấp
--     kh.tengiaodich = ncc.tengiaodich;
SELECT DISTINCT
    kh.makhachhang AS 'Mã cty khách hàng',
    kh.tencongty AS 'Tên cty khách hàng',
    ncc.tengiaodich AS 'Tên giao dịch'
FROM
    khachhang kh
        JOIN
    dondathang ddh ON kh.makhachhang = ddh.makhachhang
         JOIN
    chitietdathang ccdh ON ddh.sohoadon = ccdh.sohoadon
        RIGHT JOIN
    mathang mh ON ccdh.mahang = mh.mahang
        RIGHT JOIN
    nhacungcap ncc ON mh.macongty = ncc.macongty
WHERE
    kh.tengiaodich = ncc.tengiaodich;

-- 2. Những đơn đặt hàng nào yêu cầu giao hàng ngay tại cty đặt hàng và những đơn đó là
-- của công ty nào?
SELECT 
	sohoadon as 'Đơn đạt hàng số',
    tencongty as 'Công ty đặt hàng', 
    ngaygiaohang as 'Ngày giao hàng',
    noigiaohang as 'Địa chỉ giao hàng'
FROM dondathang ddh JOIN khachhang kh 
ON ddh.noigiaohang = kh.diachi; 
-- 3. Những mặt hàng nào chưa từng được khách hàng đặt mua?
-- exits dùng để kiểm tra xem 1 câu lệnh select nào đó có trả bản ghi nào không
-- nếu select trả ít nhất 1 bản ghi  = true của exits ngược lại trả về flase
-- not exits ngược câu lệnh exits, nếu not exits đc thỏa mãn nếu select không trả bất kì bản ghi nào
-- SELECT 
--     mahang AS 'Mã hàng',
--     tenhang AS 'Tên mặt hàng khách chưa từng đặt mua'
-- FROM
--     mathang mh
-- WHERE
--     NOT EXISTS( SELECT 
--             mahang
--         FROM
--             chitietdathang ctdh
--         WHERE
--             ctdh.mahang = mh.mahang);
--
SELECT 
    mh.mahang AS 'Mã hàng',
    mh.tenhang AS 'Tên mặt hàng khách chưa từng đặt mua'
FROM
    mathang mh
LEFT JOIN
    chitietdathang ctdh ON mh.mahang = ctdh.mahang
WHERE
    ctdh.mahang IS NULL;

-- 4. Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
-- SELECT 
--     manhanvien AS 'Mã nhân viên',
--     CONCAT_WS(' ', ho, ten) AS 'Họ và tên'
-- FROM
--     nhanvien nv
-- WHERE
--     NOT EXISTS( SELECT 
--             *
--         FROM
--             dondathang ddh
--         WHERE
--             nv.manhanvien = ddh.manhanvien);
-- where not exit kiểm tra xem có bất kì bản ghi nào trong bảng ddh mà có mã nv tương ứng với mã nv trong bản nv hay không, nếu không
-- có nv sẽ đc lấy ra
SELECT 
    nhanvien.manhanvien AS 'Mã nhân viên',
    CONCAT_WS('.' ,nhanvien.ho, nhanvien.ten) AS 'Họ và tên'
FROM
    nhanvien
        LEFT JOIN
    dondathang ON nhanvien.manhanvien = dondathang.manhanvien
WHERE
    dondathang.manhanvien IS NULL;
-- left join lấy ra tất cả bản ghi từ bảng nv và những bản ghi từ bảng ddh 
-- có giá trị trùng với manv,Các bản ghi của bảng nv mà không có bản ghi trong bảng ddh
-- sẽ có giá trị null cho các cột trong bảng ddh
-- where dondathang.manhanvien IS NULL sẽ chỉ lấy những bản ghi trong bảng nv mà ko 
-- có bất kì bản ghi nào trong bảng ddh có giá trị trùng với manv
-- 5. Trong năm 2003, những mặt hàng nào chỉ được đặt mua đúng một lần
--  Đối với lệnh ANY thì biểu thức ANY (câu lệnh SELECT) sẽ trả về giá trị TRUE nếu cột column có thể kết hợp với
-- ít nhất một giá trị bên trong cột dữ liệu (được trả về từ câu lệnh SELECT) làm cho biểu thức column value thỏa điều kiện.
SELECT mh.mahang AS 'Mã mặt hàng', mh.tenhang AS 'Tên hàng'
FROM mathang mh
JOIN chitietdathang ctdh ON mh.mahang = ctdh.mahang
JOIN dondathang ddh ON ctdh.sohoadon = ddh.sohoadon
WHERE YEAR(ddh.ngaydathang) = 2023
GROUP BY mh.mahang, mh.tenhang
HAVING COUNT(*) = 1;

-- 6. Hãy cho biết mỗi một khách hàng đã phải bỏ ra bao nhiêu tiền để đặt mua hàng của
-- công ty? // de ma khach hang bo bao nhieu tien thi ta tinh tong giaBan x soluonh - giaban x soluong x giamgia
SELECT 
    ddh.makhachhang AS 'Mã khách hàng', 
    kh.tencongty AS 'Tên cty khách hàng', 
    COALESCE(SUM(ctdh.giaban*ctdh.soluong - giaban*soluong*mucgiamgia),0) AS "Số tiền bỏ ra để mua" 
FROM khachhang kh 
RIGHT JOIN dondathang ddh ON ddh.makhachhang = kh.makhachhang 
LEFT JOIN chitietdathang ctdh ON ctdh.sohoadon = ddh.sohoadon 
GROUP BY ddh.makhachhang;
-- 7. Mỗi một nhân viên của công ty đã lập bao nhiêu đơn đặt hàng (nếu nhân viên chưa hề
-- lập một hoá đơn nào thì cho kết quả là 0)
SELECT 
    nv.manhanvien AS 'Mã nhân viên',
    CONCAT_WS(' ', ho, ten) AS 'Họ và tên',
    COALESCE(COUNT(sohoadon), 0) AS 'Số lượng hóa đơn'
FROM
    nhanvien nv
        LEFT JOIN
    dondathang ddh ON nv.manhanvien = ddh.manhanvien
GROUP BY ddh.manhanvien , ho , ten
ORDER BY COUNT(sohoadon) DESC;
-- UNION distinct
-- select nv.manhanvien , CONCAT_WS( " ", ho , ten) as 'Họ và tên', count(*) = 0 as "Số lượng hóa đơn" from nhanvien nv left outer join dondathang ddh
-- on nv.manhanvien = ddh.manhanvien group by ddh.manhanvien, ho, ten;
-- 8. Cho biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2003 (thời
-- được gian tính theo ngày đặt hàng).
select    
sum(case month(ngaydathang) when 1 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 1' ,
sum(case month(ngaydathang) when 2 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 2' ,
sum(case month(ngaydathang) when 3 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 3' ,
sum(case month(ngaydathang) when 4 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 4' ,
sum(case month(ngaydathang) when 5 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 5' ,
sum(case month(ngaydathang) when 6 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 6' ,
sum(case month(ngaydathang) when 7 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 7' ,
sum(case month(ngaydathang) when 8 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 8' ,
sum(case month(ngaydathang) when 9 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 9' ,
sum(case month(ngaydathang) when 10 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 10' ,
sum(case month(ngaydathang) when 11 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 11' ,
sum(case month(ngaydathang) when 12 then soluong * giaban * mucgiamgia
else 0 end) as 'Tháng 12' 
FROM
    chitietdathang ctdh
        JOIN
    dondathang ddh ON ctdh.sohoadon = ddh.sohoadon
WHERE
    YEAR(ngaydathang) = 2023;

-- không sử dụng được left hay right vì join sẽ chỉ trả về các hàng trong đó có ít nhất một giá trị khớp trong cả hai bảng. mà left or r
-- sẽ trả về tất cả các hàng từ bảng bên trái hoặc bên phải bao gồm các hàng không có khớp trong bảng kia.
-- 9. Hãy cho biết tổng số lượng hàng của mỗi mặt hàng mà cty đã có (tổng số lượng hàng
-- hiện có và đã bán).
select 
	mh.mahang as 'Mã hàng' ,
    mh.tenhang as 'Tên hàng', 
    sum(mh.soluong) as 'Tổng hàng',
    coalesce(sum(ctdh.soluong),0) as "Số lượng hàng đã bán" ,
	coalesce(sum(mh.soluong - ctdh.soluong),mh.soluong) as "Số lượng hàng còn" 
from mathang mh 
left join chitietdathang ctdh on mh.mahang =  ctdh.mahang
group by mh.mahang , mh.tenhang;


-- 10. Nhân viên nào của cty bán được số lượng hàng nhiều nhất và số lượng hàng bán được
-- của nhân viên này là bao nhiêu?
SELECT nv.manhanvien AS 'Mã nhân viên',
       CONCAT_WS(' ', nv.ho, nv.ten) AS 'Họ và tên',
       COALESCE(SUM(ctdh.soluong), 0)  AS 'Số lượng hàng bán được'
FROM nhanvien nv
LEFT JOIN dondathang ddh ON nv.manhanvien = ddh.manhanvien
LEFT JOIN chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
GROUP BY nv.manhanvien, nv.ho, nv.ten
ORDER BY SUM(ctdh.soluong) DESC;
-- nếu muốn lấy toàn bộ danh sách nhân viên bao gồm cả những nhân viên chưa từng bán hàng, sử dụng left

-- 11. Mỗi một đơn đặt hàng đặt mua những mặt hàng nào và tổng số tiền mà mỗi đơn đặt
-- hàng phải trả là bao nhiêu? 

SELECT mh.mahang AS 'Mã hàng',
       mh.tenhang AS 'Tên hàng',
       ddh.sohoadon AS 'Hóa đơn số',
       ctdh.soluong * giaban - ctdh.giaban * ctdh.soluong * mucgiamgia AS "Số tiền phải trả"
FROM dondathang ddh
LEFT JOIN chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
JOIN mathang mh ON ctdh.mahang = mh.mahang
ORDER BY ddh.sohoadon;
-- 12. Hãy cho biết mỗi một loại hàng bao gồm những mặt hàng nào, tổng số lượng hàng của
-- mỗi loại và tổng số lượng của tất cả các mặt hàng hiện có trong công ty là bao nhiêu?
SELECT  lh.maloaihang AS 'Mã loại hàng',
       tenloaihang AS 'Tên loại hàng', 
       tenhang AS 'Tên hàng', 
	   sum(mh.soluong) as "Tổng số lượng hàng " ,
	   coalesce(sum(mh.soluong - ctdh.soluong),mh.soluong) as "Số lượng hàng còn của công ty" 
FROM loaihang lh 
Left JOIN mathang mh ON lh.maloaihang = mh.maloaihang 
Left JOIN chitietdathang ctdh ON mh.mahang = ctdh.mahang
group by lh.maloaihang, tenloaihang, tenhang;

-- 13. Thống kê xem trong năm 2003, mỗi một mặt hàng trong mỗi tháng và trong cả năm bán
-- được với số lượng bao nhiêu.
select 
	ctdh.mahang as 'Mã hàng', tenhang as 'Tên hàng' , 
    sum(case month(ngaydathang) when 1 then ctdh.soluong 
else 0 end) as 'Tháng 1' ,
 sum(case month(ngaydathang) when 2 then ctdh.soluong 
else 0 end) as 'Tháng 2',
 sum(case month(ngaydathang) when 3 then ctdh.soluong 
else 0 end) as 'Tháng 3',
 sum(case month(ngaydathang) when 4 then ctdh.soluong 
else 0 end) as 'Tháng 4',
 sum(case month(ngaydathang) when 5 then ctdh.soluong 
else 0 end) as 'Tháng 5',
 sum(case month(ngaydathang) when 6 then ctdh.soluong 
else 0 end) as 'Tháng 6',
 sum(case month(ngaydathang) when 7 then ctdh.soluong 
else 0 end) as 'Tháng 7',
 sum(case month(ngaydathang) when 8 then ctdh.soluong 
else 0 end) as 'Tháng 8',
 sum(case month(ngaydathang) when 9 then ctdh.soluong 
else 0 end) as 'Tháng 9',
 sum(case month(ngaydathang) when 10 then ctdh.soluong 
else 0 end) as 'Tháng 10',
 sum(case month(ngaydathang) when 11 then ctdh.soluong 
else 0 end) as 'Tháng 11',
 sum(case month(ngaydathang) when 12 then ctdh.soluong 
else 0 end) as 'Tháng 12', sum(ctdh.soluong) as 'Cả Năm'
from(dondathang ddh join chitietdathang ctdh on ddh.sohoadon = ctdh.sohoadon)
join mathang mh on ctdh.mahang = mh.mahang 
where year(ngaydathang) = 2023
group by ctdh.mahang, tenhang;
-- 14. Cập nhật lại giá trị NGAYCHUYENHANG của những bản ghi có giá trị
-- NGAYCHUYENHANG chưa xác định (NULL) trong bảng DONDATHANG bằng với giá
-- trị của trường NGAYDATHANG.
-- set SQL_SAFE_UPDATES=0;
-- UPDATE dondathang 
-- SET 
--     ngaychuyenhang = ngaydathang
-- WHERE
--     ngaychuyenhang IS NULL;
--   
-- lấy ra
select dd.sohoadon,dd.ngaydathang, dd.ngaychuyenhang as 'Ngày chuyển hàng', dd.ngaydathang as 'Sau khi cập nhật'
from dondathang as dd 
where dd.ngaychuyenhang is null;

-- 15. Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG bằng địa chỉ
-- của khách hàng đối với những đơn đặt hàng chưa xác định được nơi giao hàng (có giá
-- trị trường NOIGIAOHANG bằng NULL)
-- set SQL_SAFE_UPDATES=0;
-- UPDATE dondathang ddh
--         JOIN
--     khachhang kh ON ddh.makhachhang = kh.makhachhang 
-- SET 
--     ddh.noigiaohang = kh.diachi
-- WHERE
--     ddh.noigiaohang IS NULL;
-- lấy ra
SELECT ddh.sohoadon, kh.diachi AS 'Địa chỉ giao hàng', ddh.noigiaohang AS 'Nơi giao hàng' ,kh.diachi AS 'Nơi giao hàng '
FROM dondathang ddh
JOIN khachhang kh ON ddh.makhachhang = kh.makhachhang 
WHERE ddh.noigiaohang IS NULL;

-- 16. Cập nhật lại dữ liệu trong bảng KHACHHANG sao cho nếu tên công ty và tên giao dịch
-- của khách hàng trùng với tên công ty và tên giao dịch của một nhà cung cấp nào đó thì
-- địa chỉ, điện thoại, fax và email phải giống nhau.
set SQL_SAFE_UPDATES=0;
UPDATE khachhang kh
        JOIN
    nhacungcap ncc ON kh.tencongty = ncc.tencongty
        AND kh.tengiaodich = ncc.tengiaodich 
SET 
    kh.diachi = ncc.diachi,
    kh.dienthoai = ncc.dienthoai,
    kh.fax = ncc.fax,
    kh.email = ncc.email;
-- 17. Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100
-- trong năm 2003
-- UPDATE nhanvien nv 
-- SET 
--     luongcoban = luongcoban * 1.5
-- WHERE
--     manhanvien = (SELECT 
--             manhanvien
--         FROM
--             dondathang ddh
--                 JOIN
--             chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
--         WHERE
--             manhanvien = nv.manhanvien
-- 		and year(ddh.ngaydathang) = 2023
-- GROUP BY manhanvien
-- HAVING sum(ctdh.soluong) > 100);
-- lấy ra
SELECT 
    nv.manhanvien as 'Mã nhân viên', 
    CONCAT_WS(' ', nv.ho, nv.ten) AS 'Họ và tên',
    nv.luongcoban as 'Lương cơ bản' ,
    nv.luongcoban * 1.5 AS 'Lương sau khi tăng'
FROM
    nhanvien nv
WHERE
    nv.manhanvien IN (SELECT 
            ddh.manhanvien
FROM dondathang ddh
                JOIN
            chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
where year(ddh.ngaydathang) = 2023
GROUP BY ddh.manhanvien
HAVING sum(ctdh.soluong) > 100);
-- 18. Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.
-- UPDATE nhanvien nv 
-- SET 
--     phucap = luongcoban / 2
-- WHERE
--     manhanvien IN (SELECT 
--             manhanvien
--         FROM
--             dondathang ddh
--                 JOIN
--             chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
--         GROUP BY manhanvien
--         HAVING SUM(soluong) >= ALL (SELECT 
--                 SUM(soluong)
--             FROM
--                 chitietdathang
--             GROUP BY manhanvien));
--
SELECT 
    nv.manhanvien,
     CONCAT_WS(' ', nv.ho, nv.ten) AS 'Họ và tên',
    IF(SUM(soluong) >= ALL(SELECT SUM(soluong) FROM chitietdathang  GROUP BY nv.manhanvien),
    nv.luongcoban/2, nv.phucap) AS 'Lương phụ cấp mới'
FROM 
    nhanvien nv
    LEFT JOIN dondathang ddh ON nv.manhanvien = ddh.manhanvien
    LEFT JOIN chitietdathang ctdh ON ddh.sohoadon = ctdh.sohoadon
GROUP BY 
    nv.manhanvien
Limit 1;

-- -- 19. Giảm 25% lương của những nhân viên trong năm 2003 ko lập được bất kỳ đơn đặt
-- -- hàng nào
-- UPDATE nhanvien nv
-- LEFT JOIN dondathang ddh ON nv.manhanvien = ddh.manhanvien
-- SET nv.luongcoban = nv.luongcoban * 0.85
-- WHERE ddh.manhanvien IS NULL;
-- SELECT 
--     nv.manhanvien AS 'Mã nhân viên',
--     CONCAT_WS(' ', nv.ho, nv.ten) AS 'Họ và tên',
--     nv.luongcoban as 'Lương cơ bản hiện tại',
-- 	nv.luongcoban * 0.75 as 'Lương sau khi trừ'
-- FROM
--     nhanvien nv
--         LEFT JOIN
--     dondathang ddh ON nv.manhanvien = ddh.manhanvien
-- WHERE  ddh.manhanvien IS NULL ;
SELECT 
		nv.manhanvien as 'Mã NV', 
	    nv.luongcoban as 'Lương cơ bản', 
        (nv.luongcoban * 0.75) AS 'Lương sau giảm 25% lương'
FROM nhanvien AS nv
LEFT JOIN (
    SELECT DISTINCT ddh.manhanvien
    FROM dondathang AS ddh
    JOIN chitietdathang AS ctdh ON ddh.sohoadon = ctdh.sohoadon
    WHERE YEAR(ddh.ngaydathang) = 2023
) AS ddh ON nv.manhanvien = ddh.manhanvien
WHERE ddh.manhanvien IS NULL
GROUP BY nv.manhanvien, nv.luongcoban;
-- -- 20. Giả sử trong bảng DONDATHANG có them trường SOTIEN cho biết số tiền mà khách
-- -- hàng phải trả trong mỗi dơnđặt hàng. Hãy tính giá trị cho trường này.
-- UPDATE dondathang
-- SET sotien = (
--     SELECT SUM(soluong * giaban + soluong * giaban * mucgiamgia)
--     FROM chitietdathang ctdh
--     WHERE chitietdathang.sohoadon = dondathang.sohoadon
--     GROUP BY sohoadon
-- );
SELECT  
    ddh.sohoadon as 'Số hóa đơn', 
    SUM(soluong * giaban + soluong * giaban * mucgiamgia) as 'Số tiền khách hàng phải trả' 
FROM chitietdathang ctdh 
JOIN dondathang ddh ON ctdh.sohoadon = ddh.sohoadon 
GROUP BY ddh.sohoadon;

-- -- 21. Xoá khỏi bảng MATHANG những mặt hàng có số lượng bằng 0 và không được đặt mua
-- -- trong bất kỳ đơn đặt hàng nào.
delete from mathang mh 
where soluong = 0 and not exists (
select sohoadon from chitietdathang 
where mahang = mh.mahang);
-- -- 3. Yêu cầu nâng cao
-- -- 1. Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới cho
-- bảng MATHANG (thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cần bổ sung:
-- không trùng khoá chính và đảm bảo toàn vẹn tham chiếu)
DELIMITER //
CREATE PROCEDURE sp_insert_mathang(
    IN p_mahang VARCHAR(10),
    IN p_tenhang NVARCHAR(50),
    IN p_macongty VARCHAR(10),
    IN p_maloaihang INT,
    IN p_soluong INT,
    IN p_donvitinh NVARCHAR(20),
    IN p_giahang DECIMAL(18,2) 
)
BEGIN
    IF NOT EXISTS(SELECT mahang FROM mathang WHERE mahang = p_mahang) THEN
            INSERT INTO mathang (mahang, tenhang, macongty, maloaihang, soluong, donvitinh, giahang)
            VALUES (p_mahang, p_tenhang, p_macongty, p_maloaihang, p_soluong, p_donvitinh, p_giahang);
        END IF;
-- 	END IF;
END //
DELIMITER ;
-- Lệnh DELIMITER được sử dụng để thay đổi delimiter mặc định (";") sang delimiter mới ("//") để phân tách các câu lệnh trong thủ tục.
drop procedure sp_insert_mathang;
CALL sp_insert_mathang('MH005', 'pen', 'cty03', 2, 34, 'VND', 500000);
delete from mathang where mahang = 'MH005';
-- 3. Viết trigger cho bảng CHITIETDATHANG theo yêu cầu sau:
--  Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng hiện có nếu
-- số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. Ngược lại thì
-- huỷ bỏ thao tác bổ sung.
DELIMITER $$
CREATE TRIGGER trg_chitietdathang_insert
 AFTER INSERT ON chitietdathang
 FOR EACH ROW
 BEGIN
   DECLARE mahang VARCHAR(10);
   DECLARE soluongban INT;
   DECLARE soluongcon INT;
   SELECT mahang, soluong INTO mahang, soluongban FROM inserted;
   SELECT soluong INTO soluongcon FROM mathang WHERE mahang = mahang;
   IF soluongcon >= soluongban THEN
     UPDATE mathang SET soluong = soluong - soluongban WHERE mahang = mahang;
   ELSE
     SIGNAL SQLSTATE '45000' 
     SET MESSAGE_TEXT = 'Số lượng hàng trong kho không đủ để thực hiện đặt hàng.';
   END IF;
END $$
DELIMITER ;
DROP TRIGGER trg_chitietdathang_insert;
SHOW TRIGGERS;
--  Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập nhật lại có
-- phù hợp hay không (số lượng hàng bán ra không được vượt quá số lượng hàng hiện
-- có và không được nhỏ hơn 1). Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng hàng
-- hiện có trong công ty, ngược lại thì huỷ bỏ thao tác cập nhật.
DELIMITER $$
CREATE TRIGGER trg_chitietdathang_update
 AFTER UPDATE ON chitietdathang
 FOR EACH ROW
 BEGIN
     IF NEW.soluong <> OLD.soluong THEN
         IF EXISTS(SELECT sohoadon FROM inserted WHERE soluong < 0) THEN
             SIGNAL SQLSTATE '45000' 
             SET MESSAGE_TEXT = 'Số lượng sản phẩm không hợp lệ.';
         ELSE
             UPDATE mathang SET soluong = soluong - (
                 SELECT SUM(inserted.soluong - deleted.soluong)
                 FROM inserted INNER JOIN deleted
                 ON inserted.sohoadon = deleted.sohoadon AND inserted.mahang = deleted.mahang
                 WHERE inserted.mahang = mathang.mahang
                 GROUP BY inserted.mahang
             )
             WHERE mahang IN (
                 SELECT DISTINCT mahang FROM inserted
             );
             IF EXISTS(SELECT mahang FROM mathang WHERE soluong < 0) THEN
                 SIGNAL SQLSTATE '45000' 
                 SET MESSAGE_TEXT = 'Không đủ sản phẩm để cập nhật.';
             END IF;
         END IF;
     END IF;
END $$
DELIMITER ;
DROP TRIGGER trg_chitietdathang_update;
SHOW TRIGGERS;
-- 4. Viết trigger cho bảng CHITIETDATHANG để sao cho chỉ chấp nhận giá hàng bán ra
-- phải nhỏ hơn hoặc bằng giá gốc (giá của mặt hàng trong bảng MATHANG)
DELIMITER $$
CREATE TRIGGER trg_chitietdathang_giaban
AFTER UPDATE ON chitietdathang
FOR EACH ROW
BEGIN
    IF NEW.giaban <> OLD.giaban THEN
        IF EXISTS (
            SELECT mahang
            FROM mathang
            WHERE mahang = NEW.mahang AND giahang > NEW.giaban
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá bán không hợp lệ!';
        END IF;
    END IF;
END $$
DELIMITER ;

-- Để xóa trigger, sử dụng câu lệnh:
-- DROP TRIGGER trg_chitietdathang_giaban;

-- Để hiển thị danh sách các trigger, sử dụng câu lệnh:
-- SHOW TRIGGERS;

DROP TRIGGER trg_chitietdathang_giaban;
SHOW TRIGGERS;




