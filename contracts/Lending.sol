//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/ISwapRouter.sol";
import "hardhat/console.sol";

contract Lending is Ownable,ERC20 ReentrancyGuard {

    address private constant AAVE = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint256 public baseRate = 20000000000000000;
    uint256 public fixedAnnuBorrowRate = 300000000000000000;

    mapping(address => uint256) private usersCollateral;
    mapping(address => uint256) private usersBorrowed;

    event Supply(
        address indexed asset,
        uint256 amount,
        address indexed onBehalfOf,
        uint16 referralCode
    );

    constructor(address _aave) ERC20("Bond DAI", "bDAI") {
        AAVE = _aave;
    }

    function upadateAave(address _aave) external onlyOwner {
        AAVE = _aave;
    }

    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external payable nonReentrant {
        require(asset == dai, "Only dai is supported");
        ILending(AAVE).supply(asset, amount, onBehalfOf, 0);
        _mint(_msgSender(), amount);
        emit Supply(asset, amount, onBehalfOf, referralCode);
    }

    function unbound(address _asset, uint256 _amount) external {
        _burn(_msgSender(), amount);
        ILending(AAVE).withdraw(_asset, _amount, _msgSender());
    }

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external payable {
        ILending(AAVE).borrow(asset, amount, interestRateMode, 0, onBehalfOf);
    }

    function getEthValue(address token, uint256 amount)
        public
        view
        returns (uint256)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            s_tokenToPriceFeed[token]
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // 2000 DAI = 1 ETH
        // 0.002 ETH per DAI
        // price will be something like 20000000000000000
        // So we multiply the price by the amount, and then divide by 1e18
        // 2000 DAI * (0.002 ETH / 1 DAI) = 0.002 ETH
        // (2000 * 10 ** 18) * ((0.002 * 10 ** 18) / 10 ** 18) = 0.002 ETH
        return (uint256(price) * amount) / 1e18;
    }
}
