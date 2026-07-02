# NovaFlow

NovaFlow adalah aplikasi **Task Management** berbasis **Flutter** yang dirancang untuk membantu mahasiswa mengelola tugas kuliah secara terorganisir. Aplikasi ini menyediakan berbagai fitur untuk mencatat, mengelola, memantau progres, dan mengingat tenggat waktu sehingga membantu meningkatkan produktivitas serta mengurangi risiko keterlambatan dalam penyelesaian tugas akademik.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Objectives](#-objectives)
- [Features](#-features)
- [Technology Stack](#️-technology-stack)
- [Project Structure](#-project-structure)
- [Database](#️-database)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Installation](#-installation)
- [Usage](#-usage)
- [Author](#-author)

---

## 📖 Overview

Mahasiswa sering kali harus mengelola banyak tugas dari berbagai mata kuliah dengan tenggat waktu yang berbeda. NovaFlow hadir sebagai solusi untuk membantu pengguna mencatat, mengatur, dan memantau seluruh tugas akademik dalam satu aplikasi yang sederhana, mudah digunakan, dan terorganisir.

---

## 🎯 Objectives

NovaFlow dikembangkan dengan tujuan untuk:

- Membantu mahasiswa mengelola tugas kuliah secara lebih efektif.
- Mempermudah pencatatan dan pengelolaan tugas akademik.
- Memantau progres penyelesaian tugas.
- Mengurangi risiko keterlambatan dalam menyelesaikan tugas.
- Meningkatkan produktivitas melalui penyajian informasi yang terstruktur.

---

## ✨ Features

### 📊 Dashboard

Menampilkan ringkasan kondisi tugas secara keseluruhan, meliputi:

- Total tugas
- Jumlah tugas selesai
- Jumlah tugas yang belum selesai
- Jumlah tugas yang telah melewati deadline (Overdue)
- Upcoming Tasks (tugas dengan deadline terdekat)

---

### 📝 Task Management (CRUD)

Mengelola data tugas secara lengkap, meliputi:

- Menambahkan tugas
- Melihat detail tugas
- Mengubah tugas
- Menghapus tugas

Informasi yang tersimpan pada setiap tugas meliputi:

- Kategori tugas
- Judul tugas
- Deskripsi
- Waktu pembuatan tugas
- Deadline
- Status penyelesaian

---

### 🔍 Search & Filter

Memudahkan pengguna menemukan tugas berdasarkan:

- Judul tugas
- Kategori

---

### ↕️ Task Sorting

Mengurutkan daftar tugas berdasarkan deadline sehingga pengguna dapat mengetahui tugas yang harus diprioritaskan.

---

### 📅 Calendar

Menampilkan kalender bulanan yang menandai tanggal dengan deadline tugas.

Fitur ini memungkinkan pengguna untuk:

- Melihat seluruh deadline pada kalender
- Memilih tanggal tertentu
- Menampilkan daftar tugas berdasarkan tanggal yang dipilih

---

### 📈 Statistics & Analytics

Menyediakan visualisasi data dalam bentuk grafik untuk membantu pengguna memantau produktivitas, meliputi:

- Total seluruh tugas
- Total tugas selesai
- Total tugas belum selesai
- Jumlah tugas dalam satu minggu

---

## 🛠️ Technology Stack

| Technology | Description |
|------------|-------------|
| Flutter | Framework pengembangan aplikasi mobile |
| Dart | Bahasa pemrograman |
| SQLite (sqflite) | Penyimpanan data lokal |
| Provider | State Management |
| Flutter Quill | Rich Text Editor untuk deskripsi tugas |
| Table Calendar | Kalender deadline |
| Syncfusion Flutter Charts | Visualisasi statistik |
| Intl | Format tanggal dan waktu |

---

## 📂 Project Structure

```
├── 📁 core
│   └── 📄 theme_provider.dart
├── 📁 data
│   ├── 📁 auth
│   │   ├── 📄 auth_provider.dart
│   │   └── 📄 login_helper.dart
│   ├── 📁 models
│   │   ├── 📄 app_error.dart
│   │   └── 📄 task_model.dart
│   └── 📁 services
│       ├── 📄 database_helper.dart
│       └── 📄 task_helper.dart
├── 📁 features
│   ├── 📁 analytics
│   │   └── 📄 analytics_screen.dart
│   ├── 📁 calendar
│   │   └── 📄 calendar_screen.dart
│   ├── 📁 home
│   │   └── 📄 home_screen.dart
│   ├── 📁 landing
│   │   └── 📄 landing_screen.dart
│   ├── 📁 login
│   │   └── 📄 login_screen.dart
│   ├── 📁 settings
│   │   └── 📄 settings_screen.dart
│   └── 📁 tasks
│       ├── 📄 add_task_category.dart
│       ├── 📄 task_detail.dart
│       ├── 📄 task_form.dart
│       └── 📄 tasks_screen.dart
├── 📁 routes
│   └── 📄 bottom_nav.dart
├── 📁 state
│   └── 📄 task_provider.dart
├── 📁 widgets
└── 📄 main.dart
```

---

## 🗄️ Konsep Database

NovaFlow menggunakan **SQLite** sebagai media penyimpanan data lokal.
```
assets\concept\erd.png
```

## 📊 Alur Aplikasi
```
assets\concept\work_flow.png
```

## 📷 Screenshots
### Landing Screen

```
assets\screenshots\landing_screen.jpg
```

### Register

```
assets\screenshots\register.jpg
```

### Login

```
assets\screenshots\login.jpg
```

### Add Task Category

```
assets\screenshots\add_task_category.jpg
```

### Home

```
assets\screenshots\home.jpg
```

### Tasks

```
assets\screenshots\tasks.jpg
```

### Calendar

```
assets\screenshots\calendar.jpg
```

### Analytics

```
assets\screenshots\analytics.jpg
```

### settings

```
assets\screenshots\settings.jpg
```

### Create Task

```
assets\screenshots\create_task.jpg
```

### Edit Task

```
assets\screenshots\edit_task.jpg
```

### Task Detail

```
assets\screenshots\task_detail.jpg
```
---

## 🚀 Getting Started

### Prerequisites

Pastikan perangkat telah terpasang:

- Flutter SDK
- Dart SDK
- Android Studio atau Visual Studio Code
- Android SDK atau Emulator
- Git

Pastikan instalasi Flutter telah dikonfigurasi dengan benar.

```bash
flutter doctor
```

---

## 📥 Installation

Clone repository:

```bash
git clone https://github.com/<username>/<repository>.git
```

Masuk ke direktori project:

```bash
cd <repository>
```

Install seluruh dependency:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

---

## ▶️ Usage

Beberapa perintah Flutter yang umum digunakan selama pengembangan:

Menjalankan aplikasi:

```bash
flutter run
```

Menjalankan aplikasi pada mode release:

```bash
flutter run --release
```

Membangun APK:

```bash
flutter build apk --release
```

---

## 👨‍💻 Author

**Nama:** *and*

GitHub: https://github.com/<username>