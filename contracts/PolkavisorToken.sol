// SPDX-License-Identifier: agpl-3.0

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PolkavisorToken is ERC20, Ownable {
   
    /**
     * @dev - The max supply.
     */
    uint256 internal constant INITIAL_SUPPLY = 70_000_000e18;
    uint256 internal constant LOCKED_SUPPLY = 10_000_000e18;
    uint256 public constant TOTAL_MAX_SUPPLY = 80_000_000e18;
    
    uint256 public teamNextUnlockTime;

    constructor() ERC20("Polkavisor", "PVS") {
        
        _mint(msg.sender, INITIAL_SUPPLY);
        _mint(address(this), LOCKED_SUPPLY);
        teamNextUnlockTime = block.timestamp;
    }

    /**
     * @dev - Mint token
     */
    function mint(address _to, uint256 _amount) public onlyOwner {
        
        require(ERC20.totalSupply() + _amount <= TOTAL_MAX_SUPPLY, "Max token supply exceeded");
        _mint(_to, _amount);
    }

    /**
     * @dev - Team tokens - lock and release
     */
    function transferTeamTokens() public onlyOwner {

        require(block.timestamp >= teamNextUnlockTime, "Still in time-lock");
       
        teamNextUnlockTime += 30 days;

        // transfer to owner address
        ERC20 ercToken = ERC20(address(this));
        ercToken.transfer(msg.sender, 30_000e18);
    }

    function getTeamTokensNextUnlockDate() public view returns (uint256) {

        return teamNextUnlockTime;
    }
}