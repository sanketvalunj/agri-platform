// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarbonCredit {
    address public admin;

    struct Credit {
        uint256 amount;
        string source;
        uint256 timestamp;
    }

    mapping(address => Credit[]) public credits;

    event CreditIssued(address indexed farmer, uint256 amount, string source);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueCredit(
        address farmer,
        uint256 amount,
        string memory source
    ) public onlyAdmin {
        credits[farmer].push(
            Credit(amount, source, block.timestamp)
        );

        emit CreditIssued(farmer, amount, source);
    }

    function getCredits(address farmer)
        public
        view
        returns (Credit[] memory)
    {
        return credits[farmer];
    }
}
