-- =============================================================
-- Database Schema — Game Item & Currency System
-- Based on need.md design
-- Normalized to 3NF, 5 constraints applied
-- =============================================================

-- 1. Player
CREATE TABLE Player (
    player_id INTEGER PRIMARY KEY,
    username  TEXT NOT NULL UNIQUE
);

-- 2. PlayerCurrency
CREATE TABLE PlayerCurrency (
    player_id      INTEGER PRIMARY KEY,
    common_candies INTEGER NOT NULL DEFAULT 0 CHECK(common_candies >= 0),
    golden_candies INTEGER NOT NULL DEFAULT 0 CHECK(golden_candies >= 0),
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

-- 3. ComponentType (lookup: Chains, Scissors, Rags, Buttons, Yarn)
CREATE TABLE ComponentType (
    name TEXT PRIMARY KEY
);

-- 4. ComponentQuality (lookup: Broken, Slightly damaged, Intact)
CREATE TABLE ComponentQuality (
    name TEXT PRIMARY KEY
);

-- 5. PlayerComponent
CREATE TABLE PlayerComponent (
    player_id      INTEGER NOT NULL,
    component_type TEXT    NOT NULL,
    quality        TEXT    NOT NULL,
    quantity       INTEGER NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (player_id, component_type, quality),
    FOREIGN KEY (player_id)      REFERENCES Player(player_id),
    FOREIGN KEY (component_type) REFERENCES ComponentType(name),
    FOREIGN KEY (quality)        REFERENCES ComponentQuality(name)
);

-- 6. Blueprint
CREATE TABLE Blueprint (
    blueprint_id INTEGER PRIMARY KEY,
    name         TEXT NOT NULL
);

-- 7. BlueprintRequirement
CREATE TABLE BlueprintRequirement (
    blueprint_id   INTEGER NOT NULL,
    component_type TEXT    NOT NULL,
    quality        TEXT    NOT NULL,
    quantity       INTEGER NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (blueprint_id, component_type, quality),
    FOREIGN KEY (blueprint_id)   REFERENCES Blueprint(blueprint_id) ON DELETE CASCADE,
    FOREIGN KEY (component_type) REFERENCES ComponentType(name),
    FOREIGN KEY (quality)        REFERENCES ComponentQuality(name)
);

-- 8. Costume
CREATE TABLE Costume (
    costume_id   INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    blueprint_id INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (blueprint_id) REFERENCES Blueprint(blueprint_id)
);

-- 9. PlayerBlueprint
CREATE TABLE PlayerBlueprint (
    player_id    INTEGER NOT NULL,
    blueprint_id INTEGER NOT NULL,
    quantity     INTEGER NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (player_id, blueprint_id),
    FOREIGN KEY (player_id)    REFERENCES Player(player_id),
    FOREIGN KEY (blueprint_id) REFERENCES Blueprint(blueprint_id)
);

-- 10. PlayerCostume
CREATE TABLE PlayerCostume (
    player_id  INTEGER NOT NULL,
    costume_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (player_id, costume_id),
    FOREIGN KEY (player_id)  REFERENCES Player(player_id),
    FOREIGN KEY (costume_id) REFERENCES Costume(costume_id)
);

-- 11. LotteryRecord
CREATE TABLE LotteryRecord (
    record_id INTEGER PRIMARY KEY,
    player_id INTEGER NOT NULL,
    draw_time TEXT    NOT NULL,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

-- =============================================================
-- Seed Data: Lookup Tables
-- =============================================================

INSERT INTO ComponentType (name) VALUES ('Chains');
INSERT INTO ComponentType (name) VALUES ('Scissors');
INSERT INTO ComponentType (name) VALUES ('Rags');
INSERT INTO ComponentType (name) VALUES ('Buttons');
INSERT INTO ComponentType (name) VALUES ('Yarn');

INSERT INTO ComponentQuality (name) VALUES ('Broken');
INSERT INTO ComponentQuality (name) VALUES ('Slightly damaged');
INSERT INTO ComponentQuality (name) VALUES ('Intact');
