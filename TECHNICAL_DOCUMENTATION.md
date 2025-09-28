# Car On Rental App - Technical Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Overview](#architecture-overview)
3. [Custom Objects](#custom-objects)
4. [Apex Classes](#apex-classes)
5. [Lightning Web Components](#lightning-web-components)
6. [Triggers and Automation](#triggers-and-automation)
7. [Flows and Process Automation](#flows-and-process-automation)
8. [Security and Sharing](#security-and-sharing)
9. [API Integration](#api-integration)
10. [Testing Strategy](#testing-strategy)
11. [Deployment Configuration](#deployment-configuration)

---

## Project Overview

The **Car On Rental App** is a comprehensive Salesforce application designed to manage car rental operations. Built using Salesforce DX and Lightning Web Components, this application provides a complete solution for car rental businesses including inventory management, booking processing, payment handling, customer reviews, and administrative workflows.

### Key Features
- **Car Inventory Management**: Complete car catalog with images, specifications, and availability tracking
- **Booking System**: Advanced booking management with overlap validation and pricing calculations
- **Payment Processing**: Multi-stage payment handling with security deposits and refunds
- **Customer Reviews**: Rating and review system with automated case creation for negative feedback
- **Coupon Management**: Discount code system with approval workflows
- **REST API**: External integration capabilities for car availability queries
- **Mobile-Responsive UI**: Modern Lightning Web Components for optimal user experience

### Technology Stack
- **Platform**: Salesforce Lightning Platform
- **Frontend**: Lightning Web Components (LWC)
- **Backend**: Apex Classes and Triggers
- **Automation**: Salesforce Flows and Process Builder
- **API**: REST Services
- **Testing**: Apex Test Classes

---

## Architecture Overview

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

---

## Custom Objects

### 1. Booking__c
**Purpose**: Central object managing all car rental bookings and the core business entity

**Object Configuration**:
- **Label**: Booking
- **Plural Label**: Bookings
- **Name Field**: Auto Number (BOOK-{0000})
- **Sharing Model**: Private
- **Deployment Status**: Deployed
- **Features Enabled**: Activities, Bulk API, History, Reports, Sharing, Streaming API

**Detailed Field Specifications**:

#### Core Identification Fields
- **`Booking ID`** (Auto Number)
  - Format: BOOK-{0000}
  - Unique identifier for each booking
  - Display format ensures sequential numbering
  - Track History: Disabled

#### Customer and Vehicle Relationships
- **`Customer__c`** (Lookup to Contact)
  - Required: Yes
  - Track History: Enabled
  - Represents the customer making the booking
  - Used for customer communication and billing

- **`Car__c`** (Lookup to Car__c)
  - Required: Yes
  - Track History: Enabled
  - Links to the specific vehicle being rented
  - Used for availability checking and pricing

#### Date and Time Management
- **`Start_Date_Time__c`** (DateTime)
  - Required: Yes
  - Track History: Enabled
  - Rental start timestamp
  - Used for overlap validation and availability checking

- **`End_Date_Time__c`** (DateTime)
  - Required: Yes
  - Track History: Enabled
  - Rental end timestamp
  - Used for duration calculation and return processing

- **`Booking_Duration__c`** (Number)
  - Calculated field for rental duration
  - Used for pricing calculations

#### Status Management
- **`Status__c`** (Picklist)
  - Required: No
  - Track History: Enabled
  - Values: Pending (Default), Confirmed, Started, Completed, Cancelled, Closed
  - Controls booking workflow and business logic

- **`Payment_Status__c`** (Picklist)
  - Required: No
  - Track History: Enabled
  - Values: Pending (Default), Paid, Refunded, Partially Paid, Overdue
  - Tracks payment completion status

#### Financial Fields
- **`Base_Price__c`** (Currency)
  - Base rental cost before discounts
  - Calculated from daily rate × duration

- **`Final_Booking_Price__c`** (Currency)
  - Total booking amount after all adjustments
  - Includes discounts, fees, and adjustments

- **`Security_Deposit__c`** (Currency)
  - Security deposit amount required
  - Calculated as percentage of booking value

- **`Total_Paid_Amount__c`** (Currency)
  - Sum of all payments received
  - Updated via payment transactions

- **`Booking_Balance__c`** (Currency)
  - Outstanding balance calculation
  - Formula: Final_Booking_Price__c - Total_Paid_Amount__c

- **`Total_Adjustment__c`** (Currency)
  - Sum of all adjustments made
  - Includes late fees, damage charges, etc.

#### Coupon and Discount Management
- **`Coupon_Code__c`** (Lookup to Coupon_Code__c)
  - Optional discount code application
  - Track History: Enabled

- **`Coupen_Discount__c`** (Currency)
  - Applied discount amount
  - Calculated from coupon code

#### Post-Rental Processing
- **`Actual_Mileage__c`** (Number)
  - Mileage reading at return
  - Used for mileage limit validation

- **`Deduction_Of_Deposit__c`** (Currency)
  - Amount deducted from security deposit
  - Used for damage charges and fees

- **`Security_Refund_Completed__c`** (Checkbox)
  - Indicates if security deposit refund is processed
  - Used for refund workflow automation

- **`Total_Security_Deposit_Paid__c`** (Currency)
  - Total security deposit amount paid
  - Tracks deposit collection

- **`Total_Security_Refund_Amount__c`** (Currency)
  - Total refund amount processed
  - Tracks refund disbursement

#### Audit and Compliance
- **`Cancellation_Reason__c`** (Text)
  - Required when booking is cancelled
  - Used for analytics and process improvement

- **`Post_Booking_Completion_Audit__c`** (Long Text)
  - Audit trail for completed bookings
  - Contains compliance and quality check data

**Validation Rules**:
1. **Check_Booking_Dates**: Ensures End Date is after Start Date
2. **Check_Future_Start_Date**: Validates start date is in the future
3. **Check_Booking_and_Payment_Status**: Ensures status consistency
4. **Check_Cancellation_After_Start**: Prevents cancellation after rental starts
5. **Check_Mandatory_Cancellation_Reason**: Requires reason for cancellations
6. **Prevent_Coupon_Code_Change_if_Not_Pending**: Prevents coupon changes after confirmation
7. **Validation_for_Booking_Cancellation**: Comprehensive cancellation validation
8. **Booking_Completion_Check**: Ensures completion criteria are met

**Business Logic**:
- Overlap prevention via triggers
- Automatic pricing calculations
- Status transition validation
- Payment processing automation

---

### 2. Car__c
**Purpose**: Comprehensive vehicle inventory management system

**Object Configuration**:
- **Label**: Car
- **Plural Label**: Cars
- **Name Field**: Text (Car Name)
- **Sharing Model**: Read (Public read for customer browsing)
- **Deployment Status**: Deployed
- **Features Enabled**: Activities, Bulk API, History, Reports, Search, Sharing, Streaming API

**Detailed Field Specifications**:

#### Basic Vehicle Information
- **`Car Name`** (Text)
  - Required: Yes
  - Primary identifier for the vehicle
  - Used in search and display

- **`Make__c`** (Text)
  - Required: Yes
  - Vehicle manufacturer (e.g., Toyota, Honda, Ford)
  - Used for filtering and categorization

- **`Model__c`** (Text)
  - Required: Yes
  - Vehicle model name
  - Used with Make for complete identification

- **`Year__c`** (Number)
  - Required: Yes
  - Manufacturing year
  - Used for age-based filtering and depreciation

- **`Car_Family__c`** (Picklist)
  - Vehicle category (Sedan, SUV, Hatchback, Coupe, Convertible, etc.)
  - Used for customer preference filtering

#### Technical Specifications
- **`Fuel_Type__c`** (Picklist)
  - Required: Yes
  - Values: Petrol (Default), Diesel, Electric, Hybrid, Biodiesel, Gasoline
  - Controlling field for dependent picklists
  - Used for environmental and cost considerations

- **`Transmission_Type__c`** (Picklist)
  - Required: Yes
  - Values: Manual, Automatic
  - Controls Fuel_Type__c dependent picklist
  - Used for customer preference matching

- **`Number_of_Seats__c`** (Number)
  - Required: Yes
  - Passenger capacity
  - Used for group size matching

#### Pricing and Availability
- **`Rental_Rate_Per_Day__c`** (Currency)
  - Required: Yes
  - Daily rental rate
  - Primary pricing field for calculations

- **`Availability_Status__c`** (Picklist)
  - Required: Yes
  - Values: Available, Unavailable, Maintenance, Out of Service
  - Controls booking availability

- **`Mileage_Limit_Per_Day__c`** (Number)
  - Required: Yes
  - Daily mileage allowance
  - Used for overage calculations

#### Location and Logistics
- **`PickupLocation__c`** (Text)
  - Required: Yes
  - Rental pickup location
  - Used for location-based filtering

- **`Fuel_Level__c`** (Percent)
  - Current fuel level percentage
  - Used for return inspection

#### Visual and Media
- **`Primary_Image_Url__c`** (URL)
  - Main vehicle image URL
  - Used in car listings and details

- **`Car_Image__c`** (File)
  - Image file attachment
  - Alternative to URL-based images

- **`Car_Description__c`** (Long Text)
  - Detailed vehicle description
  - Used for marketing and customer information

#### Service and Maintenance
- **`Last_Service_Date__c`** (Date)
  - Date of last maintenance service
  - Used for service scheduling

- **`Next_Service_Date__c`** (Date)
  - Scheduled next service date
  - Used for maintenance planning

- **`Service_Countdown__c`** (Number)
  - Days until next service
  - Calculated field for maintenance alerts

- **`Damage_Notes__c`** (Long Text)
  - Current damage documentation
  - Used for condition tracking

#### Performance and Analytics
- **`Average_Rating__c`** (Number)
  - Customer rating average (1-5 scale)
  - Calculated from reviews
  - Used for quality assessment

- **`Current_Average__c`** (Number)
  - Current period average rating
  - Used for trend analysis

- **`Total_Bookings_Value__c`** (Currency)
  - Total revenue generated
  - Calculated from completed bookings
  - Used for performance metrics

**Business Logic**:
- Automatic rating calculations
- Service scheduling automation
- Availability management
- Revenue tracking

---

### 3. Coupon_Code__c
**Purpose**: Advanced discount code management with approval workflows

**Object Configuration**:
- **Label**: Coupon Code
- **Plural Label**: Coupon Codes
- **Name Field**: Text (Coupon Code Name)
- **Sharing Model**: ReadWrite
- **Deployment Status**: Deployed
- **Description**: Stores coupon codes and their discount information for bookings

**Detailed Field Specifications**:

#### Code Management
- **`Coupon Code Name`** (Text)
  - Required: Yes
  - Human-readable identifier
  - Used for display purposes

- **`Code__c`** (Text)
  - Required: Yes
  - Length: 50 characters
  - External ID: Yes
  - Unique: Yes
  - Case Sensitive: No
  - Track History: Enabled
  - The actual coupon code customers enter

#### Discount Configuration
- **`Discount_Percentage__c`** (Percent)
  - Optional percentage-based discount
  - Used for percentage-off promotions

- **`Discount_Amount__c`** (Currency)
  - Optional fixed amount discount
  - Used for dollar-off promotions

#### Usage Management
- **`Max_Uses__c`** (Number)
  - Maximum number of times code can be used
  - Used for usage limitation

- **`Current_Uses_Count__c`** (Number)
  - Current usage count
  - Tracked automatically
  - Used for usage monitoring

#### Validity and Status
- **`Expiration_Date__c`** (Date)
  - Code expiration date
  - Used for validity checking

- **`Is_Active__c`** (Checkbox)
  - Active status flag
  - Used for enabling/disabling codes

- **`Approval_Status__c`** (Picklist)
  - Approval workflow status
  - Values: Pending, Approved, Rejected
  - Used for approval process management

**Features**:
- Approval process integration
- Duplicate prevention via validation rules
- Usage tracking and limits
- Expiration date management
- Active/inactive status control

**Validation Rules**:
- Duplicate code prevention
- Expiration date validation
- Usage limit enforcement
- Approval status consistency

---

### 4. Payment_Transaction__c
**Purpose**: Comprehensive financial transaction tracking and management

**Object Configuration**:
- **Label**: Payment Transaction
- **Plural Label**: Payment Transactions
- **Name Field**: Auto Number (TRN-{0000})
- **Sharing Model**: Controlled by Parent (Booking)
- **Deployment Status**: Deployed
- **Features Enabled**: Bulk API, Sharing, Streaming API

**Detailed Field Specifications**:

#### Transaction Identification
- **`Transaction ID`** (Auto Number)
  - Format: TRN-{0000}
  - Unique transaction identifier
  - Sequential numbering system

#### Relationship Management
- **`Booking__c`** (Master-Detail to Booking__c)
  - Required: Yes
  - Links transaction to specific booking
  - Enables rollup summaries and cascading deletes

#### Financial Details
- **`Amount__c`** (Currency)
  - Required: Yes
  - Transaction amount
  - Can be positive (payment) or negative (refund)

- **`Type__c`** (Picklist)
  - Required: Yes
  - Transaction type classification
  - Values: Initial Payment, Security Deposit, Partial Payment, Late Fee, Damage Charge, Refund, Adjustment
  - Used for transaction categorization

#### Status and Timing
- **`Status__c`** (Picklist)
  - Transaction processing status
  - Values: Pending, Completed, Failed, Cancelled
  - Used for transaction monitoring

- **`Transaction_Date__c`** (DateTime)
  - Required: Yes
  - Transaction timestamp
  - Used for chronological tracking

**Business Logic**:
- Automatic booking balance updates
- Payment status synchronization
- Refund processing automation
- Transaction validation and processing

**Integration Points**:
- Payment gateway integration
- Accounting system synchronization
- Financial reporting
- Audit trail maintenance

---

### 5. Review__c
**Purpose**: Customer feedback and rating system with automated case creation

**Object Configuration**:
- **Label**: Review
- **Plural Label**: Reviews
- **Sharing Model**: Read (Public read for transparency)
- **Deployment Status**: Deployed

**Detailed Field Specifications**:

#### Review Content
- **`Rating__c`** (Number)
  - Required: No
  - Precision: 1, Scale: 0
  - Star rating (1-5 scale)
  - Used for quality assessment

- **`Comments__c`** (Long Text)
  - Optional review text
  - Customer feedback content
  - Used for qualitative analysis

#### Relationships
- **`Booking__c`** (Lookup to Booking__c)
  - Required: Yes
  - Links review to specific booking
  - Ensures one review per booking

- **`Customer__c`** (Lookup to Contact)
  - Required: Yes
  - Reviewer identification
  - Used for customer communication

**Automation Features**:
- Average rating calculation for cars
- Negative review case creation (rating < 3)
- Review validation and moderation
- Customer notification system

**Business Rules**:
- One review per booking
- Rating validation (1-5 range)
- Automatic case creation for negative reviews
- Customer communication triggers

---

### 6. Car_Image__c
**Purpose**: Comprehensive vehicle image management system

**Object Configuration**:
- **Label**: Car Image
- **Plural Label**: Car Images
- **Sharing Model**: Controlled by Parent (Car)
- **Deployment Status**: Deployed

**Detailed Field Specifications**:

#### Image Management
- **`Car__c`** (Lookup to Car__c)
  - Required: Yes
  - Links image to specific vehicle
  - Enables image galleries

- **`Image__c`** (File)
  - Optional image file attachment
  - Supports multiple file formats
  - Used for direct file uploads

- **`Image_Url__c`** (URL)
  - Optional external image URL
  - Used for CDN or external hosting
  - Alternative to file attachments

- **`Primary_Image__c`** (Checkbox)
  - Primary image designation
  - Only one per car
  - Used for main image display

**Features**:
- Multiple images per car
- Primary image designation
- File and URL support
- Image validation and processing
- Automatic primary image synchronization

**Business Logic**:
- Primary image enforcement (only one per car)
- Image validation and format checking
- Automatic URL synchronization
- Image processing and optimization

---

### 7. Log__e (Platform Event)
**Purpose**: Real-time system logging and monitoring

**Object Configuration**:
- **Label**: Log
- **Plural Label**: Logs
- **Type**: Platform Event
- **Deployment Status**: Deployed

**Detailed Field Specifications**:

#### Logging Information
- **`Log_Level__c`** (Text)
  - Required: Yes
  - Log severity level
  - Values: DEBUG, INFO, WARN, ERROR, FATAL
  - Used for log filtering and monitoring

- **`Message__c`** (Text)
  - Required: Yes
  - Log message content
  - Contains detailed error or information
  - Used for debugging and analysis

- **`Source__c`** (Text)
  - Required: Yes
  - Log source identification
  - Identifies originating component
  - Used for source tracking

- **`Timestamp__c`** (DateTime)
  - Required: Yes
  - Log timestamp
  - Used for chronological analysis
  - Automatic population

**Features**:
- Real-time event processing
- External system integration
- Log aggregation and analysis
- Performance monitoring
- Error tracking and alerting

**Integration Points**:
- External logging systems
- Monitoring dashboards
- Alert systems
- Analytics platforms

---

### 8. LogEvent__c
**Purpose**: Persistent log event storage for historical analysis

**Object Configuration**:
- **Label**: Log Event
- **Plural Label**: Log Events
- **Sharing Model**: Private
- **Deployment Status**: Deployed
- **Features Enabled**: Bulk API, Reports, Sharing, Streaming API

**Detailed Field Specifications**:

#### Event Information
- **`Log_Level__c`** (Text)
  - Log severity level
  - Same values as Platform Event
  - Used for filtering and analysis

- **`Message__c`** (Long Text)
  - Detailed log message
  - Extended content support
  - Used for comprehensive analysis

- **`Source__c`** (Text)
  - Source component identification
  - Used for component tracking

- **`Timestamp__c`** (DateTime)
  - Event timestamp
  - Used for temporal analysis

**Features**:
- Persistent storage
- Historical analysis
- Report generation
- Data retention management
- Automated cleanup processes

---

### 9. Custom Metadata Types

#### Disabled_For__mdt
**Purpose**: Feature flag and configuration management

**Field Specifications**:
- **`Object_Name__c`** (Text)
  - Target object name
  - Used for object-specific feature control

- **`Feature_Name__c`** (Text)
  - Feature identifier
  - Used for feature-specific control

**Use Cases**:
- Feature toggling
- Environment-specific configurations
- A/B testing
- Gradual feature rollouts

#### Metadata_Driven_Trigger__mdt
**Purpose**: Configurable trigger management system

**Field Specifications**:
- **`Object_Name__c`** (Text)
  - Target object for trigger
  - Used for trigger configuration

- **`Handler_Class__c`** (Text)
  - Apex handler class name
  - Used for dynamic trigger routing

- **`Is_Active__c`** (Checkbox)
  - Trigger activation flag
  - Used for enabling/disabling triggers

**Features**:
- Dynamic trigger management
- Environment-specific configurations
- Easy trigger maintenance
- Centralized trigger control

#### System_Thresholds__mdt
**Purpose**: System configuration and threshold management

**Field Specifications**:
- **`Threshold_Name__c`** (Text)
  - Threshold identifier
  - Used for threshold lookup

- **`Threshold_Value__c`** (Number)
  - Threshold value
  - Used for comparison operations

- **`Description__c`** (Text)
  - Threshold description
  - Used for documentation and understanding

**Use Cases**:
- Business rule thresholds
- Performance limits
- Configuration parameters
- System limits and boundaries

---

## Data Model Relationships

### Primary Relationships

#### Booking__c (Central Hub)
- **Master-Detail**: Payment_Transaction__c
- **Lookup**: Contact (Customer__c)
- **Lookup**: Car__c (Car__c)
- **Lookup**: Coupon_Code__c (Coupon_Code__c)
- **Lookup**: Review__c (one-to-one)

#### Car__c (Inventory Management)
- **Lookup**: Car_Image__c (one-to-many)
- **Lookup**: Review__c (through Booking__c)

#### Contact (Customer Management)
- **Lookup**: Booking__c (one-to-many)
- **Lookup**: Review__c (one-to-many)

### Relationship Patterns

#### Hierarchical Relationships
```
Contact (Customer)
    ↓ (one-to-many)
Booking__c
    ↓ (master-detail)
Payment_Transaction__c
    ↓ (one-to-many)
Review__c
```

#### Cross-Object Relationships
```
Car__c
    ↓ (one-to-many)
Car_Image__c
    ↓ (one-to-many)
Booking__c (through Car__c lookup)
```

### Data Integrity Rules

#### Referential Integrity
- Master-Detail relationships enforce referential integrity
- Lookup relationships maintain data consistency
- Validation rules prevent orphaned records

#### Business Rules
- One review per booking
- One primary image per car
- Unique coupon codes
- Sequential transaction numbering

#### Data Validation
- Date range validation
- Status transition validation
- Required field validation
- Format validation (email, phone, etc.)

---

## Data Model Best Practices

### 1. Naming Conventions
- **Objects**: Descriptive names with `__c` suffix
- **Fields**: Clear, descriptive names with `__c` suffix
- **Relationships**: Descriptive field names indicating purpose

### 2. Field Design
- **Appropriate Data Types**: Using correct field types for data
- **Required Fields**: Strategic use of required fields
- **Default Values**: Sensible defaults for picklist fields
- **Field Length**: Appropriate lengths for text fields

### 3. Relationship Design
- **Master-Detail**: For tightly coupled data with rollup needs
- **Lookup**: For loosely coupled data with independent lifecycle
- **External ID**: For integration and data migration

### 4. Validation and Security
- **Validation Rules**: Comprehensive business rule enforcement
- **Sharing Models**: Appropriate sharing for data sensitivity
- **Field-Level Security**: Granular access control
- **Record-Level Security**: Row-level security implementation

### 5. Performance Optimization
- **Indexing**: Strategic use of external IDs and indexed fields
- **Field Selection**: Minimizing field selection in queries
- **Relationship Queries**: Efficient relationship traversal
- **Bulk Operations**: Bulkified data operations

---

## Apex Classes

### Core Business Logic Classes

#### 1. BookingTriggerHandler
**Purpose**: Handles booking-related trigger events

**Key Methods**:
- `beforeInsert()`: Validates booking overlaps before creation
- `beforeUpdate()`: Re-validates overlaps when critical fields change
- `afterUpdate()`: Updates total booking value for cars

**Dependencies**: BookingTriggerHandlerService

#### 2. BookingTriggerHandlerService
**Purpose**: Core booking business logic

**Key Methods**:
- `validateBookingOverlap()`: Prevents double bookings
- `updateTotalBookingValueForCar()`: Calculates car revenue totals

#### 3. CarAvailabilityRestApiService
**Purpose**: REST API for external car availability queries

**Endpoint**: `/services/apexrest/v1/cars/available/*`

**Query Parameters**:
- `startDate`: Rental start date
- `endDate`: Rental end date
- `fuelType`: Fuel type filter
- `transmissionType`: Transmission filter
- `location`: Pickup location filter

**Response Format**:
- **Success Flag**: Boolean indicating operation success
- **Message Field**: Descriptive message about the operation
- **Cars Array**: Array of car objects with detailed information
- **Car Object Structure**: Contains car details, pricing, images, and specifications
- **Error Handling**: Includes error information when operations fail

#### 4. CarReviewController
**Purpose**: Manages car review operations

**Key Methods**:
- Review submission and validation
- Rating calculation and updates
- Negative review case creation

#### 5. ContactTriggerHandler
**Purpose**: Contact management automation

**Key Methods**:
- Email validation using external service
- Contact data enrichment
- Duplicate prevention

#### 6. PaymentTransactionTriggerHandler
**Purpose**: Payment processing logic

**Key Methods**:
- Payment validation and processing
- Security deposit calculations
- Refund processing automation

#### 7. ReviewTriggerHandler
**Purpose**: Review system automation

**Key Methods**:
- Average rating calculations
- Negative review case creation
- Review validation

### Utility Classes

#### 8. Constants
**Purpose**: Application-wide constants

**Key Constants**:
- Booking statuses (Pending, Confirmed, Started, Completed, Closed)
- Payment statuses (Pending, Partially Paid, Paid)
- Payment types (Initial Payment, Security Deposit, Partial Payment)
- Rating thresholds and system limits

#### 9. TestDataFactory
**Purpose**: Test data generation

**Key Methods**:
- `createContacts()`: Generate test contacts
- `createCars()`: Generate test cars
- `createBookings()`: Generate test bookings
- `createReviews()`: Generate test reviews

### Batch and Scheduled Classes

#### 10. LogCleanupBatch
**Purpose**: Automated log cleanup

**Features**:
- Scheduled log deletion
- Configurable retention periods
- Performance optimization

#### 11. QueuableTotalCarValue
**Purpose**: Asynchronous car value calculation

**Features**:
- Queueable implementation
- Bulk processing capability
- Error handling

---

## Lightning Web Components

### Core UI Components

#### 1. carTileList
**Purpose**: Main car listing component

**Features**:
- Dynamic car filtering via message channels
- Real-time search and filter updates
- Car selection and booking initiation
- Navigation to booking records

**Key Methods**:
- `handleCarSelected()`: Car selection handling
- `handleEstimateBooking()`: Booking estimation
- `handleBookNow()`: Direct booking creation

#### 2. carTile
**Purpose**: Individual car display card

**Features**:
- Car information display
- Rating visualization
- Action buttons (Estimate, Book Now)
- Event dispatching for parent components

**Properties**:
- `car`: Car record data
- Computed properties for display formatting

#### 3. bookCarModal
**Purpose**: Booking creation modal

**Features**:
- Lightning modal implementation
- Form validation and submission
- Success/error handling
- Navigation to created booking

**Form Fields**:
- Customer selection
- Start/end dates
- Coupon code application
- Car assignment (auto-populated)

#### 4. carFilter
**Purpose**: Advanced car filtering interface

**Features**:
- Date range selection
- Location filtering
- Fuel type and transmission filters
- Real-time filter updates via message channels

#### 5. carCard
**Purpose**: Detailed car information display

**Features**:
- Comprehensive car details
- Image gallery
- Specification display
- Booking actions

#### 6. carImageManager
**Purpose**: Car image management

**Features**:
- Image upload and management
- Primary image selection
- Image URL handling
- File validation

#### 7. carRatingReview
**Purpose**: Review and rating system

**Features**:
- Star rating input
- Review text submission
- Rating display
- Review validation

#### 8. estimateBooking
**Purpose**: Booking cost estimation

**Features**:
- Price calculation
- Duration-based pricing
- Coupon code application
- Cost breakdown display

#### 9. estimateCarBooking
**Purpose**: Car-specific booking estimation

**Features**:
- Car-specific pricing
- Availability checking
- Date validation
- Cost preview

### Utility Components

#### 10. starRating
**Purpose**: Reusable star rating component

**Features**:
- Interactive star selection
- Read-only mode support
- Customizable star count
- Event dispatching

#### 11. errorPanel
**Purpose**: Error handling and display

**Features**:
- Error message display
- No data illustrations
- Inline message templates
- Consistent error styling

#### 12. placeholder
**Purpose**: Loading and empty state management

**Features**:
- Loading animations
- Empty state illustrations
- Customizable messages
- Responsive design

#### 13. ldsUtils
**Purpose**: Lightning Data Service utilities

**Features**:
- Record operations
- Error handling
- Data transformation
- Service layer abstraction

---

### Component Relationship Diagrams

#### 1. Main Application Flow
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   carFilter     │    │  carTileList    │    │    carTile      │
│                 │    │                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ Search      │ │    │ │ carTile × N │ │    │ │ Car Image   │ │
│ │ Location    │ │    │ │             │ │    │ │ Car Info    │ │
│ │ Date Range  │ │    │ │ placeholder │ │    │ │ Rating      │ │
│ │ Filters     │ │    │ │ errorPanel  │ │    │ │ Actions     │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │ Message Channel       │ Event Handling        │ Event Handling
         │ (carFilter)           │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Filter Updates  │    │ Car Selection   │    │ User Actions    │
│ Published       │    │ Published       │    │ (Estimate/Book) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### 2. Message Channel Communication Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                    Message Channel Architecture                 │
└─────────────────────────────────────────────────────────────────┘

carFilter Component                    carTileList Component
┌─────────────────┐                   ┌─────────────────┐
│ Filter Changes  │ ──Message───────► │ Filter Updates  │
│                 │                   │                 │
│ • Search        │                   │ • Query Cars    │
│ • Location      │                   │ • Update UI     │
│ • Date Range    │                   │ • Handle States │
│ • Filters       │                   │                 │
└─────────────────┘                   └─────────────────┘
         │                                       │
         │ carFilter Message Channel             │ carSelection Message Channel
         │                                       │
         ▼                                       ▼
┌─────────────────┐                   ┌─────────────────┐
│ Published Data: │                   │ Published Data: │
│ {                │                   │ {               │
│   selCarFilter:  │                   │   carId: "..."  │
│   {              │                   │ }               │
│     filters: {...}│                   │                 │
│   }              │                   │                 │
│ }                │                   │                 │
└─────────────────┘                   └─────────────────┘
```

#### 3. Component Hierarchy and Data Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                    Component Hierarchy                          │
└─────────────────────────────────────────────────────────────────┘

Parent Page/App
│
├── carFilter
│   ├── lightning-input (search)
│   ├── lightning-combobox (location)
│   ├── lightning-input (dates)
│   ├── lightning-slider (seats, rate, rating)
│   └── lightning-input (checkboxes)
│
├── carTileList
│   ├── lightning-card
│   ├── lightning-layout
│   │   └── lightning-layout-item × N
│   │       └── carTile
│   │           ├── img (car image)
│   │           ├── lightning-icon (price)
│   │           ├── starRating
│   │           ├── lightning-badge (transmission)
│   │           ├── lightning-badge (fuel)
│   │           └── lightning-button × 2 (actions)
│   ├── placeholder
│   └── errorPanel
│
└── Modal Components (when triggered)
    ├── bookCarModal
    │   ├── lightning-modal-header
    │   ├── lightning-modal-body
    │   ├── lightning-record-edit-form
    │   ├── lightning-input-field × 4
    │   └── lightning-button × 2
    └── estimateCarBooking
        ├── lightning-modal-header
        ├── lightning-modal-body
        └── estimation components
```

#### 4. Event Flow Diagram
```
┌─────────────────────────────────────────────────────────────────┐
│                        Event Flow                               │
└─────────────────────────────────────────────────────────────────┘

User Interaction Flow:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ User Types  │───►│ carFilter   │───►│ Message     │───►│ carTileList │
│ in Filter   │    │ Validates   │    │ Channel     │    │ Updates     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                    │
                                                                    ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Modal       │◄───│ carTileList │◄───│ carTile      │◄───│ User Clicks │
│ Opens       │    │ Handles     │    │ Dispatches   │    │ Book Now    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │
       ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Booking     │───►│ Success     │───►│ Navigation  │
│ Created     │    │ Toast       │    │ to Record   │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Message Channel Implementation Details

#### 1. carFilter Message Channel
**Purpose**: Transmits filter criteria between components

**Channel Definition**:
- **Master Label**: CarFilter for display purposes
- **Exposure**: Set to true for cross-component access
- **Description**: Documents the channel's purpose for filter criteria transmission
- **Message Fields**: Defines selCarFilter field for filter data structure
- **Field Description**: Documents the filter criteria purpose

**Publisher (carFilter)**:
- **Message Service Import**: Imports publish and MessageContext from Lightning Message Service
- **Channel Import**: Imports carFilter message channel
- **Wire Service**: Uses @wire decorator for MessageContext
- **Publish Method**: Creates payload with filter data and publishes to message channel
- **Filter Structure**: Organizes filters in selCarFilter object structure

**Subscriber (carTileList)**:
- **Message Service Import**: Imports subscribe, unsubscribe, APPLICATION_SCOPE, and MessageContext
- **Channel Import**: Imports carFilter message channel
- **Wire Service**: Uses @wire decorator for MessageContext
- **Lifecycle Methods**: Implements connectedCallback and disconnectedCallback for subscription management
- **Subscription Logic**: Creates subscription with APPLICATION_SCOPE for cross-component communication
- **Message Handling**: Processes incoming filter messages and updates component state
- **State Management**: Updates filters and controls initial message display

#### 2. carSelection Message Channel
**Purpose**: Transmits selected car information

**Channel Definition**:
- **Master Label**: Car Selection for display purposes
- **Exposure**: Set to true for cross-component access
- **Description**: Documents the channel's purpose for selected car ID transmission
- **Message Fields**: Defines carId field for car record identification
- **Field Description**: Documents the selected car record ID purpose

**Publisher (carTileList)**:
- **Channel Import**: Imports carSelection message channel
- **Event Handling**: Processes car selection events from child components
- **Payload Creation**: Creates payload with car ID from event detail
- **Message Publishing**: Publishes car selection to message channel for other components

### Component Communication Best Practices

#### 1. Message Channel Benefits
- **Decoupled Communication**: Components don't need direct references
- **Scalable Architecture**: Easy to add new subscribers
- **Cross-Page Communication**: Works across different pages
- **Performance**: Efficient event handling

#### 2. Event-Driven Patterns
- **Custom Events**: For parent-child communication
- **Property Binding**: For data flow from parent to child
- **Method Calls**: For direct child component control

#### 3. State Management
- **Local State**: Component-specific data
- **Shared State**: Message channel data
- **Server State**: Wire service data

#### 4. Performance Optimizations
- **Debouncing**: Prevents excessive API calls
- **Lazy Loading**: Components load on demand
- **Efficient Rendering**: Conditional rendering patterns
- **Event Delegation**: Efficient event handling

This comprehensive Lightning Web Components architecture provides a scalable, maintainable, and performant user interface that follows Salesforce best practices and modern web development patterns.

---

### Trigger Architecture

The application uses a **metadata-driven trigger pattern** for maintainability and scalability. All triggers follow a consistent pattern:

**Trigger Pattern**:
- **Consistent Structure**: All triggers follow the same metadata-driven pattern
- **Handler Integration**: Uses MetadataTriggerHandler for centralized management
- **Event Processing**: Handles multiple trigger events (before/after insert/update/delete)
- **Maintainability**: Single point of configuration for all trigger logic

This pattern provides:
- **Centralized Management**: All trigger logic managed through metadata
- **Environment Flexibility**: Easy enable/disable per environment
- **Maintainability**: Single point of configuration
- **Scalability**: Consistent pattern across all objects

---

### Detailed Trigger Analysis

#### 1. BookingTrigger
**Purpose**: Core booking validation and business logic automation

**Trigger Events**:
- `before insert`: Validation before record creation
- `before update`: Validation before record modification
- `after update`: Business logic after record modification

**Handler Class**: `BookingTriggerHandler`
**Service Class**: `BookingTriggerHandlerService`

**Detailed Business Logic**:

##### Before Insert Processing
- **Overlap Validation**: Prevents double bookings for the same car
- **Date Validation**: Ensures start date is before end date
- **Status Validation**: Sets appropriate initial status
- **Field Validation**: Validates required fields and business rules

##### Before Update Processing
- **Change Detection**: Identifies critical field changes (Car, Start Date, End Date)
- **Re-validation**: Re-runs overlap validation for changed bookings
- **Status Transition**: Validates status changes are appropriate
- **Business Rule Enforcement**: Ensures data consistency

##### After Update Processing
- **Revenue Calculation**: Updates total booking value for cars
- **Status Synchronization**: Synchronizes related record statuses
- **Notification Triggers**: Initiates customer communications
- **Audit Trail**: Maintains booking history

**Key Methods in BookingTriggerHandlerService**:

###### `validateBookingOverlap(List<Booking__c> bookings)`
**Purpose**: Prevents overlapping bookings for the same vehicle

**Algorithm**:
1. **Car Collection**: Extracts all car IDs from new bookings
2. **Existing Booking Query**: Retrieves active bookings for same cars
3. **Overlap Detection**: Uses date range intersection logic
4. **Error Handling**: Adds validation errors for overlapping bookings

**Overlap Detection Logic**:
- **Date Range Comparison**: Compares start and end dates of bookings
- **Intersection Logic**: Checks if date ranges overlap using mathematical comparison
- **Boolean Return**: Returns true if overlap exists, false otherwise
- **Efficient Algorithm**: Simple and performant overlap detection

**Active Status Filtering**:
- Pending, Confirmed, Started, Completed statuses considered active
- Cancelled and Closed bookings excluded from overlap check

###### `updateTotalBookingValueForCar(List<Booking__c> bookings, Map<Id,Booking__c> oldBookingMap)`
**Purpose**: Updates car revenue totals when bookings are closed

**Process**:
1. **Status Change Detection**: Identifies bookings transitioning to "Closed"
2. **Car Collection**: Extracts car IDs from closed bookings
3. **Asynchronous Processing**: Queues `QueuableTotalCarValue` job
4. **Revenue Calculation**: Calculates total revenue per car

**Performance Optimization**:
- Only processes bookings that change to "Closed" status
- Uses asynchronous processing for bulk operations
- Implements efficient car ID collection

**Error Handling**:
- Comprehensive exception handling
- Logging integration for debugging
- Graceful failure handling

---

#### 2. ReviewTrigger
**Purpose**: Customer feedback processing and quality management automation

**Trigger Events**:
- `after insert`: Process new reviews
- `after update`: Handle review modifications
- `after delete`: Recalculate averages when reviews are removed

**Handler Class**: `ReviewTriggerHandler`
**Service Class**: `ReviewTriggerHandlerService`

**Detailed Business Logic**:

##### After Insert Processing
- **Rating Analysis**: Evaluates review ratings for quality issues
- **Case Creation**: Automatically creates cases for low ratings (< 3 stars)
- **Sharing Management**: Shares booking records with customer support
- **Average Calculation**: Updates car average ratings

##### After Update Processing
- **Rating Recalculation**: Recalculates averages when ratings change
- **Case Updates**: Updates related cases if rating changes
- **Sharing Updates**: Maintains appropriate record sharing

##### After Delete Processing
- **Average Recalculation**: Recalculates car averages when reviews are deleted
- **Case Cleanup**: Handles case management for deleted reviews
- **Sharing Cleanup**: Removes unnecessary record sharing

**Key Methods in ReviewTriggerHandlerService**:

###### `shareLowRatingAndCreateCase(List<Review__c> reviews)`
**Purpose**: Manages low-rating reviews and customer support access

**Process Flow**:
1. **Group Identification**: Retrieves Customer Support public group
2. **Booking Collection**: Extracts booking IDs from reviews
3. **Sharing Check**: Verifies existing sharing records
4. **Sharing Creation**: Creates manual sharing records for support team
5. **Case Creation**: Calls `createCaseForLowRating()` method

**Sharing Logic**:
- **Manual Sharing**: Creates Booking__share records for customer support access
- **Parent Assignment**: Links sharing record to specific booking
- **Group Assignment**: Assigns sharing to Customer Support public group
- **Access Level**: Sets read-only access for support team
- **Row Cause**: Uses manual sharing cause for explicit access control

###### `createCaseForLowRating(List<Review__c> reviews)`
**Purpose**: Automatically creates support cases for negative reviews

**Case Creation Logic**:
1. **Record Type**: Uses "Review_Issue" record type
2. **Duplicate Prevention**: Checks for existing cases per review
3. **Case Population**: Populates case fields with review data
4. **Relationship Mapping**: Links case to booking, customer, and car

**Case Field Mapping**:
- `Type`: "Negative Review"
- `Priority`: "Medium"
- `Review_ID__c`: Review record ID
- `Related_Booking__c`: Associated booking
- `Related_Car__c`: Associated car (via booking)
- `Subject`: "Low Rating Review : X Stars"
- `Description`: Review comments

###### `udpateCarAverageRating(List<Review__c> listOfReviews)`
**Purpose**: Calculates and updates car average ratings

**Calculation Process**:
1. **Booking Mapping**: Maps reviews to cars through bookings
2. **Aggregate Query**: Calculates average ratings per car
3. **Rating Rounding**: Rounds averages using HALF_UP mode
4. **Car Updates**: Updates car records with new averages
5. **Null Handling**: Sets rating to null if no reviews exist

**Aggregate Query**:
- **Car Grouping**: Groups reviews by car through booking relationship
- **Average Calculation**: Calculates average rating per car using aggregate function
- **Filtering**: Filters reviews for specific car IDs
- **Data Structure**: Returns car ID and average rating for processing

**Error Handling**:
- Comprehensive exception handling
- Logging integration
- Graceful failure handling

---

#### 3. ContactTrigger
**Purpose**: Contact management and data validation automation

**Trigger Events**:
- `after insert`: Process new contacts
- `after update`: Handle contact modifications

**Handler Class**: `ContactTriggerHandler`
**Service Class**: `ContactTriggerHandlerService`

**Detailed Business Logic**:

##### After Insert Processing
- **Email Validation**: Initiates asynchronous email validation
- **Data Enrichment**: Triggers contact data enhancement
- **Duplicate Detection**: Identifies potential duplicate contacts
- **Communication Setup**: Prepares customer communication channels

##### After Update Processing
- **Change Detection**: Identifies critical field changes
- **Re-validation**: Re-runs validation for modified contacts
- **Data Synchronization**: Updates related records
- **Audit Trail**: Maintains contact change history

**Key Methods in ContactTriggerHandlerService**:

###### `processContact(List<Contact> contacts)`
**Purpose**: Initiates contact processing workflows

**Process Flow**:
1. **Contact Collection**: Extracts contact IDs from trigger context
2. **Asynchronous Processing**: Queues `queueableEmailValidation` job
3. **Batch Processing**: Handles multiple contacts efficiently

**Asynchronous Processing**:
- **Queueable Job**: Uses System.enqueueJob for asynchronous execution
- **Contact Processing**: Processes contact IDs in background
- **Non-blocking**: Prevents blocking of main transaction
- **Error Isolation**: Isolates processing errors from main flow

**Benefits**:
- Non-blocking processing
- Bulk operation support
- Error isolation
- Retry capability

---

#### 4. PaymentTransactionTrigger
**Purpose**: Financial transaction processing and booking status automation

**Trigger Events**:
- `after insert`: Process new payment transactions
- `after delete`: Handle transaction deletions

**Handler Class**: `PaymentTransactionTriggerHandler`
**Service Class**: `PaymentTransactionTriggerHandlerService`

**Detailed Business Logic**:

##### After Insert Processing
- **Payment Aggregation**: Calculates total payments per booking
- **Status Calculation**: Determines payment and booking statuses
- **Balance Updates**: Updates booking balance fields
- **Notification Triggers**: Initiates payment confirmations

##### After Delete Processing
- **Re-calculation**: Recalculates totals after transaction deletion
- **Status Updates**: Updates booking statuses accordingly
- **Balance Adjustments**: Adjusts booking balances

**Key Methods in PaymentTransactionTriggerHandlerService**:

###### `handlePaymentTransactions(List<Payment_Transaction__c> paymentTransactions)`
**Purpose**: Processes payment transactions and updates booking statuses

**Process Flow**:
1. **Booking Collection**: Extracts booking IDs from transactions
2. **Payment Aggregation**: Groups payments by type and booking
3. **Status Calculation**: Calculates payment and booking statuses
4. **Booking Updates**: Updates booking records with new statuses

**Payment Type Processing**:
- **Initial Payment**: Primary rental payment
- **Security Deposit**: Security deposit payment
- **Partial Payment**: Additional rental payments
- **Late Fee**: Overdue payment charges
- **Damage Charge**: Damage-related charges
- **Refund**: Payment refunds
- **Adjustment**: Payment adjustments

**Query Optimization**:
- **Parent-Child Query**: Uses relationship query to get booking and payment data
- **Field Selection**: Selects only necessary fields for performance
- **Status Filtering**: Filters payments by success status and type
- **Efficient Joins**: Uses relationship queries instead of separate queries

###### `calculatePaymentStatus(Decimal initialPayment, Decimal partialPayment, Decimal securityPayment, Decimal finalBookingPrice, Decimal securityDeposit)`
**Purpose**: Determines payment status based on payment amounts

**Status Logic**:
- **Paid**: Total rental payment ≥ Final booking price AND Security payment ≥ Security deposit
- **Partially Paid**: Some payments made but not complete
- **Pending**: No payments made

**Calculation Formula**:
- **Total Payment Calculation**: Sums initial and partial payments
- **Completion Check**: Compares total payment against final booking price
- **Security Deposit Check**: Compares security payment against required deposit
- **Status Determination**: Returns appropriate status based on completion criteria

###### `calculateBookingStatus(Decimal initialPayment, Decimal partialPayment, Decimal securityPayment, String currentBookingStatus)`
**Purpose**: Determines booking status based on payment status

**Status Transition Logic**:
- **Pending → Confirmed**: When any payment is received
- **Other Statuses**: Remain unchanged unless specific conditions met

**Business Rules**:
- Payment receipt triggers booking confirmation
- Status changes are conservative (only Pending → Confirmed)
- Maintains existing status unless payment conditions met

---

#### 5. LogTrigger
**Purpose**: System logging and monitoring automation

**Trigger Events**:
- `after insert`: Process new log events

**Handler Class**: `LogTriggerHandler`
**Service Class**: `LogTriggerHandlerService`

**Detailed Business Logic**:

##### After Insert Processing
- **Log Processing**: Processes platform event logs
- **External Integration**: Sends logs to external systems
- **Alert Generation**: Creates alerts for critical errors
- **Performance Monitoring**: Tracks system performance metrics

**Key Features**:
- **Real-time Processing**: Immediate log event processing
- **External Integration**: Integration with monitoring systems
- **Alert Management**: Critical error alerting
- **Performance Tracking**: System performance monitoring

**Log Levels Supported**:
- **DEBUG**: Development and debugging information
- **INFO**: General information messages
- **WARN**: Warning messages
- **ERROR**: Error conditions
- **FATAL**: Critical system errors

---

### Trigger Best Practices Implementation

#### 1. Bulk Processing
- **Collection Patterns**: All triggers use collection-based processing
- **SOQL Optimization**: Efficient queries with proper field selection
- **DML Optimization**: Bulk DML operations for performance

#### 2. Error Handling
- **Exception Management**: Comprehensive try-catch blocks
- **Logging Integration**: Error logging to platform events
- **Graceful Degradation**: System continues functioning despite errors

#### 3. Performance Optimization
- **Asynchronous Processing**: Queueable jobs for heavy operations
- **Query Efficiency**: Optimized SOQL queries
- **Bulk Operations**: Bulkified DML operations

#### 4. Maintainability
- **Metadata-Driven**: Centralized trigger management
- **Service Layer**: Business logic separation
- **Consistent Patterns**: Uniform trigger implementation

#### 5. Testing Coverage
- **Comprehensive Tests**: Full trigger test coverage
- **Edge Cases**: Testing of boundary conditions
- **Error Scenarios**: Testing of failure conditions

---

### Trigger Dependencies and Integration

#### Cross-Trigger Dependencies
- **BookingTrigger** → **PaymentTransactionTrigger**: Payment status updates
- **ReviewTrigger** → **Case Management**: Automatic case creation
- **ContactTrigger** → **Email Validation**: External service integration

#### External System Integration
- **Email Validation Service**: Contact validation
- **Payment Gateway**: Transaction processing
- **Logging Systems**: External monitoring

#### Data Flow Patterns
```
Contact Creation → Email Validation → Contact Enrichment
Booking Creation → Payment Processing → Status Updates
Review Creation → Rating Calculation → Case Creation
Payment Transaction → Status Calculation → Notification
```

This comprehensive trigger architecture ensures robust data integrity, automated business processes, and seamless integration with external systems while maintaining high performance and maintainability standards.

---

## Flows and Process Automation

### Business Process Flows

#### 1. Approval_for_Coupon_Code
**Purpose**: Coupon code approval workflow
**Trigger**: Coupon code creation/update
**Process**:
- Manager approval required
- Email notifications
- Status updates
- Approval history tracking

#### 2. Car_Return_Checklist
**Purpose**: Car return process automation
**Trigger**: Booking completion
**Process**:
- Return checklist generation
- Damage assessment
- Mileage verification
- Deposit refund calculation

#### 3. Estimate_your_Booking
**Purpose**: Booking cost estimation
**Trigger**: User-initiated
**Process**:
- Price calculation
- Duration computation
- Discount application
- Cost breakdown

#### 4. Post_Booking_Automation_After_Save_activity
**Purpose**: Post-booking activities
**Trigger**: Booking creation/update
**Process**:
- Email notifications
- Calendar events
- Task creation
- Status updates

#### 5. Post_Booking_Automation_Field_Update
**Purpose**: Booking field updates
**Trigger**: Booking status changes
**Process**:
- Status synchronization
- Payment updates
- Availability changes
- Notification triggers

#### 6. Post_Booking_Cancellation_Automation
**Purpose**: Cancellation processing
**Trigger**: Booking cancellation
**Process**:
- Refund calculations
- Availability restoration
- Customer notifications
- Cancellation tracking

#### 7. Prevent_Deletion_Of_Primary_Image
**Purpose**: Image protection
**Trigger**: Image deletion attempt
**Process**:
- Primary image validation
- Deletion prevention
- User notifications
- Alternative suggestions

#### 8. Sync_Primary_Image
**Purpose**: Image synchronization
**Trigger**: Image updates
**Process**:
- Primary image updates
- URL synchronization
- Cache invalidation
- Display updates

---

## Security and Sharing

### Sharing Models

#### 1. Private Sharing
- **Booking__c**: Private sharing with manual sharing rules
- **Payment_Transaction__c**: Controlled by parent (Booking)

#### 2. Read Sharing
- **Car__c**: Public read access for customer browsing
- **Review__c**: Public read access for transparency

#### 3. ReadWrite Sharing
- **Coupon_Code__c**: ReadWrite access for management

### Permission Sets

#### 1. Car_Rental_Manager
**Permissions**:
- Full CRUD on all objects
- Approval process management
- System configuration access
- Report and dashboard access

#### 2. Car_Rental_Agent
**Permissions**:
- Booking management
- Customer service
- Limited administrative access
- Case management

### Profiles

#### 1. Car Rental Manager Profile
**Features**:
- Administrative access
- Approval process management
- System configuration
- Full object permissions

#### 2. Car Rental Agent Profile
**Features**:
- Operational access
- Customer service tools
- Limited administrative functions
- Standard object permissions

### Sharing Rules

#### 1. Booking Sharing Rules
- Manager access to all bookings
- Agent access to assigned bookings
- Customer access to own bookings

#### 2. Case Sharing Rules
- Support team access
- Manager escalation access
- Customer visibility

---

## API Integration

### REST API Services

#### 1. Car Availability API
**Endpoint**: `/services/apexrest/v1/cars/available/*`
**Method**: GET
**Authentication**: Salesforce session-based

**Request Parameters**:
```
startDate: YYYY-MM-DD (required)
endDate: YYYY-MM-DD (required)
location: String (required)
fuelType: String (optional)
transmissionType: String (optional)
```

**Response Format**:
- **Success Flag**: Boolean indicating operation success
- **Message Field**: String message describing the operation result
- **Cars Array**: Array of car objects with detailed information
- **Car Object Structure**: Contains car details, pricing, images, and specifications
- **Error Handling**: Includes error information when operations fail

### External Service Integration

#### 1. Email Validation Service
**Purpose**: Contact email validation
**Implementation**: HTTP callout with mock service
**Handler**: queueableEmailValidation class

**Features**:
- Asynchronous processing
- Retry mechanism
- Error handling
- Status tracking

### Named Credentials

#### 1. Email_Validation_Service
**Purpose**: External email validation API
**Type**: Named Credential
**Authentication**: API Key
**Endpoint**: Configurable external service

---

## Testing Strategy

### Apex Test Classes

#### 1. BookingTriggerTest
**Coverage**: BookingTriggerHandler
**Test Scenarios**:
- Booking overlap validation
- Status transition testing
- Payment processing
- Error handling

#### 2. CarAvailabilityRestApiServiceTest
**Coverage**: CarAvailabilityRestApiService
**Test Scenarios**:
- API parameter validation
- Query execution
- Response formatting
- Error conditions

#### 3. ContactTriggerHandlerServiceTest
**Coverage**: ContactTriggerHandlerService
**Test Scenarios**:
- Email validation
- Duplicate prevention
- Data enrichment
- Error handling

#### 4. PaymentTransactionTriggerHandlerTest
**Coverage**: PaymentTransactionTriggerHandler
**Test Scenarios**:
- Payment processing
- Refund calculations
- Status updates
- Validation rules

#### 5. ReviewTriggerTest
**Coverage**: ReviewTriggerHandler
**Test Scenarios**:
- Rating calculations
- Case creation
- Review validation
- Average computation

### Test Data Factory

#### TestDataFactory Class
**Purpose**: Centralized test data creation

**Methods**:
- `createContacts()`: Generate test contacts
- `createCars()`: Generate test cars
- `createBookings()`: Generate test bookings
- `createReviews()`: Generate test reviews

**Features**:
- Configurable record counts
- Realistic data generation
- Relationship management
- Bulk data creation


## File Structure Overview

### Force App Structure
```
force-app/main/default/
├── applications/           # Custom applications
├── approvalProcesses/      # Approval workflows
├── assignmentRules/        # Case assignment rules
├── aura/                   # Aura components (legacy)
├── classes/                # Apex classes
├── contentassets/          # Static content
├── customMetadata/         # Custom metadata types
├── duplicateRules/         # Duplicate prevention
├── escalationRules/        # Case escalation
├── flexipages/            # Lightning pages
├── flowDefinitions/       # Flow definitions
├── flows/                 # Flow processes
├── groups/                # Public groups
├── labels/                # Custom labels
├── layouts/               # Page layouts
├── lwc/                   # Lightning Web Components
├── matchingRules/         # Duplicate matching
├── messageChannels/       # Lightning message channels
├── namedCredentials/      # External service credentials
├── objects/               # Custom objects
├── pathAssistants/        # Path definitions
├── permissionsets/        # Permission sets
├── profiles/              # User profiles
├── queues/                # Case queues
├── quickActions/          # Quick actions
├── roles/                 # User roles
├── sharingRules/          # Sharing rules
├── staticresources/       # Static resources
├── tabs/                  # Custom tabs
├── triggers/              # Apex triggers
└── workflows/              # Workflow rules
```

### Key Directories

#### classes/
Contains all Apex classes including:
- Trigger handlers
- Service classes
- Controller classes
- Test classes
- Utility classes
- Batch and scheduled classes

#### lwc/
Contains Lightning Web Components:
- UI components
- Utility components
- Test files
- Configuration files

#### objects/
Contains custom object definitions:
- Object metadata
- Field definitions
- Validation rules
- List views
- Record types

#### flows/
Contains process automation:
- Business process flows
- Screen flows
- Record-triggered flows
- Scheduled flows

---

## Best Practices Implemented

### 1. Code Organization
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Modular Design**: Reusable components and services
- **Consistent Naming**: Standardized naming conventions across all components

### 2. Security
- **Sharing Model**: Appropriate sharing models for different data types
- **Permission Sets**: Granular permission management
- **Data Validation**: Comprehensive validation rules and triggers

### 3. Performance
- **Bulk Processing**: Bulkified triggers and batch operations
- **Efficient Queries**: Optimized SOQL queries with proper indexing
- **Caching**: Strategic use of caching mechanisms

### 4. Maintainability
- **Metadata-Driven**: Configurable trigger and automation patterns
- **Test Coverage**: Comprehensive test coverage for all components
- **Documentation**: Detailed inline documentation and comments

### 5. User Experience
- **Responsive Design**: Mobile-friendly Lightning Web Components
- **Real-time Updates**: Message channels for dynamic updates
- **Error Handling**: Comprehensive error handling and user feedback

---

## Conclusion

The Car On Rental App represents a comprehensive, enterprise-grade Salesforce application that demonstrates modern development practices and architectural patterns. The application provides a complete solution for car rental businesses with robust features for inventory management, booking processing, payment handling, and customer service.

The architecture follows Salesforce best practices with clear separation of concerns, comprehensive testing, and scalable design patterns. The use of Lightning Web Components ensures a modern, responsive user experience while the metadata-driven approach provides flexibility and maintainability.

This documentation serves as a comprehensive guide for developers, administrators, and stakeholders to understand the application's architecture, functionality, and implementation details.

---

*Document Version: 1.0*  
*Last Updated: [Current Date]*  
*Author: Technical Documentation Team*
