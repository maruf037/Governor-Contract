// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./governance/Governor.sol";
import "./governance/compatibility/GovernorCompatibilityBravo.sol";
import "./governance/extensions/GovernorVotes.sol";
import "./governance/extensions/GovernorVotesQuorumFraction.sol";
import "./governance/extensions/GovernorTimelockControl.sol";

contract MyGovernor is Governor, GovernorCompatibilityBravo, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
    
    constructor(IVotes _token, TimelockController _timelock)
        Governor('MyGovernor')
        GovernorVoters(_token)
        GovernorVotesQoutaFraction(4)
        GovernorTimelockControl(_timelock)
    {}

    function votingDelay() public pure override returns (uint256) {
        return 6575; // 1 day
    }

    function votingPeriod() public pure override returns (uint256) {
        return 46027; // 1 week
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }

    // The function below are overrides required by Solidity.
    
    function quorum(uint256 blocknumber) public view override(IGovernor, GovernorVotesQuorumFraction) returns (uint256) {
        return super.quorum(blocknumber);
    }

    function getVotes(address account, uint256 blockNumber) public view override(IGovernor, GovernorVotes) returns (uint256) {
        return super.getVotes(account, blockNumber);
    }

    function state(uint256 proposalId) public view override(Governer, IGovernor, GovernorTimelockControl) returns (ProposalState) {
        return super.state(proposalId);
    }

    functon propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description) 
        pure 
        override(Governor, GovernorCompatibilityBravo, IGoverner)
        returns(uint256) {
            return super.propose(targets, values, calldatas, description);
    }

    function _execute(uint256 proposalId, address[] memory targets, uint256[]) values, bytes[] memory calldatas, bytes32 descriptionHash) 
        internal
        override(Governor, GovernorTimelockControl) {
            super._execute(proposalId, targets, values, calldatas, descriptionHash);
        }

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256) {
            return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor, GovernorTimelockControl) returns (address) {
        return super._executor();
    }

    function supportInterface(bytes4 interfaceId) public view returns (bool) {
        return super.supportInterface(interfaceId);
    }
    
}