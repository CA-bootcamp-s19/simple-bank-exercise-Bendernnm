pragma solidity ^0.5.0;

contract SimpleBank {
    //
    // State variables
    //
    mapping(address => uint256) private balances;
    mapping(address => bool) public enrolled;
    address public owner;

    //
    // Events - publicize actions to external listeners
    //
    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint256 amount);
    event LogWithdrawal(address accountAddress, uint256 withdrawAmount, uint256 newBalance);

    //
    // Functions
    //
    constructor() public {
        owner = msg.sender;
    }

    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
        balances[msg.sender] = 0;
        enrolled[msg.sender] = true;

        emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint256) {
        require(enrolled[msg.sender], 'Users should be enrolled before they can make deposits');

        balances[msg.sender] = balances[msg.sender] + msg.value;

        emit LogDepositMade(msg.sender, balances[msg.sender]);

        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint256 withdrawAmount) public returns (uint256) {
        require(balances[msg.sender] >= withdrawAmount, 'You had not enough coins');

        balances[msg.sender] = balances[msg.sender] - withdrawAmount;
        msg.sender.transfer(withdrawAmount);

        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);

        return balances[msg.sender];
    }
}
