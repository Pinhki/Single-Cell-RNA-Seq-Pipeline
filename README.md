# scRNA-seq Pipeline

R Shiny application for single-cell RNA sequencing analysis. The current source declares version 0.5.2. It provides separate Seurat 4 and Seurat 5 environments, data import, quality control, integration, interactive data browsing, downstream analysis, and workspace recovery.

## Workflow

1. Prepare the Seurat environment in the application.
2. Import raw expression inputs, or restore a saved workspace from the workspace page.
3. Review sample metadata and available hashtag or VDJ associations.
4. Review quality control and run normalization, integration and dimensional reduction for the chosen Seurat version.
5. Inspect objects in Analysis and Data Browser, then export results or save a workspace.

Method availability depends on the selected runtime, installed dependencies and required inputs. The presence of a backend does not establish independent scientific validation.

## Run from source

Install R 4.4.3. RStudio is optional. Internet access is required for dependency bootstrap; some packages require platform build tools and system libraries.

```sh
git clone https://github.com/Pinhki/Single-Cell-RNA-Seq-Pipeline.git
cd Single-Cell-RNA-Seq-Pipeline
```

On macOS, run `bash Launch_mac.sh` from the repository directory. On Windows, open `Launch_Windows.bat`. Start through the launcher rather than opening `Content/app.R` directly. The launchers call `Content/run.R`, which prepares project-managed dependencies.

Runtime libraries belong in `package_libraries/` and Python environments in `python_envs/`. Preserve these directories when updating. They are not included in the source repository. The bootstrap prepares the Seurat environments; its dependency policy is described in [package.md](package.md).

The existing [installation guide](installation.md) and [installer guide](README_Install_Update.txt) also describe packaged distributions. This source repository does not supply the prebuilt installer payload mentioned in those guides.

A clean installation and full analysis workflows have not been tested for this publication. No external user count or adoption claim is asserted.

## Source layout

- `Content/core/`: scientific backends and Seurat-version-specific methods.
- `Content/interface/`: Shiny pages and shared controls.
- `Content/www/`: browser assets.
- `scripts/` and `tests/`: targeted checks and development tests.

## Public history and data

This public copy derives from the existing local development repository. Its exported history follows the retained code paths. Commit identifiers differ from the original because data, installed libraries, local environments and internal agent material were excluded. The original repository remains unchanged. The public copy removes personal startup-blocklist entries and updates old permission notices to GPL-3.0. `Content/run.R` is added from the current source with those personal entries removed; its earlier revisions are not exported.

Sequencing matrices, analysis outputs, saved R sessions, credentials and local runtime paths are not supplied. Supply your own authorized data. Do not upload private data to GitHub Issues.

## License

Copyright Pinhki. Original project code is licensed under the [GNU General Public License version 3](LICENSE) (`GPL-3.0-only`). Third-party components retain their own licenses; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
