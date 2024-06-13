import React, { useState } from 'react';
import '../styles/App.css';

const App = () => {
  const [showStartPopup, setShowStartPopup] = useState(false);
  const [showSearchPopup, setShowSearchPopup] = useState(false);
  const [newMazeName, setNewMazeName] = useState('');
  const [mazeName, setMazeName] = useState('');
  const [mazeData, setMazeData] = useState(null);
  const [showAnswer, setShowAnswer] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [mazeDimensions, setMazeDimensions] = useState({ width: 0, height: 0 });

  const getCSRFToken = () => {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    return token;
  };

  const handleStartMaze = () => {
    setLoading(true);
    setError(null);
    fetch('/api/v1/mazes/start', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken(),
      },
      body: JSON.stringify({ name: newMazeName }),
    })
      .then((res) => res.json())
      .then((data) => {
        setLoading(false);
        if (data.success) {
          setMazeData(data.data);
          setMazeDimensions(getMazeDimensions(data.data.nodes));
          setShowStartPopup(false); // Close popup after submission
        } else {
          setError(data.error);
        }
      });
  };

  const handleSearchMaze = () => {
    setLoading(true);
    setError(null);
    fetch('/api/v1/mazes/search', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken(),
      },
      body: JSON.stringify({ name: mazeName }),
    })
      .then((res) => res.json())
      .then((data) => {
        setLoading(false);
        if (data.success) {
          setMazeData(data.data);
          setMazeDimensions(getMazeDimensions(data.data.nodes));
          setShowSearchPopup(false); // Close popup after search
        } else {
          setError(data.error);
        }
      });
  };

  const handleStartButtonClick = () => {
    setShowStartPopup(true);
    setShowSearchPopup(false);
  };

  const handleSearchButtonClick = () => {
    setShowStartPopup(false);
    setShowSearchPopup(true);
  };

  const handleShowAnswer = () => {
    setShowAnswer(true);
  };

  const handleHideAnswer = () => {
    setShowAnswer(false);
  };

  const getMazeDimensions = (nodes) => {
    const maxX = Math.max(...nodes.map(node => node.position_x + node.width));
    const maxY = Math.max(...nodes.map(node => node.position_y + node.height));
    return { width: maxX, height: maxY };
  };

  return (
    <div className="app">
      <h1>Maze Challenge!</h1>
      <div className="buttons">
        <button onClick={handleStartButtonClick}>Start New Maze</button>
        <button onClick={handleSearchButtonClick}>Search Previous Maze</button>
      </div>
      {!loading && showStartPopup && (
        <div className="popup">
          <input
            type="text"
            value={newMazeName}
            onChange={(e) => setNewMazeName(e.target.value)}
            placeholder="Enter new maze name"
          />
          <button onClick={handleStartMaze}>Start</button>
        </div>
      )}
      {!loading && showSearchPopup && (
        <div className="popup">
          <input
            type="text"
            value={mazeName}
            onChange={(e) => setMazeName(e.target.value)}
            placeholder="Enter maze name"
          />
          <button onClick={handleSearchMaze}>Search</button>
        </div>
      )}
      {loading && <div className="loading-spinner" />}
      {error && <div className="error-popup">{error}</div>}
      {mazeData && (
        <>
          <div className="answer-buttons">
            <button className="show-answer-button" onClick={handleShowAnswer}>Show Answer</button>
            <button className="hide-answer-button" onClick={handleHideAnswer}>Hide Answer</button>
          </div>
          <div className="maze-container" style={{ width: mazeDimensions.width, height: mazeDimensions.height }}>
            {mazeData.nodes.map((node, index) => (
              <div
                key={index}
                className="maze-node"
                style={{
                  left: `${node.position_x}px`,
                  top: `${node.position_y}px`,
                  width: `${node.width}px`,
                  height: `${node.height}px`,
                  backgroundColor: showAnswer ? node.ans_color : node.color,
                  borderTop: `1px solid ${showAnswer && node.borders.top.color !== 'Black' ? node.ans_color : node.borders.top.color}`,
                  borderLeft: `1px solid ${showAnswer && node.borders.left.color !== 'Black' ? node.ans_color : node.borders.left.color}`,
                  borderRight: `1px solid ${showAnswer && node.borders.right.color !== 'Black' ? node.ans_color : node.borders.right.color}`,
                  borderBottom: `1px solid ${showAnswer && node.borders.bottom.color !== 'Black' ? node.ans_color : node.borders.bottom.color}`,
                }}
              />
            ))}
          </div>
          <div className="entry-exit-points">
            <div className="entry-point" style={{ backgroundColor: showAnswer ? 'LightSkyBlue' : 'DodgerBlue' }} />
            <div className="entry-comment">Entry Point</div>
            <div className="exit-point" style={{ backgroundColor: showAnswer ? 'Orange' : 'Tomato' }} />
            <div className="exit-comment">Exit Point</div>
          </div>
        </>
      )}
    </div>
  );
};

export default App;
