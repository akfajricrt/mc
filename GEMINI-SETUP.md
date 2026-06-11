# 🚀 Gemini Setup Guide (LiteLLM Proxy)

Panduan lengkap untuk setup Google Gemini dengan LiteLLM proxy agar bisa digunakan di `mc`.

## 🎯 Overview

Gemini memerlukan local proxy LiteLLM karena:
- ✅ Gemini API tidak kompatibel dengan Anthropic API secara langsung
- ✅ LiteLLM mengubah Gemini API menjadi format Anthropic-compatible
- ✅ Proxy berjalan lokal di port 4000

Flow:
```
mc gemini → http://127.0.0.1:4000 (LiteLLM Proxy) → Google Gemini API
```

## 📋 Requirements

- Python 3.8+ (check: `python3 --version`)
- pip (check: `pip3 --version`)
- Google account dengan akses Gemini API

## 🛠️ Step 1: Install LiteLLM

```bash
# Install LiteLLM
pip install litellm

# Verify installation
litellm --version
```

## 🔑 Step 2: Get Gemini API Key

1. Visit: https://aistudio.google.com/apikey
2. Click "Create API Key"
3. Copy the key (starts with `AIza-`)
4. Save it somewhere safe

## 📁 Step 3: Create LiteLLM Configuration

Create folder untuk Gemini setup:

```bash
mkdir ~/gemini-litellm
cd ~/gemini-litellm
```

Create `config.yaml`:

```bash
cat > config.yaml << 'EOF'
model_list:
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-1.5-pro-exp
      api_key: "os.environ/GEMINI_API_KEY"
  
  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-1.5-flash-exp
      api_key: "os.environ/GEMINI_API_KEY"
EOF
```

File structure sekarang:

```
~/gemini-litellm/
└── config.yaml
```

## 🚀 Step 4: Start LiteLLM Proxy

**PENTING: Buka terminal baru dan biarkan tetap terbuka!**

```bash
# Mac/Linux/WSL
export GEMINI_API_KEY="AIza-your-actual-key-here"
cd ~/gemini-litellm
litellm --config config.yaml --port 4000
```

Atau di Windows PowerShell:

```powershell
$env:GEMINI_API_KEY="AIza-your-actual-key-here"
cd $HOME\gemini-litellm
litellm --config config.yaml --port 4000
```

Expected output:

```
LiteLLM Proxy Server Starting
Available Routes:
  - /chat/completions (POST)
  - /models (GET)

Proxy Server running on http://0.0.0.0:4000
```

✅ Jika terlihat seperti di atas, LiteLLM sudah siap!

## 💻 Step 5: Gunakan di Terminal Baru

**Buka terminal baru** (jangan tutup terminal LiteLLM):

```bash
# Setup mc dengan Gemini
mc setup

# Pilih opsi 4 (Gemini)
# Ikuti instruksi

# Gunakan Gemini
mc gemini
```

## ✅ Verification

Test connection:

```bash
# Check if LiteLLM is running
curl http://127.0.0.1:4000/models

# Should return available models
```

Test dengan mc:

```bash
mc gemini "hello, what's your name?"
```

## 🔧 Troubleshooting

### LiteLLM command not found

```bash
# Install with pip
pip install litellm

# Or with pip3
pip3 install litellm
```

### Port 4000 already in use

```bash
# Use different port
litellm --config config.yaml --port 5000

# Then update config.json:
# Change base_url dari http://127.0.0.1:4000
# Menjadi http://127.0.0.1:5000
```

### API Key error

```bash
# Check if API key is set
echo $GEMINI_API_KEY

# If empty, set again:
export GEMINI_API_KEY="AIza-your-key"
```

### Connection refused

```bash
# Make sure LiteLLM is running
# Check terminal dengan litellm, harus ada:
# "Proxy Server running on http://0.0.0.0:4000"

# If not running, start it again
```

## 📝 Setup dalam ~/.mc/config.json

Saat `mc setup` memilih Gemini, config akan diset automatic:

```json
{
  "gemini": {
    "base_url": "http://127.0.0.1:4000",
    "api_key": "sk-dummy-token",
    "model": "gemini-pro",
    "small_model": "gemini-flash"
  }
}
```

Atau manual edit:

```bash
mc config
# Edit base_url jika port berbeda
```

## 🎯 Usage Examples

```bash
# Interactive mode
mc gemini

# With prompt
mc gemini "write a Python function"

# Specific model (di LiteLLM config)
mc gemini "create REST API"
```

## 🔄 Keep LiteLLM Running

```bash
# Terminal 1 (JANGAN TUTUP)
export GEMINI_API_KEY="AIza-..."
cd ~/gemini-litellm
litellm --config config.yaml --port 4000

# Terminal 2 (Gunakan mc disini)
mc gemini
mc gemini "code"
```

## 💡 Pro Tips

### 1. Create Alias untuk LiteLLM

Add ke `~/.zshrc` atau `~/.bashrc`:

```bash
alias gemini-start="export GEMINI_API_KEY='AIza-your-key' && cd ~/gemini-litellm && litellm --config config.yaml --port 4000"
```

Then:

```bash
gemini-start    # Start LiteLLM
```

### 2. Multiple Gemini Models

Edit `config.yaml`:

```yaml
model_list:
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-1.5-pro-exp
      api_key: "os.environ/GEMINI_API_KEY"
  
  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-1.5-flash-exp
      api_key: "os.environ/GEMINI_API_KEY"
  
  - model_name: gemini-2-flash
    litellm_params:
      model: gemini/gemini-2.0-flash-exp
      api_key: "os.environ/GEMINI_API_KEY"
```

### 3. Secure API Key Storage

Jangan hardcode API key. Options:

**Option A: .env file**

```bash
# Create ~/.env
echo "GEMINI_API_KEY=AIza-your-key" > ~/.env

# Load sebelum run LiteLLM
source ~/.env
litellm --config config.yaml --port 4000
```

**Option B: Macbook Keychain (Recommended)**

```bash
# Store di Keychain
security add-generic-password -a gemini_key -s GEMINI -w "AIza-your-key"

# Retrieve
security find-generic-password -a gemini_key -s GEMINI -w
```

**Option C: ~/.zshrc atau ~/.bashrc**

```bash
# Add ke ~/.zshrc
export GEMINI_API_KEY="AIza-your-key"

# Then reload
source ~/.zshrc
```

## 🔗 Resources

- **Google Gemini API:** https://aistudio.google.com/apikey
- **LiteLLM Docs:** https://docs.litellm.ai
- **Gemini Models:** https://ai.google.dev/models/gemini

## 🆘 Need Help?

Check:
1. LiteLLM terminal - ada error?
2. API key valid? - https://aistudio.google.com/apikey
3. Port 4000 open?
4. mc config tersetel benar?

## ⚙️ Advanced: Multiple Proxy Instances

Bisa jalankan multiple LiteLLM instances dengan port berbeda:

```bash
# Terminal 1: Gemini Pro
export GEMINI_API_KEY="AIza-..."
litellm --config config-pro.yaml --port 4000

# Terminal 2: Gemini Flash (berbeda port)
export GEMINI_API_KEY="AIza-..."
litellm --config config-flash.yaml --port 4001

# Update config di mc untuk use port 4001 untuk gemini-flash
```

---

**Happy coding with Gemini!** 🎉
