# Treat Yo Self Readme

## Treat Yo Self APP
The TreatYoSelf API is a combination of a GraphQL API and several Restful endpoints. The data base is queried with GraphQl while third part API calls are consumed using Restful endpoints. The app is built with Ruby on Rails and Postgres to expose data to a React/Native Front End. It also utilizes the Google Oauth and Calendar API to fill in a user's calendar with activities during open time slots.

# Postgress
## Schema

| Users | Data Type |        
| ----------- | ----------- |
| Id | ID |
| first_name | String |
| last_name | String |
| email | String |
|self_care_time | Time|
| google_token | String |

| Activities | Data Type |
| ----------- | ----------- |
| Id | ID |
| name | String |
| est_time | Time |

| Categories | Data Type |
| ----------- | ----------- |
| Id | ID |
| name | String |

| CategoryActivities | Data Type |
| ----------- | ----------- |
| Id | ID |
| activity_id | ID |
| category_id | ID |

| UserActivities| Data Type |
| ----------- | ----------- |
| Id | ID |
| user_id | ID |
| category_activity_id | ID |

| EventSchedules | Data Type |
| ----------- | ----------- |
| Id | ID |
| user_id | ID |
| event_name | String |
| event_start_time | Float |
| event_end_time | Float |
| end_time | Float |
| weekday | String |


## Restful Endpoints
~~~~
get '/suggestions'
~~~~
Calls on the Google Calendar API to find open availability in your Google Calendar and schedule a way to Treat Yo Self during the upcoming week. It will also schedule a notification to remind you of the event.
~~~~
post '/suggestions'
~~~~
Takes in an array of Categories that a user selects, finds associated Treats with those Categories and connects those Treats as options to schedule in a user's Google Calendar.

~~~~
get '/user/events'
~~~~
Retrieves all of a User's Scheduled Events within a the upcoming week to display for the user to see.

~~~~
post '/user'
~~~~
Creates a user in the database.


## GraphQL

### Queries

  * Example Query

  1. **getCategories**  *Returns a list of all Categories*
  * Example Query
  ~~~~
      {
      	getCateogories {
           name
        }
      }
   ~~~~
  * Example Response
  ~~~~
  { "data": {
    "getCategories": {
      "name": "Outdoors"
    }
    {
      "name": "Medatative"
    }
    {
      "name": "Spa"
    }
  }
}  
~~~~
  2. **getUserActivities(id: ID)**  *Returns a list of all activities belonging to a specific user. Id is a user id.*
  * Example Query
~~~~
      {
      	getUserActivities(id: "112") {
           activities
        }
      }
   ~~~~
  * Example Response
  ~~~~
  { "data": {
    "getUserActivities": {
      "activities": ["Bath", "Yoga", "Outdoor Walk"]
    }
  }
}  
~~~~
3. **getActivities**  *Returns a list of all Activities*
  * Example Query
~~~~
      {
      	getActivities {
           name
        }
      }
   ~~~~
  * Example Response
  ~~~~
  { "data": {
    "getActivities": {
      "name": "Yoga"
    }
    {
      "name": "Hike"
    }
    {
      "name": "Bubble Bath"
    }
  }
}  
~~~~
4. **getCategoryActivities**  *Returns a list of all Activities by Category (id is a category name)*
  * Example Query
  ~~~~
      {
      	getCategoryActivities(id: "Outdoors") {
           activities
        }
      }
   ~~~~
  * Example Response
  ~~~~
  { "data": {
    "getCategoryActivities": {
      "name": "Hike"
    }
    {
      "name": "Bike Ride"
    }
    {
      "name": "Sun Bathing"
    }
  }
}  
~~~~
