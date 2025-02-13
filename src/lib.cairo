#[starknet::interface]
// T is a place holder or constructor that can be use to hold something

pub trait ICounter<TContractState>{
    fn get_counter( self: @TContractState) -> u32;
    fn increase_counter( ref self: TContractState);
    fn decrease_counter( ref self: TContractState);
    fn reset_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod Counter{

    use starknet::storage::StoragePointerWriteAccess;
    use starknet::storage::StoragePointerReadAccess;
    #[storage]
    struct Storage{
        counter: u32
    }

    #[event]
    // Drops means ones it goes out of scope it gets destroyed
    #[derive(Drop, starknet::Event)]
    enum Event{
        CounterIncreased: CounterIncreased,
        CounterDecreased: CounterDecreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased{
        counter: u32
    }

    #[derive(Drop, starknet::Event)]
    struct CounterDecreased{
        counter: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_counter: u32) {
        self.counter.write(initial_counter);
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState>{

        fn get_counter(self: @ContractState) -> u32{
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState){
            let current_counter = self.counter.read();
            let new_counter = current_counter + 1;
            self.counter.write(new_counter);
            self.emit(CounterIncreased{counter: new_counter});
        }

        fn decrease_counter(ref self: ContractState){
            let current_counter = self.counter.read();
            let new_counter = current_counter - 1;
            assert(new_counter > 0, 'Counter cannot be negative'); // Since u32 cannot accept negavites
            self.counter.write(new_counter);
            self.emit(CounterDecreased{counter: new_counter});
        }

        fn reset_counter(ref self: ContractState){
            self.counter.write(0);
        }
    }
}