var pec = artifacts.require("./Exchange.sol");
var erc = artifacts.require("./zeppelin/ERC20.sol");
var int = artifacts.require("./Interface.sol");

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

contract("Exchange", function(accounts) {
    
    // Assign testrpc accounts to variables
    const acc0 = accounts[0]; // Owner
    const acc1 = accounts[1]; // Not owner, no tokens
    const acc2 = accounts[2]; // Not owner, Owns 1000 tokens
    const acc3 = accounts[3]; // Not owner, Owns 10 tokens
    const acc4 = accounts[4]; // Dummy address
    const acc5 = accounts[5];
    
    // web3.BigNumber(1);
    // web3.fromAscii("short");
    
    // Generate dummy constants
    const dummyString1 = web3.fromAscii("token");
    const dummyString2 = web3.fromAscii("test");
    const dummyAddress = acc4;
    const zeroAddress = 0x0;
    
    // Initiate contract instance variables
    var exchange;
    var token;
        
    beforeEach(async function() {

        // assign new contract instances to variables
        exchange = await pec.new();
        token = await erc.new();
        interface = await int.new();

        // mint tokens to 2 accounts
        await token.mint(acc2, 1000);
        await token.mint(acc3, 10);
        await token.finishMinting();

    });
    
    describe("Unit tests", function() {
        
        // interface function does not return up to the interface
        describe.skip("getTokenIndex", function() {

            it("should return 0 if _tokenSymbol does not exist", async function() {
                await exchange.addToken(dummyString1, token.address, {from: acc0});
                let index = await interface.getTokenIndexTestable.call(dummyString2);
                assert.equal(index.toNumber(), 0, "did not return 0");
            });
            
            it("should return 0 for empty string _tokenSymbol", async function() {
                await exchange.addToken(dummyString1, token.address, {from: acc0});
                let index = await interface.getTokenIndexTestable.call("");
                assert.equal(index.toNumber(), 0, "did not return 0");
            });
            
            it("should return 1 for first token", async function() {
                await exchange.addToken(dummyString1, token.address, {from: acc0});
                let index = await interface.getTokenIndexTestable.call(dummyString1);
                assert.equal(index.toNumber(), 1, "did not return 1");
            });
            
            it("should return 2 for second token", async function() {
                await exchange.addToken(dummyString1, token.address, {from: acc0});
                await exchange.addToken(dummyString2, token.address, {from: acc0});
                let index = await interface.getTokenIndexTestable.call(dummyString2);
                assert.equal(index.toNumber(), 2, "did not return 2");
            });

        });
        
        describe("hasToken", function() {

            it("", async function() {
                
            });

        });
        
        describe("getTokenBalance", function() {

            it("", async function() {
                
            });

        });
        
        describe("getTokenAddress", function() {

            it("", async function() {
                
            });

        });
        
        describe("getEthBalanceInWei", function() {

            it("", async function() {
                
            });

        });
        
        describe("addToken", function() {
        
            it("should throw if the tokenSymbol exists", async function() {
                
            });

            it("should throw if tokenAddress is set to 0 address", async function() {
                
            });
            
            it("should throw if _tokenSymbol is not valid string", async function() {
                
            });
            
            it("should throw if _erc20Addr is not valid address", async function() {
                
            });

            it("should correctly set the tokenSybol to the struct", async function() {
                
            });

            it("should correctly set the tokenAddress to the struct", async function() {
                
            });

            it("should increment the tokenIndexCounter by exactly 1", async function() {
                
            });

        });

        describe("depositToken", function() {

            it("", async function() {
                
            });

        });

        describe("withdrawToken", function() {

            it("", async function() {
                
            });

        });
        
        describe("depositEther", function() {

            it("", async function() {
                
            });

        });

        describe("withdrawEther", function() {

            it("", async function() {
                
            });

        });
        
    });
    
    describe("Interaction tests", function() {
        
        describe("Owner visibility", function() {
            // Example of catching an error with helpers
            it("should only be accessible to the owner *helper*", async function() {
                await expectThrow(exchange.addToken('TOKEN', acc5, {from: acc1}));
            });

        });
        
    });
    
});