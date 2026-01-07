CREATE TABLE IF NOT EXISTS tenants ( 
id SERIAL PRIMARY KEY, 
name VARCHAR(100), 
email VARCHAR(100), 
created_at TIMESTAMP DEFAULT NOW() 
); 
CREATE TABLE IF NOT EXISTS contracts ( 
id SERIAL PRIMARY KEY, 
tenant_id INT, 
start_date DATE, 
amount DECIMAL(10, 2) 
); 
CREATE TABLE IF NOT EXISTS invoices ( 
id SERIAL PRIMARY KEY, 
contract_id INT, 
issue_date DATE, 
total_amount DECIMAL(10, 2), 
status VARCHAR(20) 
); 
CREATE TABLE IF NOT EXISTS payments ( 
id SERIAL PRIMARY KEY, 
invoice_id INT, 
payment_date DATE, 
amount DECIMAL(10, 2) 
); -- TRUNCATE TABLE payments, invoices, contracts, tenants RESTART 
IDENTITY; 
INSERT INTO tenants (name, email, created_at) 
SELECT  
'Tenant_Company_' || i,  
'contact_' || i || '@example.com', 
NOW() - (random() * (INTERVAL '5 years')) -- FROM 
generate_series(1, 100000) AS i; -- Перевірка: 
24 -- SELECT count(*) FROM tenants; -- Має бути 100,000 
INSERT INTO contracts (tenant_id, start_date, amount) 
SELECT  
floor(random() * 100000 + 1)::int, 
NOW() - (random() * (INTERVAL '2 years')), 
(random() * 5000 + 100)::decimal(10,2) 
FROM generate_series(1, 150000) AS i; 
INSERT INTO invoices (contract_id, issue_date, total_amount, status) 
SELECT  
floor(random() * 150000 + 1)::int, 
NOW() - (random() * (INTERVAL '1 year')), 
(random() * 5000 + 100)::decimal(10,2), 
CASE WHEN random() > 0.1 THEN 'PAID' ELSE 'PENDING' END -- 
90% оплачені 
FROM generate_series(1, 600000) AS i;  
INSERT INTO payments (invoice_id, payment_date, amount) 
SELECT  
id, 
issue_date + (random() * (INTERVAL '5 days')), 
total_amount 
FROM invoices 
WHERE status = 'PAID'; 
SELECT 'Tenants' as table_name, count(*) as count FROM tenants 
UNION ALL 
SELECT 'Contracts', count(*) FROM contracts 
UNION ALL 
SELECT 'Invoices (Facts)', count(*) FROM invoices 
UNION ALL 
SELECT 'Payments (Facts)', count(*) FROM payments; 