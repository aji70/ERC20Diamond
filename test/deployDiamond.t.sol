// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/facets/StakingFaucet.sol";
import "../contracts/facets/RewardFaucet.sol";

import "../contracts/facets/LayoutChangerFacet.sol";
import "../contracts/facets/AjidokwuFaucet.sol";
import "forge-std/Test.sol";
import "../contracts/Diamond.sol";

import "../contracts/libraries/LibAppStorage.sol";
import "../contracts/libraries/LibERC20.sol";
import "../contracts/libraries/LibStaking.sol";
import "../contracts/libraries/LibReward.sol";

contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    LayoutChangerFacet lFacet;
    AjidokwuFaucet aji;
    StakingFaucet stake;
    RewardFaucet reward;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        lFacet = new LayoutChangerFacet();
        aji = new AjidokwuFaucet();
        stake = new StakingFaucet();
        reward = new RewardFaucet();
        // owner = mkaddr("owner");
        // owner = address(this);
        // owner1 = mkaddr("owner1");

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](5);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );
        cut[2] = (
            FacetCut({
                facetAddress: address(lFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("LayoutChangerFacet")
            })
        );

        cut[3] = (
            FacetCut({
                facetAddress: address(aji),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("AjidokwuFaucet")
            })
        );
        cut[4] = (
            FacetCut({
                facetAddress: address(stake),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("StakingFaucet")
            })
        );
        // cut[5] = (
        //     FacetCut({
        //         facetAddress: address(reward),
        //         action: FacetCutAction.Add,
        //         functionSelectors: generateSelectors("RewardFaucet")
        //     })
        // );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        //call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();
    }

    function testLayoutfacet2() public {
        LayoutChangerFacet l = LayoutChangerFacet(address(diamond));
        l.getLayout();
        l.ChangeNameAndNo(67, "dis guy");
        // check outputs
        LibAppStorage.Layout memory la = l.getLayout();
        assertEq(la.name, "dis guy");
        assertEq(la.currentNo, 67);
    }

    function testLayoutfacet3()
        public
        returns (string memory, string memory, uint256)
    {
        AjidokwuFaucet l = AjidokwuFaucet(address(diamond));
        l.init();

        // check outputs
        string memory la = l.name11();
        assertEq(la, "Ajidokwu");
    }

    //    function testLayoutfacet4() public  returns(address)  {
    //     AjidokwuFaucet le = AjidokwuFaucet(address(diamond));
    //     RewardFaucet lei = RewardFaucet(address(diamond));
    //     StakingFaucet l = StakingFaucet(address(diamond));
    //     l.init(address(le), address(lei));
    //     le.init();
    //     lei.init();
    //     // LibERC20.Layout memory la = le.name1();
    //     le.balanceOf(address(this));
    //     le.balanceOf(msg.sender);
    //     // le.balanceOf(address(this));
    //     le.mint(msg.sender, 10000);
    //     le.mint(msg.sender, 1000000000);
    //     // le.mint(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496, 1000000000);
    //     // le.balanceOf(msg.sender);
    //     le.approve(address(l), 10000000000);
    //     le.balanceOf(address(this));
    //     le.balanceOf(msg.sender);
    //     lei.transfer(address(l), 10000000000 );
    //     le.transfer(msg.sender, 1000);
    //     // uint256 oldBal = l.balanceOf(address(this));
    //     //  uint256 na = l.onetwo(100);
    //     // lei.balanceOf(msg.sender);
    //      l.stake(1000, 10);
    //      l.unstake();
    //     // l.Calculatereward(100,10);
    //     //  l.unstake();
    //     //  lei.balanceOf(msg.sender);
    //     // return(la.name, la.symbol, la.totalSupply);
    //     return(msg.sender);
    //     //  string memory na = l.name11();
    //     //  assertEq(na, la.name);
    //     //  assertEq(l.balanceOf(address(this)), la.name);
    //     // return(na);
    //     // assertEq(l.balanceOf(address(this)), (oldBal + 1000));

    // }

    function generateSelectors(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}
