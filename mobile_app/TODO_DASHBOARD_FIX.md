# Flutter Dashboard Fix - TODO List

## Task 1: Fix path in new dashboard file ✅ COMPLETED

### Issues Fixed:
- [x] Rename class from `HomeDashboard` to `NewHomeDashboard`
- [x] Fix widget import paths (`./widgets/` → `../../shared/widgets/`)
- [x] Fix widget import paths (`../../widgets/` → `../../shared/widgets/`)
- [x] Update state class name `_HomeDashboardState` to `_NewHomeDashboardState`

### Changes Made:
- Class name: `HomeDashboard` → `NewHomeDashboard`
- State class: `_HomeDashboardState` → `_NewHomeDashboardState`
- Import paths fixed for all 7 widgets to use `../../shared/widgets/`

---

## Task 2: Connect quick actions to their respective pages ✅ COMPLETED

### Routes Added to app_routes.dart:
- Added imports for `crop_management.dart` and `community_feed.dart`
- Added route constant: `cropManagement = '/crop-management'`
- Added route constant: `communityFeed = '/community-feed'`
- Added route mapping: `cropManagement → CropManagementScreen`
- Added route mapping: `communityFeed → CommunityFeedScreen`

### Routes Updated in new_home_dashboard.dart:

| Section | Old Route | New Route |
|---------|-----------|-----------|
| Quick Action - AI Assistant | `/ai-chat-interface` | `AppRoutes.chatbot` |
| Quick Action - Weather | `/weather-insights` | `AppRoutes.weather` |
| Quick Action - My Crops | `/crop-management` | `AppRoutes.cropManagement` |
| Quick Action - Community | `/community-feed` | `AppRoutes.communityFeed` |
| FAB - Ask AI | `/ai-chat-interface` | `AppRoutes.chatbot` |
| AppBar - Weather Tap | `/weather-insights` | `AppRoutes.weather` |
| WeatherSummaryCard Tap | `/weather-insights` | `AppRoutes.weather` |
| Recent Conversations View All | `/ai-chat-interface` | `AppRoutes.chatbot` |
| Recent Conversation Item | `/ai-chat-interface` | `AppRoutes.chatbot` |
| My Crops View All | `/crop-management` | `AppRoutes.cropManagement` |
| CropStatusCard Tap | `/crop-management` | `AppRoutes.cropManagement` |
| Community Highlights View All | `/community-feed` | `AppRoutes.communityFeed` |
| CommunityHighlightCard Tap | `/community-feed` | `AppRoutes.communityFeed` |

### Additional Fixes:
- Fixed responsive heights for My Crops (`180` → `22.h`) and Community Highlights (`320` → `40.h`)
- All navigation now uses centralized route constants from `AppRoutes`
