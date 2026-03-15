# instagram_clone

this ia an assignment project which replicates the home feed of instagram with a focus on smooth animations, custom pinch-to-zoom, and efficient state management using BLoC. 
  
## Demo Recording:

 https://www.youtube.com/shorts/AuaWsFqMDGc


## 🎥 Demo Highlights
The demo video above showcases the following core features:
- **Shimmer Loading State:** Smooth skeleton screens mirroring Instagram's initial loading phase for stories, avatars, and posts.
- **Smooth Infinite Scrolling:** Seamlessly paginates mock network data as the user reaches the bottom of the feed.
- **Custom Pinch-to-Zoom:** A custom-built native overlay implementation that instantly locks feed scrolling, darkens the background, and dynamically zooms the image with realistic snap-back physics.
- **Toggle Interactions:** Double-tap to interact with gradient animations (Like/Save) that update state independently via BLoC.

## 🧠 State Management Choice
For this project, I chose **BLoC** utilizing the `flutter_bloc` package. 

- First and foremost, it is the state management tool I am most familiar with, allowing me to build the architecture efficiently and with confidence. 
- Beyond that, it fits a social feed use-case perfectly because a complex feed has many isolated moving parts. When a user double-taps to like a post or reaches the bottom to fetch more pages, the app needs to update *just those specific elements*. BLoC makes it incredibly simple to pinpoint these state changes (e.g., *"update the heart icon for post #3"* or *"append 10 new items to the list"*) while keeping the rest of the heavily animated UI perfectly smooth and avoiding unnecessary widget rebuilds.

## 🚀 How to Run the Build

Follow these steps to run the application locally on your emulator or physical device.

**Prerequisites:** 
- Flutter SDK installed on your machine.
- An emulator running (Android/iOS) or a physical device connected.

**Installation Steps:**
1. Clone the repository:
   ```bash
   git clone https://github.com/debasmitaas/instagram_clone.git
   cd instagram_clone

2. Clean the project directory to ensure a fresh environment:
   ```bash
    flutter clean
3. Get the dependencies:
   ```bash
    flutter pub get
4. Run the application:
    ```bash
     flutter run

**Apk Installation :**
 Install it from the release section of the repo.
