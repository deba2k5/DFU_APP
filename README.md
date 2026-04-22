# Diabetic Foot Ulcer (DFU) Classification System

An AI-powered full-stack SaaS application for the clinical assessment and staging of Diabetic Foot Ulcers. The platform leverages a fine-tuned MobileNetV3 computer vision model for predicting Wagner scale grades (0-5) and is integrated with Groq's Llama-4 model to provide dynamic, professional clinical recommendations and an interactive medical AI assistant.

---

## 🌟 Key Features

*   **Clinical-Grade AI Diagnosis:** Uses a MobileNetV3-Small architecture fine-tuned on a 6-class DFU dataset, incorporating an Active Contour (Snake algorithm) preprocessor for region-of-interest extraction.
*   **Agentic Pipeline:**
    *   *Preprocessor Agent:* Normalizes and segments clinical images.
    *   *Diagnostician Agent:* Classifies the ulcer severity (Grade 0 to Grade 5).
    *   *Reporter Agent:* Formats the findings into structured medical reports.
    *   *Assistant Agent:* A Groq-powered Llama-4 agent that generates precise next-step clinical summaries and supports real-time Q&A.
*   **Cross-Platform Frontend:** A beautiful, responsive Flutter application featuring a modern glassmorphism aesthetic.

---

## 🏗️ System Architecture

*   **Frontend:** Flutter (Mobile/Web/Desktop)
*   **Backend:** Python, FastAPI
*   **Machine Learning:** PyTorch, Torchvision, Scikit-Image, OpenCV
*   **LLM Integration:** Groq API (Llama-4-scout)

---

## 🚀 Getting Started

Follow the instructions below to set up and run the frontend and backend servers locally.

### 1. Backend Setup (FastAPI)

The backend handles the AI inference and interacts with the Groq API.

**Prerequisites:** Python 3.9+

1.  Navigate to the backend directory:
    ```bash
    cd dfu_backend
    ```
2.  Set up a virtual environment (optional but recommended):
    ```bash
    python -m venv .venv
    # Windows
    .\.venv\Scripts\activate
    # macOS/Linux
    source .venv/bin/activate
    ```
3.  Install the required Python packages:
    ```bash
    pip install -r requirements.txt
    ```
4.  Configure Environment Variables:
    *   Ensure there is a `.env` file in the `dfu_backend` directory.
    *   Add your Groq API key:
        ```env
        GROQ_API_KEY=your_groq_api_key_here
        ```
5.  Start the FastAPI Server:
    ```bash
    python -m uvicorn main:app --reload --host 127.0.0.1 --port 8000
    ```
    The API will be available at `http://127.0.0.1:8000`. You can view the API documentation at `http://127.0.0.1:8000/docs`.

### 2. Frontend Setup (Flutter)

The frontend provides the user interface for capturing/uploading images and viewing the clinical reports.

**Prerequisites:** Flutter SDK installed and configured.

1.  Navigate to the frontend directory:
    ```bash
    cd dfu_frontend
    ```
2.  Install Flutter dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    *   **To run on Chrome (Web):** (Recommended for quick testing)
        ```bash
        flutter run -d chrome
        ```
    *   **To run on an Android device/emulator:**
        Ensure your emulator is running or device is connected via USB debugging.
        ```bash
        flutter run -d android
        ```
    *   **To run on Windows Desktop:**
        *(Note: Requires CMake 3.22+ and Visual Studio with C++ workload installed)*
        ```bash
        flutter run -d windows
        ```

---

## 📊 Wagner Scale Classes Supported

*   **Grade 0:** Pre-ulcerative lesion, healed ulcer, or presence of bony deformity.
*   **Grade 1:** Superficial ulcer without subcutaneous tissue involvement.
*   **Grade 2:** Deep ulcer with penetration to the tendon, bone, or joint capsule.
*   **Grade 3:** Deep ulcer with osteitis, abscess, or osteomyelitis.
*   **Grade 4:** Localized gangrene (e.g., toe or forefoot).
*   **Grade 5:** Extensive gangrene involving the whole foot.
