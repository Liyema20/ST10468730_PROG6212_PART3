IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Roles] (
        [RoleId] int NOT NULL IDENTITY,
        [Name] nvarchar(30) NOT NULL,
        CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleId])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Users] (
        [UserId] int NOT NULL IDENTITY,
        [RoleId] int NOT NULL,
        [FirstName] nvarchar(60) NOT NULL,
        [LastName] nvarchar(60) NOT NULL,
        [Email] nvarchar(150) NOT NULL,
        [PasswordHash] nvarchar(max) NOT NULL,
        [ProfilePictureUrl] nvarchar(500) NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_Users] PRIMARY KEY ([UserId]),
        CONSTRAINT [FK_Users_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([RoleId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Events] (
        [EventId] int NOT NULL IDENTITY,
        [OrganiserId] int NOT NULL,
        [Name] nvarchar(150) NOT NULL,
        [Description] nvarchar(1000) NOT NULL,
        [EventDate] datetime2 NOT NULL,
        [Location] nvarchar(200) NOT NULL,
        [DistanceKm] decimal(6,2) NOT NULL,
        [EventType] nvarchar(10) NOT NULL,
        [BannerImageUrl] nvarchar(500) NULL,
        CONSTRAINT [PK_Events] PRIMARY KEY ([EventId]),
        CONSTRAINT [FK_Events_Users_OrganiserId] FOREIGN KEY ([OrganiserId]) REFERENCES [Users] ([UserId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Categories] (
        [CategoryId] int NOT NULL IDENTITY,
        [EventId] int NOT NULL,
        [Name] nvarchar(80) NOT NULL,
        [MinAge] int NULL,
        [MaxAge] int NULL,
        [DistanceKm] decimal(6,2) NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([CategoryId]),
        CONSTRAINT [FK_Categories_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Enrolments] (
        [EnrolmentId] int NOT NULL IDENTITY,
        [ParticipantId] int NOT NULL,
        [EventId] int NOT NULL,
        [CategoryId] int NOT NULL,
        [Status] nvarchar(15) NOT NULL,
        [EnrolledAt] datetime2 NOT NULL,
        CONSTRAINT [PK_Enrolments] PRIMARY KEY ([EnrolmentId]),
        CONSTRAINT [FK_Enrolments_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([CategoryId]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Enrolments_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Enrolments_Users_ParticipantId] FOREIGN KEY ([ParticipantId]) REFERENCES [Users] ([UserId]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE TABLE [Results] (
        [ResultId] int NOT NULL IDENTITY,
        [EnrolmentId] int NOT NULL,
        [FinishTime] time NOT NULL,
        [Position] int NOT NULL,
        [RecordedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_Results] PRIMARY KEY ([ResultId]),
        CONSTRAINT [FK_Results_Enrolments_EnrolmentId] FOREIGN KEY ([EnrolmentId]) REFERENCES [Enrolments] ([EnrolmentId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'RoleId', N'Name') AND [object_id] = OBJECT_ID(N'[Roles]'))
        SET IDENTITY_INSERT [Roles] ON;
    EXEC(N'INSERT INTO [Roles] ([RoleId], [Name])
    VALUES (1, N''Organiser''),
    (2, N''Participant'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'RoleId', N'Name') AND [object_id] = OBJECT_ID(N'[Roles]'))
        SET IDENTITY_INSERT [Roles] OFF;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Categories_EventId] ON [Categories] ([EventId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Enrolments_CategoryId] ON [Enrolments] ([CategoryId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Enrolments_EventId] ON [Enrolments] ([EventId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Enrolments_ParticipantId_EventId] ON [Enrolments] ([ParticipantId], [EventId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Events_OrganiserId] ON [Events] ([OrganiserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Results_EnrolmentId] ON [Results] ([EnrolmentId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Roles_Name] ON [Roles] ([Name]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Users_Email] ON [Users] ([Email]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Users_RoleId] ON [Users] ([RoleId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20261022221859_InitialCreate'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20261022221859_InitialCreate', N'8.0.11');
END;
GO

COMMIT;
GO

