# docker build --no-cache -t store-api:latest .
# docker run -d -p 6310:9090 --name store-app-api store-api:latest

# Базовый образ .NET 9
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app

# Копирование проекта и восстановление зависимостей
COPY "StoreApi.sln" "StoreApi.sln"
COPY "Api/Api.csproj" "Api/Api.csproj"

RUN dotnet restore "StoreApi.sln"

# Копирование и сборка приложения
COPY . .
WORKDIR /app
RUN dotnet publish -c Release -o out

# Финальный образ
FROM mcr.microsoft.com/dotnet/aspnet:9.0 
WORKDIR /app
COPY --from=build-env /app/out .
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:9090

ENTRYPOINT ["dotnet", "Api.dll"]
