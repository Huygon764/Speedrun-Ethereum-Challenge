pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint256 amountOfToken = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfToken);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        uint256 amountOfEth = address(this).balance;
        payable(msg.sender).transfer(amountOfEth);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        // check allowance
        require(yourToken.allowance(msg.sender, address(this)) >= _amount, "Not enough token to sell");

        // transfer token to vendor
        yourToken.transferFrom(msg.sender, address(this), _amount);

        // convert amount and transfer eth to sender
        uint256 amountEth = _amount / tokensPerEth;
        payable(msg.sender).transfer(amountEth);
    }
}
