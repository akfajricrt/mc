# 🎯 Step-by-Step Setup Guide - Create Your Own `mc`

Ini adalah panduan lengkap untuk membuat versi Anda sendiri dari `mc` dan publikasikan ke GitHub.

## 📋 Prerequisites

Anda perlu:
- GitHub account
- Git installed
- Basic knowledge of Git

## 🚀 Step 1: Setup Lokal

### 1.1 Buat folder project

```bash
mkdir ~/projects/mc
cd ~/projects/mc
```

### 1.2 Copy file-file dari outputs

Anda sudah punya:
- `mc` (main script)
- `install-custom.sh` (installer)
- `uninstall.sh` (uninstaller - NEW!)
- `config.json.example`
- `README-CUSTOM.md`

Copy ke folder:

```bash
cp ~/Downloads/mc ~/projects/mc/mc
cp ~/Downloads/install-custom.sh ~/projects/mc/install.sh
cp ~/Downloads/uninstall.sh ~/projects/mc/uninstall.sh
cp ~/Downloads/config.json.example ~/projects/mc/config.json.example
cp ~/Downloads/README-CUSTOM.md ~/projects/mc/README.md
```

### 1.3 Customize Files

**Edit `install.sh`:**

Ganti baris ini:

```bash
# Line 17-21
TOOL_NAME="mc"                    # 👈 Ubah ini jika mau nama lain
REPO_OWNER="yourusername"         # 👈 Ubah dengan username GitHub Anda
REPO_NAME="mc"                    # 👈 Ubah jika repo punya nama lain
REPO_RAW="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main"
```

Contoh:

```bash
TOOL_NAME="mc"
REPO_OWNER="rasupii"              # Username GitHub Anda
REPO_NAME="mc"
REPO_RAW="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main"
```

**Edit `mc` script:**

Ganti baris ini:

```bash
# Line 18-20
TOOL_NAME="mc"
AUTHOR="Your Name"
CONFIG_DIR="${MC_CONFIG_DIR:-$HOME/.mc}"
```

Contoh:

```bash
TOOL_NAME="mc"
AUTHOR="Rasupii"
CONFIG_DIR="${MC_CONFIG_DIR:-$HOME/.mc}"
```

**Edit `README.md`:**

Ganti bagian-bagian ini:

```markdown
# Line 7
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash

# Ubah menjadi:
curl -fsSL https://raw.githubusercontent.com/rasupii/mc/main/install.sh | bash
```

Dan bagian GitHub links:

```markdown
## 📝 Setup for GitHub

...

3. Update `install.sh`:
   ```bash
   REPO_OWNER="rasupii"     # 👈 Username Anda
   REPO_NAME="mc"
   ```
```

### 1.4 Test Lokal (Optional)

```bash
# Buat symlink untuk test
ln -s ~/projects/mc/mc ~/.local/bin/mc-test

# Test
mc-test setup
mc-test list
mc-test help

# Hapus symlink setelah test
rm ~/.local/bin/mc-test
```

## 📚 Step 2: Siapkan Repository GitHub

### 2.1 Buat Repository Baru

1. Buka https://github.com/new
2. Isi form:
   - Repository name: `mc` (atau nama pilihan Anda)
   - Description: "Claude Code with multiple model support"
   - Public (biar semua bisa install)
   - ✓ Initialize with README (uncheck, kita punya sendiri)
3. Klik "Create repository"

### 2.2 Clone atau Initialize Git

Di folder `~/projects/mc`:

```bash
git init
git config user.name "Your Name"
git config user.email "your@email.com"
```

### 2.3 Link ke GitHub

Setelah create repository, GitHub akan kasih instruksi:

```bash
git remote add origin https://github.com/yourusername/mc.git
git branch -M main
git add .
git commit -m "Initial commit: mc - Claude Code with multiple model support"
git push -u origin main
```

## 🎯 Step 3: Setup Repository Structure

### 3.1 File yang harus ada

```
mc/
├── README.md              # Dokumentasi
├── install.sh             # Installer script
├── uninstall.sh           # Uninstaller script (NEW!)
├── mc                     # Main executable (NO extension)
├── config.json.example    # Config template
├── .gitignore             # Ignore files
└── LICENSE                # Optional: MIT License
```

### 3.2 Buat `.gitignore`

```bash
cat > ~/projects/mc/.gitignore << 'EOF'
# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# User config (JANGAN di-commit!)
config.json

# Node
node_modules/
npm-debug.log

# Temp
*.tmp
*.bak
EOF
```

### 3.3 Buat LICENSE (Optional)

```bash
cat > ~/projects/mc/LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
EOF
```

## 🔄 Step 4: Push ke GitHub

```bash
cd ~/projects/mc

# Add all files
git add .

# Commit
git commit -m "Initial commit: mc - Claude Code with multiple model support"

# Push ke main branch
git push -u origin main

# Verify
# Kunjungi https://github.com/yourusername/mc
```

## ✅ Step 5: Test Installation

### 5.1 Test Install Command

Di terminal baru (atau logout/login):

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
```

Atau test lokal:

```bash
bash ~/projects/mc/install.sh
```

### 5.2 Verify Installation

```bash
which mc
mc --help
mc setup
```

## 📝 Step 6: Dokumentasi & Sharing

### 6.1 Update README

Pastikan README lengkap dengan:
- ✓ Installation command
- ✓ Quick start examples
- ✓ Supported platforms
- ✓ Configuration guide
- ✓ Troubleshooting

### 6.2 Create Release (Optional)

```bash
# Tag version
git tag v1.0.0
git push origin v1.0.0
```

Di GitHub:
- Klik "Releases" 
- Create release dari tag
- Add release notes

### 6.3 Share dengan Teman

```
Install mc:

curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash

Add to PATH:
export PATH="$HOME/.local/bin:$PATH"

Then run:
mc setup
```

## 🔧 Maintenance

### Update Code

```bash
cd ~/projects/mc

# Edit files
vim mc
vim install.sh
# etc

# Commit
git add .
git commit -m "Description of changes"

# Push
git push origin main
```

### Update Version

```bash
git tag v1.0.1
git push origin v1.0.1
```

### Uninstall Script

Users dapat uninstall dengan:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/uninstall.sh | bash
```

Jadi pastikan `uninstall.sh` di-commit juga:

```bash
git add uninstall.sh
git commit -m "Add uninstall script"
git push
```

## 🎨 Customization Ideas

### 1. Rename Tool

```bash
# Ubah install.sh
TOOL_NAME="claudio"          # Ganti dari "mc"

# Rename file
mv mc claudio

# Update README.md semua reference

# Commit
git add .
git commit -m "Rename: mc -> claudio"
git push
```

### 2. Add More Platforms

Edit `mc` script dan tambah platform baru:

```bash
# Find section "Platform shortcuts"

# Add:
custom)
  if [ ! -f "$CONFIG_FILE" ]; then
    setup_config
  fi
  export_platform_vars "custom"
  if [ $# -gt 0 ]; then
    exec claude "$@"
  else
    exec claude
  fi
  ;;
```

Edit `config.json.example`:

```json
{
  "platforms": {
    "custom": {
      "base_url": "https://api.custom.com/anthropic",
      "api_key": "",
      "model": "custom-model",
      "small_model": "custom-model"
    }
  }
}
```

### 3. Add Configuration Options

Edit `config.json.example` dan `mc` script untuk support opsi baru seperti:
- Default theme
- Auto-format settings
- Custom hooks
- etc

## 📊 Example Repository Structure

```
your-github-account/
└── mc/
    ├── README.md
    ├── install.sh
    ├── mc
    ├── config.json.example
    ├── .gitignore
    ├── LICENSE
    └── .git/ (hidden)
```

## 🎓 Final Checklist

- [ ] Files copied ke ~/projects/mc
- [ ] Customize install.sh (REPO_OWNER, REPO_NAME)
- [ ] Customize mc script (TOOL_NAME, AUTHOR)
- [ ] Customize README.md
- [ ] Create .gitignore
- [ ] Create LICENSE (optional)
- [ ] Initialize git (git init)
- [ ] Create GitHub repository
- [ ] Add remote (git remote add origin)
- [ ] First commit & push (git push)
- [ ] Test installation
- [ ] Share dengan orang lain!

## 🚀 Setelah Semuanya Siap

Sebarkan installer command:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
```

Orang lain cukup copy-paste satu baris, dan mereka sudah bisa pakai tool Anda! 🎉

---

Butuh bantuan? Cek troubleshooting di README.md atau buat GitHub Issue.
