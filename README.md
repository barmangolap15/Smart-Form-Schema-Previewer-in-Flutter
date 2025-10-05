# Smart Form Schema Previewer 📝💡

A dynamic form generator in Flutter that renders entire forms from a JSON schema — no hardcoding required! Ideal for survey apps, CMS-driven apps, and Typeform/Google Forms clones.

🌟 Features

Paste or load JSON schema

Dynamically generate Flutter form UI

Handle validation (required fields, data types)

Collect and display submitted form data

Optional: Export schema or results to JSON or file

🧠 Example JSON Schema
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

⚙️ Tech Stack

Flutter & Dart – Cross-platform UI

GetX / Provider (optional) – State management

JSON Parsing – Dynamic form rendering

Validation logic – Required fields & data types

🛠️ How It Works

Input your JSON schema in the app

Parse the JSON into model classes

Dynamically generate widgets based on the field type

Apply validation rules

Capture and show submitted form data

🚀 Getting Started

Clone the repo:

git clone https://github.com/your-username/your-repo.git


Navigate to project folder:

cd your-repo


Install dependencies:

flutter pub get


Run the app:

flutter run

📸 Preview
