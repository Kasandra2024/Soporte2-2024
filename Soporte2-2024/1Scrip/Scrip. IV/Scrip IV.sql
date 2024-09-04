-- Verificar si la base de datos ya existe
IF DB_ID('Aeropuerto8') IS NULL
BEGIN
    -- Crear la base de datos
    EXEC('CREATE DATABASE Aeropuerto8');
END
GO

-- Uso de la base de datos recién creada
USE Aeropuerto8;
GO




-- Tabla para country 
CREATE TABLE Country
(
    id_country INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
GO
-- Índices en la tabla Country
CREATE INDEX idx_country_name ON Country (name);
GO

-- Tabla para city

CREATE TABLE City
(
    id_city INT IDENTITY(1,1) PRIMARY KEY,
    id_country INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_country) REFERENCES Country(id_country)
);
GO

-- Índices en la tabla City
CREATE INDEX idx_city_name ON City (name);
GO

-- Tabla para Airport
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100)			-- nombre del aeropuerto
);
GO

-- Índices en la tabla Airport
CREATE INDEX idx_airport_name ON Airport (Name);
GO

-- Tabla para City_Airport 

CREATE TABLE City_Airport
(
    id_city INT,
    id_airport INT,
    PRIMARY KEY (id_city, id_airport),
    FOREIGN KEY (id_city) REFERENCES City(id_city),
    FOREIGN KEY (id_airport) REFERENCES Airport(AirportID)
);
GO

-- Índices en la tabla City_Airport
CREATE INDEX idx_city_airport_city ON City_Airport (id_city);
CREATE INDEX idx_city_airport_airport ON City_Airport (id_airport);
GO

---------------------------------------------------

CREATE TABLE CustomerCategory (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL, -- Nombre de la categoría (e.g., Regular, VIP)
    Description VARCHAR(255) -- Descripción de la categoría y sus beneficios
);
GO

-- Índices en la tabla CustomerCategory
CREATE INDEX idx_customer_category_name ON CustomerCategory (CategoryName);
GO


CREATE TABLE Document
(
    id_document INT IDENTITY PRIMARY KEY,
    description VARCHAR(50) NOT NULL
);
GO
-- Índices en la tabla Document
CREATE INDEX idx_document_description ON Document (description);
GO



-- Tabla para Frequent Flyer Card
CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY, --Numero de tarjeta del viajero 
    Miles INT,                 -- Millas acumuladas 
    MealCode VARCHAR(50),       --Codigo del tipo de comida preferida por el cliente.
	StatusLevel VARCHAR(50)     --- Nivel de estatus del viajero frecuente
);
GO
-- Índices en la tabla FrequentFlyerCard
CREATE INDEX idx_ffc_number ON FrequentFlyerCard (FFCNumber);
GO


-- Tabla para Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),			--nombre del cliente 
    DateOfBirth DATE,           --fecha de nacimiento
    FFCNumber INT NULL FOREIGN KEY REFERENCES FrequentFlyerCard(FFCNumber), -- numero de tarjeta de viajero frecuente 
    DocumentID INT FOREIGN KEY REFERENCES Document(id_document),
	CategoryID INT FOREIGN KEY REFERENCES CustomerCategory(CategoryID)   --
);
GO

-- Índices en la tabla Customer
CREATE INDEX idx_customer_name ON Customer (Name);
CREATE INDEX idx_customer_dob ON Customer (DateOfBirth);
GO


-- Tabla para Flight Number

CREATE TABLE FlightNumber (
    FlightNumberID INT PRIMARY KEY IDENTITY(1,1),
    DepartureTime TIME,					-- hora de salida del vuelo
    Description VARCHAR(255),			-- descripcion 
    Type VARCHAR(50),					-- tipo de vuelo (nacional, internacional)
    Airline VARCHAR(50),				-- nombre de la aerolinia que opera ejemplo (boa)
    StartAirportID INT FOREIGN KEY REFERENCES Airport(AirportID),	--identificador del origen 
    GoalAirportID INT FOREIGN KEY REFERENCES Airport(AirportID)		--identificador del destino 
);
GO
-- Índices en la tabla FlightNumber
CREATE INDEX idx_flightnumber_departure ON FlightNumber (DepartureTime);
CREATE INDEX idx_flightnumber_description ON FlightNumber (Description);
GO


-- Tabla para Airplane
CREATE TABLE Airplane (
    RegistrationNumber VARCHAR(50) PRIMARY KEY,
    BeginOfOperation DATE,		-- Fecha en la que el avión comenzó a operar
    Status VARCHAR(50)			--Estado operativo del avión (activo, en mantenimiento, retirado, etc)
);
GO
-- Índices en la tabla Airplane
CREATE INDEX idx_airplane_status ON Airplane (Status);
GO



-- Tabla para Plane Model
CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(100),		-- Descripción del modelo del avión
    Graphic VARBINARY(MAX) NULL,	--
    RegistrationNumber VARCHAR(50) FOREIGN KEY REFERENCES Airplane(RegistrationNumber)--Número de registro del avión asociado
);
GO
-- Índices en la tabla PlaneModel
CREATE INDEX idx_plane_model_description ON PlaneModel (Description);
GO


-- Tabla para Seat
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    Size VARCHAR(50),		--Tamaño del asiento.
    Number INT,				--Numero del asiento.
    Location VARCHAR(50),	--Ubicacion del asiento
    PlaneModelID INT FOREIGN KEY REFERENCES PlaneModel(PlaneModelID) --Identificador del modelo del avión 
);
GO
-- Índices en la tabla Seat
CREATE INDEX idx_seat_size ON Seat (Size);
CREATE INDEX idx_seat_number ON Seat (Number);
GO


-- Tabla para Flight
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    BoardingTime TIME,	--Hora de abordaje del vuelo
    FlightDate DATE,	--Fecha del vuelo.
    Gate VARCHAR(50),	--Puerta de embarque asignada para el vuelo.
    CheckInCounter VARCHAR(50), -- facturación asignado para el vuelo.
	FlightStatus VARCHAR(50) NOT NULL DEFAULT 'Scheduled', -- Estado del vuelo (e.g., Scheduled, Cancelled)
    FlightNumberID INT FOREIGN KEY REFERENCES FlightNumber(FlightNumberID)--Identificador del número de vuelo
);
GO
-- Índices en la tabla Flight
CREATE INDEX idx_flight_boarding_time ON Flight (BoardingTime);
CREATE INDEX idx_flight_gate ON Flight (Gate);
GO

---------------------------------
CREATE TABLE Reservation (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    ReservationCode VARCHAR(50) UNIQUE NOT NULL, -- Código de reserva único
    ReservationDate DATE NOT NULL, -- Fecha en la que se hizo la reserva
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), -- Cliente que hizo la reserva
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID), -- Vuelo reservado
    ReservationStatus VARCHAR(50) NOT NULL, -- Estado de la reserva (e.g., Confirmed, Cancelled)
    PaymentStatus VARCHAR(50) NOT NULL -- Estado del pago (Paid, Pending)
);
GO
-- Índices en la tabla Reservation
CREATE INDEX idx_reservation_code ON Reservation (ReservationCode);
CREATE INDEX idx_reservation_date ON Reservation (ReservationDate);
CREATE INDEX idx_reservation_status ON Reservation (ReservationStatus);
GO

---------------------------------------


-- Tabla para Available Seat
CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY IDENTITY(1,1),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID), --Identificador del vuelo al que pertenece este asiento disponible
    SeatID INT FOREIGN KEY REFERENCES Seat(SeatID),		  --Identificador del asiento disponible
	ReservationID INT NULL FOREIGN KEY REFERENCES Reservation(ReservationID)
);
GO
-- Índices en la tabla AvailableSeat
CREATE INDEX idx_available_seat_flight ON AvailableSeat (FlightID);
CREATE INDEX idx_available_seat_seat ON AvailableSeat (SeatID);
GO

-- Tabla para Ticket
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    TicketingCode VARCHAR(50),	--Código de ticket usado para identificar el boleto
    Number INT,					--Número del ticket.
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), --identificador del cliente
	ReservationID INT NULL FOREIGN KEY REFERENCES Reservation(ReservationID)
);
GO
-- Índices en la tabla Ticket
CREATE INDEX idx_ticket_code ON Ticket (TicketingCode);
CREATE INDEX idx_ticket_number ON Ticket (Number);
GO

-- Tabla para Coupon
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    DateOfRedemption DATE,  -- Fecha de redención del cupón.
    Class VARCHAR(50),		-- Clase de servicio a la que aplica el cupón (económica, business, primera clase).	
    Standby BIT,			-- Indica si el cupón es para un asiento en standby
    MealCode VARCHAR(50),   -- Codigo de comida 
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID), --Identificador del ticket
	FlightID INT FOREIGN KEY REFERENCES Flight(FlightID),
	ReservationID INT NULL FOREIGN KEY REFERENCES Reservation(ReservationID),
	AvailableSeatID INT FOREIGN KEY REFERENCES AvailableSeat(AvailableSeatID)
);
GO
-- Índices en la tabla Coupon
CREATE INDEX idx_coupon_date_of_redemption ON Coupon (DateOfRedemption);
CREATE INDEX idx_coupon_class ON Coupon (Class);
CREATE INDEX idx_coupon_meal_code ON Coupon (MealCode);

-- Tabla para Pieces of Luggage
CREATE TABLE PiecesOfLuggage (
    LuggageID INT PRIMARY KEY IDENTITY(1,1),
    Number INT,           --Número de piezas de equipaje.
    Weight DECIMAL(5, 2), --Peso total del equipaje en kilogramos.
    CouponID INT NUll FOREIGN KEY REFERENCES Coupon(CouponID)
);
GO
-- Índices en la tabla PiecesOfLuggage
CREATE INDEX idx_luggage_number ON PiecesOfLuggage (Number);
CREATE INDEX idx_luggage_weight ON PiecesOfLuggage (Weight);
GO


-- Insertar datos en la tabla Country
INSERT INTO Country (name) VALUES
('United States'),
('Canada'),
('United Kingdom'),
('Germany'),
('France'),
('Italy'),
('Spain'),
('Australia'),
('Japan'),
('China');
GO

-- Insertar datos en la tabla City
INSERT INTO City (id_country, name) VALUES
(1, 'New York'),
(1, 'Los Angeles'),
(2, 'Toronto'),
(3, 'London'),
(4, 'Berlin'),
(5, 'Paris'),
(6, 'Rome'),
(7, 'Madrid'),
(8, 'Sydney'),
(9, 'Tokyo');
GO

-- Insertar datos en la tabla Airport
INSERT INTO Airport (Name) VALUES
('JFK International Airport'),
('LAX International Airport'),
('Toronto Pearson International Airport'),
('Heathrow Airport'),
('Berlin Brandenburg Airport'),
('Charles de Gaulle Airport'),
('Leonardo da Vinci International Airport'),
('Adolfo Suárez Madrid-Barajas Airport'),
('Sydney Airport'),
('Narita International Airport');
GO

-- Insertar datos en la tabla City_Airport
INSERT INTO City_Airport (id_city, id_airport) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10);
GO

-- Insertar datos en la tabla CustomerCategory
INSERT INTO CustomerCategory (CategoryName, Description) VALUES
('Regular', 'Standard customer category'),
('VIP', 'High-priority customers with exclusive benefits'),
('Gold', 'Gold level customers with additional perks'),
('Platinum', 'Platinum level customers with premium benefits'),
('Silver', 'Silver level customers with some extra perks'),
('Bronze', 'Basic level customers with minimal benefits'),
('Frequent Flyer', 'Customers with frequent flyer status'),
('Corporate', 'Corporate customers with special arrangements'),
('Travel Agent', 'Travel agents with special rates'),
('Member', 'Loyalty program members');
GO

-- Insertar datos en la tabla Document
INSERT INTO Document (description) VALUES
('Passport'),
('License'),
('National ID'),
('Birth Certificate'),
('Health Insurance Card'),
('Student ID'),
('Employee ID'),
('Military ID'),
('Residence Permit'),
('Visa');
GO

--Insertar datos en la tabla FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode, StatusLevel) VALUES
(1001, 50000, 'Vegetarian', 'Gold'),
(1002, 30000, 'Non-Vegetarian', 'Silver'),
(1003, 75000, 'Vegan', 'Platinum'),
(1004, 20000, 'Halal', 'Regular'),
(1005, 60000, 'Kosher', 'Gold'),
(1006, 40000, 'Gluten-Free', 'Silver'),
(1007, 100000, 'Seafood', 'Platinum'),
(1008, 15000, 'Diabetic', 'Regular'),
(1009, 80000, 'Low-Carb', 'Gold'),
(1010, 50000, 'Paleo', 'Silver');
GO

-- Insertar datos en la tabla Customer
INSERT INTO Customer (Name, DateOfBirth, FFCNumber, DocumentID, CategoryID) VALUES
('John Doe', '1985-05-15', 1001, 1, 1),
('Jane Smith', '1990-07-22', 1002, 2, 2),
('Alice Johnson', '1982-11-30', 1003, 3, 3),
('Bob Brown', '1978-02-10', 1004, 4, 4),
('Carol Davis', '1995-09-12', 1005, 5, 5),
('David Wilson', '1988-12-01', 1006, 6, 6),
('Emma Garcia', '1992-03-15', 1007, 7, 7),
('Frank Miller', '1986-08-22', 1008, 8, 8),
('Grace Lee', '1980-10-30', 1009, 9, 9),
('Henry Martinez', '1993-04-18', 1010, 10, 10);
GO

-- Insertar datos en la tabla FlightNumber
INSERT INTO FlightNumber (DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID) VALUES
('08:00', 'Flight to London', 'International', 'British Airways', 1, 4),
('12:00', 'Flight to Paris', 'International', 'Air France', 2, 6),
('16:00', 'Flight to Tokyo', 'International', 'Japan Airlines', 3, 10),
('20:00', 'Flight to Sydney', 'International', 'Qantas', 4, 9),
('09:00', 'Flight to Berlin', 'International', 'Lufthansa', 5, 7),
('14:00', 'Flight to Rome', 'International', 'Alitalia', 6, 8),
('18:00', 'Flight to Madrid', 'International', 'Iberia', 7, 9),
('22:00', 'Flight to Toronto', 'International', 'Air Canada', 8, 3),
('11:00', 'Flight to New York', 'International', 'American Airlines', 9, 1),
('15:00', 'Flight to Los Angeles', 'International', 'Delta Air Lines', 10, 2);
GO

-- Insertar datos en la tabla Airplane
INSERT INTO Airplane (RegistrationNumber, BeginOfOperation, Status) VALUES
('N12345', '2010-06-01', 'Active'),
('N67890', '2015-03-15', 'Active'),
('N54321', '2012-08-30', 'In Maintenance'),
('N98765', '2018-11-10', 'Active'),
('N24680', '2014-05-22', 'Retired'),
('N13579', '2016-07-19', 'Active'),
('N86420', '2019-01-05', 'In Maintenance'),
('N11223', '2020-09-15', 'Active'),
('N33445', '2013-10-10', 'Retired'),
('N55667', '2021-06-25', 'Active');
GO

-- Insertar datos en la tabla PlaneModel
INSERT INTO PlaneModel (Description, Graphic, RegistrationNumber) VALUES
('Boeing 737', NULL, 'N12345'),
('Airbus A320', NULL, 'N67890'),
('Boeing 747', NULL, 'N54321'),
('Airbus A380', NULL, 'N98765'),
('Boeing 787', NULL, 'N24680'),
('Airbus A350', NULL, 'N13579'),
('Boeing 767', NULL, 'N86420'),
('Airbus A321', NULL, 'N11223'),
('Boeing 737 MAX', NULL, 'N33445'),
('Airbus A319', NULL, 'N55667');
GO

-- Insertar datos en la tabla Seat
INSERT INTO Seat (Size, Number, Location, PlaneModelID) VALUES
('Economy', 1, 'Aisle', 1),
('Business', 2, 'Window', 1),
('First Class', 3, 'Middle', 2),
('Economy', 4, 'Aisle', 2),
('Business', 5, 'Window', 3),
('Economy', 6, 'Middle', 3),
('First Class', 7, 'Aisle', 4),
('Economy', 8, 'Window', 4),
('Business', 9, 'Middle', 5),
('Economy', 10, 'Aisle', 5);
GO

-- Insertar datos en la tabla Flight
INSERT INTO Flight (BoardingTime, FlightDate, Gate, CheckInCounter, FlightStatus, FlightNumberID) VALUES
('07:00', '2024-10-01', 'G1', 'C1', 'Scheduled', 1),
('12:30', '2024-10-02', 'G2', 'C2', 'Scheduled', 2),
('16:45', '2024-10-03', 'G3', 'C3', 'Scheduled', 3),
('21:00', '2024-10-04', 'G4', 'C4', 'Scheduled', 4),
('10:15', '2024-10-05', 'G5', 'C5', 'Scheduled', 5),
('14:30', '2024-10-06', 'G6', 'C6', 'Scheduled', 6),
('19:00', '2024-10-07', 'G7', 'C7', 'Scheduled', 7),
('23:30', '2024-10-08', 'G8', 'C8', 'Scheduled', 8),
('09:00', '2024-10-09', 'G9', 'C9', 'Scheduled', 9),
('13:15', '2024-10-10', 'G10', 'C10', 'Scheduled', 10);
GO

-- Insertar datos en la tabla Reservation
INSERT INTO Reservation (ReservationCode, ReservationDate, CustomerID, FlightID, ReservationStatus, PaymentStatus) VALUES
('R001', '2024-09-01', 1, 1, 'Confirmed', 'Paid'),
('R002', '2024-09-02', 2, 2, 'Confirmed', 'Pending'),
('R003', '2024-09-03', 3, 3, 'Cancelled', 'Refunded'),
('R004', '2024-09-04', 4, 4, 'Confirmed', 'Paid'),
('R005', '2024-09-05', 5, 5, 'Confirmed', 'Pending'),
('R006', '2024-09-06', 6, 6, 'Confirmed', 'Paid'),
('R007', '2024-09-07', 7, 7, 'Cancelled', 'Pending'),
('R008', '2024-09-08', 8, 8, 'Confirmed', 'Paid'),
('R009', '2024-09-09', 9, 9, 'Confirmed', 'Pending'),
('R010', '2024-09-10', 10, 10, 'Confirmed', 'Paid');
GO

-- Insertar datos en la tabla AvailableSeat
INSERT INTO AvailableSeat (FlightID, SeatID, ReservationID) VALUES
(1, 1, NULL),
(1, 2, NULL),
(2, 3, 1),
(2, 4, NULL),
(3, 5, NULL),
(3, 6, NULL),
(4, 7, 2),
(4, 8, NULL),
(5, 9, NULL),
(5, 10, NULL);
GO

-- Insertar datos en la tabla Ticket
INSERT INTO Ticket (TicketingCode, Number, CustomerID, ReservationID) VALUES
('T001', 1001, 1, 1),
('T002', 1002, 2, 2),
('T003', 1003, 3, 3),
('T004', 1004, 4, 4),
('T005', 1005, 5, 5),
('T006', 1006, 6, 6),
('T007', 1007, 7, 7),
('T008', 1008, 8, 8),
('T009', 1009, 9, 9),
('T010', 1010, 10, 10);
GO

-- Insertar datos en la tabla Coupon
INSERT INTO Coupon (DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID, ReservationID, AvailableSeatID) VALUES
('2024-09-01', 'Economy', 0, 'Vegetarian', 1, 1, 1, 1),
('2024-09-02', 'Business', 1, 'Non-Vegetarian', 2, 2, 2, 2),
('2024-09-03', 'First Class', 0, 'Vegan', 3, 3, 3, 3),
('2024-09-04', 'Economy', 1, 'Halal', 4, 4, 4, 4),
('2024-09-05', 'Business', 0, 'Kosher', 5, 5, 5, 5),
('2024-09-06', 'Economy', 1, 'Gluten-Free', 6, 6, 6, 6),
('2024-09-07', 'First Class', 0, 'Seafood', 7, 7, 7, 7),
('2024-09-08', 'Economy', 1, 'Diabetic', 8, 8, 8, 8),
('2024-09-09', 'Business', 0, 'Low-Carb', 9, 9, 9, 9),
('2024-09-10', 'Economy', 1, 'Paleo', 10, 10, 10, 10);
GO

-- Insertar datos en la tabla PiecesOfLuggage
INSERT INTO PiecesOfLuggage (Number, Weight, CouponID) VALUES
(1, 23.5, 1),
(2, 15.0, 2),
(1, 20.0, 3),
(3, 18.2, 4),
(2, 22.5, 5),
(1, 25.0, 6),
(4, 30.0, 7),
(2, 17.5, 8),
(1, 12.0, 9),
(3, 28.0, 10);
GO


-- Seleccionar todos los datos de la tabla Country
SELECT * FROM Country;

-- Seleccionar todos los datos de la tabla City
SELECT * FROM City;

-- Seleccionar todos los datos de la tabla Airport
SELECT * FROM Airport;

-- Seleccionar todos los datos de la tabla City_Airport
SELECT * FROM City_Airport;

-- Seleccionar todos los datos de la tabla CustomerCategory
SELECT * FROM CustomerCategory;

-- Seleccionar todos los datos de la tabla Document
SELECT * FROM Document;

-- Seleccionar todos los datos de la tabla FrequentFlyerCard
SELECT * FROM FrequentFlyerCard;

-- Seleccionar todos los datos de la tabla Customer
SELECT * FROM Customer;

-- Seleccionar todos los datos de la tabla FlightNumber
SELECT * FROM FlightNumber;

-- Seleccionar todos los datos de la tabla Airplane
SELECT * FROM Airplane;

-- Seleccionar todos los datos de la tabla PlaneModel
SELECT * FROM PlaneModel;

-- Seleccionar todos los datos de la tabla Seat
SELECT * FROM Seat;

-- Seleccionar todos los datos de la tabla Flight
SELECT * FROM Flight;

-- Seleccionar todos los datos de la tabla Reservation
SELECT * FROM Reservation;

-- Seleccionar todos los datos de la tabla AvailableSeat
SELECT * FROM AvailableSeat;

-- Seleccionar todos los datos de la tabla Ticket
SELECT * FROM Ticket;

-- Seleccionar todos los datos de la tabla Coupon
SELECT * FROM Coupon;

-- Seleccionar todos los datos de la tabla PiecesOfLuggage
SELECT * FROM PiecesOfLuggage;
