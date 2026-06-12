USE sneakerlab;

CREATE TABLE IF NOT EXISTS sneaker_variants (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    sneaker_id INT NOT NULL,
    color      VARCHAR(50) NOT NULL,
    image_url  VARCHAR(255),
    FOREIGN KEY (sneaker_id) REFERENCES sneakers(id) ON DELETE CASCADE
);

SELECT 'sneaker_variants table created successfully!' AS result;
