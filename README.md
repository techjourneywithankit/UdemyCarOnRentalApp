# Car On Rental App 🚗

A comprehensive Salesforce application for managing car rental operations, built with Lightning Web Components and modern Salesforce development practices.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Key Components](#key-components)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

The **Car On Rental App** is a full-featured Salesforce application designed to streamline car rental business operations. It provides a complete solution for inventory management, booking processing, payment handling, customer reviews, and administrative workflows.

### Business Value
- **Streamlined Operations**: Automated booking and payment processing
- **Customer Experience**: Modern, responsive UI with real-time updates
- **Business Intelligence**: Comprehensive reporting and analytics
- **Scalability**: Built to handle growing rental businesses
- **Integration Ready**: REST APIs for external system connectivity

## ✨ Features

### 🚗 Car Inventory Management
- Complete car catalog with images and specifications
- Real-time availability tracking
- Advanced filtering and search capabilities
- Service and maintenance scheduling
- Performance analytics and revenue tracking

### 📅 Booking System
- Advanced booking management with overlap validation
- Dynamic pricing calculations
- Coupon code integration with approval workflows
- Status tracking (Pending → Confirmed → Started → Completed)
- Automated notifications and communications

### 💳 Payment Processing
- Multi-stage payment handling
- Security deposit management
- Refund processing automation
- Payment status synchronization
- Financial transaction tracking

### ⭐ Customer Reviews
- Star rating system (1-5 scale)
- Review submission and validation
- Automated case creation for negative feedback
- Average rating calculations
- Customer communication triggers

### 🔧 Administrative Tools
- Approval workflows for coupon codes
- Case management for customer support
- Comprehensive reporting and dashboards
- User role and permission management
- System monitoring and logging

## 🛠 Technology Stack

### Frontend
- **Lightning Web Components (LWC)**: Modern, performant UI components
- **Lightning Design System**: Consistent Salesforce styling
- **JavaScript ES6+**: Modern JavaScript features
- **CSS3**: Responsive design and animations

### Backend
- **Apex**: Server-side business logic
- **Salesforce Platform**: Cloud-based infrastructure
- **SOQL**: Database query language
- **REST APIs**: External integration capabilities

### Development Tools
- **Salesforce CLI**: Command-line development tools
- **VS Code**: Integrated development environment
- **Jest**: Lightning Web Component testing
- **ESLint**: Code quality and consistency
- **Prettier**: Code formatting

### Automation
- **Salesforce Flows**: Process automation
- **Triggers**: Data validation and business logic
- **Platform Events**: Real-time communication
- **Batch Jobs**: Scheduled data processing

## 🏗 Architecture

The application follows a layered architecture pattern:

```
┌─────────────────────────────────────────┐
│           Presentation Layer             │
│     (Lightning Web Components)          │
├─────────────────────────────────────────┤
│           Business Logic Layer          │
│         (Apex Classes & Triggers)        │
├─────────────────────────────────────────┤
│           Data Access Layer             │
│        (Custom Objects & Fields)         │
├─────────────────────────────────────────┤
│           Integration Layer              │
│        (REST APIs & External Services)   │
└─────────────────────────────────────────┘
```

### Core Components
1. **Data Model**: Custom objects representing business entities
2. **Business Logic**: Apex classes handling complex operations
3. **User Interface**: Lightning Web Components for modern UX
4. **Automation**: Flows and triggers for process automation
5. **Integration**: REST APIs for external system connectivity

## 🚀 Getting Started

### Prerequisites
- Salesforce Developer Edition org
- Salesforce CLI installed
- Node.js (v14 or higher)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/UdemyCarOnRentalApp.git
   cd UdemyCarOnRentalApp
   ```

3. **Authenticate with Salesforce**
   ```bash
   sfdx auth:web:login -a MyOrg
   ```

4. **Install Star Rating Package**
   - Once logged into your org, replace the URL segment that comes after `lightning.force.com` with:
   ```
   /packaging/installPackage.apexp?p0=04t5G0000043xs2QAA
   ```
   - Complete URL will look like: `https://yourorg.lightning.force.com/packaging/installPackage.apexp?p0=04t5G0000043xs2QAA`
   - Follow the installation wizard to install the Star Rating package

5. **Deploy the application**
   ```bash
   sfdx force:source:push
   ```

6. **Assign permissions**
   ```bash
   sfdx force:user:permset:assign -n Car_Rental_Manager
   ```

7. **Open the org**
   ```bash
   sfdx force:org:open
   ```

### Quick Start Guide

1. **Navigate to the Car On Rental app** in your Salesforce org
2. **Go to the Car Hunt tab** to browse available vehicles
3. **Use filters** to find cars by location, date, fuel type, etc.
4. **Click "Book Now"** on any car to create a booking
5. **Process payments** through the Payment Transaction records
6. **Manage reviews** and customer feedback through the Review system

## 📁 Project Structure

```
UdemyCarOnRentalApp/
├── config/                          # Project configuration
│   └── project-scratch-def.json     # Scratch org definition
├── force-app/main/default/          # Main application code
│   ├── applications/                # Custom applications
│   ├── classes/                     # Apex classes
│   ├── lwc/                         # Lightning Web Components
│   ├── objects/                     # Custom objects
│   ├── triggers/                    # Apex triggers
│   ├── flows/                       # Process automation
│   ├── flexipages/                  # Lightning pages
│   ├── permissionsets/             # Permission sets
│   ├── profiles/                    # User profiles
│   └── staticresources/             # Static resources
├── scripts/                         # Utility scripts
├── manifest/                        # Package manifest
├── package.json                     # Node.js dependencies
├── sfdx-project.json               # Salesforce project config
└── README.md                       # This file
```

## 🧩 Key Components

### Lightning Web Components

#### Core UI Components
- **`carTileList`**: Main car listing with filtering
- **`carTile`**: Individual car display card
- **`carFilter`**: Advanced filtering interface
- **`bookCarModal`**: Booking creation modal
- **`carCard`**: Detailed car information display

#### Utility Components
- **`starRating`**: Reusable star rating component
- **`errorPanel`**: Error handling and display
- **`placeholder`**: Loading and empty states
- **`ldsUtils`**: Lightning Data Service utilities

### Apex Classes

#### Business Logic
- **`BookingTriggerHandler`**: Booking validation and processing
- **`CarAvailabilityRestApiService`**: REST API for car availability
- **`CarReviewController`**: Review management
- **`PaymentTransactionTriggerHandler`**: Payment processing
- **`ContactTriggerHandler`**: Contact management

#### Utility Classes
- **`Constants`**: Application-wide constants
- **`TestDataFactory`**: Test data generation
- **`LogCleanupBatch`**: Automated log cleanup

### Custom Objects

#### Core Objects
- **`Booking__c`**: Central booking management
- **`Car__c`**: Vehicle inventory
- **`Payment_Transaction__c`**: Financial transactions
- **`Review__c`**: Customer feedback
- **`Coupon_Code__c`**: Discount management

#### Supporting Objects
- **`Car_Image__c`**: Vehicle images
- **`Log__e`**: Platform events for logging
- **`LogEvent__c`**: Persistent log storage

## 🔌 API Documentation

### Car Availability API

**Endpoint**: `/services/apexrest/v1/cars/available/*`
**Method**: GET
**Authentication**: Salesforce session-based

#### Request Parameters
```
startDate: YYYY-MM-DD (required)
endDate: YYYY-MM-DD (required)
location: String (required)
fuelType: String (optional)
transmissionType: String (optional)
```

#### Response Format
```json
{
  "success": true,
  "message": "Cars retrieved successfully",
  "cars": [
    {
      "Id": "car_id",
      "Name": "Car Name",
      "Make__c": "Toyota",
      "Model__c": "Camry",
      "Rental_Rate_Per_Day__c": 50.00,
      "Primary_Image_Url__c": "image_url",
      "Availability_Status__c": "Available"
    }
  ]
}
```

### Usage Example
```javascript
// JavaScript example
const response = await fetch('/services/apexrest/v1/cars/available/?startDate=2024-01-01&endDate=2024-01-05&location=Downtown');
const data = await response.json();
console.log(data.cars);
```

## 🧪 Testing

### Running Tests

#### Lightning Web Component Tests
```bash
npm run test:unit
npm run test:unit:watch
npm run test:unit:coverage
```

#### Apex Tests
```bash
sfdx force:apex:test:run --testlevel RunLocalTests --resultformat human
```

### Test Coverage
- **LWC Components**: Jest-based unit tests
- **Apex Classes**: Comprehensive test classes
- **Integration Tests**: End-to-end workflow testing
- **API Tests**: REST service validation

### Test Data
Use the `TestDataFactory` class to generate test data:
```apex
List<Contact> contacts = TestDataFactory.createContacts(5);
List<Car__c> cars = TestDataFactory.createCars(10);
List<Booking__c> bookings = TestDataFactory.createBookings(20);
```

