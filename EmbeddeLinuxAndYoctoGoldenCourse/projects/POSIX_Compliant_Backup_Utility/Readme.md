# POSIX-Compliant Backup Utility

A lightweight, strictly POSIX-compliant shell script designed to securely copy files to a specified destination directory. This utility is optimized for resource-constrained Embedded Linux environments where heavy interpreters like `bash` might not be available.

## Features
- **Argument Validation:** Ensures exactly two arguments (source and destination) are provided.
- **Source Verification:** Checks if the target source file actually exists before attempting operations.
- **Destination Verification:** Confirms the destination is a valid, existing directory.
- **POSIX Compliant:** Uses standard commands (`test`, `cp`) and strictly avoids Bashisms for maximum portability.
- **Robust Error Handling:** Returns proper exit statuses (`exit 1`) upon failure to integrate smoothly with other automated workflows.

## Prerequisites
Before running the script for the first time, ensure it has the correct execution permissions:
```sh
chmod u+x backup_tool.sh
```

## Usage
Run the script by providing the source file and the destination directory as arguments:
```sh
./backup_tool.sh <source_file> <destination_directory>
```

## Example
```sh
./backup_tool.sh main.c /home/user/backups/
```