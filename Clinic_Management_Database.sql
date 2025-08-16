CREATE DATABASE clinic_management;
USE clinic_management;

-- 1. Patients Table (1-to-Many with Appointments)
CREATE TABLE clinicpatients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Doctors Table
CREATE TABLE clinicdoctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. Appointments Table (M-to-M between Patients and Doctors)
CREATE TABLE clinicappointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES clinicpatients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES clinicdoctors(doctor_id) ON DELETE RESTRICT,
    CONSTRAINT unique_doctor_timeslot UNIQUE (doctor_id, appointment_date)
);

-- 4. Medical Records (1-to-1 with Appointments)
CREATE TABLE clinicmedical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL,
    diagnosis TEXT NOT NULL,
    prescription TEXT,
    follow_up_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES clinicappointments(appointment_id) ON DELETE CASCADE
);

-- 5. Medications Table
CREATE TABLE clinicmedications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    unit VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- 6. Prescription_Medications Junction Table (M-to-M between Medical Records and Medications)
CREATE TABLE prescription_medications (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    instructions TEXT,
    FOREIGN KEY (record_id) REFERENCES clinicmedical_records(record_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES clinicmedications(medication_id) ON DELETE RESTRICT
);

-- Inserting Patients
INSERT INTO clinicpatients (national_id, full_name, date_of_birth, gender, phone, email, blood_type) VALUES
('789', 'John Smith', '2001-05-15', 'Male', '555-0101', 'john.smith@email.com', 'O+'),
('321', 'Maria Garcia', '1995-11-22', 'Female', '555-0102', 'mgarcia@email.com', 'A-'),
('389', 'James Wilson', '1992-03-08', 'Male', '555-0103', NULL, 'B+'),
('123', 'Sarah Johnson', '1988-07-30', 'Female', '555-0104', 'sjohnson@email.com', 'AB+'),
('987', 'Robert Chen', '2000-09-14', 'Male', '555-0105', 'r.chen@email.com', 'O-');

-- Inserting Doctors
INSERT INTO clinicdoctors (license_number, full_name, specialization, phone) VALUES
('MD-10001', 'Dr. Emily Parker', 'Cardiology', '555-0201'),
('MD-10002', 'Dr. Michael Brown', 'Pediatrics', '555-0202'),
('MD-10003', 'Dr. Lisa Wong', 'Dermatology', '555-0203'),
('MD-10004', 'Dr. David Kim', 'Orthopedics', '555-0204'),
('MD-10005', 'Dr. Amanda Taylor', 'Neurology', '555-0205');

-- Inserting Appointments
INSERT INTO clinicappointments (patient_id, doctor_id, appointment_date, status, notes) VALUES
(1, 1, '2023-06-15 09:00:00', 'Completed', 'Annual heart checkup'),
(2, 3, '2023-06-15 10:30:00', 'Completed', 'Skin rash examination'),
(3, 2, '2023-06-16 14:00:00', 'Cancelled', 'Patient rescheduled'),
(4, 5, '2023-06-17 11:15:00', 'Completed', 'Migraine evaluation'),
(1, 4, '2023-06-18 13:30:00', 'Scheduled', 'Knee pain follow-up'),
(5, 1, '2023-06-19 15:45:00', 'No-Show', 'Did not arrive for appointment');

-- Insert Medical Records
INSERT INTO clinicmedical_records (appointment_id, diagnosis, prescription, follow_up_date) VALUES
(1, 'Normal cardiac function, slightly elevated blood pressure', 'Lifestyle modifications', '2024-06-15'),
(2, 'Contact dermatitis', 'Topical hydrocortisone 1% cream', '2023-07-15'),
(4, 'Chronic migraine', 'Sumatriptan 50mg as needed', '2023-09-17'),
(5, 'Osteoarthritis in right knee', 'Ibuprofen 400mg every 6 hours as needed', '2023-07-18');

-- Insert Medications
INSERT INTO clinicmedications (name, stock_quantity, unit, price) VALUES
('Hydrocortisone 1% Cream', 150, 'tubes', 8.99),
('Sumatriptan 50mg', 200, 'tablets', 12.50),
('Ibuprofen 400mg', 500, 'tablets', 5.25),
('Amoxicillin 500mg', 300, 'capsules', 7.80),
('Lisinopril 10mg', 400, 'tablets', 9.45);

-- Insert Prescription Medications
INSERT INTO prescription_medications (record_id, medication_id, dosage, duration, instructions) VALUES
(2, 1, 'Apply thin layer', '2 weeks', 'Apply to affected area twice daily'),
(3, 2, '1 tablet', 'as needed', 'Take at onset of migraine, max 2/day'),
(4, 3, '1 tablet', 'every 6 hours', 'Take with food, max 4 tablets daily'),
(1, 5, '1 tablet daily', '30 days', 'Take in morning with water');
