use starknet::{ContractAddress, contract_address_const};

use snforge_std::{declare, ContractClassTrait};

use stark_safari::safari::safariTraitDispatcherTrait;
use stark_safari::safari::safariTraitDispatcher;
use core::array::ArrayTrait;

fn deploy() -> safariTraitDispatcher {
    let contract = declare('Safari');
    let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();
    safariTraitDispatcher {contract_address}
}

#[test]
fn test_add_bus() {
    let mut contract = deploy();
    let registration_no = 'KCA 452Z';
    let route = 'Kisumu-Nairobi';
    let bus_capacity = '60';
    let all_seats = '60';
    let bus_status = 'Active';

    contract.add_bus(registration_no, route, bus_capacity, all_seats, bus_status);

    let count = contract.get_bus(1);

    // assert(count.all_seats == '60', 'bus registration number');
}

// #[test]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract('HelloStarknet');

//     let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         }
//     };
// }
