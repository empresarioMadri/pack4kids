pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

contract Notary {
  struct DocumentSaved {
      bytes32 doc;
      uint time;
      bool exist;
      string user;
  }

  mapping(bytes32 => DocumentSaved) private documents;
  mapping (bytes32 => bool) private proofs;

  function storeProof(bytes32 proof, string memory dni) private {
    proofs[proof] = true;
    DocumentSaved storage document = documents[proof];
    document.doc = proof;
    document.exist = true;
    document.user = dni;
    document.time = block.timestamp; //conversion to normal date https://www.epochconverter.com/
  }

  function notarize(string memory document, string memory dni) public {
    bytes32 proof = proofFor(document);
    storeProof(proof, dni);
  }

  function proofFor(string memory document) private pure returns (bytes32) {
    return sha256(abi.encode(document));
  }

  function checkDocument(string memory document) public view returns (DocumentSaved memory) {
    bytes32 proof = proofFor(document);

    return hasProof(proof);
  }

  function hasProof(bytes32 proof) private view returns(DocumentSaved memory) {
    DocumentSaved memory doc = documents[proof];
    return doc;
  }

}