// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.7.0;

contract CryptService {
    
    int counter;

    struct cipherAssociation {
        string identifier;
        string cipher;
        address issuer;
        address[] accessPool;
    }

    cipherAssociation[] CA;
}