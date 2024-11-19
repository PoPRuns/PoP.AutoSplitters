// Game:           Prince of Persia SNES
// Emulator:       snes9x 1.60 [x64]
// DOS version by: ThePedMeister, Karlgamer, WinterThunder, Smathlax, GMP, eien86
// SNES port:      DavidN, Shauing, GMP
// Date:           2021-11-21
// Updated:        2024-11-19
//
// Base memory path is everything before final offset
// e.g. in ["snes9x-x64.exe", 0x08D8C38, 0x0579] base path is the ["snes9x-x64.exe", 0x22ABFD0].
//
// Base memory paths for versions:
// snes9x-1.60-win32-x64:   0x22ABFD0

state("snes9x-x64")
{
    byte720 LevelObjects            : "snes9x-x64.exe", 0x008D8C38, 0x1E170;  // 7F:E170; 24 rooms * 3 rows * 10 columns
    byte NextLevel                  : "snes9x-x64.exe", 0x008D8C38, 0x0544;   // 7E:0544; 0 means LEVEL 1, 1 means LEVEL 2, and so on.
    byte CurrentLevel               : "snes9x-x64.exe", 0x008D8C38, 0x0579;   // 7E:0579; 0 means LEVEL 1, 1 means LEVEL 2, and so on.
    byte KidMaxHP                   : "snes9x-x64.exe", 0x008D8C38, 0x050A;   // 7E:050A
    ushort FrameCount               : "snes9x-x64.exe", 0x008D8C38, 0x052D;   // 7E:052D; elapsed frames (8 video frames each); stops on level 20
    byte KidRoom                    : "snes9x-x64.exe", 0x008D8C38, 0x0472;   // 7E:0472
    byte MsgTimer                   : "snes9x-x64.exe", 0x008D8C38, 0x0518;   // 7E:0518; Message timer

    sbyte GuardAlive                : "snes9x-x64.exe", 0x008D8C38, 0x0486;   // 7E:0486; < 0 if alive, >= 0 if dead
    byte GuardRoom                  : "snes9x-x64.exe", 0x008D8C38, 0x0482;   // 7E:0482
    byte GuardDirection             : "snes9x-x64.exe", 0x008D8C38, 0x047A;   // 7E:047A; 0x7F if there is no guard
    byte GuardHP                    : "snes9x-x64.exe", 0x008D8C38, 0x050B;   // 7E:050B
    byte GuardFrame                 : "snes9x-x64.exe", 0x008D8C38, 0x0477;   // 7E:0477
    byte24 GdStartBlock             : "snes9x-x64.exe", 0x008D8C38, 0x1F114;  // 7F:F114; guard tile positions for each room, changes to 0xFF if a guard falls offscreen
    byte GuardType                  : "snes9x-x64.exe", 0x008D8C38, 0x062B;   // 7E:062B
    byte PrincessImageTime          : "snes9x-x64.exe", 0x008D8C38, 0x0E1C;   // 7E:0E1C
}

startup
{
    settings.Add("level_splits", true, "Split on finishing levels");
    settings.Add("hundo_splits", false, "Split on additional actions");
    settings.SetToolTip("hundo_splits", "Splits other than level exit splits (for 100% runs, etc.)");
    settings.Add("pickup_splits", false, "Split on pickups", "hundo_splits");
    settings.SetToolTip("pickup_splits", "Includes all type of potions and also the sword pickup");
    settings.Add("guard_splits", false, "Split on defeating guards", "hundo_splits");
    settings.Add("princess_split", false, "Split on seeing the princess in the sky in level 20", "hundo_splits");

    vars.settingsMap = new Dictionary<int, string> {
        { 'p', "pickup_splits" },
        { 'g', "guard_splits" },
        { 'x', "level_splits" },
        { 'i', "princess_split" },
    };

    // This is the list of actions needed for 100% completion.
    vars.checks = new int[][] {
        // columns: type, level, room, tile, done
        // types:
        // 'p' = pick up (potion, sword)
        // 'g' = guard: The tile is the guard type (for level 19) or -1 if we don't care.
        // Guard types are listed at: https://www.princed.org/wiki/SNES_format#Levels , however, you need to subtract 2 from the numbers listed there.
        // 'x' = level exit (ignores the room and the tile)
        // "done" starts off as 0 and is set to 1 when the action is done.
        // This column is there to support completing actions in any order.

        // Level 1
        new int[]{'p', 1,  8, 27, 0},   // Level 1: Heal potion at room 8, tile 27 (attic, under the guard)
        new int[]{'p', 1, 12,  4, 0},   // Level 1: Heal potion at room 12, tile 4 (cellar)
        new int[]{'p', 1, 20, 25, 0},   // Level 1: Sword at room 20, tile 25
        new int[]{'p', 1, 23,  1, 0},   // Level 1: Heal potion at room 23, tile 1 (attic left, above the skeleton)
        new int[]{'g', 1,  8, -1, 0},   // Level 1: Guard at room 8, tile 6 (attic)
        new int[]{'g', 1,  1, -1, 0},   // Level 1: Guard at room 1, tile 17 (before the exit)
        new int[]{'x', 1, -1, -1, 0},   // Level 1: Level exit

        // Level 2
        new int[]{'g', 2,  7, -1, 0},   // Level 2: Guard at room 7
        new int[]{'p', 2,  8, 14, 0},   // Level 2: Heal potion at room 2, tile 14 (room below the guard)
        new int[]{'g', 2, 11, -1, 0},   // Level 2: Guard at room 11 (still underground)
        new int[]{'p', 2,  5, 26, 0},   // Level 2: Heal potion at room 5, tile 26 (above the ceiling)
        new int[]{'g', 2,  2, -1, 0},   // Level 2: Guard at room 2 (at the skeleton)
        new int[]{'p', 2,  1, 27, 0},   // Level 2: Heal potion at room 1, tile 27 (between the gates)
        new int[]{'g', 2,  0, -1, 0},   // Level 2: Guard at room 0 (bluish, at the spikes)
        new int[]{'p', 2, 13, 28, 0},   // Level 2: Life potion at room 13, tile 28
        new int[]{'p', 2, 23, 25, 0},   // Level 2: Heal potion at room 23, tile 25 (ceiling)
        new int[]{'g', 2, 16, -1, 0},   // Level 2: Guard at room 16 (bluish)
        new int[]{'g', 2, 15, -1, 0},   // Level 2: Guard at room 15 (next to the exit)
        new int[]{'g', 2, 12, -1, 0},   // Level 2: Guard at room 12 (bluish) (under the button which opens the exit)
        new int[]{'x', 2, -1, -1, 0},   // Level 2: Level exit

        // Level 3
        new int[]{'g', 3, 21, -1, 0},   // Level 3: Guard at room 21
        new int[]{'g', 3,  9, -1, 0},   // Level 3: Brown Skeleton at room 9
        new int[]{'p', 3,  9, 27, 0},   // Level 3: Life potion at room 9, tile 27 (at the brown skeleton)
        new int[]{'p', 3,  8,  2, 0},   // Level 3: Life potion at room 8, tile 2 (behind chompers)
        new int[]{'p', 3, 10,  8, 0},   // Level 3: Heal potion at room 10, tile 8 (after the first gate)
        new int[]{'p', 3, 18, 11, 0},   // Level 3: Hurt potion at room 18, tile 11 (on the way to the exit opener)
        new int[]{'p', 3, 18, 21, 0},   // Level 3: Heal potion at room 18, tile 21
        new int[]{'p', 3, 12, 16, 0},   // Level 3: Heal potion at room 12, tile 16 (underground)
        new int[]{'g', 3, 13, -1, 0},   // Level 3: Skeleton at room 13, crushed in room 20, or dropped offscreen from room 11
        new int[]{'x', 3, -1, -1, 0},   // Level 3: Level exit

        // Level 4
        new int[]{'g', 4,  8, -1, 0},   // Level 4: Guard at room 8
        new int[]{'p', 4, 13, 12, 0},   // Level 4: Heal potion at room 13, tile 12 (behind the guard)
        new int[]{'p', 4, 12, 22, 0},   // Level 4: Heal potion at room 12, tile 22 (ceiling)
        new int[]{'g', 4,  2, -1, 0},   // Level 4: Guard at room 2
        new int[]{'g', 4,  3, -1, 0},   // Level 4: Guard at room 3
        new int[]{'p', 4, 17, 15, 0},   // Level 4: Heal potion at room 17, tile 15 (ceiling)
        new int[]{'p', 4, 17, 17, 0},   // Level 4: Heal potion at room 17, tile 17 (ceiling)
        new int[]{'g', 4, 16, -1, 0},   // Level 4: Guard at room 16
        new int[]{'p', 4, 22, 16, 0},   // Level 4: Life potion at room 22, tile 16
        new int[]{'x', 4, -1, -1, 0},   // Level 4: Level exit

        // Level 5
        new int[]{'p', 5,  8, 21, 0},   // Level 5: Heal potion at room 8, tile 21
        new int[]{'g', 5, 11, -1, 0},   // Level 5: Guard at room 11
        new int[]{'p', 5, 13, 10, 0},   // Level 5: Heal potion at room 13, tile 10
        new int[]{'g', 5, 13, -1, 0},   // Level 5: Guard at room 13
        new int[]{'g', 5,  2, -1, 0},   // Level 5: Guard at room 2 (outdoor)
        new int[]{'p', 5,  3,  2, 0},   // Level 5: Heal potion at room 3, tile 2
        new int[]{'p', 5, 16, 12, 0},   // Level 5: Heal potion at room 16, tile 12
        new int[]{'p', 5, 21, 13, 0},   // Level 5: Life potion at room 21, tile 13 (hidden)
        new int[]{'x', 5, -1, -1, 0},   // Level 5: Level exit

        // Level 6
        new int[]{'p', 6, 10,  4, 0},   // Level 6: Heal potion at room 10, tile 4 (behind chompers)
        new int[]{'g', 6, 11, -1, 0},   // Level 6: Guard at room 11
        new int[]{'g', 6,  0, -1, 0},   // Level 6: Guard at room 0
        new int[]{'g', 6,  1, -1, 0},   // Level 6: Guard at room 1
        new int[]{'p', 6,  6,  8, 0},   // Level 6: Heal potion at room 6, tile 8
        new int[]{'p', 6, 14, 15, 0},   // Level 6: Life potion at room 14, tile 15
        new int[]{'p', 6,  5, 18, 0},   // Level 6: Hurt potion at room 5, tile 18
        new int[]{'g', 6, 21, -1, 0},   // Level 6: Amazon at room 21
        new int[]{'x', 6, -1, -1, 0},   // Level 6: Level exit

        // Level 7
        new int[]{'p', 7,  0,  7, 0},   // Level 7: Heal potion at room 0, tile 7
        new int[]{'g', 7,  8, -1, 0},   // Level 7: Guard at room 8
        new int[]{'p', 7,  6, 24, 0},   // Level 7: Heal potion at room 6, tile 24
        new int[]{'p', 7,  6, 25, 0},   // Level 7: Heal potion at room 6, tile 25
        new int[]{'g', 7, 11, -1, 0},   // Level 7: Guard at room 11
        new int[]{'p', 7, 11, 25, 0},   // Level 7: Heal potion at room 11, tile 25
        new int[]{'p', 7, 12,  6, 0},   // Level 7: Heal potion at room 12, tile 6
        new int[]{'p', 7, 10, 17, 0},   // Level 7: Heal potion at room 10, tile 17
        new int[]{'p', 7, 16,  6, 0},   // Level 7: Life potion at room 16, tile 6 (stolen)
        new int[]{'p', 7, 13,  0, 0},   // Level 7: Heal potion at room 13, tile 0
        new int[]{'p', 7, 13,  1, 0},   // Level 7: Heal potion at room 13, tile 1
        new int[]{'p', 7, 13,  2, 0},   // Level 7: Heal potion at room 13, tile 2
        new int[]{'p', 7, 13,  3, 0},   // Level 7: Heal potion at room 13, tile 3
        new int[]{'p', 7, 20, 13, 0},   // Level 7: Life potion at room 20, tile 13 (hidden)
        new int[]{'g', 7, 19, -1, 0},   // Level 7: Guard at room 19
        new int[]{'x', 7, -1, -1, 0},   // Level 7: Level exit

        // Level 8
        new int[]{'p', 8, 23,  5, 0},   // Level 8: Life potion at room 23, tile 5 (hidden)
        new int[]{'p', 8,  6,  7, 0},   // Level 8: Heal potion at room 6, tile 7
        new int[]{'g', 8,  2, -1, 0},   // Level 8: Guard at room 2
        new int[]{'g', 8, 11, -1, 0},   // Level 8: Guard at room 11
        new int[]{'p', 8, 11, 25, 0},   // Level 8: Heal potion at room 11, tile 25
        new int[]{'g', 8, 17, -1, 0},   // Level 8: Guard at room 17
        new int[]{'g', 8, 21, -1, 0},   // Level 8: Guard at room 21
        new int[]{'x', 8, -1, -1, 0},   // Level 8: Level exit

        // Level 9
        new int[]{'g', 9,  1, -1, 0},   // Level 9: Guard at room 1
        new int[]{'g', 9,  5, -1, 0},   // Level 9: Guard at room 5
        new int[]{'p', 9, 19, 25, 0},   // Level 9: Heal potion at room 19, tile 25
        new int[]{'p', 9, 15, 14, 0},   // Level 9: Life potion at room 15, tile 14 (hidden)
        new int[]{'g', 9, 16, -1, 0},   // Level 9: Politician (fat guard) at room 16
        new int[]{'x', 9, -1, -1, 0},   // Level 9: Level exit

        // Level 10
        new int[]{'g', 10,  0, -1, 0},  // Level 10: Skeleton at room 0
        new int[]{'g', 10,  2, -1, 0},  // Level 10: Skeleton at room 2
        new int[]{'g', 10,  4, -1, 0},  // Level 10: Brown skeleton at room 4
        new int[]{'g', 10,  5, -1, 0},  // Level 10: Skeleton at room 5
        new int[]{'p', 10, 19, 14, 0},  // Level 10: Life potion at room 19, tile 14 (hidden)
        new int[]{'g', 10,  7, -1, 0},  // Level 10: Skeleton at room 7
        new int[]{'g', 10, 10, -1, 0},  // Level 10: Skeleton at room 10
        new int[]{'g', 10, 14, -1, 0},  // Level 10: Skeleton at room 14
        new int[]{'g', 10, 16, -1, 0},  // Level 10: Brown skeleton at room 16
        new int[]{'x', 10, -1, -1, 0},  // Level 10: Level exit

        // Level 11
        new int[]{'p', 11,  5,  2, 0},  // Level 11: Heal potion at room 5, tile 2 (top left)
        new int[]{'g', 11,  6, -1, 0},  // Level 11: Guard at room 6
        new int[]{'g', 11,  9, -1, 0},  // Level 11: Guard at room 9 (above a potion)
        new int[]{'p', 11,  9, 27, 0},  // Level 11: Heal potion at room 9, tile 27 (under a guard)
        new int[]{'g', 11, 13, -1, 0},  // Level 11: Guard at room 13
        new int[]{'p', 11,  7, 12, 0},  // Level 11: Heal potion at room 7, tile 12
        new int[]{'g', 11, 11, -1, 0},  // Level 11: Guard at room 11 (at the chomper)
        new int[]{'p', 11, 16, 12, 0},  // Level 11: Heal potion at room 16, tile 12 (under the spikes)
        new int[]{'p', 11, 19, 17, 0},  // Level 11: Life potion at room 19, tile 17
        new int[]{'x', 11, -1, -1, 0},  // Level 11: Level exit

        // Level 12
        new int[]{'g', 12,  2, -1, 0},  // Level 12: Guard at room 2
        new int[]{'g', 12,  7, -1, 0},  // Level 12: Guard at room 7
        new int[]{'g', 12, 21, -1, 0},  // Level 12: Guard at room 21
        new int[]{'p', 12, 21, 28, 0},  // Level 12: Heal potion at room 21, tile 28
        new int[]{'g', 12, 17, -1, 0},  // Level 12: Guard at room 17
        new int[]{'p', 12, 19, 20, 0},  // Level 12: Heal potion at room 19, tile 20
        new int[]{'p', 12, 19, 21, 0},  // Level 12: Heal potion at room 19, tile 21
        new int[]{'g', 12, 14, -1, 0},  // Level 12: Guard at room 14
        new int[]{'p', 12,  1, 20, 0},  // Level 12: Slow fall potion at room 1, tile 20
        new int[]{'p', 12,  5, 10, 0},  // Level 12: Life potion at room 5, tile 10
        new int[]{'g', 12,  4, -1, 0},  // Level 12: Golden skeleton at room 4
        new int[]{'x', 12, -1, -1, 0},  // Level 12: Level exit

        // Level 13
        new int[]{'p', 13,  2, 11, 0},  // Level 13: Hurt potion at room 2, tile 11
        new int[]{'g', 13,  3, -1, 0},  // Level 13: Guard at room 3
        new int[]{'p', 13,  3, 25, 0},  // Level 13: Heal potion at room 3, tile 25
        new int[]{'g', 13,  4, -1, 0},  // Level 13: Guard at room 4
        new int[]{'g', 13, 13, -1, 0},  // Level 13: Guard at room 13
        new int[]{'g', 13,  6, -1, 0},  // Level 13: Guard at room 6
        new int[]{'p', 13,  0, 10, 0},  // Level 13: Life potion at room 0, tile 10
        new int[]{'g', 13, 18, -1, 0},  // Level 13: Guard at room 18
        new int[]{'x', 13, -1, -1, 0},  // Level 13: Level exit

        // Level 14
        new int[]{'g', 14,  1, -1, 0},  // Level 14: Guard at room 1
        new int[]{'p', 14, 21, 17, 0},  // Level 14: Heal potion at room 21, tile 17
        new int[]{'g', 14,  4, -1, 0},  // Level 14: Guard at room 4
        new int[]{'p', 14,  5,  2, 0},  // Level 14: Heal potion at room 5, tile 2
        new int[]{'g', 14, 10, -1, 0},  // Level 14: Guard at room 10
        new int[]{'p', 14, 23, 27, 0},  // Level 14: Life potion at room 23, tile 27 (hidden)
        new int[]{'g', 14, 12, -1, 0},  // Level 14: Guard at room 12
        new int[]{'p', 14, 14, 27, 0},  // Level 14: Hurt potion at room 14, tile 27
        new int[]{'p', 14, 15, 17, 0},  // Level 14: Flip potion at room 15, tile 17
        new int[]{'p', 14, 20, 18, 0},  // Level 14: Life potion at room 20, tile 18
        new int[]{'p', 14, 18, 11, 0},  // Level 14: Flip potion at room 18, tile 11
        new int[]{'x', 14, -1, -1, 0},  // Level 14: Level exit

        // Level 15
        new int[]{'g', 15,  0, -1, 0},  // Level 15: Guard at room 0 (purple)
        new int[]{'g', 15,  3, -1, 0},  // Level 15: Guard at room 3 (blue)
        new int[]{'p', 15, 22, 16, 0},  // Level 15: Heal potion at room 22, tile 16
        new int[]{'g', 15,  5, -1, 0},  // Level 15: Guard at room 5 (red)
        new int[]{'g', 15, 10, -1, 0},  // Level 15: Guard at room 10 (purple)
        new int[]{'p', 15, 22, 11, 0},  // Level 15: Life potion at room 22, tile 11 (hidden)
        new int[]{'p', 15,  8, 27, 0},  // Level 15: Heal potion at room 8, tile 27
        new int[]{'g', 15, 17, -1, 0},  // Level 15: Shadow at room 17
        new int[]{'x', 15, -1, -1, 0},  // Level 15: Level exit

        // Level 16
        new int[]{'g', 16,  3, -1, 0},  // Level 16: Guard at room 3 (blue)
        new int[]{'g', 16,  4, -1, 0},  // Level 16: Guard at room 4 (blue)
        new int[]{'p', 16,  8,  2, 0},  // Level 16: Life potion at room 8, tile 2
        new int[]{'g', 16, 10, -1, 0},  // Level 16: Guard at room 10 (purple)
        new int[]{'p', 16,  5, 25, 0},  // Level 16: Warp potion at room 5, tile 25
        new int[]{'g', 16, 14, -1, 0},  // Level 16: Guard at room 14 (red)
        new int[]{'g', 16, 20, -1, 0},  // Level 16: Red knight at room 20
        new int[]{'x', 16, -1, -1, 0},  // Level 16: Level exit

        // Level 17
        new int[]{'p', 17, 21, 25, 0},  // Level 17: Life potion at room 21, tile 25 (hidden)
        new int[]{'g', 17,  2, -1, 0},  // Level 17: Six-armed guy at room 2
        new int[]{'x', 17, -1, -1, 0},  // Level 17: Level exit

        // Level 18
        new int[]{'p', 18, 18, 21, 0},  // Level 18: Heal potion at room 18, tile 21
        new int[]{'g', 18, 16, -1, 0},  // Level 18: Guard at room 16 (purple)
        new int[]{'g', 18, 23, -1, 0},  // Level 18: Brown skeleton at room 23
        new int[]{'p', 18, 23, 25, 0},  // Level 18: Life potion at room 23, tile 25
        new int[]{'p', 18, 23, 23, 0},  // Level 18: Kill potion at room 23, tile 23
        new int[]{'p', 18,  8,  8, 0},  // Level 18: Heal potion at room 8, tile 8
        new int[]{'g', 18, 22, -1, 0},  // Level 18: Guard at room 22 (purple)
        new int[]{'g', 18, 21, -1, 0},  // Level 18: Guard at room 21 (red)
        new int[]{'p', 18, 21, 18, 0},  // Level 18: Heal potion at room 21, tile 18
        new int[]{'g', 18, 11, -1, 0},  // Level 18: Blue knight at room 11
        new int[]{'g', 18, 14, -1, 0},  // Level 18: Guard at room 14 (purple)
        new int[]{'x', 18, -1, -1, 0},  // Level 18: Level exit

        // Level 19
        new int[]{'p', 19, 11, 18, 0},  // Level 19: Life potion at room 11, tile 18
        new int[]{'g', 19,  7, 12, 0},  // Level 19: Guard at room 7 (blue face)
        new int[]{'g', 19,  7,  3, 0},  // Level 19: Golden skeleton at room 7
        new int[]{'g', 19,  7,  4, 0},  // Level 19: Amazon at room 7
        new int[]{'g', 19,  7,  5, 0},  // Level 19: Politician (fat guard) at room 7
        new int[]{'g', 19,  7, 14, 0},  // Level 19: Blue knight at room 7
        new int[]{'x', 19, -1, -1, 0},  // Level 19: Level exit

        // Level 20
        new int[]{'i', 20, -1, -1, 0},  // Level 20: See the princess on the sky
        new int[]{'x', 20, -1, -1, 0},  // Level 20: Level exit (Jaffar warps you to the final battle)
        new int[]{'g', 21,  0, -1, 0},  // Level 21: Defeat Jaffar
        new int[]{'x', 21, -1, -1, 0},  // Level 21: Level exit (warped back to level 20)
        new int[]{'x', 20, -1, -1, 0},  // Level 20: Level exit (run into the princess's room)
    };

    vars.resetGuards = (Action)(() =>
        vars.guardOriginalRooms = Enumerable.Range(0, 24).ToArray()
    );

    vars.resetActions = (Action)(() =>
        Array.ForEach((int[][])vars.checks, check => check[4] = 0)
    );

    vars.playing = false;

    vars.CompletedSplits = new HashSet<int>();

    if (timer.CurrentTimingMethod != TimingMethod.RealTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia (SNES)",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.RealTime;
        }
    }
}

update
{
    if (!vars.playing) return;

    // CurrentLevel == 255 when restarting the level.
    if (current.CurrentLevel == 255) vars.resetGuards();

    // CurrentLevel == 128 during cutscenes.
    if (current.CurrentLevel >= 128) return;

    bool guardIsPresent = current.GuardDirection != 0x7F;
    bool guardWasPresent = old.GuardDirection != 0x7F;
    bool guardDisappeared = (!guardIsPresent && guardWasPresent);
    bool guardReappeared = (current.GdStartBlock[current.GuardRoom] != 0xFF && old.GdStartBlock[current.GuardRoom] == 0xFF);
    bool guardDidntChange = (
        guardIsPresent && guardWasPresent &&
        current.GuardDirection == old.GuardDirection &&
        current.GuardHP == old.GuardHP
    );
    bool skeletonChangedRoom = (guardDisappeared && guardReappeared);
    bool guardJustDied = (
        // A guard is present and a normal guard died, level 3 skeleton crushed or brown skeleton collapsed
        guardIsPresent
        &&
        (
            (current.GuardAlive == 0 && old.GuardAlive != 0) ||
            (current.GuardFrame == 184 && old.GuardFrame != 184) ||
            (old.GuardFrame == 177 && current.GuardFrame == 186)
        )
    );
    bool guardJustFell = (
        // A guard disappeared and not because kid changed room and cleared from old room and didn't appear in new room
        guardDisappeared &&
        current.KidRoom == old.KidRoom &&
        current.GdStartBlock[old.GuardRoom] == 0xFF && !guardReappeared
    );

    // If a guard moved to another room:
    if (current.GuardRoom != old.GuardRoom && (guardDidntChange || skeletonChangedRoom)) {
        // If there is a guard in room R, then guardOriginalRooms[R] tells the room where that guard started the level.
        int guardOriginalRoom = vars.guardOriginalRooms[old.GuardRoom];
        print("A guard moved from room " + old.GuardRoom + " to " + current.GuardRoom + ". (original room: " + guardOriginalRoom + ")");
        vars.guardOriginalRooms[current.GuardRoom] = guardOriginalRoom;
    }

    for (int checkIndex = 0; checkIndex < vars.checks.Length; checkIndex++) {
        // If a check matches, mark it as done (in a new check[4]).

        int[] check = vars.checks[checkIndex];
        char type = (char)check[0];
        int level = check[1];
        int room = check[2];
        int tile = check[3];

        // Attempt to fix "Run into the princess's room" triggering too early.
        if (current.CurrentLevel + 1 < level) break;

        // Type IDs of objects which can be picked up:
        // (Source: https://www.princed.org/wiki/SNES_format#Levels)
        // 0x0A = sword
        // 0x12 = heal potion
        // 0x13 = life potion
        // 0x14 = hurt potion
        // 0x15 = upside down potion
        // 0x16 = slow fall potion
        // 0x1A = potion of warp
        // 0x1C = kill potion

        if (current.CurrentLevel + 1 != level || check[4] == 1) continue;

        switch (type) {
            case 'p':
                int offset = room * 30 + tile;
                // TODO: Compare the old value against the specific object type?
                if (current.LevelObjects[offset] == 0x00 && old.LevelObjects[offset] != 0x00) {
                    print("The player picked up the item at: level " + level + ", room " + room + ", tile " + tile);
                    check[4] = 1;
                }
            break;

            case 'g':
                if (guardJustDied || guardJustFell) {
                    int guardOriginalRoom = vars.guardOriginalRooms[old.GuardRoom];

                    // For guards, "tile" stores the guard type or -1.
                    if (guardOriginalRoom == room && (tile == -1 || tile == old.GuardType)) {
                        print("A guard died in room " + old.GuardRoom + " of level " + (current.CurrentLevel + 1) + ". (original room: " + guardOriginalRoom + ")");
                        check[4] = 1;
                    }
                }
            break;

            case 'x':
                if (current.NextLevel != old.NextLevel && old.NextLevel == old.CurrentLevel && current.NextLevel != current.CurrentLevel) {
                    check[4] = 1;
                    vars.resetGuards();
                    print("Level exit from level " + (current.CurrentLevel + 1) + " to level " + (current.NextLevel + 1));
                    // Attempt to fix "Run into the princess's room" triggering too early.
                    return;
                }
            break;

            case 'i': // Princess image
                if (current.PrincessImageTime >= 100) {
                    check[4] = 1;
                }
            break;
        }
    }
}

start
{
    return (
        current.KidMaxHP == 3 &&
        current.FrameCount == 0 &&
        current.CurrentLevel == 0 &&
        current.KidRoom == 22 &&
        current.MsgTimer == 18
    );
}

onStart
{
    print("start");
    vars.playing = true;
    vars.resetGuards();
    vars.resetActions();
    vars.CompletedSplits.Clear();
}

reset
{
    return (
        current.KidMaxHP == 0 ||
        (current.CurrentLevel >= 21 && current.CurrentLevel < 128) ||
        current.CurrentLevel == 252 ||
        current.CurrentLevel == 254
    );
}

onReset
{
    print("reset");
    print("CurrentLevel = " + current.CurrentLevel);
    vars.playing = false;
    vars.resetGuards();
    vars.resetActions();
}

split
{
    for (int checkIndex = 0; checkIndex < vars.checks.Length; checkIndex++) {
        int[] check = vars.checks[checkIndex];
        if (check[4] == 1 && vars.CompletedSplits.Add(checkIndex) && settings[vars.settingsMap[check[0]]]) {
            return true;
        }
    }
}
