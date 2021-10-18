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

    cipherAssociation[] private CA;

    function storeCipher(string memory cipher, address[] memory parties) public returns(uint) {
        cipherAssociation memory c = cipherAssociation(counter,cipher, msg.sender,parties);
        CA.push(c);
        CA[counter].accessPool.push(msg.sender);
        uint id = counter;
        counter++;
        return id;
    }
    
    function retrieveCipher(uint identifier) public view returns(string memory) {
        cipherAssociation memory c = CA[identifier];
        
        for(uint i=0; i<c.accessPool.length; i++) {
            if(c.accessPool[i] == msg.sender) {
                return c.cipher;
            }
        }
        return "0";
    }
    
    function addAccessorCipher(uint identifier, address[] memory parties) public returns(bool) {
        cipherAssociation storage c = CA[identifier];
        bool flag = false;
        if (c.issuer == msg.sender) {
            flag= true;
            for(uint i=0; i<parties.length; i++) {
                c.accessPool.push(parties[i]);
            }
        }
        return flag;
    }
}