# 🔧 InstantMechanic

**Find nearby mechanics. Check details. Request a service in seconds.**

A SwiftUI iOS assignment project demonstrating MVVM architecture, protocol-oriented networking, `async/await`, and modern SwiftUI navigation.

---

## 📱 Screenshots

<p align="center">
  <img src="https://github.com/poojak2008/InstantMechanic/raw/main/InstantMechanic/mechanic_list.png" width="210" alt="Mechanic List" />
  <img src="https://github.com/poojak2008/InstantMechanic/raw/main/InstantMechanic/mechanic_detail.png" width="210" alt="Mechanic Details" />
  <img src="https://github.com/poojak2008/InstantMechanic/raw/main/InstantMechanic/request_service.png" width="210" alt="Request Service" />
  <img src="https://github.com/poojak2008/InstantMechanic/raw/main/InstantMechanic/confirmation.png" width="210" alt="Confirmation" />
</p>

---

## 📱 Overview

**InstantMechanic** helps users discover nearby mechanics, view detailed profile information, and submit service requests.

Built as an educational assignment application, it focuses on:
* **Clean MVVM Separation:** Strict isolation between UI logic and domain models.
* **Protocol-Based Dependency Injection:** Flexible swapping between mock and remote network services.
* **Native `async/await` Networking:** Asynchronous execution using Swift concurrency.
* **SwiftUI Navigation:** Utilizing modern `NavigationStack`.
* **Explicit UI States:** Comprehensive loading, error, empty, and success handling.
* **Testable Service-Layer Design:** Decoupled dependencies built for unit testing.

---

## ✨ Features

| Feature | Description |
| :--- | :--- |
| 🔧 **Mechanic List** | Displays mechanic name, rating, distance, location, availability, and services |
| 📍 **Mechanic Details** | Shows address, working hours, phone number, and available services |
| 📝 **Request Service** | Allows users to select a service, enter a vehicle number, and describe the problem |
| ✅ **Confirmation** | Displays a confirmation screen after successful submission |
| 🔄 **Pull to Refresh** | Refreshes the mechanic list asynchronously |
| ⚠️ **Error Handling** | Provides retry actions for failed network requests |
| 📭 **Empty State** | Handles cases where no mechanics are currently available |

---

## 📄 Sample JSON Data

The bundled `mechanics.json` structured payload example:

```json
[
  {
    "id": 1,
    "name": "Instant Auto Care",
    "rating": 4.7,
    "distance": 2.4,
    "location": "Sector 44, Gurgaon",
    "isOpen": true,
    "services": [
      "Car Service",
      "Battery",
      "Tyre"
    ]
  }
]
```

---

## 🚀 Getting Started

### Prerequisites
* Xcode 15+
* iOS 17+
* Swift 5.9+
* macOS compatible with your installed Xcode version

### Installation
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/your-username/InstantMechanic.git
   ```
2. Open `InstantMechanic.xcodeproj` in Xcode.
3. Ensure `mechanics.json` is selected under target membership.
4. Select an iOS Simulator or physical device running iOS 17+.
5. Build and run (`Cmd + R`).

### Injecting Mock vs Live Data
By default, `MechanicListViewModel` initializes with `GitHubMechanicAPIService()`. To run against local mock data, inject `MockMechanicAPIService`:

```swift
let viewModel = MechanicListViewModel(
    apiService: MockMechanicAPIService()
)
```

---

## 🧪 Testing Error States

Simulate network failures and edge cases using the mock service layer:

```swift
let service = MockMechanicAPIService()
service.simulateFailure = true
```

Use this toggle to verify UI behaviors for:
* Network failure state UI
* Retry action triggers
* Loading overlays
* Empty list scenarios

---

## 📝 Current Limitations

* **Simulated Submissions:** `submitServiceRequest(_:)` operates locally for presentation purposes. It generates a mock reference ID and simulates success without hitting a live database endpoint.

---

## 🛠 Tech Stack

* **Language:** Swift 5.9+
* **UI Framework:** SwiftUI (`NavigationStack`, `@State`, `@Published`, `@MainActor`)
* **Architecture:** MVVM + Protocol-Oriented Dependency Injection
* **Concurrency:** `async/await`, `@MainActor`
* **Networking:** Native `URLSession`, `Codable`
