
CREATE TABLE Physician (
  EmployeeID INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Position TEXT NOT NULL,
  SSN INTEGER NOT NULL
);

CREATE TABLE Department (
  DepartmentID INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Head INTEGER NOT NULL,
  CONSTRAINT fk_department_head FOREIGN KEY (Head) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Affiliated_With (
  Physician INTEGER NOT NULL,
  Department INTEGER NOT NULL,
  PrimaryAffiliation BOOLEAN NOT NULL,
  PRIMARY KEY(Physician, Department),
  CONSTRAINT fk_affiliated_physician FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_affiliated_department FOREIGN KEY (Department) REFERENCES Department(DepartmentID)
);

CREATE TABLE MedicalProcedure (
  Code INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Cost REAL NOT NULL
);

CREATE TABLE Trained_In (
  Physician INTEGER NOT NULL,
  Treatment INTEGER NOT NULL,
  CertificationDate TIMESTAMP NOT NULL,
  CertificationExpires TIMESTAMP NOT NULL,
  PRIMARY KEY(Physician, Treatment),
  CONSTRAINT fk_trained_physician FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_trained_treatment FOREIGN KEY (Treatment) REFERENCES MedicalProcedure(Code)
);

CREATE TABLE Patient (
  SSN INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Address TEXT NOT NULL,
  Phone TEXT NOT NULL,
  InsuranceID INTEGER NOT NULL,
  PCP INTEGER NOT NULL,
  CONSTRAINT fk_patient_pcp FOREIGN KEY (PCP) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Nurse (
  EmployeeID INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Position TEXT NOT NULL,
  Registered BOOLEAN NOT NULL,
  SSN INTEGER NOT NULL
);

CREATE TABLE Appointment (
  AppointmentID INTEGER PRIMARY KEY,
  Patient INTEGER NOT NULL,
  PrepNurse INTEGER,
  Physician INTEGER NOT NULL,
  Start TIMESTAMP NOT NULL,
  "End" TIMESTAMP NOT NULL,
  ExaminationRoom TEXT NOT NULL,
  CONSTRAINT fk_appt_patient FOREIGN KEY (Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_appt_nurse FOREIGN KEY (PrepNurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_appt_physician FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID)
);

CREATE TABLE Medication (
  Code INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Brand TEXT NOT NULL,
  Description TEXT NOT NULL
);

CREATE TABLE Prescribes (
  Physician INTEGER NOT NULL,
  Patient INTEGER NOT NULL,
  Medication INTEGER NOT NULL,
  Date TIMESTAMP NOT NULL,
  Appointment INTEGER,
  Dose TEXT NOT NULL,
  PRIMARY KEY(Physician, Patient, Medication, Date),
  CONSTRAINT fk_prescribes_physician FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_prescribes_patient FOREIGN KEY (Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_prescribes_medication FOREIGN KEY (Medication) REFERENCES Medication(Code),
  CONSTRAINT fk_prescribes_appt FOREIGN KEY (Appointment) REFERENCES Appointment(AppointmentID)
);

CREATE TABLE Block (
  Floor INTEGER NOT NULL,
  Code INTEGER NOT NULL,
  PRIMARY KEY(Floor, Code)
);

CREATE TABLE Room (
  Number INTEGER PRIMARY KEY,
  Type TEXT NOT NULL,
  BlockFloor INTEGER NOT NULL,
  BlockCode INTEGER NOT NULL,
  Unavailable BOOLEAN NOT NULL,
  CONSTRAINT fk_room_block FOREIGN KEY (BlockFloor, BlockCode) REFERENCES Block(Floor, Code)
);

CREATE TABLE On_Call (
  Nurse INTEGER NOT NULL,
  BlockFloor INTEGER NOT NULL,
  BlockCode INTEGER NOT NULL,
  Start TIMESTAMP NOT NULL,
  "End" TIMESTAMP NOT NULL,
  PRIMARY KEY(Nurse, BlockFloor, BlockCode, Start, "End"),
  CONSTRAINT fk_oncall_nurse FOREIGN KEY (Nurse) REFERENCES Nurse(EmployeeID),
  CONSTRAINT fk_oncall_block FOREIGN KEY (BlockFloor, BlockCode) REFERENCES Block(Floor, Code)
);

CREATE TABLE Stay (
  StayID INTEGER PRIMARY KEY,
  Patient INTEGER NOT NULL,
  Room INTEGER NOT NULL,
  Start TIMESTAMP NOT NULL,
  "End" TIMESTAMP NOT NULL,
  CONSTRAINT fk_stay_patient FOREIGN KEY (Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_stay_room FOREIGN KEY (Room) REFERENCES Room(Number)
);

CREATE TABLE Undergoes (
  Patient INTEGER NOT NULL,
  Procedure INTEGER NOT NULL,
  Stay INTEGER NOT NULL,
  Date TIMESTAMP NOT NULL,
  Physician INTEGER NOT NULL,
  AssistingNurse INTEGER,
  PRIMARY KEY(Patient, Procedure, Stay, Date),
  CONSTRAINT fk_undergoes_patient FOREIGN KEY (Patient) REFERENCES Patient(SSN),
  CONSTRAINT fk_undergoes_procedure FOREIGN KEY (Procedure) REFERENCES MedicalProcedure(Code),
  CONSTRAINT fk_undergoes_stay FOREIGN KEY (Stay) REFERENCES Stay(StayID),
  CONSTRAINT fk_undergoes_physician FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
  CONSTRAINT fk_undergoes_nurse FOREIGN KEY (AssistingNurse) REFERENCES Nurse(EmployeeID)
);
