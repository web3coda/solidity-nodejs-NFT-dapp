// Import the necessary modules and components from the React library and local files
import React from 'react';
import MintNFT from './components/MintNFT'; // Importing the MintNFT component
import OwnNFT from './components/OwnNFT';   // Importing the OwnNFT component
import './css/app.css';                    // Importing the app's CSS styling

// Define the main App component
function App() {
  // The return statement specifies the structure of the rendered application
  return (
    <div className="App"> {/* The root div for the app */}
      <header className="App-header">
        <h1>NFT Marketplace</h1> {/* Page header displaying the app name */}
      </header>
      <div className="App-list"> {/* A container for displaying NFTs owned by the user */}
        <OwnNFT /> {/* Rendering the OwnNFT component to display user's owned NFTs */}
      </div>

      <MintNFT /> {/* Rendering the MintNFT component to allow users to mint new NFTs */}
    </div>
  );
}

export default App; // Exporting the App component as the default export
