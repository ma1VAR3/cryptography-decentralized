// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.7.0;

contract CryptService {
    
    uint counter;

    constructor() public {
        counter = 0;
    }

    struct cipherAssociation {
        uint identifier;
        string cipher;
        address issuer;
        address[] accessPool;
    }

    cipherAssociation[] public CA;

    function storeCipher(string memory cipher, address[] memory parties) public returns(uint) {
        cipherAssociation memory c = cipherAssociation(counter,cipher, msg.sender,parties);
        CA.push(c);
        counter++;
    }
    
    function retrieveCipher() public returns(string) {
        
    }
}