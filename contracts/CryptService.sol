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
    
    struct publicKeyPool {
        uint identifier;
        uint publicKey;
        address[] accessPool;
    }
    
    struct diffieHillmanPool {
        uint identifier;
        uint generator;
        uint prime;
        address [] accessPool;
    }

    cipherAssociation[] private CA;
    
    mapping (address => publicKeyPool[]) private PKP;
    mapping (address => uint) private PKI;
    
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
    
    function createNewKeyPool(uint pubK, address[] memory parties) public returns(uint) {
        uint identifier = PKI[msg.sender];
        PKI[msg.sender] = identifier + 1;
        publicKeyPool memory p = publicKeyPool(identifier, pubK, parties);
        publicKeyPool[] storage keyPool = PKP[msg.sender];
        keyPool.push(p);
        keyPool[identifier].accessPool.push(msg.sender);
        PKP[msg.sender] = keyPool;
        return identifier;
    }
    
    function getPubKfromKeyPool(address party, uint identifier) public view returns(uint) {
        if(PKI[party] >= identifier) {
            return 0;
        }
        for(uint i=0; i<PKP[party][identifier].accessPool.length; i++) {
            if(PKP[party][identifier].accessPool[i] == msg.sender) {
                return PKP[party][identifier].publicKey;
            }
        }
        return 0;
        
    }

    // function to add acessor to KeyPool

    // functions for enctypted key storage
        // create
        // accesss
        // modify
        // change accessor
}