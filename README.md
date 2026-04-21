# Silahis PubVerse — Competition Laptop Management Scripts

Scripts for managing user accounts on Windows and macOS laptops during the Silahis PubVerse journalism competition.

---

## Windows (PowerShell)

> All scripts must be run as **Administrator**.

| Script | Purpose |
|---|---|
| `check_users.ps1` | List all local user accounts |
| `create_user.ps1` | Create a single user |
| `bulk_create_users.ps1` | Create multiple users from a CSV |
| `remove_user.ps1` | Remove a user (optionally delete profile) |
| `users_template.csv` | CSV template for bulk creation |

### Usage

```powershell
# Check users
powershell -ExecutionPolicy Bypass -File check_users.ps1

# Create one user
powershell -ExecutionPolicy Bypass -File create_user.ps1 -Username "competitor1" -Password "Pass123!" -FullName "Juan dela Cruz"

# Bulk create from CSV
powershell -ExecutionPolicy Bypass -File bulk_create_users.ps1 -CsvPath "users_template.csv"

# Remove a user
powershell -ExecutionPolicy Bypass -File remove_user.ps1 -Username "competitor1"

# Remove a user and delete their profile folder
powershell -ExecutionPolicy Bypass -File remove_user.ps1 -Username "competitor1" -DeleteProfile
```

---

## macOS (Bash)

> All scripts must be run with **sudo**.

| Script | Purpose |
|---|---|
| `check_users.sh` | List all local user accounts |
| `create_user.sh` | Create a single user |
| `bulk_create_users.sh` | Create multiple users from a CSV |
| `remove_user.sh` | Remove a user (optionally delete home folder) |
| `users_template.csv` | CSV template for bulk creation |

### Usage

```bash
# Check users
bash check_users.sh

# Create one user
sudo bash create_user.sh competitor1 "Juan dela Cruz" Pass123!

# Bulk create from CSV
sudo bash bulk_create_users.sh users_template.csv

# Remove a user
sudo bash remove_user.sh competitor1

# Remove a user and delete home folder
sudo bash remove_user.sh competitor1 --delete-home
```

---

## CSV Format

Both platforms use the same column structure:

```
Username,FullName,Password,Description
competitor1,Juan dela Cruz,Pass123!,Journalism Competition User
```

Edit `users_template.csv` in the relevant platform folder before running bulk scripts.
