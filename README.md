# Sports Skills App

A Flutter application that displays a list of sports skills grouped by proficiency level (Basic, Intermediate, Advanced) in horizontal scrolling carousels.

---

## Features

- Parses skill data from a JSON file in assets
- Groups skills by level: Basic, Intermediate, Advanced
- Displays three horizontal scroll carousels, one for each skill level
- Clean and responsive UI design with image cards and skill names
- Smooth horizontal scrolling with `ListView.builder` and `BouncingScrollPhysics`
- Basic error handling and loading indicators
- Well-structured Flutter code following best practices

---

## Project Structure

```

lib/
├── main.dart              \# App entry point
├── models/
│   └── skill_model.dart   \# Skill data class
├── services/
│   └── json_service.dart  \# JSON parsing logic
└── screens/
└── skills_screen.dart \# Main UI displaying skills
assets/
└── skills.json            \# JSON file with skills data
pubspec.yaml               \# Flutter project config with asset declaration

```

---

## Getting Started

1. **Clone the repository**

```

git clone <repo-url>
cd sports_skills_app

```

2. **Install dependencies**

```

flutter pub get

```

3. **Run the app**

```

flutter run

```

---

## JSON Data Format

The JSON file `assets/skills.json` should contain an array of skill objects with `name`, `level`, and `image` fields:

```

[
{
"name": "Dribbling",
"level": "Basic",
"image": "https://picsum.photos/200/200?random=1"
},
{
"name": "Vault",
"level": "Intermediate",
"image": "https://picsum.photos/200/200?random=2"
},
{
"name": "Agility",
"level": "Advanced",
"image": "https://picsum.photos/200/200?random=3"
}
]

```

---

## Code Overview

- **`JsonService`** handles loading and parsing JSON from assets.
- **`Skill` model** represents a skill object.
- **`SkillsScreen`** loads data asynchronously, manages loading/error states.
- Skills are grouped by level using a map and displayed in the order: Basic → Intermediate → Advanced.
- UI consists of three separate horizontal `ListView.builder` widgets acting as carousels.
- **`SkillCard`** displays skill image and name within a clean card.

---

## Evaluation Criteria Met

- **Correct grouping and ordering** of skill levels
- Responsive and clean UI with clear section headers
- Smooth horizontal scrolling performance
- Clear separation of concerns in code structure
- Proper error handling and user feedback

---

## Screenshots / Demo

<img width="409" height="864" alt="Screenshot 2025-10-03 165949" src="https://github.com/user-attachments/assets/7908d826-9c68-4e27-8ba0-bd688c64418c" />


