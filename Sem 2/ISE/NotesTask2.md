# Use Cases

1. Searching and direct booking of room

2. Get navigation instructions to room

# User Stories

1. As a *Student*, I want *to book a room*, so that *I have a place to work*.

2. As a *Guest*, I want *to have navigational instructions*, so that *I am able to locate a room*.

3. As a *Professor*, I want *book a room according to a schedule*, so that *I can give regular lectures in that room*.

# Use Case specification

* Name: Search and book a room for current room
* Scope: University Room Management System
* Level: User goal
* Primary actor: Student or Professor
* Stakeholders / interests:
  * Other students and professors
  * University
* Preconditions:
  * Valid university card (either enrolled student or university employee)
* Postconditions:
  * Status of rooms in the room database is updated
* Main success scenario:
  1. User searches a Room via a Room number
  2. System returns list of rooms fulfilling search query
  3. User selects a room
  4. System shows detailed information about selected room
  5. User books the room
  6. System updates booking status of the room
  7. System shows booking information and confirmation
* Extensions:
  * 1a. User searches rooms via room properties
    1. User opens list of checkboxes and input fields
    2. User checks their requirements and confirms
  * 2a. No room fulfilling search criteria exists
    1. System shows message: "No rooms found"
    2. System shows rooms similar to search criteria
  * 5a Room is already booked
    1. System shows message: "Room is already booked"
    2. System suggests list of similar rooms
  * 5b User already booked the allowed maximum amount of rooms
    1. System shows message: "You cannot book another room"
    2. System shows the list of already booked rooms
  * 5c User books room according to a schedule
    1. System presents a day and time picker
    2. User selects day of week and time
    3. System asks for the frequency of the booking
    4. User selects how often booking should be repeated
    5. System books room for all selected timeslots
       * 5a Room is not available in all time slots
         1. System shows message: "Room is not avalable at <DAY / TIME>"
         2. System provides alternative timeslots and rooms
         3. User selects alternatives
* Special requirements:
  * Stable database
  * Simple UI design
  * Fast search
* Technology / data variation: Available via a terminal at the univeryity or as via web app
* Frequency of occurence: Very regularly, up to multiple requests per minute, long pauses of no interaction also possible
* Open issues:
  * Booking of multiple rooms at once

# User story details

1. As a *Student*, I want *to book a room*, so that *I have a place to work*.
   * A Student is only allowed to book at most one room at any given time
   * Students can only book rooms for the current time and are not able to reserve them for later.
   * A student is identified by their university id
   * Bookings by students do not have an ending time specified
   * Students are able to terminate their bookings manually
   * Bookings are terminated automatically, if a booking by an employee starts.

2. As a *Guest*, I want *to have navigational instructions*, so that *I am able to locate a room*.
   * User Story is also valid for students and university employees
   * Navigation is realized trough  building schematics, aswell as indoor and outdoor maps
   * Other points of interest (parking spots, water fountains) are out of scope and might be part of standalone user stories
   * Users do not need to be verified for navigation
