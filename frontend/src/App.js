import React, { useState } from 'react';
import './App.css';
import Header from './components/header/Header';
import VideoList from './components/VideoList';
import ShareVideoPopup from './components/ShareVideoPopup';

function App() {
  const [showPopup, setShowPopup] = useState(false);

  const handleShareVideoClick = () => {
    setShowPopup(true);
  };

  const handleClosePopup = () => {
    setShowPopup(false);
  };

  return (
    <div className="App">
      <Header onShareVideoClick={handleShareVideoClick} />
      {showPopup ? <ShareVideoPopup onClose={handleClosePopup} /> : <VideoList />}
    </div>
  );
}

export default App;
