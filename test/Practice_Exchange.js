const pe = artifacts.require("./Practice_Exchange.sol");
const o = artifacts.require("./zeppelin/Ownable.sol");
const erc = artifacts.require("./zeppelin/ERC20.sol");

const expectThrow = function () {
    return async promise => {
      try {
        await promise;
      } catch (error) {
        const invalidOpcode = error.message.search('invalid opcode') >= 0;
        const outOfGas = error.message.search('out of gas') >= 0;
        assert(
          invalidOpcode || outOfGas,
          "Expected throw, got '" + error + "' instead",
        );
        return;
      }
      assert.fail('Expected throw not received');
    };
}

contract("Practice Exchange", function(accounts) {
    
    // !. Test use cases for different users
    // 2. Test proper functioning of individual functions
    
    // Assign testrpc accounts to variables
    var acc0 = accounts[0]; // Contract owner
    var acc1 = accounts[1]; 
    var acc2 = accounts[2];
    var acc3 = accounts[3];
    var acc4 = accounts[4];
    var acc5 = accounts[5];
    
    var exchange;
        
    beforeEach(async function() {
        // assign new contract instance to variable
        exchange = await pe.new();
    });
    
    describe("Owner functions", () => {
        
        // Example of catching an error with helpers
        it("should only be accessible to the owner *helper*", async function() {
            await expectThrow(exchange.addToken('TOKEN', acc5, {from: acc1}));
        });
        
    });
    
    describe("addToken", () => {
        
        it("should throw if the tokenSymbol exists", async function() {
            
        });
        
        it("should throw if tokenAddress is set to 0 address", async function() {
            
        });
        
        it("should correctly set the tokenSybol to the struct", async function() {
            
        });
        
        it("should correctly set the tokenAddress to the struct", async function() {
            
        });
        
        it("should increment the tokenIndexCounter by exactly 1", async function() {
            
        });
        
    });
    
    describe("depositEther", () => {
        
        it("", async function() {
        
        });
        
    });
    
    describe("withdrawEther", () => {
        
        it("", async function() {
        
        });
        
    });
    
});