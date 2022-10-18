// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../utils/DaddyTokens.sol";

contract BettingV1 {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private matchIds;


    address private owner;
    address private multiSigT;

    ERC20 private daddyToken;

    
    uint256 platformFee = 1;

    enum MatchResult {
        NOT_SET,
        DRAW,
        TEAM_A_WON,
        TEAM_B_WON
    }

    enum MatchState {
        NOT_STARTED,
        STARTED,
        COMPLETED
    }

    enum TeamBetOn {
        NOT_SET,
        Team_A,
        Team_B
    }

    struct Match {
        uint8 oddsTeamA;
        uint8 oddsTeamB;
        uint8 oddsDraw;
        string matchLink;
        TeamBetOn wager;
        uint256 totalPayoutA;
        uint256 totalPayoutB;
        uint256 totalPayoutDraw;
        uint256 totalCollected;
        MatchResult result;
        MatchState state;
        uint256 startTime;
        bool exists;
    }

    // Mapping of the token IDs to Match
    mapping(uint256 => Match) matches;

    mapping(uint256 => uint256) idMatches;

    event MatchCreated(address indexed creator, uint256 matchID, string matchLink, uint8 oddsA, uint8 oddsB, uint8 oddsDraw, uint256 startAt);
    
    constructor(address _multiSigT, address _daddyToken) {
        owner = msg.sender;
        multiSigT = _multiSigT;
        daddyToken = ERC20(_daddyToken);
        
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier matchExists(uint256 _matchID) {
        require(matches[_matchID].exists == true, "Match does not exist");
        _;
    }

    modifier matchNotStarted(uint256 _matchID) {
        require(matches[_matchID].state == MatchState.NOT_STARTED, "Match Started");
        _;
    }
    
    modifier matchAlreadyDecided(uint256 _matchID) {
        require(matches[_matchID].result != MatchResult.NOT_SET, "Results already decided");
        _;
    }

    modifier matchOver(uint256 _matchID) {
        require(matches[_matchID].state == MatchState.COMPLETED, "Match still on going");
        _;
    }

    function createMatch(
        uint _matchID, 
        string memory _matchLink, 
        uint8 _oddsA, 
        uint8 _oddsB,
        uint8 _oddsDraw,
        uint256 _startAt
        ) 
        onlyOwner
        external
    {
        matchIds.increment();
        uint256 matchId = matchIds.current();
        matches[matchId] = Match(_oddsA, _oddsB, _oddsDraw, _matchLink, TeamBetOn.NOT_SET, 0, 0, 0, 0, MatchResult.NOT_SET, MatchState.NOT_STARTED, _startAt, true);
        idMatches[_matchID] = matchId;
        emit MatchCreated(msg.sender, _matchID, _matchLink, _oddsA, _oddsB, _oddsDraw, _startAt);
    }

    //Include logic for setting match state to started

    function placeBet(
        uint256 _matchID,
        uint256 _amount,
        TeamBetOn _resultBetOn
    )
    external
    matchExists(_matchID)
    matchNotStarted(_matchID)
    {
        require(_amount > 0, "Bet amount must be greater than zero");
       
        address bettor = msg.sender;
        uint256 assetValue;
        // uint256 fees = _amount.mul(0.01);
        // uint256 amount = _amount - fees;


        daddyToken.transfer(address(this), _amount);
        // daddyToken.transfer(multiSigT, fees);
        // TeamBetOn proposedBet = TeamBetOn(_resultBetOn);
        matches[_matchID].wager = _resultBetOn;
    }

    // Sets the results
    function results(uint256 _matchID, MatchResult _results)
        external
        matchAlreadyDecided(_matchID)
        matchOver(_matchID)
    {
        uint256 assetValue = 0;
        matches[_matchID].result = _results;
        
        if (matches[_matchID].wager == TeamBetOn.Team_A && matches[_matchID].result == MatchResult.TEAM_A_WON) {
            assetValue = 1;
        } else if (matches[_matchID].wager == TeamBetOn.Team_B && matches[_matchID].result == MatchResult.TEAM_B_WON) {
            assetValue = 2;
        } else {
            assetValue = 3;
        }
    }

    // Start the match. To intergrate an oracle later on.
    function startMatch(uint256 _matchID) 
        external
        onlyOwner 
    {
        matches[_matchID].state = MatchState.STARTED;
    }
}