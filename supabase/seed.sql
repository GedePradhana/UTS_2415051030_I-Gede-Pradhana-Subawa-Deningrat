-- Kontrakanku: data awal (jalankan setelah schema.sql)

insert into tenants (name, full_name, room) values
  ('Budi', 'Budi Santoso', 1),
  ('Dimas', 'Dimas Anggara', 2),
  ('Rizky', 'Rizky Ramadhan', 3);

insert into expenses (title, category, amount, expense_date, note) values
  ('Token Listrik Rumah', 'listrik', 300000, '2024-10-25',
   'Token meteran PLN 24 digit untuk lampu, kulkas & colokan.'),
  ('Iuran Wi-Fi Bulanan', 'lainnya', 375000, '2024-10-18',
   'Paket internet Indihome 50 Mbps periode Oktober 2024.'),
  ('Galon Air Aqua (3 Galon)', 'air', 60000, '2024-10-15', null),
  ('Tabung Gas Elpiji 3 Kg', 'gas', 45000, '2024-10-10', null),
  ('Sewa Kontrakan', 'lainnya', 2820000, '2024-10-01', null);

insert into payments (tenant_id, amount, method, paid_at) values
  ((select id from tenants where name = 'Budi'),  1200000, 'tunai',    '2024-10-03'),
  ((select id from tenants where name = 'Dimas'),  600000, 'transfer', '2024-10-05'),
  ((select id from tenants where name = 'Rizky'),  400000, 'tunai',    '2024-10-12'),
  ((select id from tenants where name = 'Dimas'),  200000, 'transfer', '2024-10-25');