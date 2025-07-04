
# ISF Tracking - Backend (GoLang)

## Project Links
- GitHub Repository: [https://github.com/Airliftusa/ISF_Tracking](https://github.com/Airliftusa/ISF_Tracking)
- Clone URL: `https://github.com/Airliftusa/ISF_Tracking.git`

## Project File Structure

The `tracking_server` directory contains the main source code and configuration files for the Go tracking server application. Below is an overview of its structure:

```
tracking_server/
├── controller/        # Contains controller logic and route initialization
├── files/             # Storage for file-related operations (e.g., uploads/downloads)
├── gobuild.sh         # Shell script for building the Go project
├── go.mod             # Go module definition file for dependency management
├── go.sum             # Checksum file to ensure module integrity
├── index.go           # Main entry point that initializes the server and middleware
├── model/             # Contains data models and domain logic
├── requirements.sh    # Shell script for installing project dependencies
└── utils/             # Utility functions and helper packages
```

## Summary:

- **controller/**: Organizes routing and controller-level logic, including route initialization.
- **files/**: Likely manages static files, uploads, or file processing functionality.
- **gobuild.sh & requirements.sh**: Automation scripts to build the project and install dependencies.
- **go.mod & go.sum**: Manage Go modules and ensure consistent builds.
- **index.go**: Application’s main starting point that boots up the HTTP server and middleware.
- **model/**: Houses data schemas and business logic.
- **utils/**: Common utilities shared across different parts of the application.

---

## Overview of `index.go` File

The `index.go` file serves as the main entry point for the application. It is responsible for initializing the HTTP server, configuring routing, enabling cross-origin resource sharing (CORS), and starting the application.

## 1. Router Initialization

```go
controller.Init()
```

**Purpose:** Initializes the routing system of the application.

**Details:**
- Sets up the various HTTP routes (e.g., GET, POST, PUT, DELETE) and binds them to the corresponding handlers or controller functions.
- Each route defines a specific API endpoint and the business logic associated with it.
- This modular approach separates the routing logic from the main server configuration, promoting cleaner and more maintainable code.

## 2. CORS (Cross-Origin Resource Sharing) Setup

```go
handlers.AllowedHeaders([]string{"Content-Type"})
handlers.AllowedOrigins([]string{"*"})
handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE"})
```

**Purpose:** These settings configure the CORS middleware to control how the application handles cross-origin HTTP requests.

**Details:**
- **AllowedHeaders**: Specifies which headers the client is allowed to use when making requests (e.g., "Content-Type").
- **AllowedOrigins**: Defines which domains are permitted to access the server's resources. Using `"*"` allows all domains, which is useful during development but should be restricted in production.
- **AllowedMethods**: Lists the HTTP methods allowed (GET, POST, etc.) when making requests to the server.

**Why it's important:** CORS settings are crucial for enabling frontend applications hosted on different domains (or ports) to securely communicate with the backend server.

## 3. Server Start

```go
fmt.Println("Server is listening on localhost:8586")
log.Fatal(http.ListenAndServe("localhost:8586", corsHandler(router)))
```

**Purpose:** Starts the HTTP server and begins listening for incoming requests.

**Details:**
- `http.ListenAndServe`: Binds the server to `localhost:8586` and listens for HTTP traffic.
- `corsHandler(router)`: Wraps the router with the configured CORS middleware, ensuring that CORS policies are applied to every incoming request.
- `fmt.Println`: Logs a message to indicate the server is running—useful for debugging and confirming the server has started successfully.
- `log.Fatal`: Ensures that any error in starting the server will be logged and the program will exit gracefully.

In summary, the `index.go` file acts as the foundation of the application, performing essential tasks such as initializing routes, configuring CORS policies, and launching the server.

---

## `router.go` — Router Configuration and Initialization

The `router.go` file plays a central role in setting up and managing the HTTP routing structure for the application. It defines the routing logic, applies global middleware, and initializes route groups from various feature modules.

## Router Creation

```go
router := mux.NewRouter()
```

- **Function**: Creates a new instance of the Gorilla Mux router.
- **Purpose**: This router instance serves as the core HTTP request multiplexer for the application.

**Details:**
- All endpoints in the application are registered to this router.
- It supports advanced routing features such as path variables, query matching, and subrouters.

## Middleware Integration

```go
router.Use(Middleware)
```

**Function:** Applies a global middleware to all incoming HTTP requests.

**Purpose:** Middleware helps execute pre-processing logic before the request reaches the handler and after the handler executes.

**Examples of Middleware tasks:**
- Logging request and response data.
- Handling authentication and authorization.
- Measuring performance (monitoring/metrics).
- Managing panic recovery or structured error responses.

> Note: The actual `Middleware` function is assumed to be custom-defined elsewhere in the project.

## Route Initialization for Feature Modules

```go
process.Init(router)
forms.Init(router)
common.Init(router)
reports.Init(router)
exports.Init(router)
```

- **Function**: Initializes routes for each individual module.
- **Purpose**: Each module handles a specific feature set or domain of the application.

**Benefits:**
- Keeps the routing logic modular and organized.
- Each feature module is responsible for its own route definitions.
- Encourages separation of concerns and better maintainability.

---

## `tracking_server/model/exports` — Exports Module Route Documentation

##  Purpose

The `exports` module is responsible for managing routes related to export operations within the application.

##  Key Functional Areas Handled

- Debit and Credit Notes: Generating and managing financial documents tied to exports.
- Booking Confirmations: Handling confirmation logic and status updates for export bookings.
- Invoices: Managing invoice creation, download, and tracking.
- Shipments and Reports: Generating shipment-related documents and analytical reports for export operations.

##  Initialization Function

```go
exports.Init(router)
```

- Binds all the above feature routes to the main application router.
- Allows all export-related endpoints to be logically grouped and independently managed.

---

## `exports.go` — Export Module Router

##  Overview

The `exports.go` file defines all HTTP routes related to export operations in the tracking server. These routes handle the generation of essential export documentation such as debit/credit notes, booking confirmations, invoices, shipment summaries, and various export reports.

##  Code Summary

```go
package exports

import (
    "tracking_server/utils/database"
    "github.com/gorilla/mux"
)

var DB = database.DB
var ImpDB = database.ImpDB

func Init(router *mux.Router) {
    router.HandleFunc("/tracking/exp_generate_dn_no/{id}", expDebitNoteNoGenerateCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_generate_cn_no/{id}", expCreditNoteNoGenerateCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_bookingConfirmation/{id}", expBookingCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_bookingInvoice/{id}", expInvoiceCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_excelReport/", expReportCtrl).Methods("POST")
    router.HandleFunc("/tracking/exp_do/{id}", expDoCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_po/{id}", expPoCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_shipment_summary/{id}", expSsCtrl).Methods("GET")
    router.HandleFunc("/tracking/exp_blReport/{id}", expBlDocCtrl).Methods("GET")
}
```

### Database Connections

- **DB**: Primary connection used for standard export-related operations.
- **ImpDB**: Secondary database connection intended for handling import/export-specific data.

---

## Key Routes and Their Functionalities

| HTTP Method | Route Endpoint | Description |
|-------------|----------------|-------------|
| GET | /tracking/exp_generate_dn_no/{id} | Generates a Debit Note Number for the given export ID. |
| GET | /tracking/exp_generate_cn_no/{id} | Generates a Credit Note Number for the given export ID. |
| GET | /tracking/exp_bookingConfirmation/{id} | Retrieves the Booking Confirmation document. |
| GET | /tracking/exp_bookingInvoice/{id} | Retrieves the Invoice related to the export booking. |
| POST | /tracking/exp_excelReport/ | Generates an Excel report for export data. |
| GET | /tracking/exp_do/{id} | Retrieves the Delivery Order associated with the export ID. |
| GET | /tracking/exp_po/{id} | Retrieves the Purchase Order linked to the export. |
| GET | /tracking/exp_shipment_summary/{id} | Fetches the Shipment Summary for the export. |
| GET | /tracking/exp_blReport/{id} | Retrieves the Bill of Lading (BL) Report. |

---

## Example Request/Response

## Generate Debit Note

**🔹 Request:**
```
GET /tracking/exp_generate_dn_no/123
```

**🔹 Response:**
```json
{
  "debit_note_number": "DN12345"
}
```

---

## Architecture Summary

This document outlines the structure and functionality of the core components in the Go-based tracking project, focusing on:

- `index.go`: The main entry point that starts the server and sets up global middleware (like CORS).
- `controller.go`: Handles the router initialization and ties in middleware and feature modules.
- `exports.go`: Defines export-specific routes for generating and retrieving documents like debit notes, credit notes, booking confirmations, invoices, and reports.

## Key Features

- Modular routing architecture for maintainability.
- Clear separation of concerns between route configuration and business logic.
- Support for export document generation and reporting.
- Database abstraction for scalable data handling.

> This modular design enables easy extension, feature scaling, and customization as new functionalities and domain models are introduced. It ensures a maintainable and developer-friendly backend structure for handling complex export and shipment workflows.
