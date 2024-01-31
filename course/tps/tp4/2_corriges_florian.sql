CREATE TABLE  products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2),
    in_stock INT
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    desription VARCHAR(255) ,
    picture VARCHAR(255) 

);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    compagny_name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255) NOT NULL,
    contact_title VARCHAR(255) NOT NULL,
    adress VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL

);


ALTER TABLE products
ADD COLUMN category_id INTEGER,
ADD FOREIGN KEY (category_id) REFERENCES categories(category_id);
ALTER TABLE products
ADD COLUMN supplier_id INTEGER,
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);






INSERT INTO categories (category_name, desription, picture) VALUES ('Catégorie 1', 'Description 1', 'image1.jpg');
INSERT INTO categories (category_name, desription, picture) VALUES ('Catégorie 2', 'Description 2', 'image2.jpg');



INSERT INTO suppliers (compagny_name, contact_name, contact_title, adress, city) VALUES ('Fournisseur 1', 'Contact 1', 'Titre 1', 'Adresse 1', 'Ville 1');
INSERT INTO suppliers (compagny_name, contact_name, contact_title, adress, city) VALUES ('Fournisseur 2', 'Contact 2', 'Titre 2', 'Adresse 2', 'Ville 2');



SELECT * FROM products