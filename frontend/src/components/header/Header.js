import React, { useState, useEffect } from 'react';
import cookie from 'react-cookies'
import './Header.css';

function Header() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [user, setUser] = useState(null);

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
        setUser(data.user)
        const token = data.token;
        cookie.save("token", token);
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
    setUser(null);
  };

  useEffect(() => {
    
  }, []);

  const token = cookie.load("token");

  return (
    <div className="header">
      <div className="left">
        <img src="/logo-home.png" alt="Logo" />
        <h1>FUNNY MOVIES</h1>
      </div>
      <div className="right">
        {
          (token && user) ?
            <div>
              Welcome {user.email}
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
