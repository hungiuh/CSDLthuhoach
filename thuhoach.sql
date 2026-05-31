-- tao csdl
CREATE DATABASE IF NOT EXISTS hackathon;
USE hackathon;

-- bang creator
CREATE TABLE Creator (
    creator_id VARCHAR(5) PRIMARY KEY,
    creator_name VARCHAR(100) NOT NULL,
    creator_email VARCHAR(100) UNIQUE NOT NULL,
    creator_phone VARCHAR(15) UNIQUE NOT NULL,
    creator_platform VARCHAR(50) NOT NULL
);

-- bang studio
CREATE TABLE Studio (
    studio_id VARCHAR(5) PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL,
    studio_location VARCHAR(100) NOT NULL,
    hourly_price DECIMAL(10,2) NOT NULL,
    studio_status VARCHAR(20) NOT NULL
);

-- bang livesession
CREATE TABLE LiveSession (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id VARCHAR(5) NOT NULL,
    studio_id VARCHAR(5) NOT NULL,
    session_date DATE NOT NULL,
    duration_hours INT NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Creator(creator_id) ON DELETE CASCADE,
    FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE CASCADE
);

-- bang payment
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (session_id) REFERENCES LiveSession(session_id) ON DELETE CASCADE
);

-- chen du lieu
INSERT INTO Creator VALUES
('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

INSERT INTO Studio VALUES
('ST01', 'Studio A', 'Ha Noi', 20.00, 'Available'),
('ST02', 'Studio B', 'HCM', 25.00, 'Available'),
('ST03', 'Studio C', 'Danang', 30.00, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22.00, 'Available'),
('ST05', 'Studio E', 'Can Tho', 18.00, 'Maintenance');

INSERT INTO LiveSession (session_id, creator_id, studio_id, session_date, duration_hours) VALUES
(1, 'CR01', 'ST01', '2025-05-01', 3),
(2, 'CR02', 'ST02', '2025-05-02', 4),
(3, 'CR03', 'ST03', '2025-05-03', 2),
(4, 'CR01', 'ST04', '2025-05-04', 5),
(5, 'CR05', 'ST02', '2025-05-05', 1);

INSERT INTO Payment (payment_id, session_id, payment_method, payment_amount, payment_date) VALUES
(1, 1, 'Cash', 60.00, '2025-05-01'),
(2, 2, 'Credit Card', 100.00, '2025-05-02'),
(3, 3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 4, 'Credit Card', 110.00, '2025-05-04'),
(5, 5, 'Cash', 25.00, '2025-05-05');

-- cap nhat platform cr03
UPDATE Creator SET creator_platform = 'YouTube' WHERE creator_id = 'CR03';

-- cap nhat studio st05
UPDATE Studio SET studio_status = 'Available', hourly_price = hourly_price * 0.9 WHERE studio_id = 'ST05';

-- xoa payment cash truoc mùng 3
DELETE FROM Payment WHERE payment_method = 'Cash' AND payment_date < '2025-05-03';

-- cau 6: studio available gia > 20
SELECT * FROM Studio WHERE studio_status = 'Available' AND hourly_price > 20;

-- cau 7: creator dung tiktok
SELECT creator_name, creator_phone FROM Creator WHERE LOWER(creator_platform) = 'tiktok';

-- cau 8: studio theo gia giam dan
SELECT studio_id, studio_name, hourly_price FROM Studio ORDER BY hourly_price DESC;

-- cau 9: 3 payment credit card dau tien
SELECT * FROM Payment WHERE payment_method = 'Credit Card' LIMIT 3;

-- cau 10: bo 2 ban ghi dau, lay 2 tiep theo
SELECT creator_id, creator_name FROM Creator LIMIT 2 OFFSET 2;

-- p3 danh sach livestream
SELECT ls.session_id, c.creator_name, s.studio_name, ls.duration_hours, p.payment_amount 
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
LEFT JOIN Payment p ON ls.session_id = p.session_id;

-- cau 2: thong ke so lan thue studio
SELECT s.studio_id, s.studio_name, COUNT(ls.session_id) AS times_used 
FROM Studio s
LEFT JOIN LiveSession ls ON s.studio_id = ls.studio_id
GROUP BY s.studio_id, s.studio_name;

-- cau 3: tong doanh thu theo phuong thuc
SELECT payment_method, SUM(payment_amount) AS total_revenue 
FROM Payment GROUP BY payment_method;

-- cau 4: creator co tu 2 session
SELECT c.creator_id, c.creator_name, COUNT(ls.session_id) AS total_sessions 
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
GROUP BY c.creator_id, c.creator_name
HAVING COUNT(ls.session_id) >= 2;

-- cau 5: studio gia cao hon trung binh
SELECT * FROM Studio WHERE hourly_price > (SELECT AVG(hourly_price) FROM Studio);

-- cau 6: creator da live tai studio b
SELECT DISTINCT c.creator_name, c.creator_email 
FROM Creator c
JOIN LiveSession ls ON c.creator_id = ls.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
WHERE s.studio_name = 'Studio B';

-- cau 7: bao cao tong hop
SELECT ls.session_id, c.creator_name, s.studio_name, p.payment_method, p.payment_amount 
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
JOIN Payment p ON ls.session_id = p.session_id;