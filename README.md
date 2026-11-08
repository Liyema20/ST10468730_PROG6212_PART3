 # RaceDay — PROG6212 POE Part 3

RaceDay is a platform for sporting events, including walks, road runs and cycle events. Solution has 2 applications:

| Project | Responsibility |
|---|---|
Part 2 REST API, SQL Server data, authentication and uploads to Azure Blob Storage: RaceDay.Api |
| `RaceDay.Mvc` | Part 3 ASP.Frontend - NET Core MVC. It relies only on the API to perform all the data operations and does not interact with the database itself.

## Features

### Authentication and access
- Register, log-in and log-out using the MVC application.
- MVC session maintains user's role and passes along the API authentication cookie.
Role-specific navigation and protected Organiser/Participant areas.

### Organiser
- Owned event, enrolment and upcoming - event summaries on the dashboard.
- Create, edit and delete events; create categories; view enrolments.
Use the Event API to upload an event banner to Azure Blob Storage.
- Take note of and report outcomes of an event.

### Participant
Browse and filter events in the pipeline, view categories, enrol instantly.
- View enrolment status, race history and results.
- Make changes to profile information, upload a profile photo using the API.

The detailed route and authorization plan is recorded in
[`docs/API_ENDPOINT_PLAN.md`](docs/API_ENDPOINT_PLAN.md).

## Requirements
- .NET 8 SDK
Using SQL Server for an API.
Use the Azure Storage account and Azure Blob container to store uploaded images.Store uploaded images in Azure Storage account and in Azure Blob container.
The option to lower the container.Lowering the container option: -docker Desktop

## Configuration

### API
Do not store Azure credentials - use User Secrets. In Visual Studio (right-click on the RaceDay.Api application), go to Manage User Secrets and enter the storage connection string below. Do not remove the container name (first term in the `appsettings.json` value from here).

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=RaceDayDb;Trusted_Connection=True;TrustServerCertificate=True"
  }
}
```

If you like, add the following line to User Secrets:

```json
{
  "AzureBlob": {
    "ConnectionString": "PASTE_FROM_AZURE_ACCESS_KEYS"
  }
}
```

The API uses the images setting on the ‘raceday-images’ container in RaceDay.Api/appsettings.json. A secret sets the value for a setting that is not unique and therefor should not be added to User Secrets.

The API will apply EF Core migrations at startup time. Make first migration and commit it to create in the beginning:

```bash
dotnet ef migrations add InitialCreate --project RaceDay.Api --startup-project RaceDay.Api --output-dir Data/Migrations
dotnet ef database update --project RaceDay.Api --startup-project RaceDay.Api
```

The SQL deployment script is a one that is committed during idempotent.
[`docs/DatabaseScript.sql`](docs/DatabaseScript.sql).

### MVC
If you have the API running on a different address than the default URL for it (localhost:443), set the address in the `RaceDay.Mvc/appsettings.Development.json`:

```json
{ "RaceDayApi": { "BaseUrl": "https://localhost:59662/" } }
```

## Run locally

Install it in the folder into which you are installing the repository with two terminals:

```bash
dotnet run --project RaceDay.Api --urls http://localhost:5000
```

```bash
dotnet run --project RaceDay.Mvc
```

On the second terminal, click the Open zenki mvc link. API Swagger UI can be accessed from the URL `/swagger.

## Run the MVC app with Docker

To run the API without internet, run it first with the command: dotnet run --project RaceDay.Api --urls http://localhost:5000. To get around this, if the container fails to bind, be sure to use `--urls http://0.0.0.0:5000` when you start the container to bind the API to all interfaces. Then, from the same repository root, it will automatically build and run the MVC container in one step:

```bash
docker build -f RaceDay.Mvc/Dockerfile -t raceday-mvc . && docker run --rm -p 8080:8080 -e RaceDayApi__BaseUrl=http://host.docker.internal:5000/ raceday-mvc
```

Open `http://localhost:8080`. Change the API URL if you are using an alternate address for your API. To use the features for Linux-based systems, include the argument `--add-host=host.docker.internal:host-gateway` in the "docker run" section.

## Tests and CI

```bash
dotnet test RaceDay.Tests/RaceDay.Tests.csproj -c Release
```

The API suite is restored, built and tested on GitHub Actions and the MVC Docker image is built and verified to build on GitHub Actions.

The CI pipeline will be run from this root directory housing the component-wise `RaceDay.Api` repertoire,
`RaceDay.Mvc`, and `RaceDay.Tests`.

## Video walkthrough

Unlisted YouTube demonstration, ADD YOUR VIDEO LINK HERE BEFORE submitting.

The demonstration should include the following explained: Separation between MVC and API, role based flows, Uploading to Azure Blob Storage, Docker setup and GitHub Actions. Follow the following steps from docs/PART3_VIDEO_WALKTHROUGH.md to shoot.

## Submission evidence

Refer to `docs/PART3_SUBMISSION_CHECKLIST.md` for the final evidence and a checklist on GitHub.
