pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

contract Notary {
  struct DocumentSaved {
      bytes32 doc;
      uint time;
      bool exist;
      //User creator;
  }

  /*struct User {
      string name;
      string surName;
  }*/

  mapping(bytes32 => DocumentSaved) private documents;
  mapping (bytes32 => bool) private proofs;

  function storeProof(bytes32 proof) private {
    proofs[proof] = true;
    DocumentSaved storage document = documents[proof];
    document.doc = proof;
    document.exist = true;
    document.time = block.timestamp;
  }

  function notarize(string memory document) public {
    if (checkDocument(document)){
      //all user data
    } else {
      //not all user data
    }
    bytes32 proof = proofFor(document);
    storeProof(proof);
  }

  function proofFor(string memory document) private pure returns (bytes32) {
    return sha256(abi.encode(document));
  }

  function checkDocument(string memory document) public view returns (bool) {
    bytes32 proof = proofFor(document);

    return hasProof(proof);
  }

  function hasProof(bytes32 proof) private view returns(bool) {
    DocumentSaved memory doc = documents[proof];
    if (doc.exist){
      return true;
    } else {
      return false;
    }
  }

}