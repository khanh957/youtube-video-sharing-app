import React, { useState, useEffect } from 'react';
import './VideoList.css';

function VideoList() {
  const [videos, setVideos] = useState([]);
  const [limit] = useState(5);
  const [offset, setOffset] = useState(0);
  const [initialLoad, setInitialLoad] = useState(true);

  useEffect(() => {
    fetchVideos();

    window.addEventListener('scroll', handleScroll);
    return () => {
      window.removeEventListener('scroll', handleScroll);
    };
  }, [limit, offset]);

  const fetchVideos = () => {
    fetch(`http://localhost:3001/videos?limit=${limit}&offset=${offset}`)
      .then(response => response.json())
      .then(data => {
        if (initialLoad) {
          setVideos(data.data);
          setInitialLoad(false);
        } else {
          setVideos(prevVideos => [...prevVideos, ...data.data]);
        }
      })
      .catch(error => {
        console.error('error:', error);
      });
  };

  const handleLoadMore = () => {
    setOffset(offset + limit);
  };

  const handleScroll = () => {
    if (
      window.innerHeight + window.scrollY >= document.body.offsetHeight - 100
    ) {
      handleLoadMore();
    }
  };

  return (
    <div>
      <div className="body">
        <ul>
          {videos.map(video => (
            <li key={video.id} className="video-item">
              <iframe
                className="video-iframe"
                width="560"
                height="250"
                src={`https://www.youtube.com/embed/${video.video_id}`}
                title={video.title}
                allowFullScreen
              ></iframe>
              <div className="video-info">
                <h3 className="video-title">{video.title}</h3>
                <p className="video-user">Shared by: {video.user.email}</p>
                <p className="description-label">Description:</p>
                <p className="description-content">{video.description}</p>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default VideoList;
