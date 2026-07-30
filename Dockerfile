# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivo de solución y proyectos para restaurar dependencias
COPY ["Sagrisa.sln", "./"]
COPY ["Sagrisa.API/Sagrisa.API.csproj", "Sagrisa.API/"]
COPY ["Sagrisa.Application/Sagrisa.Application.csproj", "Sagrisa.Application/"]
COPY ["Sagrisa.Domain/Sagrisa.Domain.csproj", "Sagrisa.Domain/"]
COPY ["Sagrisa.Infrastructure/Sagrisa.Infrastructure.csproj", "Sagrisa.Infrastructure/"]
COPY ["Sagrisa.UnitTests/Sagrisa.UnitTests.csproj", "Sagrisa.UnitTests/"]

RUN dotnet restore "Sagrisa.sln"

# Copiar todo el código fuente y publicar en modo Release
COPY . .
WORKDIR "/src/Sagrisa.API"
RUN dotnet publish "Sagrisa.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa 2: Runtime final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Puerto por defecto para ASP.NET Core 8
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "Sagrisa.API.dll"]
