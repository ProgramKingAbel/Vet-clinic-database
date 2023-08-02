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

-- Medical histories table 

CREATE TABLE medical_histories (
  id INT,
  admitted_at TIMESTAMP,
  patient_id INT,
  status VARCHAR(255),
  PRIMARY KEY (id)
);

--  treatments table 

CREATE TABLE treatments (
  id INT,
  type VARCHAR(255),
  name VARCHAR(255),
  PRIMARY KEY (id)
);

--junction table for many to many relationship 

CREATE TABLE medical_history_treatments (
  medical_history_id INT,
  treatment_id INT,
  PRIMARY KEY (medical_history_id, treatment_id),
  FOREIGN KEY (medical_history_id) REFERENCES medical_histories (id),
  FOREIGN KEY (treatment_id) REFERENCES treatments (id)
);
