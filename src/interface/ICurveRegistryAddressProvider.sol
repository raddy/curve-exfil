pragma solidity ^0.8.10;

interface ICurveRegistryAddressProvider {
    event AddressModified(
        uint256 indexed id,
        address new_address,
        uint256 version
    );
    event CommitNewAdmin(uint256 indexed deadline, address indexed admin);
    event NewAddressIdentifier(
        uint256 indexed id,
        address addr,
        string description
    );
    event NewAdmin(address indexed admin);

    function add_new_id(
        address _address,
        string memory _description
    ) external returns (uint256);

    function admin() external view returns (address);

    function apply_transfer_ownership() external returns (bool);

    function commit_transfer_ownership(
        address _new_admin
    ) external returns (bool);

    function future_admin() external view returns (address);

    function get_address(uint256 _id) external view returns (address);

    function get_id_info(
        uint256 arg0
    )
        external
        view
        returns (
            address addr,
            bool is_active,
            uint256 version,
            uint256 last_modified,
            string memory description
        );

    function get_registry() external view returns (address);

    function max_id() external view returns (uint256);

    function revert_transfer_ownership() external returns (bool);

    function set_address(uint256 _id, address _address) external returns (bool);

    function transfer_ownership_deadline() external view returns (uint256);

    function unset_address(uint256 _id) external returns (bool);
}
