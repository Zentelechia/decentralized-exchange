pragma solidity ^0.4.15;

// Interface for testing internal functions and variables

import "./Exchange.sol";

contract Interface is Exchange {
    function getTokenIndexTestable(string _tokenSymbol) returns (uint8) {
        return getTokenIndex(_tokenSymbol);
    }
}