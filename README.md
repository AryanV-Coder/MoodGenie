# 🌈 MoodGenie - Your Emotional AI Companion

MoodGenie is an AI-powered mood journaling and companion app built using **Flutter** (frontend) and **FastAPI + Gemini API** (backend). It helps users reflect on their thoughts, get emotionally intelligent replies, and store their mood summaries locally using **Hive**.

📥 **Download MoodGenie App**: [Download APK](https://drive.google.com/file/d/1bS43TN5nnJhanVEdiFTTMrBMrcnqcFUS/view?usp=sharing)

---

## 🚀 Features

- 🧠 AI-generated emotional responses using Google Gemini API
- ✨ Auto-generated mood summaries stored locally on device
- 🐝 Local database using Hive (no internet needed for mood history)
- 📱 Shareable as APK, without the Play Store
- 🌐 Backend deployed via FastAPI on Render
- 🎨 Beautiful UI with custom animations and Google Fonts

---

## 📦 Tech Stack

| Layer        | Technology       |
|--------------|------------------|
| Frontend     | Flutter          |
| Backend      | FastAPI          |
| AI Model     | Google Gemini (gemini-2.0-flash-lite) |
| Local Storage | Hive            |

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

### For Backend:
- **Python 3.8+** - [Download Python](https://www.python.org/downloads/)
- **pip** (Python package manager, comes with Python)

### For Frontend:
- **Flutter SDK 3.8.0+** - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (comes with Flutter)
- **Android Studio** (for Android development) or **Xcode** (for iOS development on macOS)
- **A code editor** like VS Code or Android Studio

### API Keys:
- **Google Gemini API Key** - [Get API Key](https://makersuite.google.com/app/apikey)

---

## ⚙️ Backend Setup

### 1. Navigate to Backend Directory

```bash
cd backend
```

### 2. Create Virtual Environment (Recommended)

```bash
# On macOS/Linux
python3 -m venv venv
source venv/bin/activate

# On Windows
python -m venv venv
venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Create a `.env` file in the `backend` directory:

```bash
touch .env
```

Add your Gemini API key to the `.env` file:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

Replace `your_gemini_api_key_here` with your actual API key from Google AI Studio.

### 5. Run the Backend Server

```bash
# Development mode with auto-reload
uvicorn main:app --reload

# Production mode
uvicorn main:app --host 0.0.0.0 --port 8000
```

The backend API will be available at `http://localhost:8000`

### API Endpoints:
- `POST /chat` - Send user prompt and receive AI response
- `GET /summary` - Get conversation summary when app closes

---

## 📱 Frontend Setup

### 1. Navigate to Frontend Directory

```bash
cd frontend
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Backend URL

Open `lib/screens/home_screen.dart` and update the API URL if needed:

```dart
final url = Uri.parse('http://localhost:8000/chat'); // For local testing
// OR
final url = Uri.parse('https://moodgenie.onrender.com/chat'); // For production
```

### 4. Verify Assets

Ensure the following assets are present in the `assets/` directory:
- `app_icon.png` - App launcher icon
- `cloudy_animation.mp4` - Background animation (optional)

### 5. Run the App

#### For Android:
```bash
flutter run
```

#### For iOS (macOS only):
```bash
cd ios
pod install
cd ..
flutter run
```

#### For Web:
```bash
flutter run -d chrome
```

### 6. Build APK (Android)

To create a release APK:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

For split APKs per ABI (smaller file sizes):

```bash
flutter build apk --split-per-abi
```

---

## 🎯 Project Structure

```
MoodGenie/
├── backend/
│   ├── main.py                          # FastAPI server
│   ├── gemini_handler.py                # Gemini AI integration
│   ├── moodgenie_training_data.json     # AI training context
│   ├── requirements.txt                 # Python dependencies
│   ├── .env                             # Environment variables (not tracked)
│   └── .gitignore
├── frontend/
│   ├── lib/
│   │   ├── main.dart                    # App entry point
│   │   └── screens/
│   │       ├── splash_screen.dart       # Welcome screen
│   │       ├── mainAppScreen.dart       # Main navigation
│   │       ├── home_screen.dart         # Chat interface
│   │       └── history_screen.dart      # Mood history
│   ├── assets/
│   │   ├── app_icon.png                 # App icon
│   │   └── cloudy_animation.mp4         # Background video
│   ├── pubspec.yaml                     # Flutter dependencies
│   └── .gitignore
└── README.md
```

---

## 🧪 Testing the Application

### Backend Testing:

1. Start the backend server:
   ```bash
   cd backend
   uvicorn main:app --reload
   ```

2. Test the chat endpoint:
   ```bash
   curl -X POST http://localhost:8000/chat \
     -H "Content-Type: application/json" \
     -d '{"user_prompt": "I am feeling happy today!"}'
   ```

3. Test the summary endpoint:
   ```bash
   curl http://localhost:8000/summary
   ```

### Frontend Testing:

1. Ensure backend is running
2. Launch the Flutter app
3. Test conversation flow
4. Check mood history storage
5. Verify summary generation on app close

---

## 🌐 Deployment

### Backend Deployment (Render):

1. Push your code to GitHub
2. Connect your repository to Render
3. Set environment variable: `GEMINI_API_KEY`
4. Deploy with build command: `pip install -r requirements.txt`
5. Start command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### Frontend Deployment:

- **Android**: Share the APK file directly
- **iOS**: Distribute via TestFlight or App Store
- **Web**: Deploy using `flutter build web` and host on Firebase/Netlify/Vercel

---

## 🔧 Troubleshooting

### Common Backend Issues:

**Issue**: `ModuleNotFoundError: No module named 'fastapi'`  
**Solution**: Run `pip install -r requirements.txt` in the backend directory

**Issue**: `google.generativeai.types.generation_types.BlockedPromptException`  
**Solution**: Check your API key and ensure it's valid

### Common Frontend Issues:

**Issue**: `Failed to load asset`  
**Solution**: Run `flutter pub get` and verify assets in `pubspec.yaml`

**Issue**: `Connection refused` when testing  
**Solution**: Ensure backend server is running and URL is correct in `home_screen.dart`

**Issue**: Build fails for iOS  
**Solution**: Run `cd ios && pod install && cd ..` then try again

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available for educational purposes.

---

## 👤 Author

**Aryan Varshney**

- GitHub: [@AryanV-Coder](https://github.com/AryanV-Coder)

---

## 🙏 Acknowledgments

- Google Gemini AI for the conversational intelligence
- Flutter team for the amazing framework
- FastAPI for the lightning-fast backend framework
- Hive for efficient local storage

---

## 📞 Support

If you encounter any issues or have questions, please:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review existing issues on GitHub
3. Create a new issue with detailed information

**Happy Coding! 🚀**
