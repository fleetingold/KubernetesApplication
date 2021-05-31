FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["KubernetesApplication.csproj", "./"]

RUN dotnet restore "./KubernetesApplication.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "KubernetesApplication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KubernetesApplication.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KubernetesApplication.dll"]