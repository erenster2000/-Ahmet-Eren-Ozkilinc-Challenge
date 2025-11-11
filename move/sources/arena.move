module challenge::arena;

use sui::object::{Self, ID, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

use challenge::hero::{Hero, hero_power};
use sui::event;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {

    
    // Set owner to ctx.sender()
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: ctx.sender()
    };

    
    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: ctx.epoch_timestamp_ms()
    });
    
    
    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {

    
    let Arena { id, warrior, owner } = arena;


    if (hero_power(&hero) > hero_power(&warrior)) {
        

        
        event::emit(ArenaCompleted {
            winner_hero_id: object::id(&hero),
            loser_hero_id: object::id(&warrior),
            timestamp: ctx.epoch_timestamp_ms()
        });
        

        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, ctx.sender());
    } else {



        event::emit(ArenaCompleted {
            winner_hero_id: object::id(&warrior),
            loser_hero_id: object::id(&hero),
            timestamp: ctx.epoch_timestamp_ms()
        });


        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);
    }; 


    object::delete(id);
    }
