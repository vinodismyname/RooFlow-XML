<!-- ======================= -->
<!-- ROOFLOW XML             -->
<!-- ======================= -->

# RooFlow XML -  **EXPERIMENT**

## 🎯 Motivation

- Role Definitons: Updated role definitions solve issues where LLMs would "forget" about memory bank functionality during complex tasks and removed them from the mode level descriptions using .roomodes definitions to ensure Roo consistently prioritizes memory bank usage without competing instructions
- XML Optimization: XML versions of the system prompt provides potential performance benefits with certain LLM backends that parse XML more efficiently than YAML. This is yet to be fully validated with Roo.
- Simplified Setup: One-line installation script dramatically reduces friction, replacing the complex multi-step process that caused inconsistent configurations

## 📋 Prerequisites

**YQ Tool Required**: The setup script depends on `yq` for YAML/XML processing. If you don't have it installed:

```bash
# macOS/Linux (using Homebrew)
brew install yq
```

## ✨  One-Line Setup

The RooFlow setup can be done with a one-line setup command:

```bash
curl -s "https://raw.githubusercontent.com/vinodismyname/RooFlow-XML/main/config/setup-roo.sh" | bash -s -- "https://github.com/vinodismyname/RooFlow-XML.git" --xml
```

### 🔄  Shell Aliases

Add these aliases to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file:

```bash
# Basic setup alias
alias setup-rooflow='curl -s "https://raw.githubusercontent.com/vinodismyname/RooFlow-XML/main/config/setup-roo.sh" | bash -s -- "https://github.com/vinodismyname/RooFlow-XML.git"'

# Remote setup with XML format conversion
alias setup-rooflow-xml='curl -s "https://raw.githubusercontent.com/vinodismyname/RooFlow-XML/main/config/setup-roo.sh" | bash -s -- "https://github.com/vinodismyname/RooFlow-XML.git" --xml'
```

After adding these aliases, reload your shell configuration:

```bash
source ~/.bashrc   # For Bash
# OR
source ~/.zshrc    # For Zsh
```

Then simply run the desired alias:

```bash
setup-rooflow
# OR
setup-rooflow-xml
```

### 🛠️ Setup Features

- **Local & Remote Modes**: Install from local files or directly from a repository
- **Override Option**: Force overwrite existing settings with `--override` flag
- **XML Conversion**: Convert YAML files to XML format with `--xml` flag for potentially improved performance with certain LLMs

## 🧠 Updated Role Definitions

All system prompts now include more detailed role definitions to strengthen the AI assistant's adherence to memory bank functionality:

- **Architect Mode**: "You are Roo, an experienced technical leader who is inquisitive and an excellent planner, focusing on system design, documentation structure, and project organization..."
- **Code Mode**: "You are Roo, a highly skilled software engineer with extensive knowledge in many programming languages, frameworks, design patterns, and best practices..."
- **Ask Mode**: "You are Roo, a knowledgeable technical assistant focused on answering questions, providing information about software development and technology..."
- **Debug Mode**: "You are Roo, an expert software debugger who specializes in systematic problem diagnosis and resolution..."

## 📋 Standardized Configuration

- Aligned formatting across all system prompts for better maintainability
- `.roomodes` set Blank Role Definitions: The .roomodes file use blank space (" ") for role definitions instead of duplicate content. This prevents the LLM from prioritizing these shorter definitions over the more detailed memory-aware instructions in the system prompts, ensuring consistent memory bank functionality across all modes


## 🧪 Testing Request

If you're using this fork, please test and share your feedback.

1. Whether the setup script works smoothly in your environment
2. If you notice improved LLM performance with the enhanced role definitions
3. Any performance differences when using the XML conversion option

## ⚙️ Manual Setup Options

You can also download and run the script manually:

```bash
# Download the script
curl -o setup-roo.sh https://raw.githubusercontent.com/vinodismyname/RooFlow/main/config/setup-roo.sh
chmod +x setup-roo.sh

# Run with options
./setup-roo.sh                        # Local mode
./setup-roo.sh --xml                  # Local mode with XML conversion
./setup-roo.sh [REPO_URL] --override  # Remote mode, force override
```

---

<!-- ======================= -->
<!--  ORIGINAL DOCUMENTATION -->
<!-- ======================= -->

<div align="center">

### ✨MCP server tools✨ 

#### Still working on full MCP functionality in RooFlow modes. If you have issues, there is a global [Default mode](https://github.com/GreatScottyMac/RooFlow/blob/main/config/default-mode/README.md) available which runs with the Roo Code default system prompt. 

<br>
  
### ☢️☢️☢️ Footgun in Use ☢️☢️☢️

<br>

# 🚀 RooFlow 🌊

**Persistent Project Context and Streamlined AI-Assisted Development**

[![Roo Code](https://img.shields.io/badge/VS%20Code-Extension-blue.svg)](https://github.com/RooVetGit/Roo-Code)
[![RooFlow](https://img.shields.io/badge/View%20on-GitHub-lightgrey.svg)](https://github.com/GreatScottyMac/RooFlow)

</div>

## 🎯 Overview

RooFlow enhances AI-assisted development in VS Code by providing **persistent project context** and **optimized mode interactions**, resulting in **reduced token consumption** and a more efficient workflow.  It builds upon the concepts of the Roo Code Memory Bank, but streamlines the process and introduces a more integrated system of modes. RooFlow ensures your AI assistant maintains a deep understanding of your project across sessions, even after interruptions.

### Key Improvements over Roo Code Memory Bank:

*   **Reduced Token Consumption:** Optimized prompts and instructions minimize token usage.
*   **Five Integrated Modes:**  Architect, Code, Test, Debug, and Ask modes work together seamlessly.
*   **Simplified Setup:**  Easier installation and configuration.
*   **Streamlined Real-time Updates:**  More efficient and targeted Memory Bank updates.
*   **Clearer Instructions:**  Improved YAML-based rule files for better readability and maintainability.

### Key Components

```mermaid
flowchart LR
    A["RooFlow"] --> D["Toolkit"]
    A["RooFlow"] --> M["Real-time Updates"]
    D --> C["Mode Rules"]
    B["Memory Bank"] --> E["Product Context"] & N["Active Context"] & F["Decisions"] & G["Progress"]
    C --> H["Architect"] & I["Code"] & J["Ask"] & K["Debug"] & L["Test"]
    M["Real-time Updates"] --> B
```

- 🧠 **Memory Bank**: Persistent storage for project knowledge (automatically managed).
- 💻 **System Prompts**: YAML-based core instructions for each mode (`.roo/system-prompt-[mode]`).
- 🔧 **VS Code Integration**: Seamless development experience within VS Code.
- ⚡ **Real-time Updates**:  Automatic Memory Bank updates triggered by significant events.

## 🚀 Quick Start

   ###  1. Installation

   1.  **Install Roo Code Extension:** Ensure you have the Roo Code extension installed in VS Code.
   2.  **Download [RooFlow Files](https://github.com/GreatScottyMac/RooFlow/tree/main/config):** Download the following files from this repository:
   * [`system-prompt-architect`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roo/system-prompt-architect)
   * [`system-prompt-ask`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roo/system-prompt-ask)
   * [`system-prompt-code`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roo/system-prompt-code)
   * [`system-prompt-debug`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roo/system-prompt-debug) 
   * [`system-prompt-test`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roo/system-prompt-test)
   * [`.rooignore`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.rooignore)
   * [`.roomodes`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roomodes)
   * [`insert-variables.cmd`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/insert-variables.cmd)For Windows OS
   * [`insert-variables.sh`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/insert-variables.sh)For Unix/Linux/macOS
   3.  **Place Files in Project:**
   *   Create a directory named [`.roo`](https://github.com/GreatScottyMac/RooFlow/tree/main/config/.roo) in your project's root directory.
   *   Place the `system-prompt-[mode]` files inside the [`.roo`](https://github.com/GreatScottyMac/RooFlow/tree/main/config/.roo) directory.
   * Place the [`.rooignore`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.rooignore) file in the project's root directory. (Or add !memory-bank/ to your existing .rooignore file)
   * Place the [`.roomodes`](https://github.com/GreatScottyMac/RooFlow/blob/main/config/.roomodes) file in the project's root directory (Or add its contents to your existing .roomodes file)
   * Place the appropriate `insert-variables.[sh/cmd]` script for your platform in the project's root directory.

   Your project structure should look like this:

   ```
   project-root
    ├── .roo
    |    ├── system-prompt-architect
    |    ├── system-prompt-ask
    |    ├── system-prompt-code
    |    ├── system-prompt-debug
    |    └── system-prompt-test
    ├── memory-bank (This directory will be created automatically by Roo after your first prompt)
    |    ├── activeContext.md
    |    ├── decisionLog.md
    |    ├── productContext.md
    |    ├── progress.md
    |    └── systemPatterns.md
    ├── .rooignore               
    ├── .roomodes
    └──insert-variables.[sh/cmd]
```
   4. **Run insert-variables script**

   #### For Windows: 
   1. Open Command Prompt or PowerShell
   2. Navigate to your project:
      ```cmd
      cd path\to\your\project
      ```
   3. Run the script:

      From Command Prompt:

      ```cmd
      insert-variables.cmd
      ```

      From Powershell:

      ```powershell
      .\insert-variables.cmd
      ```
      Troubleshooting (Windows)
   * **If you get "access denied" or execution policy errors:**
   1. Open PowerShell as Administrator
   2. Run this command once:
      ```powershell
      Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
      ```
   3. Close Administrator PowerShell
   4. Try running the script again from your project directory
   * **If you see "Error: .roo directory not found", verify your directory structure.**
   * **If using PowerShell 7+, run as:**
      ```powershell
      cmd /c insert-variables.cmd
      ```
   #### For Unix/Linux/macOS
   1. Open Terminal
   2. Navigate to your project:
      ```bash
      cd path/to/your/project
      ```
   3. Make the script executable:
      ```bash
      chmod +x insert-variables.sh
      ```
   4. Run the script:
      ```bash
      ./insert-variables.sh
      ```

      Troubleshooting (Unix/Linux/macOS)
   * **If you see "Permission denied", run:** 
      ```bash
      sudo chmod +x insert-variables.sh
      ```
   * **If you see "Error: .roo directory not found", verify your directory structure**

    
   #### Expected Output
   The script will:
   1. Detect your system configuration
   2. Process each system prompt file
   3. Show "Processing" and "Completed" messages for each file
   4. Display "Done" when finished


   #### Variables Being Replaced
   The script replaces these placeholders with your system-specific values:
   - OS_PLACEHOLDER (e.g., "Windows 10 Pro" or "Ubuntu 22.04")
   - SHELL_PLACEHOLDER (e.g., "cmd" or "bash")
   - HOME_PLACEHOLDER (your home directory)
   - WORKSPACE_PLACEHOLDER (your project directory)
   - GLOBAL_SETTINGS_PLACEHOLDER (Roo Code global settings path)
   - MCP_LOCATION_PLACEHOLDER (Roo Code MCP directory path)
   - MCP_SETTINGS_PLACEHOLDER (Roo Code MCP settings path)

   #### Next Steps
   After running the script:
   1. Verify that `.roo/system-prompt-*` files contain your system paths
   2. Start using VS Code with the Roo Code extension
   3. The Memory Bank will be initialized on first use

   ### 2. Using RooFlow

   1.  **Start a Chat:** Open a new Roo Code chat in your project.
   2.  **Select a Mode:** Choose the appropriate mode (Architect, Code, Test, Debug, Ask) for your task.
   3.  **Interact with Roo:**  Give Roo instructions and ask questions. Roo will automatically use the Memory Bank to maintain context.
   4.  **Memory Bank Initialization:**  If you start a chat in a project *without* a `memory-bank/` directory, Roo will suggest switching to Architect mode and guide you through the initialization process.
   5. **"Update Memory Bank" Command:** At any time, you can type "Update Memory Bank" or "UMB" to force a synchronization of the chat session's information into the Memory Bank. This is useful for ensuring continuity across sessions or before switching modes.

## 📚 Memory Bank Structure

The Memory Bank is a directory named `memory-bank` located in your project's root. It contains several Markdown files that store different aspects of your project's knowledge:

| File                 | Purpose                                                                                                                               |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `activeContext.md`   | Tracks the current session's context: recent changes, current goals, and open questions/issues.                                       |
| `decisionLog.md`     | Records architectural and implementation decisions, including the context, decision, rationale, and implementation details.        |
| `productContext.md`  | Provides a high-level overview of the project, including its goals, features, and overall architecture.                             |
| `progress.md`        | Tracks the progress of the project, including completed work, current tasks, and next steps.  Uses a task list format.               |
| `systemPatterns.md` | (Optional) Documents recurring patterns and standards used in the project (coding patterns, architectural patterns, testing patterns). |

RooFlow automatically manages these files. You generally don't need to edit them directly, although you can review them to understand the AI's knowledge.

## ✨ Features

### 🧠 Persistent Context

RooFlow remembers project details across sessions, maintaining a consistent understanding of your codebase, design decisions, and progress.

### ⚡ Real-time Updates

The Memory Bank is updated automatically based on significant events within each mode, ensuring that the context is always up-to-date.

### 🤝 Mode Collaboration

The five modes (Architect, Code, Test, Debug, Ask) are designed to work together seamlessly.  They can switch between each other as needed, and they share information through the Memory Bank.

### ⬇️ Reduced Token Consumption

RooFlow is designed to use fewer tokens than previous systems, making it more efficient and cost-effective.

## 📝 UMB Command
The command "Update Memory Bank" or "UMB" can be given at any time to update the memory bank with information from the current chat session.

## Contributing

Contributions to RooFlow are welcome! Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file (you'll need to create this) for guidelines.

## License
  [Apache 2.0](LICENSE)
