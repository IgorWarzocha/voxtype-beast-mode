# Voxtype BEAST MODE

Upgrade your Voxtype experience with high-fidelity Whisper models, AI-powered British English cleanup, technical instruction formatting, and robust Hyprland integration. A lot of work put into enabling "lazy keypresses" that don't trigger multiple system keybinds while typing, and ensuring somewhat consistent activation via push to talk (if sticks, toggle will deactivate). Check benchmarks folder for more info and demos.

Assumes you have Omarchy, somewhat correctly configured Voxtype and a snappy completions endpoint available (min 8GB VRAM models recommended, non thinking).

## Features
- **High-Accuracy Transcription**: Support for quantized 8-bit Whisper models (Medium Q8) for near-perfect local capture.
- **Stable Triggers**: A custom "Smart Stop" script and Hyprland submap strategy that handles "sloppy" key releases (letting go of mods before the key).
- **Modifier Suppression**: Automatically blocks Super/Ctrl/Alt while Voxtype is typing to prevent accidental shortcut triggers.
- **Three Strategic Modes**:
  - **General Mode**: Casual British English (mate, cheers) with aggressive noise/filler removal. (SUPER CTRL X)
  - **Coding Mode**: Spoken technical thoughts compiled into professional `backtick`-wrapped specifications. (SUPER CTRL C)
  - **Business Mode**: LinkedIn/Email ready posts with formal British grammar. (SUPER CTRL Z)
- **Dual LLM Backend**: Switch between **Cloud (Gemini 2.5 Flash)** or **Local (Qwen/Llama)** for post-processing.

## Installation

### 1. Requirements
Ensure you have the latest `voxtype` installed along with these dependencies:
```bash
# Arch Linux
sudo pacman -S wtype wl-clipboard curl jq
```

### 2. High-Accuracy Model Setup
For the best local transcription, download the 8-bit quantized Medium English model:
```bash
mkdir -p ~/.local/share/voxtype/models/
curl -L -o ~/.local/share/voxtype/models/ggml-medium.en-q8_0.bin \
  https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.en-q8_0.bin
```

### 3. Deploy Beast Mode Files
```bash
# Create directory structure
mkdir -p ~/.config/voxtype/beast-mode
mkdir -p ~/.config/hypr/scripts

# Copy repo contents (from this folder)
cp -r configs scripts prompts ~/.config/voxtype/beast-mode/

# Deploy the robust stop helper
cp scripts/voxtype-smart-stop.sh ~/.config/hypr/scripts/

# Ensure scripts are executable
chmod +x ~/.config/voxtype/beast-mode/scripts/*.sh
chmod +x ~/.config/hypr/scripts/voxtype-smart-stop.sh
```

### 4. Configure Voxtype Daemon
Edit `~/.config/voxtype/config.toml` to use the new model and router script:

```toml
[whisper]
model = "ggml-medium.en-q8_0.bin"

[output]
type_delay_ms = 0  # 0ms is safe with modifier suppression

[output.post_process]
command = "/home/YOUR_USER/.config/voxtype/beast-mode/scripts/router.sh"
timeout_ms = 30000
```
*Restart the daemon:* `systemctl --user restart voxtype`

### 5. Robust Hyprland Bindings
Add these to your `hyprland.conf` or `bindings.conf` for rock-solid "Hold-to-Talk" performance:

```hyprlang
# --- Voxtype Beast Mode Triggers ---

# 1. Start on Press (writes mode to tmp and starts recording)
bindd = SUPER CTRL, X, Standard Dictation, exec, echo "general" > /tmp/voxtype_mode && voxtype record start
bindd = SUPER CTRL, C, Coding Dictation, exec, echo "coding" > /tmp/voxtype_mode && voxtype record start
bindd = SUPER CTRL, Z, LinkedIn Dictation, exec, echo "business" > /tmp/voxtype_mode && voxtype record start

# 2. Smart Stop on Release
# This handles "sloppy" releases of X, C, Z, or the modifiers themselves.
bindrn = SUPER CTRL, X, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = SUPER CTRL, C, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = SUPER CTRL, Z, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = , X, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = , C, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = , Z, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = , SUPER_L, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh
bindrn = , Control_L, exec, ~/.config/hypr/scripts/voxtype-smart-stop.sh

# 3. Suppression Submap
# Prevents modifiers from messing up the typed text if you are still physically holding them.
submap = voxtype_suppress
bind = , SUPER_L, exec, true
bind = , SUPER_R, exec, true
bind = , Control_L, exec, true
bind = , Control_R, exec, true
bind = , Alt_L, exec, true
bind = , Alt_R, exec, true
submap = reset
```

## ⚙️ Backend Selection
By default, Beast Mode uses **Gemini 2.5 Flash** via (https://github.com/Mirrowel/LLM-API-Key-Proxy)[https://github.com/Mirrowel/LLM-API-Key-Proxy] . To switch to a local LLM, edit `~/.config/voxtype/beast-mode/scripts/cleanup-template.sh`. I've tested qwen3 4b instruct 2507 & gemma3 en4b. Wouldn't go below that.

```bash
# Switch between Option 1 (Gemini) and Option 2 (Local LM Studio)
API_URL="http://localhost:1234/v1/chat/completions"
MODEL="qwen3-4b-instruct"
```
