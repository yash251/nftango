module overmind::nftango {
    use std::option::Option;
    use std::string::String;

    use aptos_framework::account;

    use aptos_token::token::TokenId;

    //
    // Errors
    //
    const ERROR_NFTANGO_STORE_EXISTS: u64 = 0;
    const ERROR_NFTANGO_STORE_DOES_NOT_EXIST: u64 = 1;
    const ERROR_NFTANGO_STORE_IS_ACTIVE: u64 = 2;
    const ERROR_NFTANGO_STORE_IS_NOT_ACTIVE: u64 = 3;
    const ERROR_NFTANGO_STORE_HAS_AN_OPPONENT: u64 = 4;
    const ERROR_NFTANGO_STORE_DOES_NOT_HAVE_AN_OPPONENT: u64 = 5;
    const ERROR_NFTANGO_STORE_JOIN_AMOUNT_REQUIREMENT_NOT_MET: u64 = 6;
    const ERROR_NFTS_ARE_NOT_IN_THE_SAME_COLLECTION: u64 = 7;
    const ERROR_NFTANGO_STORE_DOES_NOT_HAVE_DID_CREATOR_WIN: u64 = 8;
    const ERROR_NFTANGO_STORE_HAS_CLAIMED: u64 = 9;
    const ERROR_NFTANGO_STORE_IS_NOT_PLAYER: u64 = 10;
    const ERROR_VECTOR_LENGTHS_NOT_EQUAL: u64 = 11;

    //
    // Data structures
    //
    struct NFTangoStore has key { // Type abilities - The key ability allows the type to serve as a key for global storage operations.
        creator_token_id: TokenId,
        // The number of NFTs (one more more) from the same collection that the opponent needs to bet to enter the game
        join_amount_requirement: u64,
        opponent_address: Option<address>,
        opponent_token_ids: vector<TokenId>,
        active: bool,
        has_claimed: bool,
        did_creator_win: Option<bool>,
        signer_capability: account::SignerCapability
    }

    //
    // Assert functions
    //
    public fun assert_nftango_store_exists(
        account_address: address,
    ) {
        // TODO: assert that `NFTangoStore` exists
        // assert is a builtin, macro-like operation provided by the Move compiler. It takes two arguments, a condition of type bool and a code of type u64
        // assert!(condition: bool, code: u64)
        // The primary purpose of address values are to interact with the global storage operations. address values are used with the exists, borrow_global, borrow_global_mut, and move_from operations.
        assert!(NFTangoStore::exists(account_address), ERROR_NFTANGO_STORE_EXISTS);
    }

    public fun assert_nftango_store_does_not_exist(
        account_address: address,
    ) {
        // TODO: assert that `NFTangoStore` does not exist
        assert!(!NFTangoStore::exists(account_address), ERROR_NFTANGO_STORE_DOES_NOT_EXIST);
    }

    public fun assert_nftango_store_is_active(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.active` is active
        let store = NFTangoStore::get(account_address);
        assert!(store.active, ERROR_NFTANGO_STORE_IS_ACTIVE);
    }

    public fun assert_nftango_store_is_not_active(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.active` is not active
        let store = NFTangoStore::get(account_address);
        assert!(!store.active, ERROR_NFTANGO_STORE_IS_NOT_ACTIVE);
    }

    public fun assert_nftango_store_has_an_opponent(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.opponent_address` is set
        // Return true if opt_elem contains a value.
        // public fun is_some<Element>(opt_elem: &Option<Element>): bool;
        let store = NFTangoStore::get(account_address);
        assert!(option::is_some(&store.opponent_address), ERROR_NFTANGO_STORE_HAS_AN_OPPONENT);
        // earlier error - assert!(store.opponent_address.is_some(), ERROR_NFTANGO_STORE_HAS_AN_OPPONENT);
    }

    public fun assert_nftango_store_does_not_have_an_opponent(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.opponent_address` is not set
        // Return true if opt_elem does not contain a value.
        // public fun is_none<Element>(opt_elem: &Option<Element>): bool;
        let store = NFTangoStore::get(account_address);
        assert!(option::is_none(&store.opponent_address), ERROR_NFTANGO_STORE_DOES_NOT_HAVE_AN_OPPONENT);
    }

    public fun assert_nftango_store_join_amount_requirement_is_met(
        game_address: address,
        token_ids: vector<TokenId>,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.join_amount_requirement` is met
        let store = NFTangoStore::get(game_address);
        assert!(Vector::length(&token_ids) == store.join_amount_requirement, ERROR_NFTANGO_STORE_JOIN_AMOUNT_REQUIREMENT_NOT_MET);
    }

    public fun assert_nftango_store_has_did_creator_win(
        game_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.did_creator_win` is set
        let store = NFTangoStore::get(game_address);
        assert!(option::is_some(&store.did_creator_win), ERROR_NFTANGO_STORE_DOES_NOT_HAVE_DID_CREATOR_WIN);
    }

    public fun assert_nftango_store_has_not_claimed(
        game_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.has_claimed` is false
        let store = NFTangoStore::borrow(game_address);
        assert(!store.has_claimed, ERROR_NFTANGO_STORE_HAS_CLAIMED);
    }

    public fun assert_nftango_store_is_player(account_address: address, game_address: address) acquires NFTangoStore {
        // TODO: assert that `account_address` is either the equal to `game_address` or `NFTangoStore.opponent_address`
        let store = NFTangoStore::borrow(game_address);
        assert(account_address == game_address || account_address == store.opponent_address, ERROR_NFTANGO_STORE_IS_NOT_PLAYER);
    }

    public fun assert_vector_lengths_are_equal(creator: vector<address>,
                                               collection_name: vector<String>,
                                               token_name: vector<String>,
                                               property_version: vector<u64>) {
        // TODO: assert all vector lengths are equal
        assert(Vector::length(&creator) == Vector::length(&collection_name), ERROR_VECTOR_LENGTHS_ARE_NOT_EQUAL);
        assert(Vector::length(&creator) == Vector::length(&token_name), ERROR_VECTOR_LENGTHS_ARE_NOT_EQUAL);
        assert(Vector::length(&creator) == Vector::length(&property_version), ERROR_VECTOR_LENGTHS_ARE_NOT_EQUAL);
    }

    //
    // Entry functions
    //
    public entry fun initialize_game(
        account: &signer,
        creator: address,
        collection_name: String,
        token_name: String,
        property_version: u64,
        join_amount_requirement: u64
    ) {
        // TODO: run assert_nftango_store_does_not_exist
        assert_nftango_store_does_not_exist(account);

        // TODO: create resource account
        let resource_addr = account::create_address(account.address(), b"yash".to_vec());
        account::create_account(resource_addr);

        // TODO: token::create_token_id_raw
        let token_id = aptos_token::token::create_token_id_raw(creator, collection_name, token_name, property_version);

        // TODO: opt in to direct transfer for resource account
        aptos_token::token::opt_in_to_direct_transfer(&resource_addr);

        // TODO: transfer NFT to resource account
        aptos_token::token::transfer(&creator, &resource_address, token_id);

        // TODO: move_to resource `NFTangoStore` to account signer
        let nftango_store = NFTangoStore {
            creator_token_id: token_id,
            join_amount_requirement: join_amount_requirement,
            opponent_address: None,
            opponent_token_ids: vec![],
            active: true,
            has_claimed: false,
            did_creator_win: None,
            signer_capability: account::SignerCapability::Mutable,
        };
        move_to(nftango_store, account);
    }

    public entry fun cancel_game(
        account: &signer,
    ) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(account);
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(account);
        // TODO: run assert_nftango_store_does_not_have_an_opponent
        assert_nftango_store_does_not_have_an_opponent(account);

        // TODO: opt in to direct transfer for account
        aptos_token::token::opt_in_to_direct_transfer(&account);

        // TODO: transfer NFT to account address
        let nftango_store = NFTangoStore::get(account.address());
        let creator_token = Token::get_token(nftango_store.creator_token_id);
        creator_token.transfer_from(account.address(), account.sender(), nftango_store.creator_token_id);

        // TODO: set `NFTangoStore.active` to false
        let &mut nftango_store = nftango_store;
        nftango_store.active = false;
        NFTangoStore::save(account.address(), nftango_store);
    }

    public fun join_game(
        account: &signer,
        game_address: address,
        creators: vector<address>,
        collection_names: vector<String>,
        token_names: vector<String>,
        property_versions: vector<u64>,
    ) acquires NFTangoStore {
        // TODO: run assert_vector_lengths_are_equal
        assert_vector_lengths_are_equal(creators, collection_names, token_names, property_versions);

        // TODO: loop through and create token_ids vector<TokenId>
        let &mut token_ids = vec![];
        let i = 0;
        loop {
            let token_id = aptos_token::token::create_token_id_raw(collection_names[i], token_names[i], property_versions[i]);
            token_ids.push(token_id);
            i = i + 1;
        }

        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(account);
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(account);
        // TODO: run assert_nftango_store_does_not_have_an_opponent
        assert_nftango_store_does_not_have_an_opponent(account);
        // TODO: run assert_nftango_store_join_amount_requirement_is_met
        assert_nftango_store_join_amount_requirement_is_met(account, token_ids);

        // TODO: loop through token_ids and transfer each NFT to the resource account
        let i = 0;
        loop {
            let token_id = token_ids[i];
            let creator = creators[i];
            let resource_addr = account::create_address(account.address(), b"yash".to_vec());
            aptos_token::token::transfer(&creator, &resource_addr, token_id);
            i = i + 1;
        }

        // TODO: set `NFTangoStore.opponent_address` to account_address
        let &mut nftango_store = nftango_store;
        nftango_store.opponent_address = account.address();
        NFTangoStore::save(account.address(), nftango_store);

        // TODO: set `NFTangoStore.opponent_token_ids` to token_ids
        let &mut nftango_store = nftango_store;
        nftango_store.opponent_token_ids = token_ids;
        NFTangoStore::save(account.address(), nftango_store);
    }

    public entry fun play_game(account: &signer, did_creator_win: bool) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(account);
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(account);
        // TODO: run assert_nftango_store_has_an_opponent
        assert_nftango_store_has_an_opponent(account);
        // TODO: set `NFTangoStore.did_creator_win` to did_creator_win
        let &mut nftango_store = nftango_store;
        nftango_store.did_creator_win = did_creator_win;
        NFTangoStore::save(account.address(), nftango_store);

        // TODO: set `NFTangoStore.active` to false
        let &mut nftango_store = nftango_store;
        nftango_store.active = false;
        NFTangoStore::save(account.address(), nftango_store);
    }

    public entry fun claim(account: &signer, game_address: address) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(account);
        // TODO: run assert_nftango_store_is_not_active
        assert_nftango_store_is_not_active(account);
        // TODO: run assert_nftango_store_has_not_claimed
        assert_nftango_store_has_not_claimed(account);
        // TODO: run assert_nftango_store_is_player
        assert_nftango_store_is_player(account, game_address);

        // TODO: if the player won, send them all the NFTs
        let nftango_store = NFTangoStore::get(account.address());
        if (nftango_store.did_creator_win) {
            let i = 0;
            loop {
                let token_id = nftango_store.opponent_token_ids[i];
                let creator = nftango_store.opponent_address;
                let resource_addr = account::create_address(account.address(), b"yash".to_vec());
                aptos_token::token::transfer(&resource_addr, &creator, token_id);
                i = i + 1;
            }
        }

        // TODO: set `NFTangoStore.has_claimed` to true
        let &mut nftango_store = nftango_store;
        nftango_store.has_claimed = true;
        NFTangoStore::save(account.address(), nftango_store);

    }
}