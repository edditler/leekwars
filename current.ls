include('functions')
include('statistics')

// We have movement points to walk
var totalMP = getTotalMP(me)

// We have turn points to shoot/chips/talk/...?
var totalTP = getTotalTP(me)

// Statistics
debug("Estimate that the enemy can kill me in "+estimateTurnsToKillMe()+" turns.")
debug("Estimate that I need "+estimateShotsToKillEnemy(enemy)+" shots.")

function attack(enemy) {
    var return_code = 1000;
    var total = 0
    useChip(CHIP_ROCK, enemy)
    useChip(CHIP_PROTEIN, me)
    while (getTP(me) >= 3 and total < 10 and canUseWeapon(enemy)) {
        var enemy_lp_before = getLife(enemy)
        return_code = useWeapon(enemy);
        var damage = enemy_lp_before - getLife(enemy)

        if (return_code > 0 and damage > 0) {
            number_of_shots += 1
            damage_dealt += damage
            debug("Shots: "+number_of_shots+" damage ("+damage+","+damage_dealt+")")
        }
        total++
    }
    useChip(CHIP_HELMET, me)
}

// Usage of movement points
function stay_put() {
    return true
}

function move_towards_the_enemy(enemy) {
    // Where exactly to move? Maybe hide?
    // I don't have enough MP to make something elaborate
    moveToward(enemy, 1)
}

var did_attack = false  // This will tell us whether or not we attacked
        
// While we are moving
while (getMP() > 0) {
    var distance = getCellDistance(getCell(me), getCell(enemy))
    debug("We have "+getMP()+"MP and a distance of "+distance)

    // Can we even attack?
    if (getTP() < 3) {
        debug("We have less than 3 TP, breaking")
        break
    }
    
    // Are there enemies left?
    if (getEnemiesLife() == 0) {
        debug("No enemies left")
        break
    }

    // There are three options
    //  - Stay put
    //  - Move towards the enemy
    //  - Move away from the enemy
    
    // If the distance is 11 and we have a range of 7+4 => move towards the enemy
    if (distance <= my_range + getMP()) {
        debug("Distance is such that we could move close enough")

        if (canUseWeapon(enemy) and getTP(me) >= 3) {
            // Can we attack immediately?
            attack(enemy)
            did_attack = true
        } else {
            debug("Possible shots "+possibleShots()+" estimated "+estimateShotsToKillEnemy(enemy))
            // I think this never hurts. 4TP -> 6TP
            //    ... actually if we can go for the instant kill, it hurts.
            useChip(CHIP_MOTIVATION, me)
            // Not sure about these. Same principle basically...
            useChip(CHIP_HELMET, me)
            useChip(CHIP_PROTEIN, me)

            var my_x = getCellX(getCell(me))
            var my_y = getCellY(getCell(me))
            if (did_attack == false) {
                for (var ix = -getMP(); ix <= getMP(); ix++) {
                    for (var iy = -getMP()+abs(ix); (abs(iy)+abs(ix)) <= getMP(); iy++) {
                        var try_cell = getCellFromXY(my_x+ix, my_y+iy)
                        if (getCellDistance(getCell(me), try_cell) <= getMP()) {
                            if (in_sight_and_range(try_cell, enemy)) {
                                debug("In sight at ("+ix+","+iy+")")
                                var eff = moveTowardCell(try_cell)
                                distance = getCellDistance(getCell(me), getCell(enemy))
                                attack(enemy)
                                did_attack = true
                                break
                            }  // in sight
                        }  // close enough
                    }  // Grid search iy
                }  // Grid search ix
            } // Only do all this if we didn't attack yet
        }
        
        if (did_attack) {
            debug("We found a match to go to and attacked hopefully")
        } else {
            debug("We didn't find a match to go to. Just move")
            move_towards_the_enemy(enemy)
            useChip(CHIP_ICE, enemy)
            useChip(CHIP_SPARK, enemy)
        }
    } else if (distance > my_range + getMP()) {
        debug("Distance is such that we are far away")
        // Will we be in range for the enemy next turn?
        var enemy_range = getMP(enemy)
        var enemy_weapon = getWeapon(enemy)
        if (enemy_weapon) {
            enemy_range += getWeaponMaxRange(enemy_weapon)
        }

        // We can't move to shoot, so we buff ourselves
        // Buffing only makes sense when we are kinda in range
        if (distance < my_range + enemy_range) {
            useChip(CHIP_HELMET, me)
            useChip(CHIP_PROTEIN, me)
        } else {
            //debug("Didn't use helmet and protein because "+string(my_range + enemy_range))
        }


        if ( distance <= enemy_range ) {
            // moveAwayFromLine(getCell(me), getCell(enemy), 1)
            break
        } else {
            useChip(CHIP_LEATHER_BOOTS, me)
            move_towards_the_enemy(enemy)
        }
        
    } else {
        debug("Distance is something else? "+distance)
    }

}

// Stuff we always want to try
// This chip goes through obstacles
useChip(CHIP_SPARK, enemy)
useChip(CHIP_SPARK, enemy)
useChip(CHIP_SPARK, enemy)
useChip(CHIP_SPARK, enemy)

if (getLife(me) < getTotalLife(me) - 13) useChip(CHIP_CURE, me)