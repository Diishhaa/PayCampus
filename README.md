# 💳 PayCampus

**PayCampus** is a premium, AI-powered school fee management and audit reconciliation platform built for parents and school administrators. It streamlines fee collection, automates payment verification using **Google Gemini AI OCR**, and enables real-time ledger updates across both parent and admin portals.

Developed with a sleek, minimalist Material 3 design, custom fintech color systems, and interactive analytical charts, PayCampus delivers a premium user experience for modern educational institutions.

---

## 🚀 Hackathon Live Demo Walkthrough Script

Experience the end-to-end billing and audit loop in the Sandbox environment:

### **Step 1: Parent Portal & Child Linking**
1. Launch the app and select **Parent Portal**.
2. Log in using a mock 10-digit phone number (e.g., `9876543210`).
3. Link a student profile by entering `Rahul Sharma` (Class: `8`, Div: `A`).
4. View the child's dynamic profile dashboard displaying outstanding dues, annual progress bar, and past verified billing transaction receipts.

### **Step 2: Digital Payment & AI OCR Verification**
1. Click **Pay Outstanding Fees** on the dashboard.
2. Select **UPI (PhonePe, GPay, Paytm)** and click **Pay Now**.
3. Choose **Upload Transaction Screenshot**. Click **From Gallery** (it mocks choosing a PhonePe payment screenshot).
4. Tap **Proceed to OCR Verification**.
5. The **Gemini AI OCR Engine** scans the screenshot, extracts the UTR transaction number (`UTR829402948293`), payment amount, and updates the local database ledger in real-time.
6. Click **View Official Receipt** to see the custom, high-fidelity digital e-receipt.

### **Step 3: School Administrator Real-Time Audit**
1. Return to the Launcher and select **School Admin Dashboard** (Admin Portal).
2. Log in using a mock school email address (e.g., `admin@greenwood.edu`).
3. View live KPI counters (Today's Revenue, Outstanding Balance, Defaulter Count) which are synced in real-time with the parent's transactions.
4. Go to **Queue** to open the **AI Reconciliation Queue**. You will find receipts flagged for manual review (with low confidence scores).
5. Tap on **Devansh Varma**'s Hostel slip $\rightarrow$ Inspect the uploaded screenshot side-by-side with extracted data $\rightarrow$ Click **Approve & Post**.
6. Switch back to the **Parent Portal** $\rightarrow$ Select **Devansh Varma** $\rightarrow$ Notice that his dues are cleared and transaction status is updated to **Verified**!

### **Step 4: Dynamic Fee publishing**
1. In the Admin Portal, go to **Builder** (Dynamic Fee Builder).
2. Create a new fee demand: `Term 3 tuition fee`, Amount: `12500`, Target: `Grade 8-A`. Click **Publish Now**.
3. Switch back to the **Parent Portal** $\rightarrow$ Select **Rahul Sharma** (who is in Grade 8-A) $\rightarrow$ Notice his outstanding balance has dynamically increased by ₹12,500!

---

## ✨ Core Features

* **Dual-Portal Sandbox**: Switch instantly between the parent billing view and admin accounting ledger.
* **Gemini AI OCR Receipt Reader**: Reads uploaded receipt screenshots (or scans invoices via camera) to extract UTR, date, and transacted amounts, preventing manual entry fraud.
* **AI Reconciliation Queue**: Interactive audit queue presenting OCR confidence scores, mismatch highlighting, and side-by-side transaction proofs for easy school reviews.
* **Dynamic Fee Builder**: Let administrators publish recurring or one-off fee demands to specific classes, grades, or individual student accounts.
* **Waiver & Penalty Adjustments**: Full administrative control to adjust waivers (e.g., scholarships, sports merits) or waive late fees on student profiles with live state updates.
* **Premium UX/UI**: Implements dynamic Glassmorphism navigation bars, Notion-style inputs, rich fintech color gradients, Google Fonts (Inter/Outfit), and system-integrated Light/Dark modes.

---

## 🛠️ Technology Stack

* **Frontend Framework**: Flutter (Dart SDK `>=3.0.0 <4.0.0`)
* **Design System**: Material 3
* **AI Model API**: Google Gemini 1.5 Flash API (Vision Capabilities)
* **Data Visualization**: `fl_chart` (Custom graphs/revenue lines)
* **Typography**: `google_fonts` (Inter, Outfit)
* **Networking**: Native Dart `HttpClient` (Safe, lightweight REST calls)

---

## ⚙️ Project Setup & Installation

### **Prerequisites**
* Flutter SDK (version `>=3.0.0`)
* Android Studio / Xcode / VS Code

### **Run Locally**
1. Clone the repository:
   ```bash
   git clone https://github.com/RajvardhanS-Patil/PayCampus.git
   cd PayCampus
   ```
2. Get packages and dependencies:
   ```bash
   flutter pub get
   ```
3. Run the analysis and test suite to ensure clean build compilation:
   ```bash
   flutter analyze
   ```
   ```bash
   flutter test
   ```
4. Run the application on your device or emulator:
   ```bash
   flutter run
   ```

### **Configure Gemini API OCR (Optional)**
To enable real Gemini AI Vision recognition on receipt uploads (instead of the sandbox mock simulations):
1. Obtain a Google AI Studio Gemini API Key.
2. Run the application with the API key defined in the environment:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key_here
   ```
   *Alternatively, configure it inside the sandbox mock settings within the app.*

---

## 📁 Codebase Architecture

```
lib/
├── core/
│   ├── constants/       # AppColors and Gradients
│   ├── theme/           # Light & Dark Material 3 Theme configurations
│   ├── widgets/         # Custom widgets (Glassbar, Shimmer, Empty State, KPI Card)
│   └── services/        # MockDatabase & Gemini OcrService
├── models/              # Student, Fee, Transaction, Reconciliation classes
└── features/
    ├── auth/            # Role selection, onboarding and login screens
    ├── parent/          # Dashboard, receipt viewing, payments, OCR scanner screens
    └── admin/           # KPI Dashboard, reconciliation queue, fee builder, directories
```

---

## 🤝 Contributors

* **Rajvardhan S Patil** - [GitHub Profile](https://github.com/RajvardhanS-Patil)