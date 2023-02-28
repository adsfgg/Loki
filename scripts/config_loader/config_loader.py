import json
import os

def _load_config(config_name : str):
    config = None
    path = os.path.join("..", "configs", config_name)
    with open(path, "r") as f:
        config = json.load(f)

    return config

def load_docugen_config():
    return _load_config("docugen.json")

def load_general_config():
    return _load_config("config.json")
