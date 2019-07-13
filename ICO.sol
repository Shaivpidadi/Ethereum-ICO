pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol";

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol";

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol";

import "https://raw.githubusercontent.com/Sonblind/openzeppelin-solidity/add-leasable/contracts/lifecycle/TimeFrame.sol";

    // @param rate Number of token units a buyer gets per wei
    // @param wallet Address where collected funds will be forwarded to
    // @param token Address of the token being sold
     

contract MyTokenCrowdsale is Crowdsale,ERC20, Ownable, TimedCrowdsale, PostDeliveryCrowdsale, TokenTimelock, CappedCrowdsale, RefundableCrowdsale, IndividuallyCappedCrowdsale{
    
    mapping(address => uint256) public contributions;
    enum CrowdsaleStage { one, two, three, four, five }
    CrowdsaleStage public stage = CrowdsaleStage.one;



    uint public eachRounds;
    mapping(address => uint256) private _contributions;
    mapping(address => uint256) private _caps;


    constructor(uint256 rate, address payable wallet, IERC20 tokenAddress, uint256 startTime, uint256 closingTime, uint256 hardcap,uint256 softcap, address teamAddress, uint256 releaseTimeTeam)  
    Crowdsale( rate,  wallet,  tokenAddress)
    TimedCrowdsale(startTime, closingTime)
    PostDeliveryCrowdsale()
    TokenTimelock(tokenAddress, teamAddress, releaseTimeTeam)
    CappedCrowdsale(hardcap)
    RefundableCrowdsale(softcap)
    public payable{
        
    }
    
      function setCrowdsaleStage(uint _stage,uint currentRoundCap, address currentRoundAddress) public payable onlyOwner {
        if(uint(CrowdsaleStage.one) == _stage) {
          stage = CrowdsaleStage.one;
        } else if (uint(CrowdsaleStage.two) == _stage) {
          stage = CrowdsaleStage.two;
        }else if (uint(CrowdsaleStage.three) == _stage) {
          stage = CrowdsaleStage.three;
        }else if (uint(CrowdsaleStage.four) == _stage) {
          stage = CrowdsaleStage.three;
        }else if (uint(CrowdsaleStage.five) == _stage) {
          stage = CrowdsaleStage.three;
        }
        
        if(stage == CrowdsaleStage.one) {
            setCap(currentRoundAddress,currentRoundCap);
        } else if (stage == CrowdsaleStage.two) {
            uint thisRoundCap = getContribution(currentRoundAddress) + currentRoundCap;
           setCap(currentRoundAddress,thisRoundCap);
        }else if (stage == CrowdsaleStage.three) {
           uint thisRoundCap = getContribution(currentRoundAddress) + currentRoundCap;
           setCap(currentRoundAddress,thisRoundCap);
        }else if (stage == CrowdsaleStage.four) {
           uint thisRoundCap = getContribution(currentRoundAddress) + currentRoundCap;
           setCap(currentRoundAddress,thisRoundCap);
        }else if (stage == CrowdsaleStage.five) {
           uint thisRoundCap = getContribution(currentRoundAddress) + currentRoundCap;
           setCap(currentRoundAddress,thisRoundCap);
        }
      }
      
  function getUserContribution(address _beneficiary)
    public view returns (uint256)
  {
    return contributions[_beneficiary];
  }

    function setCap(address beneficiary, uint256 cap) public onlyCapper {
        _caps[beneficiary] = cap;
    }
    
}

contract MyToken is ERC20, ERC20Detailed, ERC20Burnable,Ownable {
    constructor(uint256 initialSupply,uint256 teamSupply,uint256 albSupply,address teamAddress,address albAddress) ERC20Detailed("My Token", "MTK", 18) public {
        _mint(msg.sender, initialSupply);
        emit Transfer(msg.sender,teamAddress,teamSupply);
        emit Transfer(msg.sender,albAddress,albSupply);
    }
}      