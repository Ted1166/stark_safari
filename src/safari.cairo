
use stark_safari::safari::Safari::{Bus, Message, ContractAddress};
use core::array::ArrayTrait;

#[starknet::interface]
trait safariTrait<TContractState> {
    fn add_bus(ref self:TContractState, registration_no:felt252, route:felt252, bus_capacity:u128,all_seats:u128, bus_status:felt252);
    fn get_bus(self:@TContractState, key:u128) -> Array<Bus>;
    fn show_bus(self:@TContractState, key:u128) -> Bus;
    fn get_message(self:@TContractState, key:u128) -> Message;
}

#[starknet::contract]
mod Safari {

    use core::array::ArrayTrait;
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        bus : LegacyMap::<u128, Bus>,
        messages : LegacyMap::< u128, Message>,
        bus_count : u128
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Bus {
        registration_no : felt252,
        route : felt252,
        bus_capacity : u128,
        all_seats : u128,
        bus_status : felt252
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Message {
        recipient : ContractAddress,
        msg : felt252
    }

    #[external(v0)]
    impl safariImpl of super::safariTrait<ContractState> {
        fn add_bus(ref self:ContractState, registration_no:felt252, route:felt252, bus_capacity:u128,all_seats:u128, bus_status:felt252){
            let key_ = self.bus_count.read() + 1;
            let new_bus = Bus{registration_no:registration_no, route:route,bus_capacity:bus_capacity, all_seats:all_seats, bus_status:bus_status};
            self.bus.write(key_, new_bus);
            self.bus_count.write(key_);
        }

        fn get_bus(self:@ContractState, key:u128) -> Array<Bus> {
            let mut bus = ArrayTrait::<Bus>::new();
            let bus_no = self.bus_count.read();
            let mut count = 1;

            if bus_no > 0{
                loop{
                    let buz = self.bus.read(count);
                    bus.append(buz);
                    count +=1;
                    if(count > bus_no){
                        break;
                    }
                }
            }
            bus
        }

        fn show_bus(self:@ContractState, key:u128) -> Bus{
            self.bus.read(key)
        }

        fn get_message(self:@ContractState, key:u128) -> Message {
            self.messages.read(key)
        }

    }
}
