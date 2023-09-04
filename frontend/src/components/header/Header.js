import React, { useState, useEffect } from 'react';
import cookie from 'react-cookies'
import './Header.css';

function Header({ onShareVideoClick }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [userData, setUserData] = useState(null);

  const handleLogin = async () => {
    try {
      const response = await fetch('http://localhost:3001/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      if (response.ok) {
        const data = await response.json();
        setUserData(data)
        cookie.save("token", data);
      } else {
        const errorData = await response.json();
        alert(errorData.error);
      }
    } catch (error) {
      console.error('error:', error);
    }
  };

  const handleLogout = () => {
    cookie.remove("token");
    setUserData(null);
  };

  useEffect(() => {
    setUserData(cookie.load("token"))
  }, []);

  return (
    <div className="header">
      <div className="left">
        <img src="/logo-home.png" alt="Logo" />
        <h1>FUNNY MOVIES</h1>
      </div>
      <div className="right">
        {
          (userData) ?
            <div>
              Welcome {userData.user.email}
              <button className="button" onClick={onShareVideoClick}>
                Share a Video
              </button>
              <button className="button" onClick={handleLogout}>Logout</button>
            </div>
            :
            <div>
              <input className="input-field"
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
              <input className="input-field"
                type="password"
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
              <button className="button" onClick={handleLogin}>Login / Register</button>
            </div>
        }
      </div>
    </div>
  );
}

export default Header;
