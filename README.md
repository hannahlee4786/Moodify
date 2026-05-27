# 🎵 Moodify

A social music-sharing iOS app (think Instagram, but for music). Connect your Spotify account, discover what your friends are listening to, share songs based on your mood, and send recommendations back and forth through a dedicated inbox.


## Features

- **🔐 Spotify OAuth 2.0 Authorization Code Flow with PKCE (Proof Key for Code Exchange)**
  - For secure, token-based Spotify login (no passwords stored). A code challenge and code verifier are generated on-device before each login, ensuring secure token exchange in a native mobile environment.

- **👤 User Profile**
  - Each user has a personal profile displaying their saved/liked songs pulled from Spotify and their posts (songs they've shared to their feed).

- **📮 Inbox (Song Requests + Recommendations)**
  - Receive requests from friends asking for song recommendations based on a mood or vibe, send recommendations back in response, and make your own requests to friends by specifying a mood so they can send you something fitting.

- **🔍 Friend Search**
  - Search for other Moodify users by username to find and connect with friends.

- **📝 Create & Delete Posts**
  - Create a post by searching for any song via the Spotify API where each post displays the album cover art, song title, artist name, and user caption.
  - Delete your own posts at any time.
  - Like + Comment on posts.

- **🎵 Spotify Song Search**
  - Integrated Spotify search lets you look up any song when creating a post or sending a recommendation, pulling live data including album art, artist, and track info directly from the Spotify API.


## Prerequisites

- A Mac with **Xcode** installed
- An **iPhone or iOS Simulator** (iOS 15+)
- A **Spotify premium account** (Web API now requires a premium account for features listed above)
- A **Spotify Developer app** (takes ~2 minutes to set up — see below)


## Setup

### 1. Clone the repo

```bash
git clone https://github.com/hannahlee4786/Moodify.git
cd Moodify
```

### 2. Create a Spotify Developer app

1. Go to [developer.spotify.com/dashboard](https://developer.spotify.com/dashboard) and log in.
2. Click **Create App**.
3. Fill in any app name and description.
4. Under **Redirect URIs**, add: `moodify://callback`
5. Save. You'll land on your app's dashboard. Copy your **Client ID**.

### 3. Add your Client ID to the project

Open `Moodify.xcodeproj` in Xcode and find the SpotifyAuthManager.swift where the Spotify Client ID is configured. Paste in your Client ID from step 2. Repeat for Client Secret.

> **Note:** The redirect URI in the code should match exactly what you entered in the Spotify dashboard (`moodify://callback`).


## Running the App

1. Open **Moodify.xcodeproj** in Xcode.
2. Select your target device (simulator or a connected iPhone).
3. Hit the **▶ Play** button (note: it should fail because the developer is untrusted. Go to Settings > General > VPN & Device Management and click Allow on the app and Trust user).
5. Once the app launches, tap **Login with Spotify** and sign in.


## Tech Stack

- **Swift** — Swift codebase
- **SwiftUI** — UI framework for building the interface
- **Procreate** — custom retro-styled assets and illustrations designed by hand
- **Spotify Web API** — user saved songs, user playlists, song search and track metadata fetching, and Spotify login via OAuth 2.0 + PKCE
- **Firebase Authentication** — user account creation and authentication
- **Firestore** — stores posts, inbox requests and recommendations, and users' friends
