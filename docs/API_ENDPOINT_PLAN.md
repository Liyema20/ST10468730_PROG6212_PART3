# RaceDay API endpoint plan

The API is the only service that accesses SQL Server and Azure Blob Storage. The MVC application calls these endpoints through `IRaceDayApi` and `RaceDayApi`.

## Authentication

| Method | Route | Access | Purpose |
|---|---|---|---|
| POST | `/api/auth/register` | Anonymous | Create an Organiser or Participant account. |
| POST | `/api/auth/login` | Anonymous | Start the encrypted API session cookie. |
| POST | `/api/auth/logout` | Authenticated | End the current API session. |

## Events and categories

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/events?type=&upcomingOnly=` | Authenticated | Browse and filter events. |
| GET | `/api/events/{id}` | Authenticated | View event details. |
| POST | `/api/events` | Organiser | Create an owned event. |
| PUT | `/api/events/{id}` | Owning Organiser | Edit an owned event. |
| DELETE | `/api/events/{id}` | Owning Organiser | Delete an event with no enrolments. |
| GET | `/api/events/{eventId}/categories` | Authenticated | List event categories. |
| POST | `/api/events/{eventId}/categories` | Owning Organiser | Add a category. |
| PUT | `/api/categories/{id}` | Owning Organiser | Edit a category. |
| DELETE | `/api/categories/{id}` | Owning Organiser | Delete a category with no enrolments. |

## Enrolments and results

| Method | Route | Access | Purpose |
|---|---|---|---|
| POST | `/api/events/{eventId}/enrolments` | Participant | Enrol in a future event and category. |
| GET | `/api/enrolments/my` | Participant | View the current participant's enrolments. |
| GET | `/api/events/{eventId}/enrolments` | Owning Organiser | View participants for an owned event. |
| POST | `/api/enrolments/{enrolmentId}/result` | Owning Organiser | Publish a result after the event. |
| GET | `/api/events/{eventId}/results` | Owning Organiser | View results for an owned event. |
| GET | `/api/results/my` | Participant | View personal race history. |

## Profile and image uploads

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/profile` | Authenticated | View the current user's profile. |
| PUT | `/api/profile` | Authenticated | Update the user's name and profile image URL. |
| POST | `/api/events/{eventId}/banner` | Owning Organiser | Upload an event banner through Azure Blob Storage. |
| POST | `/api/profile/picture` | Authenticated | Upload a profile picture through Azure Blob Storage. |

All protected routes return `401 Unauthorized` when there is no API session and `403 Forbidden` when the authenticated role or ownership rule is insufficient. Validation failures use `400 Bad Request`; missing resources use `404 Not Found`; duplicate or blocked operations use `409 Conflict` where applicable.
