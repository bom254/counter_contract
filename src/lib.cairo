#[starknet::interface]
pub trait ICounter<TContractState>{
    fn get_counter( self: @TContractState) -> u32;
    fn increase_counter( ref self: TContractState);
    fn decrease_counter( ref self: TContractState);
    fn reset_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod Counter{

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

    
}