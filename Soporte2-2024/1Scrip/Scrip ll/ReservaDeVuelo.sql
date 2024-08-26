CREATE DATABASE Reserva_de_Vuelo;
GO
USE Reserva_de_Vuelo;
Go

-- Tabla para country 
CREATE TABLE Country
(
    id_country INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Tabla para city

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
    Name VARCHAR(100)			-- nombre del aeropuerto
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
    FFCNumber INT PRIMARY KEY, --Numero de tarjeta del viajero 
    Miles INT,                 -- Millas acumuladas 
    MealCode VARCHAR(50)       --Codigo del tipo de comida preferida por el cliente.
);

-- Tabla para Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),			--nombre del cliente 
    DateOfBirth DATE,           --fecha de nacimiento
    FFCNumber INT NULL FOREIGN KEY REFERENCES FrequentFlyerCard(FFCNumber), -- numero de tarjeta de viajero frecuente 
    id_document INT FOREIGN KEY (id_document) REFERENCES Document(id_document)
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


-- Inserciones para Country

INSERT INTO Country (name) VALUES
('United States'),
('United Kingdom'),
('Japan'),
('United Arab Emirates'),
('Australia'),
('Canada'),
('Germany'),
('France'),
('India'),
('Brazil');

-- Inserciones para City

INSERT INTO City (id_country, name) VALUES
(1, 'New York'),
(1, 'Los Angeles'),
(2, 'London'),
(3, 'Tokyo'),
(4, 'Dubai'),
(5, 'Sydney'),
(6, 'Toronto'),
(7, 'Berlin'),
(8, 'Paris'),
(9, 'Mumbai'),
(10, 'Sao Paulo');

-- Inserciones para Airport

INSERT INTO Airport (Name) VALUES
('John F. Kennedy International Airport'),
('Los Angeles International Airport'),
('Heathrow Airport'),
('Tokyo Haneda Airport'),
('Dubai International Airport'),
('Sydney Airport'),
('Toronto Pearson International Airport'),
('Berlin Brandenburg Airport'),
('Charles de Gaulle Airport'),
('Chhatrapati Shivaji Maharaj International Airport');


-- Inserciones para Airport
INSERT INTO City_Airport (id_city, id_airport) VALUES
(1, 1),  -- New York - John F. Kennedy International Airport
(2, 2),  -- Los Angeles - Los Angeles International Airport
(3, 3),  -- London - Heathrow Airport
(4, 4),  -- Tokyo - Tokyo Haneda Airport
(5, 5),  -- Dubai - Dubai International Airport
(6, 6),  -- Sydney - Sydney Airport
(7, 7),  -- Toronto - Toronto Pearson International Airport
(8, 8),  -- Berlin - Berlin Brandenburg Airport
(9, 9),  -- Paris - Charles de Gaulle Airport
(10, 10);  -- Mumbai - Chhatrapati Shivaji Maharaj International Airport



-- Inserciones para FrequentFlyerCard
INSERT INTO FrequentFlyerCard (FFCNumber, Miles, MealCode) VALUES
(1001, 15000, 'Vegan'),
(1002, 12000, 'Vegetarian'),
(1003, 18000, 'Gluten-Free'),
(1004, 20000, 'Non-Vegetarian'),
(1005, 8000, 'Kosher'),
(1006, 10000, 'Halal'),
(1007, 9000, 'Lactose-Free'),
(1008, 5000, 'Pescatarian'),
(1009, 7000, 'No Preference'),
(1010, 6000, 'Vegetarian');

-- Inserciones para Document
INSERT INTO Document (description) VALUES
('Passport'),
('Driver License'),
('National ID'),
('Social Security Number'),
('Voter ID');

-- Inserciones para Customer (ahora incluyendo id_document)
INSERT INTO Customer (Name, DateOfBirth, FFCNumber, id_document) VALUES
('John Doe', '1980-05-15', 1001, 1),
('Jane Smith', '1992-08-22', 1002, 2),
('Alice Johnson', '1975-03-10', NULL, 3),
('Bob Brown', '1988-11-30', 1003, 4),
('Charlie Davis', '2000-01-20', NULL, 5),
('Eve White', '1985-07-14', 1004, 1),
('Frank Black', '1995-02-25', 1005, 2),
('Grace Green', '1970-09-05', 1006, 3),
('Hank Hill', '1982-12-15', 1007, 4),
('Ivy Blue', '1990-06-01', NULL, 5);



-- Inserciones para FlightNumber
INSERT INTO FlightNumber (DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID) VALUES
('10:00:00', 'Morning flight to LA', 'International', 'Delta', 1, 2),
('14:00:00', 'Afternoon flight to London', 'International', 'British Airways', 1, 3),
('18:00:00', 'Evening flight to Tokyo', 'International', 'Japan Airlines', 1, 4),
('08:00:00', 'Early flight to Dubai', 'International', 'Emirates', 1, 5),
('12:00:00', 'Midday flight to LA', 'International', 'American Airlines', 2, 1),
('13:30:00', 'Afternoon flight to Paris', 'International', 'Air France', 1, 6),
('09:00:00', 'Morning flight to Frankfurt', 'International', 'Lufthansa', 7, 3),
('15:00:00', 'Evening flight to Hong Kong', 'International', 'Cathay Pacific', 8, 4),
('17:30:00', 'Flight to Singapore', 'International', 'Singapore Airlines', 1, 9),
('11:00:00', 'Flight to Beijing', 'International', 'Air China', 10, 5);

-- Inserciones para Airplane
INSERT INTO Airplane (RegistrationNumber, BeginOfOperation, Status) VALUES
('N12345', '2015-06-01', 'Active'),
('N67890', '2018-09-15', 'Active'),
('N54321', '2011-03-22', 'In Maintenance'),
('N98765', '2020-12-05', 'Active'),
('N11223', '2014-07-19', 'Retired'),
('N77889', '2019-03-25', 'Active'),
('N33445', '2016-01-17', 'Active'),
('N99887', '2017-11-30', 'Retired'),
('N66778', '2013-05-22', 'In Maintenance'),
('N44332', '2021-07-10', 'Active');

-- Inserciones para PlaneModel
INSERT INTO PlaneModel (Description, Graphic, RegistrationNumber) VALUES
('Boeing 737', NULL, 'N12345'),
('Airbus A320', NULL, 'N67890'),
('Boeing 777', NULL, 'N54321'),
('Airbus A380', NULL, 'N98765'),
('Boeing 787', NULL, 'N11223'),
('Boeing 747', NULL, 'N77889'),
('Airbus A330', NULL, 'N33445'),
('Boeing 767', NULL, 'N99887'),
('Boeing 757', NULL, 'N66778'),
('Airbus A350', NULL, 'N44332');

-- Inserciones para Seat
INSERT INTO Seat (Size, Number, Location, PlaneModelID) VALUES
('Economy', 1, 'Aisle', 1),
('Economy', 2, 'Window', 1),
('Business', 1, 'Aisle', 2),
('First', 1, 'Window', 3),
('Economy', 3, 'Middle', 4),
('Business', 2, 'Window', 5),
('First', 2, 'Aisle', 6),
('Economy', 4, 'Aisle', 7),
('Business', 3, 'Middle', 8),
('Economy', 5, 'Window', 9);

-- Inserciones para Flight
INSERT INTO Flight (BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID) VALUES
('09:00:00', '2024-09-01', 'A1', 'Counter 1', 1),
('13:00:00', '2024-09-02', 'B2', 'Counter 2', 2),
('17:00:00', '2024-09-03', 'C3', 'Counter 3', 3),
('07:00:00', '2024-09-04', 'D4', 'Counter 4', 4),
('11:00:00', '2024-09-05', 'E5', 'Counter 5', 5),
('10:30:00', '2024-09-06', 'F6', 'Counter 6', 6),
('08:00:00', '2024-09-07', 'G7', 'Counter 7', 7),
('14:00:00', '2024-09-08', 'H8', 'Counter 8', 8),
('16:30:00', '2024-09-09', 'I9', 'Counter 9', 9),
('12:00:00', '2024-09-10', 'J10', 'Counter 10', 10);

-- Inserciones para AvailableSeat
INSERT INTO AvailableSeat (FlightID, SeatID) VALUES
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

-- Inserciones para Ticket
INSERT INTO Ticket (TicketingCode, Number, CustomerID) VALUES
('TICKET123', 1, 1),
('TICKET124', 2, 2),
('TICKET125', 3, 3),
('TICKET126', 4, 4),
('TICKET127', 5, 5),
('TICKET128', 6, 6),
('TICKET129', 7, 7),
('TICKET130', 8, 8),
('TICKET131', 9, 9),
('TICKET132', 10, 10);

-- Inserciones para Coupon
INSERT INTO Coupon (DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID, AvailableSeatID) VALUES
('2024-08-01', 'Economy', 0, 'Vegan', 1, 1, 1),
('2024-08-02', 'Economy', 1, 'Vegetarian', 2, 2, 2),
('2024-08-03', 'Business', 0, 'Gluten-Free', 3, 3, 3),
('2024-08-04', 'First', 1, 'Non-Vegetarian', 4, 4, 4),
('2024-08-05', 'Economy', 0, 'Kosher', 5, 5, 5),
('2024-08-06', 'Business', 1, 'Halal', 6, 6, 6),
('2024-08-07', 'First', 0, 'Lactose-Free', 7, 7, 7),
('2024-08-08', 'Economy', 1, 'Pescatarian', 8, 8, 8),
('2024-08-09', 'Business', 0, 'No Preference', 9, 9, 9),
('2024-08-10', 'Economy', 1, 'Vegetarian', 10, 10, 10);


select * from dbo.Country
select * from dbo.City
select * from dbo.Airport
select * from dbo.City_Airport


select * from dbo.Coupon
select * from dbo.Flight
select * from dbo.FlightNumber
select * from dbo.Airport

select * from dbo.AvailableSeat
select * from dbo.Seat

select * from dbo.Customer

select * from dbo.Ticket
select * from dbo.Coupon