# 🩺 DFU Screening Platform v2.0

![Banner](assets/banner.png)

## 🚀 Overview
The **DFU Screening Platform** is an advanced, AI-powered diagnostic ecosystem designed for the early detection and management of **Diabetic Foot Ulcers (DFU)**. Leveraging an agentic AI architecture, the platform automates the clinical pathway from image normalization to severity classification and structured clinical reporting.

Built with a high-end **Glassmorphism UI**, the system provides a premium experience for both clinicians and patients, ensuring that diabetic care is accessible, intelligent, and real-time.

---

## 🧠 Agentic AI Pipeline
The platform utilizes a multi-agent orchestration layer to process clinical data:

1.  **🔍 Preprocessor Agent**: Normalizes raw clinical imagery, handling lighting, artifacts, and resolution scaling using **Pillow** and **NumPy**.
2.  **🩺 Diagnostician Agent**: An AI classifier that maps wounds to the **Wagner Scale** (Grades 0-3). Currently using a high-fidelity heuristic model designed to be replaced by a **DenseNet-121** ONNX weights.
3.  **📝 Reporter Agent**: Translates technical diagnosis into actionable clinical guidelines and wound management protocols.
4.  **💬 Assistant Agent**: Powered by **Groq Llama-4**, this agent provides real-time AI insights and a streaming chat interface for complex medical queries.

---

## 🛠️ Technology Stack

### Backend (`dfu_backend`)
- **Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Python 3.10+)
- **AI Engine**: [Groq](https://groq.com/) (Llama-4 70B/8B)
- **Processing**: NumPy, Pillow
- **Deployment**: Vercel-ready with `vercel.json`
- **Streaming**: Server-Sent Events (SSE) for real-time AI chat.

### Frontend (`dfu_frontend`)
- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.11.3)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **UI/UX**: `glassmorphism_ui`, `google_fonts`, `animations`
- **Backend Services**: [Firebase](https://firebase.google.com/) (Auth, Firestore)
- **Networking**: `http` for REST & Streaming APIs

---

## 📁 Project Structure
```text
.
├── dfu_backend/          # FastAPI server & AI Agents
│   ├── agents/           # Specialized AI Agent logic
│   ├── api/              # API Route definitions
│   ├── models/           # Data schemas & Model wrappers
│   └── main.py           # Server entry point
├── dfu_frontend/         # Flutter Mobile/Web Application
│   ├── lib/              # Core application logic
│   │   ├── features/     # Feature-based architecture
│   │   ├── core/         # Themes & Providers
│   │   └── widgets/      # Shared Glassmorphism components
│   └── pubspec.yaml      # Flutter dependencies
└── assets/               # Branding & Documentation assets
```

---

## 🚦 Getting Started

### Backend Setup
1. Navigate to `dfu_backend`.
2. Create a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Windows: .venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Configure `.env`:
   ```env
   GROQ_API_KEY=your_key_here
   ```
5. Run the server:
   ```bash
   uvicorn main:app --reload
   ```

### Frontend Setup
1. Navigate to `dfu_frontend`.
2. Ensure you have the Flutter SDK installed.
3. Fetch packages:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective directories.
5. Launch the app:
   ```bash
   flutter run
   ```

---

## 📈 Roadmap & Future Scope
- [ ] Integration of real DenseNet-121 ONNX weights for local inference.
- [ ] Multi-lingual support for rural healthcare workers.
- [ ] Offline-first capability with Hive local storage.
- [ ] Advanced Grad-CAM visualization for AI explainability.

---

## 📄 License
This project is for clinical research and educational purposes. See `LICENSE` for details (if applicable).

---
*Developed with ❤️ for Advanced Diabetic Care.*
