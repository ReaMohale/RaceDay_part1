/* =====================================================================
   RaceDay - Database Schema and Seed Data
   Part 1, Section C
   Run on a clean SQL Server instance using SQL Server Management Studio.
   ===================================================================== */

IF DB_ID('RaceDayDB') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDayDB;
END
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

/* ---------------------------------------------------------------------
   1. ORGANISERS
   --------------------------------------------------------------------- */
CREATE TABLE Organisers (
    OrganiserId     INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    PhoneNumber     VARCHAR(20)     NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------------------------------------------------------------
   2. PARTICIPANTS
   --------------------------------------------------------------------- */
CREATE TABLE Participants (
    ParticipantId   INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    PhoneNumber     VARCHAR(20)     NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------------------------------------------------------------
   3. EVENTS
   Each event is created and owned by one Organiser.
   --------------------------------------------------------------------- */
CREATE TABLE Events (
    EventId         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId     INT             NOT NULL,
    EventName       NVARCHAR(150)   NOT NULL,
    EventDate       DATE            NOT NULL,
    Location        NVARCHAR(150)   NOT NULL,
    Description     NVARCHAR(500)   NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId)
        REFERENCES Organisers(OrganiserId)
);
GO

/* ---------------------------------------------------------------------
   4. CATEGORIES
   Each event offers one or more race categories (5km, 10km, etc.).
   --------------------------------------------------------------------- */
CREATE TABLE Categories (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    EventId         INT             NOT NULL,
    CategoryName    NVARCHAR(50)    NOT NULL,
    DistanceKm      DECIMAL(5,2)    NOT NULL,
    EntryFee        DECIMAL(8,2)    NOT NULL DEFAULT 0,
    MaxParticipants INT             NOT NULL,
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventId)
        REFERENCES Events(EventId)
);
GO

/* ---------------------------------------------------------------------
   5. ENROLMENTS
   Links a Participant to a Category they have entered.
   --------------------------------------------------------------------- */
CREATE TABLE Enrolments (
    EnrolmentId     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId   INT             NOT NULL,
    CategoryId      INT             NOT NULL,
    EnrolmentDate   DATETIME        NOT NULL DEFAULT GETDATE(),
    Status          VARCHAR(20)     NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantId)
        REFERENCES Participants(ParticipantId),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryId)
        REFERENCES Categories(CategoryId),
    CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Confirmed', 'Cancelled')),
    CONSTRAINT UQ_Enrolments_Participant_Category UNIQUE (ParticipantId, CategoryId)
);
GO

/* ---------------------------------------------------------------------
   6. RESULTS
   Each enrolment can have exactly one result (1:1), captured once
   the participant has finished the race.
   --------------------------------------------------------------------- */
CREATE TABLE Results (
    ResultId        INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId     INT             NOT NULL UNIQUE,
    FinishTime      TIME            NOT NULL,
    Position        INT             NULL,
    RecordedAt      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentId)
        REFERENCES Enrolments(EnrolmentId)
);
GO

/* =====================================================================
   SEED DATA
   ===================================================================== */

-- Organisers (2)
INSERT INTO Organisers (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Thandiwe Nkosi',      'thandiwe.nkosi@raceday.co.za', 'HASH_PLACEHOLDER_1', '0821234567'),
('Johan van der Merwe',  'johan.vdm@raceday.co.za',      'HASH_PLACEHOLDER_2', '0837654321');

-- Participants (2)
INSERT INTO Participants (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Lerato Mokoena', 'lerato.mokoena@gmail.com', 'HASH_PLACEHOLDER_3', '0731112222'),
('Sipho Dlamini',  'sipho.dlamini@gmail.com',  'HASH_PLACEHOLDER_4', '0743334444');

-- Events (3), each owned by an Organiser
INSERT INTO Events (OrganiserId, EventName, EventDate, Location, Description) VALUES
(1, 'Standerton River Run',      '2026-11-08', 'Standerton, Mpumalanga', 'A scenic riverside road running event for all levels.'),
(1, 'Highveld Charity Cycle',    '2026-10-18', 'Standerton, Mpumalanga', 'Community cycling event raising funds for local schools.'),
(2, 'Johannesburg City Park Run','2026-09-27', 'Johannesburg, Gauteng',  'A family-friendly park run through the city centre.');

-- Categories (2 per event = 6 total)
INSERT INTO Categories (EventId, CategoryName, DistanceKm, EntryFee, MaxParticipants) VALUES
(1, '10km Run',  10.00, 150.00, 300),
(1, '21km Half Marathon', 21.10, 250.00, 200),
(2, '40km Road Cycle',    40.00, 200.00, 150),
(2, '80km Road Cycle',    80.00, 300.00, 100),
(3, '5km Fun Run',         5.00,  50.00, 500),
(3, '10km Run',           10.00, 100.00, 300);

-- Enrolments (sample participants entering categories)
-- Lerato Mokoena = ParticipantId 1, Sipho Dlamini = ParticipantId 2
INSERT INTO Enrolments (ParticipantId, CategoryId, Status) VALUES
(1, 1, 'Confirmed'),  -- Lerato -> 10km Run (Standerton)
(1, 5, 'Confirmed'),  -- Lerato -> 5km Fun Run (Joburg)
(2, 2, 'Confirmed'),  -- Sipho  -> 21km Half Marathon
(2, 3, 'Confirmed');  -- Sipho  -> 40km Road Cycle

-- Results (sample, only for events that have already taken place)
INSERT INTO Results (EnrolmentId, FinishTime, Position) VALUES
(2, '00:24:18', 3),   -- Lerato's 5km Fun Run result
(4, '01:52:07', 12);  -- Sipho's 40km Road Cycle result
GO

/* =====================================================================
   Verification queries (optional - comment out before final submission
   if your rubric wants a script with no SELECT statements)
   ===================================================================== */
-- SELECT * FROM Organisers;
-- SELECT * FROM Participants;
-- SELECT * FROM Events;
-- SELECT * FROM Categories;
-- SELECT * FROM Enrolments;
-- SELECT * FROM Results;
