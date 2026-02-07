# Scout Connect

A modern Flutter social media application designed to connect athletes with sports scouts, inspired by LinkedIn and Instagram design patterns.

## 🚀 How to Run the App

### Prerequisites
- Flutter SDK (>=2.12.0 <3.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/scout-connect.git
   cd scout-connect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-in)
   - Set up Firestore Database
   - Configure Firebase Storage
   - Download `google-services.json` and place in `android/app/`
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration Details

1. **Authentication Setup**
   - Go to Firebase Console → Authentication
   - Enable Email/Password sign-in method
   - Enable Google sign-in method
   - Add your app's SHA-1 key for Google sign-in

2. **Firestore Database**
   - Create Firestore database in test mode
   - Set up security rules for production use

3. **Firebase Storage**
   - Enable Firebase Storage
   - Set up security rules for file uploads

4. **Update Firebase Options**
   ```dart
   // In lib/firebase_options.dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'your-android-api-key',
     appId: 'your-android-app-id',
     messagingSenderId: 'your-sender-id',
     projectId: 'your-project-id',
     storageBucket: 'your-project-id.appspot.com',
   );
   ```

## 📱 App Architecture & Flow

### Project Structure
```
scout-connect/
├── lib/
│   ├── main.dart                    # App entry point & Firebase initialization
│   ├── firebase_options.dart        # Firebase configuration
│   ├── models/                      # Data models
│   │   ├── athlete.dart             # Athlete data structure
│   │   ├── scout.dart               # Scout data structure
│   │   ├── sport_category.dart     # Sport categories & positions
│   │   └── search_filter.dart       # Search & filter criteria
│   ├── screens/                     # UI screens
│   │   ├── auth_wrapper.dart        # Authentication state manager
│   │   ├── login_screen.dart        # Login & registration
│   │   ├── athlete_home_screen.dart # Athlete main interface
│   │   ├── scout_home_screen.dart   # Scout main interface
│   │   ├── athlete_discovery_screen.dart # Advanced athlete search
│   │   └── video_upload_screen.dart # Video upload interface
│   ├── services/                    # Business logic
│   │   ├── discovery_service.dart   # Athlete search & filtering
│   │   └── video_service.dart       # Video upload & management
│   ├── utilities/                   # Helper utilities
│   │   └── themes.dart              # Material 3 theming
│   └── widgets/                     # Reusable UI components
│       ├── stats_card.dart          # Statistics display
│       ├── quick_actions_card.dart  # Quick action buttons
│       ├── recent_events_card.dart  # Event listings
│       ├── athlete_profile_card.dart # Profile preview
│       └── athlete_card.dart        # Athlete search results
├── android/                        # Android platform files
├── ios/                            # iOS platform files
├── web/                            # Web platform files
└── test/                           # Test files
```

### Application Flow

#### 1. **App Initialization** (`main.dart`)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const ScoutConnectApp()); // Start app with theme
}
```

#### 2. **Authentication Flow** (`auth_wrapper.dart`)
```
Launch App → AuthWrapper → Check Auth State
                                ↓
                    ┌─ Not Authenticated → LoginScreen
                    │
                    └─ Authenticated → Get User Type
                                         ↓
                              ┌─ Athlete → AthleteHomeScreen
                              │
                              └─ Scout → ScoutHomeScreen
```

#### 3. **Athlete User Flow**
```
AthleteHomeScreen (Bottom Navigation)
    ↓
├── Feed Tab → AthleteFeedPage
│   ├── Welcome Section
│   ├── StatsCard (Profile views, connections)
│   ├── QuickActionsCard (Edit profile, upload video, etc.)
│   ├── RecentEventsCard (Upcoming events)
│   └── AthleteProfileCard (Profile preview)
│
├── Profile Tab → AthleteProfilePage (Coming Soon)
│
├── Events Tab → AthleteEventsPage (Coming Soon)
│
└── Messages Tab → AthleteMessagesPage (Coming Soon)
```

#### 4. **Scout User Flow**
```
ScoutHomeScreen (Bottom Navigation)
    ↓
├── Dashboard Tab → ScoutFeedPage
│   ├── Welcome Section
│   ├── ScoutStatsCard (Athletes discovered, events organized)
│   └── RecentActivityCard (Recent actions)
│
├── Discover Tab → AthleteDiscoveryScreen
│   ├── Search Bar (Text search)
│   ├── Filter Section (Sport, position, age, location, skills)
│   ├── Results List → AthleteCard widgets
│   └── Sort Options (Relevance, age, location, recent)
│
├── Events Tab → ScoutEventsPage (Coming Soon)
│
└── Messages Tab → ScoutMessagesPage (Coming Soon)
```

#### 5. **Video Upload Flow** (`video_upload_screen.dart`)
```
QuickActionsCard → VideoUploadScreen
    ↓
├── Instructions Section
├── Upload Options
│   ├── Record Video → Camera → Upload to Firebase Storage
│   └── Choose from Gallery → Gallery → Upload to Firebase Storage
├── Upload Progress
└── Success/Error Handling
```

#### 6. **Athlete Discovery Flow** (`athlete_discovery_screen.dart`)
```
AthleteDiscoveryScreen
    ↓
├── Search Bar → Text Search (names, bios, sports)
├── Filter Toggle → Filter Section
│   ├── Sport Dropdown (Football only, Athletics ready)
│   ├── Position Dropdown (Sport-specific positions)
│   ├── Age Range (Min/Max age)
│   ├── Location Text Field
│   └── Checkboxes (Has videos, Has achievements)
├── Apply Filters → DiscoveryService.searchAthletes()
├── Results → AthleteCard widgets
│   ├── Profile Info (Name, sport, position, location, age)
│   ├── Bio Preview
│   ├── Skills Tags
│   ├── Stats (Achievements, videos, skills count)
│   └── Action Buttons (View profile, Contact)
└── Sort Options
```

### Data Flow Architecture

#### 1. **Authentication Data Flow**
```
LoginScreen → Firebase Auth → AuthWrapper → Firestore User Document
                                                    ↓
                                            Determine Account Type
                                                    ↓
                                        Navigate to Appropriate Home Screen
```

#### 2. **Video Upload Data Flow**
```
VideoUploadScreen → VideoService.uploadVideo()
    ↓
ImagePicker → Firebase Storage → Download URL
    ↓
Firestore → Update Athlete Document (videoUrls array)
    ↓
UI Update → Success Message
```

#### 3. **Search & Discovery Data Flow**
```
AthleteDiscoveryScreen → DiscoveryService.searchAthletes()
    ↓
Firestore Query (with filters) → Stream of Athlete Documents
    ↓
Client-side Filtering (skills, experience) → Filtered Results
    ↓
UI Update → AthleteCard Widgets
```

### Key Components Explained

#### **Models Layer**
- **Athlete**: Complete athlete profile with videos, achievements, physical stats
- **Scout**: Scout profile with organization and preferences
- **SportCategory**: Sport definitions with positions and skills
- **SearchFilter**: Comprehensive filtering criteria

#### **Services Layer**
- **DiscoveryService**: Handles complex athlete search and filtering
- **VideoService**: Manages video uploads, storage, and metadata

#### **UI Layer**
- **Screens**: Main application screens with navigation
- **Widgets**: Reusable UI components for consistent design
- **Themes**: Material 3 theming with LinkedIn-inspired colors

### State Management
- **Authentication**: Firebase Auth state changes via AuthWrapper
- **Data**: Firestore streams for real-time updates
- **UI**: StatefulWidget for local state management

### Navigation Pattern
- **Bottom Navigation**: Social media-style tab navigation
- **Screen Navigation**: MaterialPageRoute for screen transitions
- **Modal Navigation**: Dialogs for uploads and confirmations

## 🏆 About Scout Connect

Scout Connect is a comprehensive mobile platform that bridges the gap between talented athletes and professional scouts. The app features a modern, social media-inspired interface with LinkedIn-style professional networking and Instagram-like visual engagement.

## ✨ Key Features

### 🏃‍♂️ For Athletes
- **Professional Profiles**: Showcase achievements, skills, stats, and performance videos
- **Discovery**: Get discovered by scouts from various sports organizations
- **Event Management**: View and register for tryouts, camps, and scouting events
- **Direct Messaging**: Connect with scouts and receive personalized feedback
- **Analytics Dashboard**: Track profile views, scout interactions, and career progress

### 🔍 For Scouts
- **Talent Discovery**: Advanced search and filtering to find athletes by sport, position, location, skills
- **Event Management**: Create and manage scouting events, tryouts, and camps
- **Direct Messaging**: Communicate directly with potential recruits
- **Analytics Dashboard**: Track scouting activities, success rates, and recruitment pipeline
- **Profile Management**: Maintain professional scout profile and organization information

### 🌟 Social Features
- **Feed System**: Instagram-like feed with updates, achievements, and event highlights
- **Real-time Messaging**: Built-in chat system for direct communication
- **Event Calendar**: Shared calendar for sports events and tryouts
- **Notifications**: Stay updated with new opportunities and messages

## 🎨 Design & UI

- **Modern Theme**: LinkedIn-inspired professional blue (#0077B5) with accent colors
- **Material 3 Design**: Latest Material Design principles with custom theming
- **Responsive Layout**: Optimized for all screen sizes and orientations
- **Dark Mode**: System-aware dark/light theme support
- **Social Media Patterns**: Familiar navigation and interaction patterns

## 🛠 Technology Stack

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **Material 3**: Modern UI design system

### Backend & Services
- **Firebase Authentication**: Email/password and Google sign-in
- **Cloud Firestore**: Real-time NoSQL database
- **Firebase Storage**: File storage for images and videos
- **Firebase Analytics**: User behavior tracking

### Key Dependencies
- `provider: ^6.0.0` - State management
- `table_calendar: ^3.1.2` - Calendar functionality
- `image_picker: ^0.8.4+4` - Image/video capture
- `google_sign_in: ^5.4.2` - Google authentication
- `http: ^1.2.2` - HTTP requests
- `shared_preferences: ^2.0.8` - Local storage

## 📱 App Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── athlete.dart          # Athlete data model
│   ├── scout.dart            # Scout data model
│   ├── event.dart            # Event data model
│   └── message.dart          # Message data model
├── screens/                  # UI screens
│   ├── auth_wrapper.dart     # Authentication wrapper
│   ├── login_screen.dart     # Login screen
│   ├── athlete_home_screen.dart  # Athlete main interface
│   ├── scout_home_screen.dart    # Scout main interface
│   └── ...                   # Additional screens
├── services/                 # Business logic
│   ├── firebase_auth_services.dart
│   ├── firebase_firestore_service.dart
│   └── firebase_storage_service.dart
├── utilities/                # Helper utilities
│   ├── themes.dart           # App theming
│   ├── constants.dart        # App constants
│   └── helpers.dart          # Utility functions
└── widgets/                  # Reusable UI components
    ├── stats_card.dart       # Statistics display
    ├── quick_actions_card.dart
    ├── recent_events_card.dart
    └── athlete_profile_card.dart
```

### Navigation Flow
1. **Authentication Flow**
   - Launch → AuthWrapper → Login/Create Account
   - Login → Home Screen (based on user type)

2. **Athlete Flow**
   - Home Feed → Profile/Events/Messages
   - Profile → Edit Profile/Upload Media
   - Events → Calendar/Event Details/Register

3. **Scout Flow**
   - Dashboard → Discover/Events/Messages
   - Discover → Search/Athlete Profiles/Contact
   - Events → Create/Manage/View Attendees

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=2.12.0 <3.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/scout-connect.git
   cd scout-connect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-in)
   - Set up Firestore Database
   - Configure Firebase Storage
   - Download `google-services.json` and place in `android/app/`
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the app**
   ```bash
   flutter run
   ```

## 📋 User Types & Permissions

### Athlete Account
- View and edit own profile
- Upload photos and videos
- Register for events
- Message scouts who have viewed their profile
- View personal analytics

### Scout Account
- Search and view athlete profiles
- Create and manage events
- Message any athlete
- View organization analytics
- Manage discovered athletes list

## 🔧 Configuration

### Environment Variables
Update the following in your Firebase configuration:
- Project ID
- API keys
- Database URLs
- Storage bucket

### Customization
- **Theme Colors**: Modify `lib/utilities/themes.dart`
- **App Icons**: Replace assets in `assets/` directory
- **Fonts**: Update font files in `fonts/` directory

## 📊 Current Status

### ✅ Completed Features
- [x] User Authentication (Email/Google)
- [x] Modern UI with Material 3
- [x] Athlete and Scout home screens
- [x] Profile management system
- [x] Event calendar integration
- [x] Messaging framework
- [x] Firebase backend integration
- [x] Social media-style navigation

### 🚧 In Progress
- [x] Advanced search and filtering
- [x] Video upload and playback
- [x] Real-time chat features
- [x] Analytics dashboard
- [ ] Push notifications
- [x] Event registration system
- [x] Connection management system
- [x] Profile picture upload
- [x] About sections
- [x] Scout 'Add Player' functionality
- [x] Scouted badge system
- [x] Connection counts (like Instagram followers)

### 📋 Planned Features
- [ ] Live streaming for events
- [ ] AI-powered athlete recommendations
- [ ] Integration with sports APIs
- [ ] Multi-language support
- [ ] Web platform support
- [ ] Advanced analytics dashboard
- [ ] Event management system
- [ ] Push notifications

## 🤝 Contributing

**⚠️ IMPORTANT: This project is not complete and is still in development.**

Contributions are welcome! Please feel free to submit issues and enhancement requests.

### Development Guidelines
- Follow Flutter/Dart coding standards
- Use Material 3 design principles
- Write clean, documented code
- Test thoroughly before submitting PRs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, issues, or feature requests:
- Create an issue on GitHub
- Contact the development team

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design team for design guidelines
- Open source community for inspiration and tools

---

**Note**: This is a development version of Scout Connect. Some features may not be fully implemented. The app is intended for demonstration and testing purposes.
