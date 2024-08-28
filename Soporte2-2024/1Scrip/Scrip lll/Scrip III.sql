CREATE DATABASE Aeropuerto4;
GO
USE Aeropuerto4;
GO

-- Eliminar claves foráneas en las tablas que dependen de Country
ALTER TABLE City_Airport DROP CONSTRAINT FK_City_Airport_City;
ALTER TABLE City_Airport DROP CONSTRAINT FK_City_Airport_Airport;
ALTER TABLE City DROP CONSTRAINT FK_City_Country;
ALTER TABLE FlightNumber DROP CONSTRAINT FK_FlightNumber_StartAirportID;
ALTER TABLE FlightNumber DROP CONSTRAINT FK_FlightNumber_GoalAirportID;
ALTER TABLE PlaneModel DROP CONSTRAINT FK_PlaneModel_Airplane;
ALTER TABLE Seat DROP CONSTRAINT FK_Seat_PlaneModel;
ALTER TABLE Flight DROP CONSTRAINT FK_Flight_FlightNumber;
ALTER TABLE AvailableSeat DROP CONSTRAINT FK_AvailableSeat_Flight;
ALTER TABLE AvailableSeat DROP CONSTRAINT FK_AvailableSeat_Seat;
ALTER TABLE Coupon DROP CONSTRAINT FK_Coupon_Ticket;
ALTER TABLE Coupon DROP CONSTRAINT FK_Coupon_Flight;
ALTER TABLE Coupon DROP CONSTRAINT FK_Coupon_AvailableSeat;
ALTER TABLE PiecesOfLuggage DROP CONSTRAINT FK_PiecesOfLuggage_Coupon;
ALTER TABLE Customer DROP CONSTRAINT FK_Customer_FrequentFlyerCard;
ALTER TABLE Customer DROP CONSTRAINT FK_Customer_Document;

-- Verificar y eliminar tablas si existen
IF OBJECT_ID('dbo.PiecesOfLuggage', 'U') IS NOT NULL DROP TABLE dbo.PiecesOfLuggage;
IF OBJECT_ID('dbo.Coupon', 'U') IS NOT NULL DROP TABLE dbo.Coupon;
IF OBJECT_ID('dbo.Ticket', 'U') IS NOT NULL DROP TABLE dbo.Ticket;
IF OBJECT_ID('dbo.AvailableSeat', 'U') IS NOT NULL DROP TABLE dbo.AvailableSeat;
IF OBJECT_ID('dbo.Flight', 'U') IS NOT NULL DROP TABLE dbo.Flight;
IF OBJECT_ID('dbo.Seat', 'U') IS NOT NULL DROP TABLE dbo.Seat;
IF OBJECT_ID('dbo.PlaneModel', 'U') IS NOT NULL DROP TABLE dbo.PlaneModel;
IF OBJECT_ID('dbo.Airplane', 'U') IS NOT NULL DROP TABLE dbo.Airplane;
IF OBJECT_ID('dbo.FlightNumber', 'U') IS NOT NULL DROP TABLE dbo.FlightNumber;
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID('dbo.FrequentFlyerCard', 'U') IS NOT NULL DROP TABLE dbo.FrequentFlyerCard;
IF OBJECT_ID('dbo.Document', 'U') IS NOT NULL DROP TABLE dbo.Document;
IF OBJECT_ID('dbo.City_Airport', 'U') IS NOT NULL DROP TABLE dbo.City_Airport;
IF OBJECT_ID('dbo.Airport', 'U') IS NOT NULL DROP TABLE dbo.Airport;
IF OBJECT_ID('dbo.City', 'U') IS NOT NULL DROP TABLE dbo.City;
IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL DROP TABLE dbo.Country;



-- Tabla para Country 
CREATE TABLE Country
(
    id_country INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Tabla para City
CREATE TABLE City
(
    id_city INT IDENTITY(1,1) PRIMARY KEY,
    id_country INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_country) REFERENCES Country(id_country)
);

-- Tabla para Airport
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) -- nombre del aeropuerto
);

-- Tabla para City_Airport 
CREATE TABLE City_Airport
(
    id_city INT,
    id_airport INT,
    PRIMARY KEY (id_city, id_airport),
    FOREIGN KEY (id_city) REFERENCES City(id_city),
    FOREIGN KEY (id_airport) REFERENCES Airport(AirportID)
);

-- Tabla para Document 
CREATE TABLE Document
(
    id_document INT IDENTITY PRIMARY KEY,
    description VARCHAR(50) NOT NULL
);

-- Tabla para Frequent Flyer Card
CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY, -- Numero de tarjeta del viajero 
    Miles INT,                 -- Millas acumuladas 
    MealCode VARCHAR(50)       -- Codigo del tipo de comida preferida por el cliente
);

-- Tabla para Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),			-- nombre del cliente 
    DateOfBirth DATE,           -- fecha de nacimiento
    FFCNumber INT NULL FOREIGN KEY REFERENCES FrequentFlyerCard(FFCNumber), -- numero de tarjeta de viajero frecuente 
    id_document INT FOREIGN KEY (id_document) REFERENCES Document(id_document)
);

-- Tabla para Flight Number
CREATE TABLE FlightNumber (
    FlightNumberID INT PRIMARY KEY IDENTITY(1,1),
    DepartureTime TIME,			-- hora de salida del vuelo
    Description VARCHAR(255),	-- descripcion 
    Type VARCHAR(50),			-- tipo de vuelo (nacional, internacional)
    Airline VARCHAR(50),		-- nombre de la aerolínea que opera ejemplo (boa)
    StartAirportID INT FOREIGN KEY REFERENCES Airport(AirportID),	-- identificador del origen 
    GoalAirportID INT FOREIGN KEY REFERENCES Airport(AirportID)	-- identificador del destino 
);

-- Tabla para Airplane
CREATE TABLE Airplane (
    RegistrationNumber VARCHAR(50) PRIMARY KEY,
    BeginOfOperation DATE,		-- Fecha en la que el avión comenzó a operar
    Status VARCHAR(50)			-- Estado operativo del avión (activo, en mantenimiento, retirado, etc.)
);

-- Tabla para Plane Model
CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(100),	-- Descripción del modelo del avión
    Graphic VARBINARY(MAX) NULL,
    RegistrationNumber VARCHAR(50) FOREIGN KEY REFERENCES Airplane(RegistrationNumber) -- Número de registro del avión asociado
);

-- Tabla para Seat
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    Size VARCHAR(50),			-- Tamaño del asiento.
    Number INT,					-- Número del asiento.
    Location VARCHAR(50),		-- Ubicación del asiento
    PlaneModelID INT FOREIGN KEY REFERENCES PlaneModel(PlaneModelID) -- Identificador del modelo del avión 
);

-- Tabla para Flight
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    BoardingTime TIME,			-- Hora de abordaje del vuelo
    FlightDate DATE,			-- Fecha del vuelo
    Gate VARCHAR(50),			-- Puerta de embarque asignada para el vuelo
    CheckInCounter VARCHAR(50), -- Facturación asignada para el vuelo
    FlightNumberID INT FOREIGN KEY REFERENCES FlightNumber(FlightNumberID) -- Identificador del número de vuelo
);

-- Tabla para Available Seat
CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY IDENTITY(1,1),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID), -- Identificador del vuelo al que pertenece este asiento disponible
    SeatID INT FOREIGN KEY REFERENCES Seat(SeatID)		  -- Identificador del asiento disponible
);

-- Tabla para Ticket
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    TicketingCode VARCHAR(50),	-- Código de ticket usado para identificar el boleto
    Number INT,					-- Número del ticket
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) -- Identificador del cliente
);

-- Tabla para Coupon
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    DateOfRedemption DATE,		-- Fecha de redención del cupón
    Class VARCHAR(50),			-- Clase de servicio a la que aplica el cupón (económica, business, primera clase)
    Standby BIT,				-- Indica si el cupón es para un asiento en standby
    MealCode VARCHAR(50),		-- Código de comida 
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID), -- Identificador del ticket
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID),
    AvailableSeatID INT FOREIGN KEY REFERENCES AvailableSeat(AvailableSeatID)
);

-- Tabla para Pieces of Luggage
CREATE TABLE PiecesOfLuggage (
    LuggageID INT PRIMARY KEY IDENTITY(1,1),
    Number INT,           -- Número de piezas de equipaje
    Weight DECIMAL(5, 2), -- Peso total del equipaje en kilogramos
    CouponID INT NULL FOREIGN KEY REFERENCES Coupon(CouponID)
);

-------------------------------------INSERCION DE DATOS A LAS TABLAS-----------------------------------------
-- Insertar datos en la tabla Country

INSERT INTO Country (name) VALUES
('USA'),
('Canada'),
('UK'),
('Germany'),
('France'),
('Australia'),
('Japan'),
('Brazil'),
('India'),
('United Arab Emirates');

-- Insertar datos en la tabla City

INSERT INTO City (id_country, name) VALUES
(1, 'New York'),
(1, 'Los Angeles'),
(2, 'Toronto'),
(2, 'Vancouver'),
(3, 'London'),
(3, 'Manchester'),
(4, 'Berlin'),
(4, 'Munich'),
(5, 'Paris'),
(5, 'Marseille');

-- Insertar datos en la tabla Airport

INSERT INTO Airport (Name) VALUES
('John F. Kennedy International Airport'),
('Los Angeles International Airport'),
('Toronto Pearson International Airport'),
('Vancouver International Airport'),
('Heathrow Airport'),
('Gatwick Airport'),
('Berlin Tegel Airport'),
('Munich Airport'),
('Charles de Gaulle Airport'),
('Orly Airport');

-- Insertar datos en la tabla City_Airport

INSERT INTO City_Airport (id_city, id_airport) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

-- Insertar datos en la tabla Document

INSERT INTO Document (description) VALUES
('Passport'),
('License'),
('National ID'),
('Residence Permit'),
('Military ID'),
('Health Card'),
('Student ID'),
('Work Permit'),
('Visa'),
('Travel Document');

-- Insertar datos en la tabla FrequentFlyerCard

INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode) VALUES
(1001, 5000, 'Veg'),
(1002, 12000, 'Non-Veg'),
(1003, 8000, 'Gluten-Free'),
(1004, 25000, 'Kosher'),
(1005, 15000, 'Halal'),
(1006, 3000, 'Veg'),
(1007, 22000, 'Non-Veg'),
(1008, 10000, 'Gluten-Free'),
(1009, 18000, 'Kosher'),
(1010, 16000, 'Halal');

-- Insertar datos en la tabla Customer

INSERT INTO Customer (Name, DateOfBirth, FFCNumber, id_document) VALUES
('John Doe', '1985-03-15', 1001, 1),
('Jane Smith', '1990-07-22', 1002, 2),
('Alice Johnson', '1982-11-05', 1003, 3),
('Bob Brown', '1978-06-30', 1004, 4),
('Carol White', '1995-09-25', 1005, 5),
('David Lee', '1987-04-18', 1006, 6),
('Emma Wilson', '1992-10-02', 1007, 7),
('Frank Harris', '1980-12-17', 1008, 8),
('Grace Taylor', '1988-08-30', 1009, 9),
('Hannah Clark', '1993-02-12', 1010, 10);

-- Insertar datos en la tabla FlightNumber

INSERT INTO FlightNumber (DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID) VALUES
('08:00:00', 'Flight to LA', 'International', 'Delta', 1, 2),
('10:00:00', 'Flight to Toronto', 'International', 'American', 1, 3),
('14:00:00', 'Flight to London', 'International', 'British Airways', 2, 5),
('17:00:00', 'Flight to Berlin', 'International', 'Lufthansa', 2, 7),
('20:00:00', 'Flight to Paris', 'International', 'Air France', 3, 9),
('09:00:00', 'Flight to Vancouver', 'International', 'WestJet', 1, 4),
('12:00:00', 'Flight to Manchester', 'International', 'Jet2', 2, 6),
('15:00:00', 'Flight to Munich', 'International', 'Lufthansa', 2, 8),
('18:00:00', 'Flight to Marseille', 'International', 'EasyJet', 3, 10),
('21:00:00', 'Flight to Sydney', 'International', 'Qantas', 4, 5);

-- Insertar datos en la tabla Airplane

INSERT INTO Airplane (RegistrationNumber, BeginOfOperation, Status) VALUES
('N12345', '2010-01-01', 'Active'),
('N67890', '2015-03-15', 'Active'),
('N11223', '2005-07-30', 'In Maintenance'),
('N44556', '2020-06-20', 'Active'),
('N78901', '2018-12-25', 'Retired'),
('N23456', '2012-05-10', 'Active'),
('N34567', '2017-11-22', 'Active'),
('N45678', '2011-08-15', 'In Maintenance'),
('N56789', '2019-09-30', 'Active'),
('N67891', '2022-01-05', 'Retired');

-- Insertar datos en la tabla PlaneModel

INSERT INTO PlaneModel (Description, Graphic, RegistrationNumber) VALUES
('Boeing 737', NULL, 'N12345'),
('Airbus A320', NULL, 'N67890'),
('Boeing 747', NULL, 'N11223'),
('Airbus A380', NULL, 'N44556'),
('Boeing 787', NULL, 'N78901'),
('Airbus A330', NULL, 'N23456'),
('Boeing 767', NULL, 'N34567'),
('Airbus A340', NULL, 'N45678'),
('Boeing 787 Dreamliner', NULL, 'N56789'),
('Airbus A350', NULL, 'N67891');

-- Insertar datos en la tabla Seat

INSERT INTO Seat (Size, Number, Location, PlaneModelID) VALUES
('Economy', 1, 'Aisle', 1),
('Economy', 2, 'Window', 1),
('Business', 3, 'Aisle', 2),
('First Class', 4, 'Window', 3),
('Economy', 5, 'Middle', 4),
('Business', 6, 'Aisle', 5),
('Economy', 7, 'Window', 6),
('First Class', 8, 'Aisle', 7),
('Economy', 9, 'Middle', 8),
('Business', 10, 'Window', 9);

-- Insertar datos en la tabla Flight

INSERT INTO Flight (BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID) VALUES
('07:00:00', '2024-09-01', 'A1', 'Counter 1', 1),
('09:00:00', '2024-09-02', 'B2', 'Counter 2', 2),
('13:00:00', '2024-09-03', 'C3', 'Counter 3', 3),
('16:00:00', '2024-09-04', 'D4', 'Counter 4', 4),
('19:00:00', '2024-09-05', 'E5', 'Counter 5', 5),
('08:00:00', '2024-09-06', 'F6', 'Counter 6', 6),
('11:00:00', '2024-09-07', 'G7', 'Counter 7', 7),
('14:00:00', '2024-09-08', 'H8', 'Counter 8', 8),
('17:00:00', '2024-09-09', 'I9', 'Counter 9', 9),
('20:00:00', '2024-09-10', 'J10', 'Counter 10', 10);

-- Insertar datos en la tabla AvailableSeat

INSERT INTO AvailableSeat (FlightID, SeatID) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(3, 9),
(3, 10);

-- Insertar datos en la tabla Ticket

INSERT INTO Ticket (TicketingCode, Number, CustomerID) VALUES
('TK1001', 1, 1),
('TK1002', 2, 2),
('TK1003', 3, 3),
('TK1004', 4, 4),
('TK1005', 5, 5),
('TK1006', 6, 6),
('TK1007', 7, 7),
('TK1008', 8, 8),
('TK1009', 9, 9),
('TK1010', 10, 10);

-- Insertar datos en la tabla Coupon

INSERT INTO Coupon (DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID, AvailableSeatID) VALUES
('2024-08-01', 'Economy', 0, 'Veg', 1, 1, 1),
('2024-08-02', 'Business', 0, 'Non-Veg', 2, 2, 2),
('2024-08-03', 'First Class', 1, 'Gluten-Free', 3, 3, 3),
('2024-08-04', 'Economy', 0, 'Kosher', 4, 4, 4),
('2024-08-05', 'Business', 1, 'Halal', 5, 5, 5),
('2024-08-06', 'Economy', 0, 'Veg', 6, 6, 6),
('2024-08-07', 'Business', 0, 'Non-Veg', 7, 7, 7),
('2024-08-08', 'First Class', 1, 'Gluten-Free', 8, 8, 8),
('2024-08-09', 'Economy', 0, 'Kosher', 9, 9, 9),
('2024-08-10', 'Business', 1, 'Halal', 10, 10, 10);

-- Insertar datos en la tabla PiecesOfLuggage

INSERT INTO PiecesOfLuggage (Number, Weight, CouponID) VALUES
(1, 23.50, 1),
(2, 30.00, 2),
(3, 15.25, 3),
(4, 25.75, 4),
(5, 40.00, 5),
(1, 22.50, 6),
(2, 28.00, 7),
(3, 16.75, 8),
(4, 27.50, 9),
(5, 35.00, 10);


-- Seleccionar todos los registros de la tabla Country
SELECT * FROM Country;

-- Seleccionar todos los registros de la tabla City
SELECT * FROM City;

-- Seleccionar todos los registros de la tabla Airport
SELECT * FROM Airport;

-- Seleccionar todos los registros de la tabla City_Airport
SELECT * FROM City_Airport;

-- Seleccionar todos los registros de la tabla Document
SELECT * FROM Document;

-- Seleccionar todos los registros de la tabla FrequentFlyerCard
SELECT * FROM FrequentFlyerCard;

-- Seleccionar todos los registros de la tabla Customer
SELECT * FROM Customer;

-- Seleccionar todos los registros de la tabla FlightNumber
SELECT * FROM FlightNumber;

-- Seleccionar todos los registros de la tabla Airplane
SELECT * FROM Airplane;

-- Seleccionar todos los registros de la tabla PlaneModel
SELECT * FROM PlaneModel;

-- Seleccionar todos los registros de la tabla Seat
SELECT * FROM Seat;

-- Seleccionar todos los registros de la tabla Flight
SELECT * FROM Flight;

-- Seleccionar todos los registros de la tabla AvailableSeat
SELECT * FROM AvailableSeat;

-- Seleccionar todos los registros de la tabla Ticket
SELECT * FROM Ticket;

-- Seleccionar todos los registros de la tabla Coupon
SELECT * FROM Coupon;

-- Seleccionar todos los registros de la tabla PiecesOfLuggage
SELECT * FROM PiecesOfLuggage;


----------- Crear índices en atributos que no son claves primarias---------------------------------------------------------

-- Índices en Customer
CREATE INDEX idx_Customer_Name ON Customer(Name);
CREATE INDEX idx_Customer_DateOfBirth ON Customer(DateOfBirth);

-- Índices en FlightNumber
CREATE INDEX idx_FlightNumber_DepartureTime ON FlightNumber(DepartureTime);
CREATE INDEX idx_FlightNumber_Airline ON FlightNumber(Airline);
CREATE INDEX idx_FlightNumber_Type ON FlightNumber(Type);

-- Índices en Airplane
CREATE INDEX idx_Airplane_BeginOfOperation ON Airplane(BeginOfOperation);
CREATE INDEX idx_Airplane_Status ON Airplane(Status);

-- Índices en PlaneModel
CREATE INDEX idx_PlaneModel_Description ON PlaneModel(Description);

-- Índices en Seat
CREATE INDEX idx_Seat_Size ON Seat(Size);
CREATE INDEX idx_Seat_Number ON Seat(Number);

-- Índices en Flight
CREATE INDEX idx_Flight_BoardingTime ON Flight(BoardingTime);
CREATE INDEX idx_Flight_FlightDate ON Flight(FlightDate);
CREATE INDEX idx_Flight_Gate ON Flight(Gate);

-- Índices en AvailableSeat
CREATE INDEX idx_AvailableSeat_FlightID ON AvailableSeat(FlightID);
CREATE INDEX idx_AvailableSeat_SeatID ON AvailableSeat(SeatID);

-- Índices en Ticket
CREATE INDEX idx_Ticket_TicketingCode ON Ticket(TicketingCode);
CREATE INDEX idx_Ticket_Number ON Ticket(Number);

-- Índices en Coupon
CREATE INDEX idx_Coupon_DateOfRedemption ON Coupon(DateOfRedemption);
CREATE INDEX idx_Coupon_Class ON Coupon(Class);
CREATE INDEX idx_Coupon_Standby ON Coupon(Standby);
CREATE INDEX idx_Coupon_MealCode ON Coupon(MealCode);

-- Índices en PiecesOfLuggage
CREATE INDEX idx_PiecesOfLuggage_Number ON PiecesOfLuggage(Number);
CREATE INDEX idx_PiecesOfLuggage_Weight ON PiecesOfLuggage(Weight);

