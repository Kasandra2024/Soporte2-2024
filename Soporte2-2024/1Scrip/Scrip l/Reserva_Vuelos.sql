CREATE DATABASE Reserva_Vuelos;
GO

USE Reserva_Vuelos;
GO

-- Tabla para Frequent Flyer Card
CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY, --Numero de tarjeta del viajero 
    Miles INT,                 -- Millas acumuladas 
    MealCode VARCHAR(50)       --Codigo del tipo de comida preferida por el cliente.
);

-- Tabla para Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),			--nombre del cliente 
    DateOfBirth DATE,           --fecha de nacimiento
    FFCNumber INT NULL FOREIGN KEY REFERENCES FrequentFlyerCard(FFCNumber) -- numero de tarjeta de viajero frecuente 
);

-- Tabla para Airport
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100)			-- nombre del aeropuerto
);

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

-- Tabla para Airplane
CREATE TABLE Airplane (
    RegistrationNumber VARCHAR(50) PRIMARY KEY,
    BeginOfOperation DATE,		-- Fecha en la que el avión comenzó a operar
    Status VARCHAR(50)			--Estado operativo del avión (activo, en mantenimiento, retirado, etc)
);

-- Tabla para Plane Model
CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(100),		-- Descripción del modelo del avión
    Graphic VARBINARY(MAX) NULL,	--
    RegistrationNumber VARCHAR(50) FOREIGN KEY REFERENCES Airplane(RegistrationNumber)--Número de registro del avión asociado
);

-- Tabla para Seat
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    Size VARCHAR(50),		--Tamaño del asiento.
    Number INT,				--Numero del asiento.
    Location VARCHAR(50),	--Ubicacion del asiento
    PlaneModelID INT FOREIGN KEY REFERENCES PlaneModel(PlaneModelID) --Identificador del modelo del avión 
);

-- Tabla para Flight
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    BoardingTime TIME,	--Hora de abordaje del vuelo
    FlightDate DATE,	--Fecha del vuelo.
    Gate VARCHAR(50),	--Puerta de embarque asignada para el vuelo.
    CheckInCounter VARCHAR(50), -- facturación asignado para el vuelo.
    FlightNumberID INT FOREIGN KEY REFERENCES FlightNumber(FlightNumberID)--Identificador del número de vuelo
);

-- Tabla para Available Seat
CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY IDENTITY(1,1),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID), --Identificador del vuelo al que pertenece este asiento disponible
    SeatID INT FOREIGN KEY REFERENCES Seat(SeatID)		  --Identificador del asiento disponible
);

-- Tabla para Ticket
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    TicketingCode VARCHAR(50),	--Código de ticket usado para identificar el boleto
    Number INT,					--Número del ticket.
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID) --identificador del cliente
);

-- Tabla para Coupon
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    DateOfRedemption DATE,  -- Fecha de redención del cupón.
    Class VARCHAR(50),		-- Clase de servicio a la que aplica el cupón (económica, business, primera clase).	
    Standby BIT,			-- Indica si el cupón es para un asiento en standby
    MealCode VARCHAR(50),   -- Codigo de comida 
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID), --Identificador del ticket
	FlightID INT FOREIGN KEY REFERENCES Flight(FlightID),
	AvailableSeatID INT FOREIGN KEY REFERENCES AvailableSeat(AvailableSeatID)
);

-- Tabla para Pieces of Luggage
CREATE TABLE PiecesOfLuggage (
    LuggageID INT PRIMARY KEY IDENTITY(1,1),
    Number INT,           --Número de piezas de equipaje.
    Weight DECIMAL(5, 2), --Peso total del equipaje en kilogramos.
    CouponID INT NUll FOREIGN KEY REFERENCES Coupon(CouponID)
);


----------------------------------Nuevo
-- Inserciones para FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode) VALUES
(1001, 15000, 'Vegan'),
(1002, 12000, 'Vegetarian'),
(1003, 18000, 'Gluten-Free'),
(1004, 20000, 'Non-Vegetarian'),
(1005, 8000, 'Kosher');

-- Inserciones para Customer
INSERT INTO Customer (Name, DateOfBirth, FFCNumber) VALUES
('John Doe', '1980-05-15', 1001),
('Jane Smith', '1992-08-22', 1002),
('Alice Johnson', '1975-03-10', NULL),
('Bob Brown', '1988-11-30', 1003),
('Charlie Davis', '2000-01-20', NULL);

-- Inserciones para Airport
INSERT INTO Airport (Name) VALUES
('John F. Kennedy International Airport'),
('Los Angeles International Airport'),
('Heathrow Airport'),
('Tokyo Haneda Airport'),
('Dubai International Airport');

-- Inserciones para FlightNumber
INSERT INTO FlightNumber (DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID) VALUES
('10:00:00', 'Morning flight to LA', 'International', 'Delta', 1, 2),
('14:00:00', 'Afternoon flight to London', 'International', 'British Airways', 1, 3),
('18:00:00', 'Evening flight to Tokyo', 'International', 'Japan Airlines', 1, 4),
('08:00:00', 'Early flight to Dubai', 'International', 'Emirates', 1, 5),
('12:00:00', 'Midday flight to LA', 'International', 'American Airlines', 2, 1);

-- Inserciones para Airplane
INSERT INTO Airplane (RegistrationNumber, BeginOfOperation, Status) VALUES
('N12345', '2015-06-01', 'Active'),
('N67890', '2018-09-15', 'Active'),
('N54321', '2011-03-22', 'In Maintenance'),
('N98765', '2020-12-05', 'Active'),
('N11223', '2014-07-19', 'Retired');

-- Inserciones para PlaneModel
INSERT INTO PlaneModel (Description, Graphic, RegistrationNumber) VALUES
('Boeing 737', NULL, 'N12345'),
('Airbus A320', NULL, 'N67890'),
('Boeing 777', NULL, 'N54321'),
('Airbus A380', NULL, 'N98765'),
('Boeing 787', NULL, 'N11223');

-- Inserciones para Seat
INSERT INTO Seat (Size, Number, Location, PlaneModelID) VALUES
('Economy', 1, 'Aisle', 1),
('Economy', 2, 'Window', 1),
('Business', 1, 'Aisle', 2),
('First', 1, 'Window', 3),
('Economy', 3, 'Middle', 4);

-- Inserciones para Flight
INSERT INTO Flight (BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID) VALUES
('09:00:00', '2024-09-01', 'A1', 'Counter 1', 1),
('13:00:00', '2024-09-02', 'B2', 'Counter 2', 2),
('17:00:00', '2024-09-03', 'C3', 'Counter 3', 3),
('07:00:00', '2024-09-04', 'D4', 'Counter 4', 4),
('11:00:00', '2024-09-05', 'E5', 'Counter 5', 5);

-- Inserciones para AvailableSeat
INSERT INTO AvailableSeat (FlightID, SeatID) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5);

-- Inserciones para Ticket
INSERT INTO Ticket (TicketingCode, Number, CustomerID) VALUES
('TICKET123', 1, 1),
('TICKET124', 2, 2),
('TICKET125', 3, 3),
('TICKET126', 4, 4),
('TICKET127', 5, 5);

-- Inserciones para Coupon
INSERT INTO Coupon (DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID, AvailableSeatID) VALUES
('2024-08-01', 'Economy', 0, 'Vegan', 1, 1, 1),
('2024-08-02', 'Business', 1, 'Vegetarian', 2, 2, 2),
('2024-08-03', 'First', 0, 'Gluten-Free', 3, 3, 3),
('2024-08-04', 'Economy', 1, 'Non-Vegetarian', 4, 4, 4),
('2024-08-05', 'Business', 0, 'Kosher', 5, 5, 5);

-- Inserciones para PiecesOfLuggage
INSERT INTO PiecesOfLuggage (Number, Weight, CouponID) VALUES
(1, 23.50, 1),
(2, 15.20, 2),
(1, 20.00, 3),
(3, 30.00, 4),
(2, 18.75, 5);

select * from dbo.Coupon
select * from dbo.Flight
select * from dbo.FlightNumber
select * from dbo.Airport

select * from dbo.AvailableSeat
select * from dbo.Seat

select * from dbo.Customer

select * from dbo.Ticket
select * from dbo.Coupon