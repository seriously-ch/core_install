## Quick Setup

To quickly set up th core project as a submodule in your repository and run the initial setup, you can use our setup script. Here's how:

1. Ensure you have Git and Elixir installed on your system.
2. Navigate to the root of your Git repository in the terminal.
3. Run the following command:

  ```sh
  curl -sSL https://raw.githubusercontent.com/seriously-ch/core_install/main/install.sh | sh
  ```

   This command will:
   - Add the core repository as a submodule to your project
   - Initialize and update the submodule
   - Run the `setup.exs` script to complete the setup
