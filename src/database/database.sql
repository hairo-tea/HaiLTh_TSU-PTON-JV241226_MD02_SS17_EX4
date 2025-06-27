create database session17_ex4;
use session17_ex4;

CREATE TABLE accounts
(
    id      int primary key auto_increment,
    balance decimal not null
);

insert into accounts (id, balance)
values (1, 10000),
       (2, 10000);

#procedure
delimiter //
create procedure transfer_funds(
    id_from int,
    id_to int,
    amount decimal,
    out result varchar(255)
)
begin
    -- khai báo các biến để lưu số lượng tài khoản tìm được
    declare count_id_from int;
    declare count_id_to int;
    declare balance_from decimal;
    declare balance_to decimal;
    -- Kiểm tra tài khoản người gửi và người nhận có tồn tại không?
select count(id) into count_id_from from accounts where id = id_from;
select count(id) into count_id_to from accounts where id = id_to;
-- lấy dố dư tài khoản người gửi
select balance into balance_from from accounts where id = id_from;
#kiểm tra và xử lý
    if count_id_from = 0 then
        set result = 'không tìm thấy người gửi';
    elseif count_id_to = 0 then
        set result = 'không tìm thấy người nhận';
    elseif balance_from - amount < 0 then
        set result = 'Người gửi không đủ số dư';
else
update accounts set balance = balance - amount where id = id_from;
update accounts set balance = balance + amount where id = id_to;
set result = 'Chuyển tiền thành công';
end if;
end //
delimiter ;