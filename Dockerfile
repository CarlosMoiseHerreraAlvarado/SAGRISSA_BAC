# Stage 1: Build & Restore
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos .csproj para restaurar dependencias primero (aprovecha la caché de Docker)
COPY ["Sagrisa.API/Sagrisa.API.csproj", "Sagrisa.API/"]
COPY ["Sagrisa.Application/Sagrisa.Application.csproj", "Sagrisa.Application/"]
COPY ["Sagrisa.Domain/Sagrisa.Domain.csproj", "Sagrisa.Domain/"]
COPY ["Sagrisa.Infrastructure/Sagrisa.Infrastructure.csproj", "Sagrisa.Infrastructure/"]

RUN dotnet restore "Sagrisa.API/Sagrisa.API.csproj"

# Copiar todo el código fuente y compilar
COPY . .
WORKDIR "/src/Sagrisa.API"
RUN dotnet build "Sagrisa.API.csproj" -c Release -o /app/build

# Stage 2: Publicar
FROM build AS publish
RUN dotnet publish "Sagrisa.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Runtime final liviano
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Puertos y variables de entorno para Render
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "Sagrisa.API.dll"]
