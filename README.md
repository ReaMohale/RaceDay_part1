# RaceDay — Event Management System

A full-stack web application for managing road running, walking, and cycling events in South Africa. From event creation to results tracking, RaceDay replaces spreadsheets and disconnected tools with a single, modern platform.

---

## 📋 Overview

RaceDay is designed for:
- **Event Organisers** — clubs, race committees, and event companies who plan and run races
- **Participants** — runners, walkers, and cyclists who take part in events

The system allows organisers to create and manage events, define categories, monitor enrolments, and capture results — while participants can discover events, enter races, and build a personal performance history.

---

## 🚀 Features

### For Organisers
- Create, edit, and delete events
- Add multiple categories per event (e.g. 5km, 10km, 21km) with:
  - Distance (km)
  - Entry fee
  - Maximum participant limit
- View all enrolments per category in real time
- Capture finish times and positions after the race

### For Participants
- Browse all upcoming events (no login required)
- Create an account and manage profile
- Enter events by selecting a category
- View own current and past enrolments
- Track personal race history with finish times and positions

### Additional Features
- Duplicate entry protection per category
- Public event browsing for unauthenticated visitors
- Race-day weather information for event locations

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|------------|
| **Database** | Microsoft SQL Server |
| **Backend API** | C# / .NET (RESTful API) |
| **Frontend** | ASP.NET MVC (consumes API) |
| **Cloud Storage** | Azure Blob Storage (for images & documents) |
| **Containerisation** | Docker |
| **CI/CD** | GitHub Actions |
| **Testing** | Unit tests |

---

## 🗄️ Database Schema

The relational database consists of six core tables:


### Table Descriptions

| Table | Purpose |
|-------|---------|
| `Organisers` | Event creators and managers |
| `Participants` | Race entrants and users |
| `Events` | Races owned by organisers |
| `Categories` | Race distances & fees within an event |
| `Enrolments` | Links participants to event categories |
| `Results` | Finish times and positions per enrolment |

### Key Relationships
- An **Organiser** can have many **Events**
- An **Event** can have many **Categories**
- A **Category** can have many **Enrolments**
- A **Participant** can have many **Enrolments**
- Each **Enrolment** can have exactly **one Result** (1:1)

### Constraints
- Unique email per Organiser and Participant
- Unique (ParticipantId, CategoryId) per Enrolment
- Status check on Enrolments (`Confirmed` / `Cancelled`)

---

## 📦 Setup Instructions

### Prerequisites
- SQL Server (2019 or later recommended)
- SQL Server Management Studio (SSMS) or Azure Data Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/raceday.git
   cd raceday

Realeboga Mohale
Student Number: st0462025



<img width="1149" height="530" alt="image" src="https://github.com/user-attachments/assets/ab6c6746-a113-4ac0-941c-c28f18690d71" />
