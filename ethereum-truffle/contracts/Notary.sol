pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

contract Notary {
  struct DocumentSaved {
      bytes32 doc;
      bytes32 docHash;
      uint time;
      bool exist;
      string user;
  }

  mapping(bytes32 => DocumentSaved) private documents;
  mapping (bytes32 => bool) private proofs;

  function storeProof(bytes32 proof, string memory dni, bytes32 documentContent) private {
    proofs[proof] = true;
    DocumentSaved storage document = documents[proof];
    document.doc = documentContent;
    document.docHash = proof;
    document.exist = true;
    document.user = dni;
    document.time = block.timestamp; //conversion to normal date https://www.epochconverter.com/
  }

  function notarize(bytes32 document, string memory dni) public {
    require(!(checkDocument(document).exist && keccak256(abi.encodePacked((checkDocument(document).user))) !=
      keccak256(abi.encodePacked((dni))) && checkDocument(document).doc == document), "Someone uploaded this document before");
    bytes32 proof = proofFor(document);
    storeProof(proof, dni, document);
  }

  function proofFor(bytes32 document) private pure returns (bytes32) {
    return sha256(abi.encode(document));
  }

  function checkDocument(bytes32 document) public view returns (DocumentSaved memory) {
    return hasProof(proofFor(document));
  }

  function hasProof(bytes32 proof) private view returns(DocumentSaved memory) {
    DocumentSaved memory doc = documents[proof];
    return doc;
  }

}