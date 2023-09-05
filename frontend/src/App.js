import React, { useState } from 'react';
import './App.css';
import Header from './components/header/Header';
import VideoList from './components/VideoList';
import ShareVideoPopup from './components/ShareVideoPopup';

const ws = new WebSocket("ws://localhost:3001/cable");

function App() {
  const [showPopup, setShowPopup] = useState(false);
  const [notifications, setNotifications] = useState([]);

  ws.onopen = () => {
    console.log("Connected websocket");
    ws.send(
      JSON.stringify({
        command: "subscribe",
        identifier: JSON.stringify({
          channel: "VideosChannel",
        })
      })
    )
  }

  ws.onmessage = (e) => {
    const data = JSON.parse(e.data);
    if (data.type === "ping") return;
    if (data.type === "welcome") return;
    if (data.type === "confirm_subscription") return;

    setNotifications(prevNotifications => [...prevNotifications, data.message]);

    setTimeout(() => {
      setNotifications(prevNotifications => prevNotifications.filter(item => item !== data.message));
    }, 5000);
  };

  const handleShareVideoClick = () => {
    setShowPopup(true);
  };

  const handleClosePopup = () => {
    setShowPopup(false);
  };

  return (
    <div className="App">
      <div className="notification-container">
        {notifications.map((notification, index) => (
          <div key={index} className="notification-popup">
            <h3>New Video Created</h3>
            <p>Title: {notification.title}</p>
            <p>Shared by: {notification.user}</p>
          </div>
        ))}
      </div>
      <div className="Content">
        <Header onShareVideoClick={handleShareVideoClick} />
        {showPopup ? <ShareVideoPopup onClose={handleClosePopup} /> : <VideoList />}
      </div>
    </div>
  );
}

export default App;
