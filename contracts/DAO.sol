// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "./DonorBadge.sol";

contract DAO is Governor, GovernorTimelockControl {
    ERC20Votes public token;
    DonorBadge public badge;

    struct ProposalVote {
        uint256 againstVotes;
        uint256 forVotes;
        uint256 abstainVotes;
    }

    struct VoterProfile {
        string country;
        string gender;
        string ageGroup;
        string ideology;
        string religion;
    }

    mapping(uint256 => ProposalVote) private _proposalVotes;
    mapping(uint256 => mapping(address => VoterProfile)) public voterMetadata;

    event MetadataSubmitted(
        uint256 indexed proposalId,
        address indexed voter,
        string country,
        string gender,
        string ageGroup,
        string ideology,
        string religion
    );

    constructor(ERC20Votes _token, TimelockController _timelock)
        Governor("UAH DAO")
        GovernorTimelockControl(_timelock)
    {
        token = _token;
        badge = new DonorBadge();
    }

    function submitVoteMetadata(
        uint256 proposalId,
        string memory country,
        string memory gender,
        string memory ageGroup,
        string memory ideology,
        string memory religion
    ) external {
        voterMetadata[proposalId][msg.sender] = VoterProfile(
            country,
            gender,
            ageGroup,
            ideology,
            religion
        );

        badge.mint(msg.sender);

        emit MetadataSubmitted(
            proposalId,
            msg.sender,
            country,
            gender,
            ageGroup,
            ideology,
            religion
        );
    }

    function votingDelay() public pure override returns (uint256) {
        return 1;
    }

    function votingPeriod() public pure override returns (uint256) {
        return 45818;
    }

    function quorum(uint256 /* blockNumber */) public pure override returns (uint256) {
        return 1;
    }

    function getVotes(address account, uint256 blockNumber)
        public
        view
        override(Governor, IGovernor)
        returns (uint256)
    {
        return token.getPastVotes(account, blockNumber);
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    )
        public
        override(Governor, IGovernor)
        returns (uint256)
    {
        return super.propose(targets, values, calldatas, description);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    function clock() public view override returns (uint48) {
        return uint48(block.number);
    }

    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=blocknumber&from=default";
    }

    function COUNTING_MODE() public pure override returns (string memory) {
        return "support=bravo&quorum=for";
    }

    function hasVoted(uint256 /* proposalId */, address /* account */)
        public
        pure
        override
        returns (bool)
    {
        return true;
    }

    function _getVotes(
        address account,
        uint256 timepoint,
        bytes memory /* params */
    )
        internal
        view
        override
        returns (uint256)
    {
        return token.getPastVotes(account, timepoint);
    }

    function _quorumReached(uint256 proposalId)
        internal
        view
        override
        returns (bool)
    {
        ProposalVote memory votes = _proposalVotes[proposalId];
        return quorum(proposalSnapshot(proposalId)) <= votes.forVotes;
    }

    function _voteSucceeded(uint256 proposalId)
        internal
        view
        override
        returns (bool)
    {
        ProposalVote memory votes = _proposalVotes[proposalId];
        return votes.forVotes > votes.againstVotes;
    }

    function _countVote(
        uint256 proposalId,
        address account,
        uint8 support,
        uint256 weight,
        bytes memory /* params */
    )
        internal
        override
    {
        ProposalVote storage votes = _proposalVotes[proposalId];

        if (support == 0) {
            votes.againstVotes += weight;
        } else if (support == 1) {
            votes.forVotes += weight;
        } else if (support == 2) {
            votes.abstainVotes += weight;
        }
    }
}