import sys
import json
import os

keys_for_user_setup = [
    "mod_name"
]

def read_config(build_dir : str, filename : str):
    default_config = None
    with open(os.path.join(build_dir, "configs", filename), "r") as f:
        default_config = json.load(f)
    return default_config
    

def write_config(build_dir : str, filename : str, config : dict):
    with open(os.path.join(build_dir, "configs", filename), "w") as f:
        json.dump(config, f, indent=2)


def main():
    (build_dir,) = sys.argv[1:]

    #####################
    #    config.json    #
    #####################
    default_config : dict = read_config(build_dir, "config.json")
    config = dict()

    mod_name = None
    mod_name_lower_first = None

    for key in default_config.keys():
        default_value = default_config[key]
        if mod_name:
            default_value = default_value.replace("%mod_name%", mod_name)
            default_value = default_value.replace("%mod_name_first_word_lower%", mod_name_lower_first)
        
        new_value = None
        if key in keys_for_user_setup:
            new_value = input("Enter value for {} (default: {}): ".format(key, default_value))

        if new_value:
            config[key] = new_value
        else:
            config[key] = default_value

        if key == "mod_name":
            mod_name = config[key]
            mod_name_lower_first = mod_name[0].lower() + mod_name[1:]
    
    write_config(build_dir, "config.json", config)


    #####################
    # local_config.json #
    #####################
    default_local_config = read_config(build_dir, "local_config.json")
    local_config = dict()

    for key in default_local_config.keys():
        default_value = default_local_config[key]
        new_value = input("Enter value for {} (default: {}): ".format(key, default_value))

        if new_value:
            local_config[key] = new_value
        else:
            local_config[key] = default_value

    write_config(build_dir, "local_config.json", local_config)


    #####################
    #     launchpad     #
    #####################
    for target in ["beta", "release"]:
        default_mod_settings = None
        filepath = os.path.join(build_dir, "launchpad", target, "mod.settings")
        with open(filepath, "r") as f:
            default_mod_settings = f.readlines()
        
        mod_settings = list()
        for line in default_mod_settings:
            line = line.replace("%mod_name%", mod_name)
            mod_settings.append(line)
        
        with open(filepath, "w") as f:
            f.writelines(mod_settings)


if __name__ == "__main__":
    main()