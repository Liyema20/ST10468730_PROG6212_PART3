# RaceDay ERD

```mermaid
erDiagram
    ROLE ||--o{ USER : "has"
    USER ||--o{ EVENT : "organises"
    EVENT ||--o{ CATEGORY : "defines"
    USER ||--o{ ENROLMENT : "participant enters"
    EVENT ||--o{ ENROLMENT : "receives"
    CATEGORY ||--o{ ENROLMENT : "selected in"
    ENROLMENT ||--o| RESULT : "produces"

    ROLE {
        int RoleId PK
        string Name UK
    }
    USER {
        int UserId PK
        int RoleId FK
        string FirstName
        string LastName
        string Email UK
        string PasswordHash
        string ProfilePictureUrl
        datetime CreatedAt
    }
    EVENT {
        int EventId PK
        int OrganiserId FK
        string Name
        string Description
        datetime EventDate
        string Location
        decimal DistanceKm
        string EventType "Run, Walk, Cycle"
        string BannerImageUrl
    }
    CATEGORY {
        int CategoryId PK
        int EventId FK
        string Name
        int MinAge
        int MaxAge
        decimal DistanceKm
    }
    ENROLMENT {
        int EnrolmentId PK
        int ParticipantId FK
        int EventId FK
        int CategoryId FK
        string Status "Pending, Confirmed"
        datetime EnrolledAt
    }
    RESULT {
        int ResultId PK
        int EnrolmentId FK, UK
        time FinishTime
        int Position
        datetime RecordedAt
    }
```

## Cardinality
- Role 1 : M User
- User (Organiser) 1 : M Event
- Event 1 : M Category
- Event M : M User (Participant), resolved by Enrolment
- Category 1 : M Enrolment
- Enrolment 1 : 0..1 Result

## Constraints
- User.Email unique; Role.Name unique
- Enrolment unique on (ParticipantId, EventId): one enrolment per event
- Result.EnrolmentId unique (1:1)
- Event to Category cascades on delete; all other FKs restrict, which avoids SQL Server multiple cascade paths
