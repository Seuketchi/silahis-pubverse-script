# Silahis PubVerse — Competition Laptop Management Scripts

Scripts for managing user accounts on Windows and macOS laptops during the Silahis PubVerse journalism competition.

---

## Preparation Workflow

Follow these steps on **each laptop** before the competition starts.

### Step 1 — Open a terminal with admin/root access

**Windows:** Search for **PowerShell**, right-click it, and select **Run as Administrator**.

**macOS:** Open **Terminal** normally. You will prefix commands with `sudo`.

---

### Step 2 — Navigate to the scripts folder

**Windows:**
```powershell
cd C:\path\to\silahis-pubverse-script\windows
```

**macOS:**
```bash
cd /path/to/silahis-pubverse-script/macos
```

---

### Step 3 — Check existing users

Verify who is already on the laptop before adding anyone.

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -File check_users.ps1
```

**macOS:**
```bash
bash check_users.sh
```

---

### Step 4 — Create the competitor account

Use a generic username (e.g. `competitor1`, `competitor2`) and the standard competition password.

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -File create_user.ps1 -Username "competitor1" -Password "pubverse2026" -FullName "Competitor 1"
```

**macOS:**
```bash
sudo bash create_user.sh competitor1 "Competitor 1" pubverse2026
```

---

### Step 5 — Verify the account

Log out of the admin account and log in as the new competitor user to confirm it works. Then log back into the admin account before moving on.

---

### Step 6 — Repeat for each laptop

Each laptop gets one competitor account. Increment the username per laptop (`competitor1`, `competitor2`, etc.).

---

## After the Competition — Cleanup

Remove the competitor account from each laptop when the competition is done.

**Windows:**
```powershell
# Remove user and delete their profile folder
powershell -ExecutionPolicy Bypass -File remove_user.ps1 -Username "competitor1" -DeleteProfile
```

**macOS:**
```bash
# Remove user and delete their home folder
sudo bash remove_user.sh competitor1 --delete-home
```

---

## Script Reference

### Windows

| Script | Purpose |
|---|---|
| `check_users.ps1` | List all local user accounts |
| `create_user.ps1` | Create a competitor account |
| `remove_user.ps1` | Remove a competitor account |

### macOS

| Script | Purpose |
|---|---|
| `check_users.sh` | List all local user accounts |
| `create_user.sh` | Create a competitor account |
| `remove_user.sh` | Remove a competitor account |

---

## Notes

- Always run PowerShell as **Administrator** on Windows or commands will fail with `Access denied`.
- Always use `sudo` on macOS.
- The standard competition password is `pubverse2026` — change this each year.
- macOS scripts use `sysadminctl`, which is compatible with macOS Ventura, Sonoma, and Sequoia.
