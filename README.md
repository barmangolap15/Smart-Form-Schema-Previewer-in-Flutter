# Smart Form Schema Previewer 📝💡

A dynamic form generator in Flutter that renders entire forms from a JSON schema — no hardcoding required! Ideal for survey apps, CMS-driven apps, and Typeform/Google Forms clones.

### 🌟 Features

- Paste or load JSON schema
- Dynamically generate Flutter form UI
- Handle validation (required fields, data types)
- Collect and display submitted form data

### 🧠 Example JSON Schema
```json
{
  "title": "User Registration Form",
  "fields": [
    { "label": "Full Name", "type": "text", "required": true },
    { "label": "Email", "type": "email", "required": true },
    { "label": "Age", "type": "number" },
    { "label": "Gender", "type": "dropdown", "options": ["Male", "Female", "Other"] },
    { "label": "Accept Terms", "type": "checkbox" }
  ]
}
```


### ⚙️ Tech Stack

- Flutter & Dart – Cross-platform UI
- JSON Parsing – Dynamic form rendering
- Validation logic – Required fields & data types

### 🛠️ How It Works

- Input your JSON schema in the app
- Parse the JSON into model classes
- Dynamically generate widgets based on the field type
- Apply validation rules
- Capture and show submitted form data

### 🚀 Getting Started

1. Clone the repo:

```json
git clone https://github.com/barmangolap15/Smart-Form-Schema-Previewer-in-Flutter.git
```

2. Navigate to project folder:

```json
cd https://github.com/barmangolap15/Smart-Form-Schema-Previewer-in-Flutter.git
```

3. Install dependencies:

```json
flutter pub get
```

4. Run the app:

```json
flutter run
```
