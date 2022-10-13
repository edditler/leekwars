global number_of_shots = 0
global damage_dealt = 0

global number_turns_damage_taken = 0
global health;

if (getLife(me) < getTotalLife(me)) {
    if (getLife(me) < health) {
        debug("I took "+string(health-getLife(me))+" damage in enemy turn.")
        number_turns_damage_taken += 1
        health = getLife(me)
    }
} else {
    health = getTotalLife(me)
    debug("I took no damage")
}

function estimateTurnsToKillMe() {
    var damage_per_turn = (getTotalLife(me) - getLife(me))/number_turns_damage_taken
    return getLife(me)/damage_per_turn
}

function estimateShotsToKillEnemy(enemy) {
    var damage_per_turn = damage_dealt/number_of_shots
    return getLife(enemy)/damage_per_turn
}

function possibleShots() {
    return floor(getTP()/3)  // 3 for pistol
}