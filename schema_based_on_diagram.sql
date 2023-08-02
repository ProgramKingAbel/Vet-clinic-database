CREATE TABLE patients (
  id INT,
  name VARCHAR(255),
  date_of_birth DATE,
  PRIMARY KEY(id)
);

CREATE TABLE invoices (
  id INT,
  total_amount DECIMAL(10, 2),
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history_id INT REFERENCES medical_histories(id),
  PRIMARY KEY(id)
);