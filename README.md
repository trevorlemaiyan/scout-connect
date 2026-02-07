# Scout Connect

A modern Flutter social media application designed to connect athletes with sports scouts, inspired by LinkedIn and Instagram design patterns.

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
- [ ] Advanced search and filtering
- [ ] Video upload and playback
- [ ] Push notifications
- [ ] Real-time chat features
- [ ] Analytics dashboard
- [ ] Event registration system

### 📋 Planned Features
- [ ] Live streaming for events
- [ ] AI-powered athlete recommendations
- [ ] Integration with sports APIs
- [ ] Multi-language support
- [ ] Web platform support

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
