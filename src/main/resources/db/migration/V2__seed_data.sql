-- Seed admin user (BCrypt hash of 'admin123')
INSERT INTO users (username, password, role, enabled) VALUES
('admin', '$2a$10$E9O5YkGq6bJ8o6s1oQ7m2u6T7c0r4r9S1r1i9QxA6fV6RrM1Q1lbe', 'ROLE_ADMIN', true)
ON CONFLICT (username) DO NOTHING;

-- Seed normal user (BCrypt hash of 'user123')
INSERT INTO users (username, password, role, enabled) VALUES
('user', '$2a$10$K8L9mN0pQ1rS2tU3vW4xY5zA6bC7dE8fG9hI0jK1lM2nO3pQ4rS5t', 'ROLE_USER', true)
ON CONFLICT (username) DO NOTHING;

-- Seed categories
INSERT INTO categories (name) VALUES
('Werkzeug'),
('3D-Druck'),
('Elektronik'),
('Sonstiges')
ON CONFLICT (name) DO NOTHING;

-- Seed subcategories
INSERT INTO subcategories (name, category_id) VALUES
('Schrauben', (SELECT id FROM categories WHERE name = 'Werkzeug')),
('Muttern', (SELECT id FROM categories WHERE name = 'Werkzeug')),
('Filament PLA', (SELECT id FROM categories WHERE name = '3D-Druck')),
('Filament PETG', (SELECT id FROM categories WHERE name = '3D-Druck')),
('Widerstände', (SELECT id FROM categories WHERE name = 'Elektronik')),
('Transistoren', (SELECT id FROM categories WHERE name = 'Elektronik'))
ON CONFLICT (name, category_id) DO NOTHING;

-- Seed example items
INSERT INTO items (name, category_id, subcategory_id, quantity, location, description) VALUES
(
    'Kreuzschlitz-Schrauben M4',
    (SELECT id FROM categories WHERE name = 'Werkzeug'),
    (SELECT id FROM subcategories WHERE name = 'Schrauben'),
    150,
    'Schrank links 1',
    'Edelstahl, verschiedene Längen'
),
(
    'PLA Filament Schwarz',
    (SELECT id FROM categories WHERE name = '3D-Druck'),
    (SELECT id FROM subcategories WHERE name = 'Filament PLA'),
    3,
    'Schrank rechts 2',
    '1kg Spulen, 1.75mm'
),
(
    'Widerstände 10kΩ',
    (SELECT id FROM categories WHERE name = 'Elektronik'),
    (SELECT id FROM subcategories WHERE name = 'Widerstände'),
    500,
    'Schrank links 3',
    '1/4W, 5% Toleranz'
);
