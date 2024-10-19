import subprocess
import argparse
import os

def run_command(command):
    "Runs a command using subprocess and checks for error"

    try:
        print(f"Running COmmand: {' '.join(command)}")
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(result.stdout)
        return True, result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error Running COmmand : {' '.join(command)}")
        print(e.stdout)
        print(e.stderr)
        return False
    
def determine_workspace(env, instance, workspace):
    "Determine the workspace name based on enb; instance and workspace"

    prefix = "gcphde"

    workspace_name = f"{prefix}-{instance}-{env}-{workspace}"

    return workspace_name

def select_workspace(env, instance, workspace):
    "Determine the workspace based on env, instance, workspave and select it"
    try:
        workspace_name = determine_workspace(env=env, instance=instance, workspace=workspace)
        success, current_workspace = run_command(["terraform", "workspace", "show"])
        if not success:
            return Exception("Failed to get current Terraform Workspace")
        print(f"Current Workspace : {current_workspace}")

        if current_workspace != workspace_name:
            print(f"Switching to workspace : {workspace_name}")
            success, _ = run_command(["terraform", "workspace", "select", workspace_name])

            if not success:
                print(f"Workspace {workspace_name} does not exists.")
                raise Exception(f"Failed to create or switch to workspace : {workspace_name}")
        else:
            print(f"Already in the correct workspace : {workspace_name}")

    except Exception as e:
        print(f"Errpr selecting workspace. Make sure you are logged in to ... {e}")

# def determine_iam_role_binding_file(env, instance, workspace):
#     "Determine the IAM Role Binding File (.yaml) based on env, instance, workspace"
#     try:
#         # Define Paths
#         iam_role_binding_file = f"iam_role_bindings/{env}_{instance}_iam_group_bindings.yaml"
#         print(f"IAM Role Binding file : {iam_role_binding_file}")
#     except Exception as e:
#         print(f"Error selecting Role Binding File. Make sure it exists ... {e}")

#     return iam_role_binding_file


def main():
    parser = argparse.ArgumentParser(description="Run plam with var-file for the env/workspace you need")
    parser.add_argument('-e', '--env', required=True, help='Environment (eg prod; synth; dev; stage)')
    parser.add_argument('-i', '--instance', required=True, help='Instance name (eg prim; sec)')
    parser.add_argument('-w', '--workspace', required=True, help='Workspace (eg intake, data)')

    args = parser.parse_args()

    # Define Paths
    tf_vars_file = f"tfvars/{args.env}_{args.instance}.tfvars"
    print(f"var file: {tf_vars_file}")
    tf_plan_file = "tfplan"

    # Step x: Determine FIle Name for IAM Role Bindings
    # iam_role_binding_file = determine_iam_role_binding_file(args.env, args.instance, args.workspace)

    # # STep 1: Select Correct tfenv
    # if not run_command(['tfenv', 'use', 'latest']):
    #     return 
    
    # Step 2: Select Correct Workspace
    select_workspace(args.env, args.instance, args.workspace)

    # Step 3: Initialize Terraform
    if not run_command(["terraform", "init"]):
        return 
    
    # Step 4: Format Terraform File
    if not run_command(["terraform", "fmt"]):
        return 
    
    # Step 5: Validate Terraform Configuration
    if not run_command(["terraform", "validate"]):
        return 
    
    # Step 6: Generate Terrafor Plan
    if not run_command(["terraform", "plan", "-var-file", tf_vars_file, "-out", tf_plan_file]):
        return 
    
    print("Terraform Plan was created successfully. Fetching Plan ....")

    # Step 7: Show TF Plan
    if not run_command(["terraform", "show", tf_plan_file]):
        return 
        
if __name__ == "__main__":
    main()

