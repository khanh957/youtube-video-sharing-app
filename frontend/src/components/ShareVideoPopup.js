import React, { useState } from 'react';
import cookie from 'react-cookies'
import './ShareVideoPopup.css';

function ShareVideoPopup({ onClose }) {
  const [videoLink, setVideoLink] = useState('');

  const handleShareVideo = async () => {
    try {
      const token = cookie.load("token").token;

      const videoData = {
        video_url: videoLink,
      };

      const response = await fetch('http://localhost:3001/videos', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify(videoData),
      });

      if (response.ok) {
        onClose();
      } else {
        const errorData = await response.json();
        alert(errorData.error);
      }
    } catch (error) {
      console.error('error:', error);
    }
  };

  return (
    <div className="popup">
      <div className="popup-content">
        <label>Youtube URL:</label>
        <input
          type="text"
          placeholder="Enter video link"
          value={videoLink}
          onChange={(e) => setVideoLink(e.target.value)}
        />
      </div>
      <div className="popup-buttons">
        <button className="button" onClick={handleShareVideo}>
          Share
        </button>
        <button className="button" onClick={onClose}>
          Cancel
        </button>
      </div>
    </div>
  );
}

export default ShareVideoPopup;
