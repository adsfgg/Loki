import pathlib

def main():
    mod_name = input("Enter mod name: ")
    mod_name_lower_first = mod_name[0].lower() + mod_name[1:]

    # Setup dir structure
    pathlib.Path("src", "lua", mod_name).mkdir(parents=True, exist_ok=True)
    pathlib.Path("src", "lua", "entry").mkdir(parents=True, exist_ok=True)

    # Setup Filehooks
    filepath = pathlib.Path("src", "lua", f"{mod_name}_FileHooks.lua")
    with open(filepath, "w") as f:
        f.writelines([
            f"g_{mod_name_lower_first}Revision = 1\n"
            f"g_{mod_name_lower_first}BuildString = \"{mod_name} Revision \" .. g_{mod_name_lower_first}Revision\n"
            "\n",
            "-- Place your filehooks here\n",
            "\n",
            f"--ModLoader.SetupFileHook(\"lua/Balance.lua\", \"lua/{mod_name}/Balance.lua\", \"post\")\n",
            "\n"
        ])

    # Setup entryfile
    filepath = pathlib.Path("src", "lua", "entry", f"{mod_name}.entry")
    with open(filepath, "w") as f:
        f.writelines([
            "modEntry = {\n",
            f"  FileHooks = \"lua/{mod_name}_FileHooks.lua\"\n",
            "  Priority = 50\n",
            "}\n",
            "\n"
        ])

    # Setup mod.settings
    lines = None
    filepath = pathlib.Path("launchpad", "prod", "mod.settings")
    template = pathlib.Path("launchpad", "prod", "mod.settings.template")
    with open(template, "r") as f:
        lines = f.readlines()
    with open(filepath, "w") as f:
        f.writelines([ line.replace("%mod_name%", mod_name) for line in lines ])
    template.unlink()



if __name__ == "__main__":
    main()
