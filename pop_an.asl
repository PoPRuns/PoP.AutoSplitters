state("demul") {
    float xPos      : "D3DCOMPILER_47.dll", 0x37E279, 0x91;
    string20 map    : "D3DCOMPILER_47.dll", 0x37E279, -2703631;
}

start
{
    timer.Run.Offset = TimeSpan.FromSeconds(0);
    if (current.xPos != 17.5f && old.xPos == 17.5f) {
        timer.Run.Offset = TimeSpan.FromSeconds(-1.15);
        vars.InFinalLevel = false;
        return true;
    }
}

split
{
    if (current.map == "" && old.map == "Moon") {
        vars.InFinalLevel = true;
    }

    if ((current.map != "" && old.map == "") || (vars.InFinalLevel && current.map == "" && old.map == "Prison")) {
        return true;
    }
}
