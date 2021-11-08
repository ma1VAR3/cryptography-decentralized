// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.7.0;

contract CryptService {
    
    
    // identifier variables
    
    uint CAcounter;
    uint DHPcounter;
    
    constructor() public {
        CAcounter = 0;
        DHPcounter = 0;
    }
    
    
    // Definition of structures
    
    struct cipherAssociation {
        uint identifier;
        address issuer;
        string cipher;
        address[] accessPool;
    }
    
    struct diffieHellmanPool {
        uint identifier;
        address issuer;
        uint prime;
        uint generator;
        mapping (address => uint) exhanges;
        address[] accessPool;
    }
    
    struct publicKeyPool {
        uint identifier;
        uint publicKey;
        address[] accessPool;
    }
    
    
    // pool declarations
    
    cipherAssociation[] private CA;
    
    diffieHellmanPool[] private DHP;
    
    mapping (address => publicKeyPool[]) private PKP;
    mapping (address => uint) private PKI;
    
    
    // cipher functions 
    
    function storeCipher(string memory cipher, address[] memory parties) public returns(uint) {
        cipherAssociation memory c = cipherAssociation(CAcounter, msg.sender, cipher,parties);
        CA.push(c);
        CA[CAcounter].accessPool.push(msg.sender);
        uint id = CAcounter;
        CAcounter++;
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
    
    
    // Diffie Hellman functions 
    
    function createNewDHExchange(uint prime, uint generator, uint exchange, address[] memory parties) public returns(uint) {
        mapping (address => uint) ex;
        ex[msg.sender] = exchange;
        diffieHellmanPool d = new diffieHellmanPool(DHPcounter, msg.sender, prime, generator, ex, parties);
        d.parties.push(msg.sender);
        DHP.push(d);
        uint id = DHPcounter;
        DHPcounter++;
        return id;
    }
    
    function addDHExchange(uint identifier, uint exhange) public returns(bool) {
        diffieHellmanPool d = DHP[identifier];
        bool flag = false;
        for(int i=0; i < d.accessPool.length; i++) {
            if(d.accessPool[i] == msg.sender) {
                mapping (address => uint) ex = d.exhanges;
                ex[msg.sender] = exhange;
                flag = true;
            }
        }
        return flag;
    }
    
    function addAccessorDH(uint identifier, address[] memory parties) public returns(bool) {
        bool flag = false;
        if(DHP[identifier].issuer == msg.sender) {
            for(int i=0; i < parties.length; i++) {
                DHP[identifier].accessPool.push(parties[i]);
            }
            flag = true;
        }
        return flag;
    }
    
    function getDHExchange() public returns(uint) {
        
    }
    
    
    // Public key cryptography functions
    
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
}