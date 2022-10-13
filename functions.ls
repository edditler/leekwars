// Variables I always want to have

global me = getEntity()
var enemy = getNearestEnemy();
for (var entity in getEnemies()) {
    if (getType(entity) == ENTITY_LEEK) {
        enemy = entity;
    }
}

if (getWeapon(me) != WEAPON_PISTOL) setWeapon(WEAPON_PISTOL);
global weapon = getWeapon(me)
global my_range = getWeaponMaxRange(weapon)


// Functions that return simple bools

function in_range(from_cell, enemy) {
    var distance = getCellDistance(from_cell, getCell(enemy))
    var too_far_by = distance - my_range;
    
    return (too_far_by <= 0)
}

function in_sight(from_cell, enemy) {
    return lineOfSight(from_cell, getCell(enemy))
}

function in_sight_and_range(from_cell, enemy) {
    return in_range(from_cell, enemy) and in_sight(from_cell, enemy)
}
