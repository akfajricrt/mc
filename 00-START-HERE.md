# 🚀 START HERE - mc Tool Setup

Ini adalah panduan untuk membuat versi **pribadi Anda** dari `mc` - Claude Code tool switcher.

## 📦 Files yang Sudah Disiapkan

```
outputs/
├── 00-START-HERE.md           ← Anda sekarang di sini!
├── SETUP-GUIDE.md             ← Step-by-step setup di GitHub
├── README-CUSTOM.md           ← Template README untuk repo Anda
├── CHEATSHEET.md              ← Quick reference guide
├── GEMINI-SETUP.md            ← Gemini + LiteLLM setup guide
├── mc                         ← Main executable script
├── install-custom.sh          ← Installer script (rename ke install.sh)
├── uninstall.sh               ← Uninstaller script (keep as is)
└── config.json.example        ← Config template
```

## 🎯 Yang Perlu Anda Lakukan

### Opsi 1: Setup Cepat (Recommended)

1. **Baca SETUP-GUIDE.md** - Full step-by-step instructions
   - Sudah lengkap dari awal sampe publikasi ke GitHub

2. **Follow instruksi**:
   - Customize file-file
   - Create GitHub repository
   - Push ke GitHub
   - Test installation

### Opsi 2: Setup Manual

1. **Prepare lokal**:
   ```bash
   mkdir ~/projects/mc
   cd ~/projects/mc
   
   # Copy files dari outputs
   cp ~/Downloads/mc .
   cp ~/Downloads/install-custom.sh install.sh
   cp ~/Downloads/config.json.example .
   cp ~/Downloads/README-CUSTOM.md README.md
   ```

2. **Customize files**:
   - Edit `install.sh` - ubah REPO_OWNER dan REPO_NAME
   - Edit `mc` - ubah TOOL_NAME dan AUTHOR
   - Edit `README.md` - ubah GitHub URLs
   - Create `.gitignore`

3. **Initialize Git**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: mc tool"
   ```

4. **Create GitHub repo** at https://github.com/new
   - Name: `mc` (atau nama pilihan Anda)
   - Public
   - Don't initialize

5. **Push ke GitHub**:
   ```bash
   git remote add origin https://github.com/yourusername/mc.git
   git branch -M main
   git push -u origin main
   ```

6. **Test**:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
   ```

## 📋 File Descriptions

### `mc` (Main Script)
- Executable utama yang user jalankan
- Support: setup, list, config, help
- Shortcuts: deep, kimi, openrouter
- Fully customizable

### `install.sh`
- One-line installer script
- Download `mc` ke `~/.local/bin/`
- Create config directory
- Customizable REPO_OWNER, REPO_NAME

### `config.json.example`
- Template konfigurasi
- Platform definitions (DeepSeek, Kimi, OpenRouter)
- User copy ke `~/.mc/config.json` dan fill API keys

### `README.md`
- Main documentation
- Installation instructions
- Usage examples
- Troubleshooting

### `SETUP-GUIDE.md`
- Panduan lengkap setup GitHub
- Step-by-step dengan examples
- Customization ideas
- Maintenance tips

### `CHEATSHEET.md`
- Quick reference untuk users
- Common commands
- Examples
- Tips & tricks

## 🔄 Customization Checklist

Sebelum publish ke GitHub, ubah:

- [ ] `install.sh` - Line 17-21
  ```bash
  TOOL_NAME="mc"
  REPO_OWNER="yourusername"    # ← Ganti ini
  REPO_NAME="mc"
  ```

- [ ] `mc` script - Line 18-20
  ```bash
  TOOL_NAME="mc"
  AUTHOR="Your Name"           # ← Ganti ini
  CONFIG_DIR="${MC_CONFIG_DIR:-$HOME/.mc}"
  ```

- [ ] `README.md` - All occurrences
  ```markdown
  https://raw.githubusercontent.com/yourusername/mc/main/install.sh
                                   ↑↑↑↑↑↑↑↑↑↑↑↑↑
                                   Change this
  ```

- [ ] Create `.gitignore` (see SETUP-GUIDE.md)

- [ ] Create `LICENSE` (optional, but recommended)

## 🚀 Installation Command

Setelah semuanya ready, bagikan ini:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
```

Ganti `yourusername` dengan GitHub username Anda.

## 📚 Quick Examples

Setelah setup, user bisa:

```bash
# Interactive
mc              # Default platform
mc kimi         # Switch to Kimi
mc openrouter   # Switch to OpenRouter

# With prompt
mc deep "write a function"
mc kimi "tulis dokumentasi"
mc openrouter "@gpt-4" "code review"

# Management
mc setup        # First time setup
mc list         # List platforms
mc config       # Edit configuration
mc help         # Show help
```

## 🎯 Next Steps

1. **Read SETUP-GUIDE.md** - Lengkap step-by-step
2. **Customize files** - Update REPO_OWNER, AUTHOR, etc
3. **Create GitHub repo** - Buat repository baru
4. **Push to GitHub** - git add, commit, push
5. **Test installation** - curl | bash
6. **Share** - Kirim install command ke teman

## 💡 Tips

### Rename Tool
Gak harus `mc`. Bisa:
- `cc` (short & simple)
- `claudio` (more personal)
- `mycode` (descriptive)

Just change `TOOL_NAME` dan rename files.

### Add More Platforms
Edit `mc` script, add case untuk platform baru:
```bash
custom)
  export_platform_vars "custom"
  ...
  ;;
```

Edit `config.json.example`, add platform definition.

### Multiple Configurations
Bisa create different config files:
- `~/.mc/config.json` - Main config
- `~/.mc/config.work.json` - Work config
- `~/.mc/config.personal.json` - Personal config

Modify script untuk support multiple configs.

## 🐛 Common Issues

**Files not found after download:**
- Check ~/Downloads/
- Make sure you downloaded from outputs

**GitHub doesn't recognize script:**
- Make sure to `git push -u origin main`
- Wait a minute for GitHub to update

**Installation fails:**
- Check REPO_OWNER dan REPO_NAME di install.sh
- Make sure files ada di GitHub main branch

## 📖 Detailed Guides

- `SETUP-GUIDE.md` - Full GitHub setup
- `README-CUSTOM.md` - Main documentation template
- `CHEATSHEET.md` - Quick reference untuk users

## ❓ Questions?

Refer to:
1. SETUP-GUIDE.md - Most comprehensive
2. README-CUSTOM.md - For user documentation
3. CHEATSHEET.md - For usage examples

---

## 🎉 Selesai!

Setelah semua setup, Anda punya:

✅ Personal Claude Code tool switcher  
✅ Published di GitHub  
✅ Easy one-line installation  
✅ Support multiple platforms  
✅ Full documentation  

Bagikan installer command ke orang lain dan mereka bisa langsung install! 🚀

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mc/main/install.sh | bash
```

Good luck! 🎯
