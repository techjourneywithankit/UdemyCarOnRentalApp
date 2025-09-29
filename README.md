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
- VS Code with Salesforce Extension Pack
- Salesforce Inspector Chrome Extension

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/techjourneywithankit/UdemyCarOnRentalApp.git
   cd UdemyCarOnRentalApp
   ```

2. **Authenticate with Salesforce**

   ```bash
   sf org login web -s -a mydevorg
   ```

3. **Install Star Rating Package**
   - Login to your Salesforce Org. Once logged into your org, replace the URL segment that comes after `lightning.force.com` with:

   ```
   /packaging/installPackage.apexp?p0=04t5G0000043xs2QAA
   ```

   - Complete URL will look like: `https://yourorg.lightning.force.com/packaging/installPackage.apexp?p0=04t5G0000043xs2QAA`
   - Follow the installation wizard to install the Star Rating package for all users

4. **Deploy the application**

   ```bash
   sf project deploy start
   ```

5. **Assign permissions**

   ```bash
   sfdx force:user:permset:assign -n Car_Rental_Manager
   ```

6. **Open the org**

   ```bash
   sfdx force:org:open
   ```

7. **Create comprehensive test data**

   ```bash
   # Or using the newer sf CLI
   sf apex run --file scripts/createTestData.apex
   ```

   This will create:
   - 20 car records (real car data from CSV)
   - 60 contact records (test customers)
   - 60 booking records (3 bookings per car)
   - 60 review records (1 review per booking)
   - 5 case records (different support processes)

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
- **`carRatingReview`**: Review and rating system for cars
- **`carImageManager`**: Car image upload and management interface
- **`estimateBooking`**: Booking cost estimation component
- **`estimateCarBooking`**: Car-specific booking estimation component

#### Utility Components

- **`starRating`**: Reusable star rating component
- **`errorPanel`**: Error handling and display
- **`placeholder`**: Loading and empty states
- **`ldsUtils`**: Lightning Data Service utilities

### Apex Classes

#### Business Logic

- **`BookingTriggerHandler`**: Booking validation and processing
- **`BookingTriggerHandlerService`**: Core booking business logic
- **`CarAvailabilityRestApiService`**: REST API for car availability
- **`CarReviewController`**: Review management
- **`carImageController`**: Car image management
- **`carTileListController`**: Car listing controller
- **`ContactTriggerHandler`**: Contact management
- **`ContactTriggerHandlerService`**: Contact processing service
- **`PaymentTransactionTriggerHandler`**: Payment processing
- **`PaymentTransactionTriggerHandlerService`**: Payment transaction service
- **`ReviewTriggerHandler`**: Review system automation
- **`ReviewTriggerHandlerService`**: Review processing service

#### Utility Classes

- **`Constants`**: Application-wide constants
- **`TestDataFactory`**: Basic test data generation
- **`CarDataPreparationService`**: Comprehensive test data creation with hardcoded car data
- **`LogCleanupBatch`**: Automated log cleanup
- **`LogCleanupBatchSchedule`**: Scheduled log cleanup
- **`QueuableTotalCarValue`**: Asynchronous car value calculation
- **`queueableEmailValidation`**: Email validation service
- **`EmailValidatoinHtppMock`**: Mock service for email validation

#### Test Classes

- **`BookingTriggerTest`**: Booking trigger test coverage
- **`CarAvailabilityRestApiServiceTest`**: API service test coverage
- **`ContactTriggerHandlerServiceTest`**: Contact handler test coverage
- **`PaymentTransactionTriggerHandlerTest`**: Payment handler test coverage
- **`ReviewTriggerTest`**: Review trigger test coverage
- **`LogCleanupBatchTest`**: Batch job test coverage

### Salesforce Flows

#### Process Automation Flows

- **`Approval_for_Coupon_Code`**: Coupon code approval workflow
- **`Car_Return_Checklist`**: Car return process automation
- **`Estimate_your_Booking`**: Booking cost estimation flow
- **`Post_Booking_Automation_After_Save_activity`**: Post-booking activities
- **`Post_Booking_Automation_Field_Update`**: Booking field updates
- **`Post_Booking_Cancellation_Automation`**: Cancellation processing

#### Data Management Flows

- **`Prevent_Deletion_Of_Primary_Image`**: Image protection flow
- **`Sync_Primary_Image`**: Image synchronization flow

### Custom Objects

#### Core Objects

- **`Booking__c`**: Central booking management
- **`Car__c`**: Vehicle inventory
- **`Payment_Transaction__c`**: Financial transactions
- **`Review__c`**: Customer feedback
- **`Coupon_Code__c`**: Discount management
- **`Contact`**: Customer information and management
- **`Case`**: Customer support and issue tracking

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
      "Rental_Rate_Per_Day__c": 50.0,
      "Primary_Image_Url__c": "image_url",
      "Availability_Status__c": "Available"
    }
  ]
}
```

## 🧪 Testing

### Running Tests

#### Apex Tests

```bash
sfdx force:apex:test:run --testlevel RunLocalTests --resultformat human
```

### Test Coverage

- **Apex Classes**: Comprehensive test classes
- **Integration Tests**: End-to-end workflow testing
- **API Tests**: REST service validation

### Test Data

#### Using TestDataFactory (Basic Test Data)

Use the `TestDataFactory` class to generate basic test data:

```apex
List<Contact> contacts = TestDataFactory.createContacts(5);
List<Car__c> cars = TestDataFactory.createCars(10);
List<Booking__c> bookings = TestDataFactory.createBookings(20, contacts, cars);
List<Review__c> reviews = TestDataFactory.createReviews(20, contacts, bookings, 4);
```

#### Using CarDataPreparationService (Comprehensive Test Data)

For comprehensive test data that mirrors real-world scenarios, use the `CarDataPreparationService` class:

##### Creating All Car Records

```apex
// Create all 20 hardcoded car records from CSV data
List<Car__c> cars = CarDataPreparationService.createAllCarRecords();
```

##### Creating Comprehensive Test Data

```apex
// Create complete test dataset: cars, contacts, bookings, reviews, and cases
Map<String, List<SObject>> testData = CarDataPreparationService.createComprehensiveTestData();

// Access specific record types
List<Car__c> cars = (List<Car__c>) testData.get('cars');           // 20 cars
List<Contact> contacts = (List<Contact>) testData.get('contacts'); // 60 contacts
List<Booking__c> bookings = (List<Booking__c>) testData.get('bookings'); // 60 bookings (3 per car)
List<Review__c> reviews = (List<Review__c>) testData.get('reviews');     // 60 reviews (1 per booking)
List<Case> cases = (List<Case>) testData.get('cases');                   // 5 cases (different support processes)
```

##### Test Data Summary

The comprehensive test data includes:

- **20 Cars**: Real car data from CSV (Maruti Suzuki Swift, Hyundai Creta, Tata Nexon, etc.)
- **60 Contacts**: Test customers with realistic email addresses and phone numbers
- **60 Bookings**: 3 bookings per car with staggered dates and different durations
- **60 Reviews**: 1 review per booking with ratings 3-5 and realistic comments
- **5 Cases**: Different support processes:
  - Booking Inquiry (Car Availability)
  - Review Issue (Poor Car Condition)
  - Maintenance Request (Engine Check)
  - Booking Inquiry (Pricing Information)
  - Review Issue (Customer Service Complaint)

##### Executing Test Data Creation

You can execute the test data creation in several ways:

**1. Developer Console (Anonymous Apex)**

```apex
// Execute in Developer Console > Debug > Open Execute Anonymous Window
Map<String, List<SObject>> testData = CarDataPreparationService.createComprehensiveTestData();
System.debug('Created ' + testData.get('cars').size() + ' cars');
System.debug('Created ' + testData.get('bookings').size() + ' bookings');
System.debug('Created ' + testData.get('reviews').size() + ' reviews');
System.debug('Created ' + testData.get('cases').size() + ' cases');
```

**2. Salesforce CLI (Execute Anonymous)**

```bash
# Create comprehensive test data
sfdx force:apex:execute -f scripts/createTestData.apex

# Or using the newer sf CLI
sf apex run --file scripts/createTestData.apex
```

**3. Custom Button/Flow**
Create a custom button or flow that calls the service method for easy access.

##### Benefits of Comprehensive Test Data

- **Realistic Scenarios**: Data mirrors actual business operations
- **Complete Workflows**: Tests entire booking-to-review process
- **Support Processes**: Includes various case types for testing
- **Performance Testing**: Large dataset for load testing
- **Integration Testing**: Tests relationships between all objects
