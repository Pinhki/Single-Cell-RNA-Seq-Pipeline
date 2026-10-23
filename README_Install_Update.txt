scRNA-seq Pipeline
Run and Update from Source

Requirements
- R 4.4.3. RStudio is optional.
- Internet access for initial dependency installation.
- Platform build tools and system libraries may be needed for compiled packages.

Start
1. Clone or download this repository.
2. macOS: run bash Launch_mac.sh in the repository directory.
3. Windows: open Launch_Windows.bat.
4. Let Content/run.R prepare the project-managed dependencies.

Do not start Content/app.R directly.

Update
Save your workspaces and back up local changes before updating the source.
Preserve package_libraries/, python_envs/ and your research inputs and outputs.
This repository does not contain the prebuilt installer payload.

Original code: GPL-3.0-only. Copyright Pinhki.
See README.md, LICENSE and THIRD_PARTY_NOTICES.md.
