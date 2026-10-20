FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY . .

RUN dotnet publish Source/AssetRipper.GUI.Free/AssetRipper.GUI.Free.csproj \
    --configuration Release \
    --output /app/publish \
    -p:PublishAot=false \
    -p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_ENVIRONMENT=Production

ENV ASPNETCORE_URLS=http://0.0.0.0:10000

EXPOSE 10000

ENTRYPOINT ["sh", "-c", "exec dotnet AssetRipper.GUI.Free.dll --headless --port ${PORT:-10000}"]
