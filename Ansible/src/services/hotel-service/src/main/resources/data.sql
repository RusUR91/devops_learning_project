-- Вставляем страны без указания ID
INSERT INTO countries (country) VALUES ('Country 1');
INSERT INTO countries (country) VALUES ('Country 2');

-- Вставляем города (используем ID из предыдущих вставок)
INSERT INTO cities (country_id, city) VALUES 
    ((SELECT country_id FROM countries WHERE country = 'Country 1'), 'City 1'),
    ((SELECT country_id FROM countries WHERE country = 'Country 1'), 'City 2'),
    ((SELECT country_id FROM countries WHERE country = 'Country 2'), 'City 3');

-- Вставляем отели
INSERT INTO hotels (hotel_uid, rooms, cost, city_id, hotel_name, address) VALUES 
    ('9d05ba36-bf8d-11eb-8529-0242ac130003', 100, 2000, 
     (SELECT city_id FROM cities WHERE city = 'City 1'), 'Hotel 1', 'Address 1');
INSERT INTO hotels (hotel_uid, rooms, cost, city_id, hotel_name, address) VALUES 
    ('ab84f4e6-bf8d-11eb-8529-0242ac130003', 200, 3000,
     (SELECT city_id FROM cities WHERE city = 'City 2'), 'Hotel 2', 'Address 2');
INSERT INTO hotels (hotel_uid, rooms, cost, city_id, hotel_name, address) VALUES 
    ('b0698102-bf8d-11eb-8529-0242ac130003', 250, 5000,
     (SELECT city_id FROM cities WHERE city = 'City 3'), 'Hotel 3', 'Address 3');
