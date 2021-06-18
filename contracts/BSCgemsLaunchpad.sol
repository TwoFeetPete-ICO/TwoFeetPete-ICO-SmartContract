// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "openzeppelin-solidity/contracts/utils/Address.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract BSCgemsLaunchpad is Ownable {
    using SafeMath for uint256;
    using Address for address;
    
    IERC20Metadata public _tokenContract;
    
    uint256 public _persaleTokenPercent;
    uint256 public _liquidityTokenPercent;
    
    uint256 public _softCap;
    uint256 public _hardCap;
    
    uint256 public _minContribution;
    uint256 public _maxContribution;
    
    uint256 public _durationDays;
    uint256 public _startPresaleTime;
    uint256 public _endPresaleTime;
    
    uint256 public _feePresaleManagerPercent;
    address public _feePresaleManagerAddress;
    
    uint256 public _feeTokenOwnerPercent;
    address public _feeTokenOwnerAddress;

    mapping (address=>uint256) public _mapDeposite;
    address[] public _listInvestors;
    uint256 public _totalDeposite;
    
    IPancakeRouter02 public pancakeRouter;
    address public pancakePair;

    address public _pancakeRouterAddress = 0xBeD1633949Be8997B17cBFd3D418dB5EaA8FA55A;

    
    bool public _isSettedPresaleToken = false;
    bool public _isSettedSoftHardCap = false;
    bool public _isSettedMinManContribution = false;
    bool public _isSettedFeeAddressPercent = false;

    bool public _isSettingConfirmed = false;
    bool public _isLiquidityCreatedAndShareDesposite = false;


    //////////////////////////////////////////////////////// Configure Presale Settings ///////////////////////////////////////////////////////////////////

    function setPresaleToken(address tokenAddress, address pancakeRouterAddress, uint256 presalePercent, uint256 liquidityPercent) external onlyOwner{
        require(!_isSettingConfirmed, "Presale Config is already defined!");
        require(presalePercent != 0, "Presale Percent should be over than 0");
        require(liquidityPercent != 0, "Liquidity Percent should be over than 0");
        require(presalePercent + liquidityPercent <= 100, "Both Percent can't be over than 100%");

        _tokenContract = IERC20Metadata(tokenAddress);
        _pancakeRouterAddress = pancakeRouterAddress;
        _persaleTokenPercent = presalePercent;
        _liquidityTokenPercent = liquidityPercent;

        _isSettedPresaleToken = true;
    }

    function setSoftHardCap(uint256 softCap, uint256 hardCap) external onlyOwner{
        require(!_isSettingConfirmed, "Presale Config is already defined!");

        _softCap = softCap;
        _hardCap = hardCap;

        _isSettedSoftHardCap = true;
    }

    function setMinMaxContribution(uint256 minContribution, uint256 maxContribution) external onlyOwner{
        require(!_isSettingConfirmed, "Presale Config is already defined!");

        _minContribution = minContribution;
        _maxContribution = maxContribution;

        _isSettedMinManContribution = true;
    }

    function setFeeAddressAndPercent(address feePresaleManagerAddress, uint32 feePresaleManagerPercent, address feeTokenOwnerAddress, uint32 feeTokenOwnerPercent) external onlyOwner{
        require(!_isSettingConfirmed, "Presale Config is already defined!");

        _feePresaleManagerAddress = feePresaleManagerAddress;
        _feePresaleManagerPercent = feePresaleManagerPercent;
        _feeTokenOwnerAddress = feeTokenOwnerAddress;
        _feeTokenOwnerPercent = feeTokenOwnerPercent;

        _isSettedFeeAddressPercent = true;
    }

    function confirmStartPresale(uint256 startTime, uint256 endTime) external onlyOwner{
        require(!_isSettingConfirmed, "Presale Config is already defined!");
        require(_isSettedPresaleToken, "Presale Token Setting is not defined!");
        require(_isSettedSoftHardCap, "SoftCap, HardCap Setting is not defined!");
        require(_isSettedMinManContribution, "Contribution Setting is not defined!");
        require(_isSettedFeeAddressPercent, "Fee Address and Percent is not defined!");

        uint256 presaleAmount = tokensForPresale();
        uint256 liquidityAmount = tokensForLiquidity();

        require(_tokenContract.balanceOf(address(this)) >= (presaleAmount + liquidityAmount), "There is not enough tokens for presale and liquidity");

        _startPresaleTime = startTime;
        _endPresaleTime = endTime;

        IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_pancakeRouterAddress);
        pancakePair = IPancakeFactory(_pancakeRouter.factory()).createPair(address(_tokenContract), _pancakeRouter.WETH());
        pancakeRouter = _pancakeRouter;

        _isSettingConfirmed = true;
    }

    //////////////////////////////////////////////////////// Get Presale Settings ///////////////////////////////////////////////////////////////////

    function tokenName() public view returns(string memory){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.name();
    }

    function tokenSymbol() public view returns(string memory){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.symbol();
    }
    function tokenDecimals() public view returns(uint8){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.decimals();
    }

    function tokenTotalSupply() public view returns(uint256){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.totalSupply();
    }

    function tokensForPresale() public view returns(uint256){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.totalSupply().mul(_persaleTokenPercent).div(10**2);
    }

    function tokensForLiquidity() public view returns(uint256){
        require(_isSettedPresaleToken, "Presale Config is not setted yet!");
        return _tokenContract.totalSupply().mul(_liquidityTokenPercent).div(10**2);
    }

    function presaleRate() public view returns(uint256){
        require(_isSettedPresaleToken && _isSettedSoftHardCap, "Presale Config is not setted yet!");
        return tokensForPresale().div(_hardCap).mul(10**18);
    }
    
    function pancakeswapListingRate() public view returns(uint256){
        require(_isSettedPresaleToken && _isSettedSoftHardCap, "Presale Config is not setted yet!");
        uint256 bnbForLiquidityPercent = pancakeswapLiquidityPercent();
        uint256 bnbForLiquidity = _hardCap.mul(bnbForLiquidityPercent).div(10**2);
        return tokensForLiquidity().div(bnbForLiquidity).mul(10**18);
    }

    function pancakeswapLiquidityPercent() public view returns(uint256){
        require(_isSettedFeeAddressPercent, "Presale Config is not setted yet!");
        uint256 hundredPercent = 10**2;
        uint256 bnbForLiquidityPercent = hundredPercent.sub(_feePresaleManagerPercent).sub(_feeTokenOwnerPercent);
        return bnbForLiquidityPercent;
    }

    //////////////////////////////////////////////////////// Presale Main Logic ///////////////////////////////////////////////////////////////////

    ///// 0: NOT STARTED, 1: PENDING, 2: FAILED, 3: POSSIBLE 4: SETTING CONFIRMED BUT DIDN't STARTED YET/////
    function statusOfPresale() public view returns(uint256){
        if (!_isSettingConfirmed){
            return 0;
        }
        else if (block.timestamp < _startPresaleTime){
            return 4;
        }
        else if (block.timestamp < _endPresaleTime){
            if (_totalDeposite >= _hardCap)
                return 3;
            return 1; 
        }
        else if (_totalDeposite < _softCap){
            return 2; 
        }
        return 3;
    }

    modifier _validateDeposite() {
        require(statusOfPresale() == 1, "Presale Status should be Pending!");
        require(_mapDeposite[_msgSender()].add(msg.value) >= _minContribution && _mapDeposite[_msgSender()].add(msg.value) <= _maxContribution, "Deposite Amount should be in range of Contribution");
        _;
    }

    modifier _validateClaimTokenAndSale() {
        require(statusOfPresale() == 3, "Presale should be finished!");
        require(_mapDeposite[_msgSender()] > 0, "Didn't deposite any thing!");
        require(_isLiquidityCreatedAndShareDesposite == true, "Liquidity is not added yet.!");
        _;
    }

    modifier _validateClaimRemainedToken() {
        require(statusOfPresale() == 3, "Presale should be finished!");
        require(_isLiquidityCreatedAndShareDesposite == true, "Liquidity is not added yet.!");
        bool bClaimedAll = true;
        for (uint i = 0; i < _listInvestors.length; i++){
            if (_mapDeposite[_listInvestors[i]] > 0){
                bClaimedAll = false;
                break;
            }
        }
        require(bClaimedAll == true, "Some Investors didn't claimed Token, please wait");
        _;
    }

    modifier _validateAddLiquidityAndShareDesposite() {
        require(statusOfPresale() == 3, "Presale should be finished!");
        require(_isLiquidityCreatedAndShareDesposite == false, "You already added liquidity and share all Desposite amount!");
        _;
    }

    modifier _validateClaimBNB(){
        require(statusOfPresale() == 2, "Presale is not failed!");
        require(_mapDeposite[_msgSender()] > 0, "Didn't deposite any thing!");
        _;
    }

    function depositeBNB() external payable _validateDeposite(){
        _mapDeposite[_msgSender()] = _mapDeposite[_msgSender()].add(msg.value);
        _totalDeposite = _totalDeposite.add(msg.value);
        _listInvestors.push(_msgSender());
    }

    function claimToken() external _validateClaimTokenAndSale(){
        uint256 tokenAmount = tokensForPresale().mul(_mapDeposite[_msgSender()]).div(_totalDeposite);
        _tokenContract.transfer(_msgSender(), tokenAmount);
        _mapDeposite[_msgSender()] = 0;
    }

    function claimRemainedTokenToOwner() external _validateClaimRemainedToken(){
        _tokenContract.transfer(_feeTokenOwnerAddress, _tokenContract.balanceOf(address(this)));
    }

    function claimBNB() external _validateClaimBNB(){
        payable(_msgSender()).transfer(_mapDeposite[_msgSender()]);
        _totalDeposite = _totalDeposite.sub(_mapDeposite[_msgSender()]);
        _mapDeposite[_msgSender()] = 0;
    }

    function addLiquidityAndShareDesposite() external _validateAddLiquidityAndShareDesposite() onlyOwner{
        uint256 feePresaleManager = _totalDeposite.mul(_feePresaleManagerPercent).div(10**2);
        uint256 feeTokenOwner = _totalDeposite.mul(_feeTokenOwnerPercent).div(10**2);
        uint256 liquidityTokenAmount = tokensForLiquidity();
        uint256 liquidityBNBAmount = _totalDeposite.sub(feePresaleManager).sub(feeTokenOwner);

        if (feePresaleManager > 0) payable(_feePresaleManagerAddress).transfer(feePresaleManager);        
        if (feeTokenOwner > 0) payable(_feeTokenOwnerAddress).transfer(feeTokenOwner);      

        _tokenContract.approve(address(pancakeRouter), liquidityTokenAmount);

        pancakeRouter.addLiquidityETH{value: liquidityBNBAmount}(
            address(_tokenContract),
            liquidityTokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(0),
            block.timestamp
        );

        _isLiquidityCreatedAndShareDesposite = true;
    }
}
