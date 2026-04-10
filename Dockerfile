# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY backend/GymApp.API/GymApp.API.csproj backend/GymApp.API/
COPY backend/GymApp.Core/GymApp.Core.csproj backend/GymApp.Core/
COPY backend/GymApp.Infrastructure/GymApp.Infrastructure.csproj backend/GymApp.Infrastructure/
RUN dotnet restore backend/GymApp.API/GymApp.API.csproj

# Copy the rest of the source code
COPY . .

# Publish the app
WORKDIR /src/backend/GymApp.API
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "GymApp.API.dll"]