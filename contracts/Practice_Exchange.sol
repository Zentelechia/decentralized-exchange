pragma solidity ^0.4.15;

import "./zeppelin/ERC20.sol";
import "./zeppelin/SafeMath.sol";
import "./zeppelin/Ownable.sol";

contract practice_exchange is Ownable {
    
    
// Constructor

    // SafeMath
    using SafeMath for uint256;
    
    // payable fallback
    function () public payable {}


// Modifiers


// Data
    
    // Ownership
    address owner;
    // TokenIndex
    uint8 tokenIndexCounter;
    // Balances
        // msg.sender => ethBalance
        // msg.sender => tokenIndex => tokenBalance
    mapping (address => uint) balancesETH;
    mapping (address => mapping (uint8 => uint)) balancesToken;
    // Tokens
        // tokenIndex => Token struct
    mapping (uint8 => Token) tokenStruct;
    struct Token {
        string tokenSymbol;
        address tokenAddress;
        mapping(uint => OrderBook) buyBook;
        mapping(uint => OrderBook) sellBook;
        uint curBuyPrice;
        uint lowestBuyPrice;
        uint amountBuyPrices;
        uint curSellPrice;
        uint highestSellPrice;
        uint amountSellPrices;
    }
    struct OrderBook {
        uint higherPrice;
        uint lowerPrice;
        mapping(uint => Offer) offers;
        uint offersKey;
        uint offersLength;
    }
    struct Offer {
        address who;
        uint amount;
    }
    
    
// Functions

    // Admin adds tokens, starts at index 1
    function addToken(string _tokenSymbol, address _erc20Addr) public onlyOwner {
        require(!hasToken(_tokenSymbol));
        require(_erc20Addr != address(0));
        tokenIndexCounter++;
        tokenStruct[tokenIndexCounter].tokenSymbol = _tokenSymbol;
        tokenStruct[tokenIndexCounter].tokenAddress = _erc20Addr;
        AddToken(_tokenSymbol, _erc20Addr, tokenIndexCounter);
    }
    
    // User deposits tokens
    function depositToken(string _tokenSymbol, uint _amount) public {
        ERC20 token = ERC20(getTokenAddress(_tokenSymbol));
        uint balance = getTokenBalance(_tokenSymbol);
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        require(token.allowance(msg.sender, this) >= _amount);
        require(token.transferFrom(msg.sender, this, _amount));
        require(token.approve(msg.sender, _amount));
        balancesToken[msg.sender][index] = balance.add(_amount);
        DepositToken(msg.sender, _tokenSymbol, _amount);
    }
    
    // User withdraws tokens
    function withdrawToken(string _tokenSymbol, uint _amount) public {
        ERC20 token = ERC20(getTokenAddress(_tokenSymbol));
        uint balance = getTokenBalance(_tokenSymbol);
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        require(token.transferFrom(this, msg.sender, _amount));
        balancesToken[msg.sender][index] = balance.sub(_amount);
        WithdrawToken(msg.sender, _tokenSymbol, _amount);
    }
    
    // User deposits ETH
    function depositEther() public payable {
        uint balance = getEthBalanceInWei();
        balancesETH[msg.sender] = balance.add(msg.value);
        DepositEther(msg.sender, msg.value);
    }
    
    // User withdraws ETH
    function withdrawEther(uint _amountWei) public {
        uint balance = getEthBalanceInWei();
        balancesETH[msg.sender] = balance.sub(_amountWei);
        msg.sender.transfer(_amountWei);
        WithdrawEther(msg.sender, _amountWei);
    }
    
    // User places buy order (execute if matching sellorder, store otherwise)
    function buyToken(string token_symbol, uint price_in_wei, uint amount) public {}
    
    // User places sell order (execute if matching buyorder, store otherwise)
    function sellToken(string token_symbol, uint price_in_wei, uint amount) public {}
    
    // Cancel specific limit order
    function cancelOrder(string token_symbol, bool isSellOrder, uint price_in_wei, uint offer_key) public {}
    
    
// Calls

    // Return index of token
    function getTokenIndex(string _tokenSymbol) internal constant returns (uint8) {
        for (uint8 i = 1; i <= tokenIndexCounter; i++) {
            if (keccak256(tokenStruct[i].tokenSymbol) == keccak256(_tokenSymbol)) { return i; }}
        return 0;
    }
    
    // Check if token is on the exchange
    function hasToken(string token_symbol) public constant returns (bool) {
        if (getTokenIndex(token_symbol) != 0) { return true; }
        return false;
    }
    
    // Return token balance of msg.sender
    function getTokenBalance(string _tokenSymbol) public constant returns (uint) {
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        return balancesToken[msg.sender][index];
    }
    
    // Return token contract address
    function getTokenAddress(string _tokenSymbol) public constant returns (address) {
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        return tokenStruct[index].tokenAddress;
    }
    
    // Return ETH balance of msg.sender
    function getEthBalanceInWei() public constant returns (uint) {
        return balancesETH[msg.sender];
    }
    
    // Return order books (price, volume)
    function getSellOrderBook(string token_symbol) public constant returns (uint[],uint[]) {}
    function getBuyOrderBook(string token_symbol) public constant returns (uint[],uint[]) {}
    
    
// Events

    // New token added
    event AddToken(string indexed _tokenSymbol, address indexed _erc20Addr, uint8 indexed _tokenIndex);
    // Deposit and Withdraw
    event DepositEther(address indexed depositor, uint indexed amountWei);
    event WithdrawEther(address indexed withdrawer, uint indexed amountWei);
    event DepositToken(address indexed depositor, string indexed tokenSymbol, uint indexed amount);
    event WithdrawToken(address indexed withdrawer, string indexed tokenSymbol, uint indexed amount);
    // Limit order created
    event LimitBuyOrder();
    event LimitSellOrder();
    // Order fulfilled
    event BuyOrderFulfilled();
    event SellOrderFulfilled();
    // Order canceled
    event OrderCanceled();
    
}
