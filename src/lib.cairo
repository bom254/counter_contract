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
}