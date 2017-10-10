pragma solidity ^0.4.15;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";

contract practice_exchange {
    
// Constructer

    // SafeMath
    using SafeMath for uint256;
    
    // Asign ownership
    function practice_exchange() internal {
        owner = msg.sender;
    }

// Modifiers
    // Ownership modifier
    modifier onlyowner() {
        if (msg.sender == owner) {
            _;
        }
    }

// Data structures
    
    // Ownership
    address owner;
    
    // TokenIndex
    uint8 tokenIndexCounter = 1;
    
    // Balances
        // msg.sender => ethBalance
    mapping (address => uint) balancesETH;
        // msg.sender => tokenIndex => tokenBalance
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
    function addToken(string _tokenSymbol, address _erc20Addr) public onlyowner {
        require(!hasToken(_tokenSymbol));
        require(_erc20Addr != address(0));
        tokenStruct[tokenIndexCounter].tokenSymbol = _tokenSymbol;
        tokenStruct[tokenIndexCounter].tokenAddress = _erc20Addr;
        tokenIndexCounter++;
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
    }
    
    // User withdraws tokens
    function withdrawToken(string _tokenSymbol, uint _amount) public {
        ERC20 token = ERC20(getTokenAddress(_tokenSymbol));
        uint balance = getTokenBalance(_tokenSymbol);
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        require(token.transferFrom(this, msg.sender, _amount));
        balancesToken[msg.sender][index] = balance.sub(_amount);
    }
    
    // User deposits ETH
    function depositEther() public payable {
        uint balance = getEthBalanceInWei();
        balancesETH[msg.sender] = balance.add(msg.value);
    }
    
    // User withdraws ETH
    function withdrawEther(uint _amountWei) public {
        uint balance = getEthBalanceInWei();
        balancesETH[msg.sender] = balance.sub(_amountWei);
        msg.sender.transfer(_amountWei);
    }
    
    // User places buy order (execute if matching sellorder, store otherwise)
    function buyToken(string token_symbol, uint price_in_wei, uint amount) public {}
    
    // User places sell order (execute if matching buyorder, store otherwise)
    function sellToken(string token_symbol, uint price_in_wei, uint amount) public {}
    
    // Cancel specific limit order
    function cancelOrder(string token_symbol, bool isSellOrder, uint price_in_wei, uint offer_key) public {}
    
// Calls
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
    
    // Return ETH balance of msg.sender
    function getEthBalanceInWei() public constant returns (uint) {
        return balancesETH[msg.sender];
    }
    
    // Return order books (price, volume)
    function getSellOrderBook(string token_symbol) public constant returns (uint[],uint[]) {}
    function getBuyOrderBook(string token_symbol) public constant returns (uint[],uint[]) {}
    
    // Return index of token
    function getTokenIndex(string _tokenSymbol) internal constant returns (uint8) {
        for (uint8 i = 1; i <= tokenIndexCounter; i++) {
            if (keccak256(tokenStruct[i].tokenSymbol) == keccak256(_tokenSymbol)) { return i; }}
        return 0;
    }
    
    // Return token contract address
    function getTokenAddress(string _tokenSymbol) public constant returns (address) {
        uint8 index = getTokenIndex(_tokenSymbol);
        require(hasToken(_tokenSymbol));
        return tokenStruct[index].tokenAddress;
    }

// Events
    // New token added
    
    // Deposit ETH
    event DepositEther();
    // Withdraw ETH
    event WithdrawEther();
    // Deposit Token 
    event DepositToken();
    // Withdraw Token 
    event WithdrawToken();
    
    // Limit order created
    event LimitBuyOrder();
    event LimitSellOrder();
    // Order fulfilled
    event BuyOrderFulfilled();
    event SellOrderFulfilled();
    // Order canceled
    event OrderCanceled();
    
}
