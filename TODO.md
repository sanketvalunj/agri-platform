# TODO: Fix Firebase Authentication and Weather API Issues

## Firebase Authentication
- [x] Replace google-services.json with correct file from Firebase console

## Weather API Integration
- [x] Fix WeatherModel.fromJson to use 'description' key instead of 'weather'
- [x] Update config.dart with network IP (10.143.85.85)
- [x] Update weather_service.dart to use config.baseUrl
- [x] Modify home_dashboard.dart to fetch weather data on init and update UI dynamically
- [x] Add error handling for API calls

## Testing
- [x] Backend server started successfully on port 8000
- [ ] Test Firebase auth login/signup flow (requires Android build)
- [ ] Test weather data loading on home screen (requires Flutter run)
- [ ] Verify end-to-end connectivity between mobile and backend (requires mobile device)
