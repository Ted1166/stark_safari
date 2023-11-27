#[starknet::interface]
trait busesTrait<TContractState> {
    fn add_bus(ref self:TContractState, registration_no:felt252, route:felt252, bus_capacity:u128,all_seats:u128, bus_status:felt252);
    fn get_bus(self:@TContractState, key:u128) -> Array<Buses>;
    fn show_bus(self:@TContractState, key:u128) -> Buses;
    fn get_message(self:@TContractState, key:u128) -> Message;
}

#[starknet::contract]
mod Safari {

    use core::array::ArrayTrait;
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        bus : LegacyMap::<Buses, u128>,
        messages : LegacyMap::<Message, u128>,
        bus_count : u128
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Buses{
        registration_no : felt252,
        route : felt252,
        bus_capacity : u128,
        all_seats : u128,
        bus_status : felt252
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Message{
        recipient : ContractAddress,
        msg : felt252
    }

    #[external(v0)]
    impl busesImpl of super::busesTrait<ContractState> {
        fn add_bus(ref self:ContractState, registration_no:felt252, route:felt252, bus_capacity:u128,all_seats:u128, bus_status:felt252){
            let key_ = self.bus_count.read() + 1;
            let new_bus = Buses{registration_no:registration_no, route:route,bus_capacity:bus_capacity, all_seats:all_seats, bus_status:bus_status};
            self.bus.write(key_, new_bus);
            self.bus_count.write(key_);
        }

        fn get_bus(self:@ContractState, key:u128) -> Array<Buses> {
            let mut bus = ArrayTrait::<Buses>::new();
            let bus_no = self.bus_count.read();
            let mut count = 1;

            if bus_no > 0{
                loop{
                    let buss = self.bus.read(count);
                    bus.append(buss);
                    count +=1;
                    if(count > bus_no){
                        break;
                    }
                }
            }
            bus
        }

        fn show_bus(self:@ContractState, key:u128) -> Buses{
            self.bus.read(key)
        }

        fn get_message(self:@ContractState, key:u128) -> Message {
            self.messages.read(key)
        }

    }
}