// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

// Import the ERC721 and Ownable contracts from the OpenZeppelin library
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Define the NFTMarketplace contract inheriting from ERC721 and Ownable
contract NFTMarketplace is ERC721, Ownable {
    // Maximum number of NFTs that can be minted
    uint256 public constant MAX_NFT_SUPPLY = 5;
    
    // Variable to keep track of the next token ID to be minted
    uint256 public nextTokenId = 1;
    
    // Price in Ether to mint an NFT
    uint256 public mintPrice = 0.01 ether;

    // Constructor to initialize the ERC721 contract with a name and symbol
    constructor() ERC721("NFT Marketplace Collection", "NFTM") {}

    modifier mintAndTransferIfNeeded(uint256 tokenId, address to) {
        if (!_exists(tokenId)) {
            require(nextTokenId <= MAX_NFT_SUPPLY, "All NFTs have been minted");
            require(msg.value >= mintPrice, "Insufficient Ether sent");

            _safeMint(address(this), nextTokenId);
            nextTokenId++;

            if (msg.value > mintPrice) {
                payable(msg.sender).transfer(msg.value - mintPrice);
            }
        }
        
        _transfer(address(this), to, tokenId);
        _;
    }

    function transferNFT(address to, uint256 tokenId) external payable mintAndTransferIfNeeded(tokenId, to) {}

    // Function to mint an NFT
    function mintNFT() external payable {
        // Check if there are remaining NFTs to mint
        require(nextTokenId <= MAX_NFT_SUPPLY, "All NFTs have been minted");
        
        // Check if the sender has sent enough Ether to cover the minting price
        require(msg.value >= mintPrice, "Insufficient Ether sent");

        // Mint the NFT and assign it to the sender's address
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;

        // Refund excess Ether back to the sender
        if (msg.value > mintPrice) {
            payable(msg.sender).transfer(msg.value - mintPrice);
        }
    }

    // Function to set the minting price, only accessible by the contract owner
    function setMintPrice(uint256 _newMintPrice) external onlyOwner {
        mintPrice = _newMintPrice;
    }

    // Function to withdraw the contract's funds, only accessible by the contract owner
    function withdrawFunds() external onlyOwner {
        // Transfer the contract's balance to the owner's address
        payable(owner()).transfer(address(this).balance);
    }
}