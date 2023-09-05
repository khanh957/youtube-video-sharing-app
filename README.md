# Youtube Video Sharing App

## Introduction

Welcome to Youtube Video Sharing App, a web application that allows users to share and discover YouTube videos with ease.

## Prerequisites

Before you get started, make sure you have the following software and tools installed on your system:

### When Using Docker (Recommended):

- **Docker:** Version 20.10.16 or higher.
- **Docker Compose:** Version 1.29.2 or higher.

### When Not Using Docker:

If you prefer not to use Docker, you'll need to install the following software and tools manually:

- **Ruby:** Version 3.2.2.
- **Ruby on Rails:** Version 7.0.7.2.
- **Bundler:** Version 2.4.10.
- **Node.js:** Version 20.5.1.
- **npm:** Version 9.8.0.

Make sure to install these dependencies with the specified versions to ensure compatibility with the application.

## Installation & Configuration

Step-by-step instructions for cloning the repository, installing dependencies, and configuring settings.
* Clone the GitHub repository:
```
git clone https://github.com/khanh957/youtube-video-sharing-app.git
cd youtube-video-sharing-app
```

### Docker Deployment (Recommended):
All you need to do is run the following command and wait until everything is launched
`docker-compose up`

### When Not Using Docker:
**Backend Setup:**
```
cd backend
bundle install
```
**Frontend Setup:**
```
cd frontend
npm install
```

## Database Setup
```
rails db:create
rails db:migrate
```

## Running the Application

How to start the development server, access the application in a web browser, and run the test suite.
* Run the backend
`rails server -p 3001`
* Run the frontend
`npm start`

* You can access the application in your web browser at `http://localhost:3000`

* To run the test suite:
```
cd backend
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
RAILS_ENV=test rspec
```

## Usage

### User Registration and Login

- You can simply log in using the fields at the top of the page.
If you don't have an account yet, don't worry! The application will automatically create one for you the first time you try to log in. Just provide your login details, and the system will handle the rest.

### Sharing YouTube Videos

1. Once logged in, navigate to the "Share a Video" button of the application.

2. Paste the URL of the YouTube video you want to share and click "Share."

3. Your shared video will now be accessible to other users of the platform.

### Viewing Shared Videos

1. Explore the "Shared Videos" section to discover a list of videos shared by other users.

2. Click on a video thumbnail to watch the video.

### Real-time Notifications

1. As you use the application, whenever another user shares a new video, a notification will appear as a pop-up in the upper corner of your screen.

2. The notification will display the video title and the user who shared it.
