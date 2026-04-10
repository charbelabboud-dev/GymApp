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
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [MembershipPlans] (
        [MemId] int NOT NULL IDENTITY,
        [MemName] nvarchar(50) NOT NULL,
        [MemPrice] decimal(10,2) NOT NULL,
        [MemDurationDays] int NOT NULL,
        [MemDescription] nvarchar(200) NULL,
        [MemStatus] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_MembershipPlans] PRIMARY KEY ([MemId])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Users] (
        [UserId] int NOT NULL IDENTITY,
        [UserEmail] nvarchar(50) NOT NULL,
        [UserPassword] nvarchar(255) NOT NULL,
        [UserRole] nvarchar(20) NOT NULL,
        [UserStatus] bit NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Users] PRIMARY KEY ([UserId])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Coaches] (
        [CoCode] nvarchar(5) NOT NULL,
        [UserId] int NOT NULL,
        [CoFname] nvarchar(20) NOT NULL,
        [CoLname] nvarchar(20) NOT NULL,
        [CoBirthDate] datetime2 NOT NULL,
        [CoPhone] nvarchar(15) NOT NULL,
        [CoEmail] nvarchar(50) NOT NULL,
        [CoAddress] nvarchar(100) NOT NULL,
        [CoHireDate] datetime2 NOT NULL,
        [CoSpecialty] nvarchar(50) NULL,
        [CoStatus] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Coaches] PRIMARY KEY ([CoCode]),
        CONSTRAINT [FK_Coaches_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([UserId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Dietitians] (
        [DietCode] nvarchar(5) NOT NULL,
        [UserId] int NOT NULL,
        [DietFname] nvarchar(20) NOT NULL,
        [DietLname] nvarchar(20) NOT NULL,
        [DietEmail] nvarchar(50) NOT NULL,
        [DietPhone] nvarchar(15) NOT NULL,
        [DietStatus] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Dietitians] PRIMARY KEY ([DietCode]),
        CONSTRAINT [FK_Dietitians_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([UserId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Notifications] (
        [NotId] int NOT NULL IDENTITY,
        [UserId] int NOT NULL,
        [Message] nvarchar(200) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [IsRead] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Notifications] PRIMARY KEY ([NotId]),
        CONSTRAINT [FK_Notifications_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([UserId]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Clients] (
        [ClCode] nvarchar(5) NOT NULL,
        [UserId] int NOT NULL,
        [ClFname] nvarchar(20) NOT NULL,
        [ClLname] nvarchar(20) NOT NULL,
        [ClBirthDate] datetime2 NOT NULL,
        [ClPhone] nvarchar(15) NOT NULL,
        [ClAddress] nvarchar(100) NOT NULL,
        [ClRegisterDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [ClStatus] bit NOT NULL,
        [ClCoachId] nvarchar(5) NULL,
        [ClMembershipId] int NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Clients] PRIMARY KEY ([ClCode]),
        CONSTRAINT [FK_Clients_Coaches_ClCoachId] FOREIGN KEY ([ClCoachId]) REFERENCES [Coaches] ([CoCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Clients_MembershipPlans_ClMembershipId] FOREIGN KEY ([ClMembershipId]) REFERENCES [MembershipPlans] ([MemId]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Clients_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([UserId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Attendances] (
        [AttId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [CheckInTime] datetime2 NOT NULL DEFAULT (GETDATE()),
        [CheckOutTime] datetime2 NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Attendances] PRIMARY KEY ([AttId]),
        CONSTRAINT [FK_Attendances_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [ClientMemberships] (
        [CmId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [MemId] int NOT NULL,
        [StartDate] datetime2 NOT NULL,
        [EndDate] datetime2 NOT NULL,
        [Status] nvarchar(20) NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_ClientMemberships] PRIMARY KEY ([CmId]),
        CONSTRAINT [FK_ClientMemberships_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_ClientMemberships_MembershipPlans_MemId] FOREIGN KEY ([MemId]) REFERENCES [MembershipPlans] ([MemId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [DietPlans] (
        [DietId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [DietitianId] nvarchar(5) NOT NULL,
        [DietStartDate] datetime2 NOT NULL,
        [DietEndDate] datetime2 NOT NULL,
        [DietDescription] nvarchar(200) NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_DietPlans] PRIMARY KEY ([DietId]),
        CONSTRAINT [FK_DietPlans_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_DietPlans_Dietitians_DietitianId] FOREIGN KEY ([DietitianId]) REFERENCES [Dietitians] ([DietCode]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Payments] (
        [PayId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [MemId] int NOT NULL,
        [PayAmount] decimal(10,2) NOT NULL,
        [PayMethod] nvarchar(20) NOT NULL,
        [PayDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [PayStatus] nvarchar(20) NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Payments] PRIMARY KEY ([PayId]),
        CONSTRAINT [FK_Payments_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Payments_MembershipPlans_MemId] FOREIGN KEY ([MemId]) REFERENCES [MembershipPlans] ([MemId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Reviews] (
        [RevId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [CoCode] nvarchar(5) NOT NULL,
        [Rating] int NOT NULL,
        [Comment] nvarchar(200) NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Reviews] PRIMARY KEY ([RevId]),
        CONSTRAINT [FK_Reviews_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Reviews_Coaches_CoCode] FOREIGN KEY ([CoCode]) REFERENCES [Coaches] ([CoCode]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [Sessions] (
        [SesId] int NOT NULL IDENTITY,
        [SesClCode] nvarchar(5) NOT NULL,
        [SesCoCode] nvarchar(5) NOT NULL,
        [SesType] nvarchar(20) NOT NULL,
        [SesDescription] nvarchar(100) NULL,
        [SesDateTime] datetime2 NOT NULL,
        [SesDuration] int NOT NULL,
        [SesStatus] nvarchar(20) NOT NULL DEFAULT N'Scheduled',
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_Sessions] PRIMARY KEY ([SesId]),
        CONSTRAINT [FK_Sessions_Clients_SesClCode] FOREIGN KEY ([SesClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_Sessions_Coaches_SesCoCode] FOREIGN KEY ([SesCoCode]) REFERENCES [Coaches] ([CoCode]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [WorkoutPlans] (
        [WpId] int NOT NULL IDENTITY,
        [ClCode] nvarchar(5) NOT NULL,
        [CoCode] nvarchar(5) NOT NULL,
        [WpName] nvarchar(50) NOT NULL,
        [WpStartDate] datetime2 NOT NULL,
        [WpEndDate] datetime2 NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_WorkoutPlans] PRIMARY KEY ([WpId]),
        CONSTRAINT [FK_WorkoutPlans_Clients_ClCode] FOREIGN KEY ([ClCode]) REFERENCES [Clients] ([ClCode]) ON DELETE NO ACTION,
        CONSTRAINT [FK_WorkoutPlans_Coaches_CoCode] FOREIGN KEY ([CoCode]) REFERENCES [Coaches] ([CoCode]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE TABLE [WorkoutExercises] (
        [WeId] int NOT NULL IDENTITY,
        [WpId] int NOT NULL,
        [ExerciseName] nvarchar(50) NOT NULL,
        [Sets] int NOT NULL,
        [Reps] int NOT NULL,
        [RestSeconds] int NOT NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_WorkoutExercises] PRIMARY KEY ([WeId]),
        CONSTRAINT [FK_WorkoutExercises_WorkoutPlans_WpId] FOREIGN KEY ([WpId]) REFERENCES [WorkoutPlans] ([WpId]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Attendances_ClCode] ON [Attendances] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_ClientMemberships_ClCode] ON [ClientMemberships] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_ClientMemberships_MemId] ON [ClientMemberships] ([MemId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Clients_ClCoachId] ON [Clients] ([ClCoachId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Clients_ClMembershipId] ON [Clients] ([ClMembershipId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Clients_UserId] ON [Clients] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Coaches_UserId] ON [Coaches] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Dietitians_UserId] ON [Dietitians] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_DietPlans_ClCode] ON [DietPlans] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_DietPlans_DietitianId] ON [DietPlans] ([DietitianId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Notifications_UserId] ON [Notifications] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Payments_ClCode] ON [Payments] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Payments_MemId] ON [Payments] ([MemId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Reviews_ClCode] ON [Reviews] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Reviews_CoCode] ON [Reviews] ([CoCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Sessions_SesClCode] ON [Sessions] ([SesClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_Sessions_SesCoCode] ON [Sessions] ([SesCoCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE UNIQUE INDEX [IX_Users_UserEmail] ON [Users] ([UserEmail]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_WorkoutExercises_WpId] ON [WorkoutExercises] ([WpId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_WorkoutPlans_ClCode] ON [WorkoutPlans] ([ClCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    CREATE INDEX [IX_WorkoutPlans_CoCode] ON [WorkoutPlans] ([CoCode]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260322190327_InitialCreate'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260322190327_InitialCreate', N'10.0.5');
END;

COMMIT;
GO

BEGIN TRANSACTION;
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260324182520_FixProgressEntry'
)
BEGIN
    DROP INDEX [IX_Clients_UserId] ON [Clients];
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260324182520_FixProgressEntry'
)
BEGIN
    ALTER TABLE [Clients] ADD CONSTRAINT [AK_Clients_UserId] UNIQUE ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260324182520_FixProgressEntry'
)
BEGIN
    CREATE TABLE [ProgressEntries] (
        [Id] int NOT NULL IDENTITY,
        [ClientId] int NOT NULL,
        [Weight] decimal(18,2) NULL,
        [BodyFatPercentage] decimal(18,2) NULL,
        [Chest] decimal(18,2) NULL,
        [Waist] decimal(18,2) NULL,
        [Notes] nvarchar(max) NULL,
        [EntryDate] datetime2 NOT NULL DEFAULT (GETDATE()),
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK_ProgressEntries] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_ProgressEntries_Clients_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [Clients] ([UserId]) ON DELETE NO ACTION
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260324182520_FixProgressEntry'
)
BEGIN
    CREATE INDEX [IX_ProgressEntries_ClientId] ON [ProgressEntries] ([ClientId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260324182520_FixProgressEntry'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260324182520_FixProgressEntry', N'10.0.5');
END;

COMMIT;
GO

