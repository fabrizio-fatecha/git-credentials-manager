Git Credentials Manager (GCM) [License: GNU GPL]

A lightweight Bash utility to switch between different Git configurations and credentials on the fly.

---

Why use this?

- Fix 403 Forbidden errors: Resolves permission issues when managing multiple GitHub accounts.
- Bypass VS Code cache: Disables VSCODE_GIT_ASKPASS which often forces the wrong identity.
- Manual Control: Forces Git to use the store helper, reading directly from your managed identity files.

---

Prerequisites

1) Identity Files
Keep your templates in the same directory as the script:

- Configs: personalconfig, workconfig
- Credentials: personalcredentials, workcredentials

2) Credential Format
Your credentials files must contain exactly this format:

https://username:your_personal_access_token@github.com

---

Installation

Make the script executable:

$ chmod +x gcm.sh

Run the manager:

$ ./gcm.sh

---

Options

1) Switch Global Configuration
   Overwrites .gitconfig (Windows system config or Linux/macOS global) with your template and ensures helper = store is active.

2) Switch Global Credentials
   Replaces ~/.git-credentials and applies 600 permissions.

3) Show Current Identity
   Verification tool to check active user, email, and token prefix.

4) Exit
   Close the manager safely.

---

Security & Safety

Windows Permissions
If switching the system config fails on Windows, you must restart Git Bash as Administrator.


# Git Identity Manager private files
*credentials
*config
gcm.sh

Verification
Always verify your identity with Option 3 before pushing code. This ensures no personal GitHub account is used accidentally.

---

Examples

Switch Config & Credentials:

$ ./gcm.sh
# 1) Switch Global Configuration
# 2) Switch Global Credentials
# 3) Show Current Identity

Show Active Identity:

$ ./gcm.sh
# Select option 3 to check which user, email, and token are active

---

Contributing

We welcome contributions! To contribute:

1) Fork the repository
2) Make your changes
3) Submit a Pull Request

Please read the Code of Conduct before participating.

---

License

This project is licensed under the GNU General Public License (GPL).  
You are free to use, modify, and redistribute this software under the terms of the GNU GPL.  
For full license details, see [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html).
