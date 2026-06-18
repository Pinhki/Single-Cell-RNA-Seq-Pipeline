Wan Lab scRNA-seq Pipeline
Install + Update Guide (One-Click)
Current release line: v0.5.1
Shipping is built on Mac, but package supports both macOS and Windows users.
Target app folder name: Wan_Lab_scRNA_seq_Pipeline

============================================================
QUICK START (DO THIS FIRST)
============================================================
If you already have the app:
1. Unzip the installer package.
2. Open the unzipped folder.
3. Double-click:
   - macOS: Install_or_Update_Mac.command
   - Windows: Install_or_Update_Windows.cmd
4. Wait for "Install/Update completed".
5. Start app from target folder:
   - macOS: Launch_mac.command
   - Windows: Launch_Windows.bat

Package contents should be:
- payload_full.wanpkg
- Install_or_Update_Mac.command
- Install_or_Update_Windows.cmd
- README_Install_Update.txt


============================================================
SECTION 1 - UPDATE (EXISTING USERS)
============================================================
Use this section if you already have an older version installed.

What updater does automatically:
- Uses target folder: Wan_Lab_scRNA_seq_Pipeline
- Creates backup at backup_updates/backup_YYYYMMDD_HHMMSS
- Preserves package_libraries/ and python_envs/
- Replaces app files from payload_full.wanpkg
- Cleans junk files

macOS update steps:
1. Unzip package.
2. Open folder.
3. Double-click Install_or_Update_Mac.command.
4. If blocked by macOS security: right-click -> Open -> Open.
5. Open Wan_Lab_scRNA_seq_Pipeline.
6. Double-click Launch_mac.command.

Windows update steps:
1. Unzip package.
2. Open folder.
3. Double-click Install_or_Update_Windows.cmd.
4. Keep the window open until completion.
5. Open Wan_Lab_scRNA_seq_Pipeline.
6. Double-click Launch_Windows.bat.


============================================================
SECTION 2 - FIRST INSTALL (NEW USERS)
============================================================
macOS first install:
1. Unzip package.
2. Double-click Install_or_Update_Mac.command.
3. Open Wan_Lab_scRNA_seq_Pipeline.
4. Double-click Launch_mac.command.

Windows first install:
1. Unzip package.
2. Double-click Install_or_Update_Windows.cmd.
3. Open Wan_Lab_scRNA_seq_Pipeline.
4. Double-click Launch_Windows.bat.


============================================================
SECTION 3 - IMPORTANT NOTES
============================================================
- Do not run app by opening Content/app.R directly.
- Always start from launcher (Launch_mac.command or Launch_Windows.bat).
- Do not manually delete package_libraries/ or python_envs/.


============================================================
SECTION 4 - TROUBLESHOOTING
============================================================
Problem: "Bootstrap status not found"
Fix: Start app from launcher only (not app.R directly).

Problem: macOS says command cannot be executed
Fix: Right-click .command -> Open.

Problem: Windows window closes too fast
Fix: Run updater from Command Prompt to view logs.
