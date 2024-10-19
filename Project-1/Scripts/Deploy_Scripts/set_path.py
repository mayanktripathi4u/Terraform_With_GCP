import sys
import os

def determine_module_and_vars_file(instance, env, workspace = None):
    env_prefix_map = {
        "prod":"prod",
        "synth": "synth",
        "stage": "stage",
        "dev": "dev"
    }

    if env not in env_prefix_map:
        raise Exception("Invalid Environment")
    
    # base Path and Vars file naming
    base_path = "infra"
    env_variable_prefix = env_prefix_map[env]
    variavle_suffix = "_prim.tfvars" if instance == "primary" else '_sec.tfvars'
    instance = "gcphde-prim" if instance == "primary" else "gcphde-sec"

    # map workspace to correct path
    workspace_path_map = {
        "data": "data",
        "data-iam": "data/iam",
    }

    if workspace not in workspace_path_map:
        raise Exception("Invalid Workspace")

    module_path = f'{base_path}/{workspace_path_map[workspace]}'
    vars_file = f'tfvars/{env_variable_prefix}{variavle_suffix}'

    workspace = f"{instance}-{env_variable_prefix}-{workspace}"

    # raise Exception("Not a Valid Combination of Env and Workspae")

    print("----------> WOrkspace is ", workspace)

    return module_path, vars_file, workspace

def write_to_github_actions(module_path, vars_file, workspace):
    def __print_paths(out_file):
        print(f"module_path={module_path}", file=out_file)
        print(f"vars_file={vars_file}", file=out_file)
        print(f"workspace={workspace}", file=out_file)

    github_output_file = os.getwnv('GITHUB_OUTPUT')

    if github_output_file:
        with open(github_output_file, 'a') as out_file:
            __print_paths(out_file)
    else:
        __print_paths(None)

def main():
    try:
        if len(sys.argv) != 4:
            print("Usage: Pythin set_path.py <instance> <env> <workspace>")
            sys.exit(1)

        instance = sys.argv[1]
        env = sys.argv[2]
        workspace = sys.argv[3]

        module_path, vars_file, workspace = determine_module_and_vars_file(instance, env, workspace)
        # write_to_github_actions(module_path, vars_file, workspace)

    except Exception:
        raise


if __name__ == "__main__":
    main()