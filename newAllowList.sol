    function whitelistMint(uint256 count, uint256 allowance, bytes32[] calldata proof) public payable {
        string memory payload = string(abi.encodePacked(_msgSender()));
        require(_verify(_leaf(Strings.toString(allowance), payload), proof), "Invalid Merkle Tree proof supplied.");
        require(addressToMinted[_msgSender()] + count <= allowance, "Exceeds whitelist supply"); 
        require(count * priceInWei == msg.value, "Invalid funds provided.");

        addressToMinted[_msgSender()] += count;
        uint256 totalSupply = _owners.length;
        for(uint i; i < count; i++) { 
            _mint(_msgSender(), totalSupply + i);
        }
    }

    function publicMint(uint256 count) public payable {
        uint256 totalSupply = _owners.length;
        require(totalSupply + count < MAX_SUPPLY, "Excedes max supply.");
        require(count < MAX_PER_TX, "Exceeds max per transaction.");
        require(count * priceInWei == msg.value, "Invalid funds provided.");
    
        for(uint i; i < count; i++) { 
            _mint(_msgSender(), totalSupply + i);
        }
    }

    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }




//------------FIXED OLD--------------------------------

    function whitelistMint(uint256 count, uint256 allowance, bytes32[] calldata proof) external payable callerIsUser{
        require(whiteListSale, "R00ts Yacht Club :: Minting is on Pause");

        string memory payload = string(abi.encodePacked(_msgSender()));
        require(_verify(_leaf(Strings.toString(allowance), payload), proof), "Invalid Merkle Tree proof supplied.");
        require(totalWhitelistMint[_msgSender()] + count <= allowance, "Exceeds whitelist supply"); 
        require(msg.value >= (WHITELIST_SALE_PRICE * count), "R00ts Yacht Club :: Payment is below the price");
        require((totalSupply() + count) <= MAX_SUPPLY, "R00ts Yacht Club :: Cannot mint beyond max supply");


        //require((totalWhitelistMint[msg.sender] + count)  <= allowance, "R00ts Yacht Club :: Cannot mint beyond whitelist max mint!");
        
        //create leaf node


        totalWhitelistMint[_msgSender()] += count;
        _safeMint(_msgSender(), _quantity);
    }



    function mint(uint256 count) external payable callerIsUser{
        require(publicSale, "R00ts Yacht Club :: Not Yet Active.");
        require((totalSupply() + count) <= MAX_SUPPLY, "R00ts Yacht Club :: Beyond Max Supply");
        require((totalPublicMint[_msgSender()] + count) <= MAX_PUBLIC_MINT, "R00ts Yacht Club :: Already minted 100 times!");
        require(msg.value >= (PUBLIC_SALE_PRICE * count), "R00ts Yacht Club :: Below ");

        totalPublicMint[_msgSender()] += count;
        _safeMint(_msgSender(), count);
    }



    