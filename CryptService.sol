// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.7.0;

contract CryptService {
    
    int counter;

    constructor() public {
        counter = 0;
    }

    struct cipherAssociation {
        uint identifier;
        string cipher;
        address issuer;
        address[] accessPool;
    }

    cipherAssociation[] CA;

    function storeCipher(string cipher, address[] parties) public returns(uint) {
        
    }
}