# === Volatility3 ===
volps()    { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.pslist; }
volnet()   { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.netstat; }
volfiles() { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.filescan; }
volcmd()   { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.cmdline; }
volhash()  { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.hashdump; }
volmalfind() { python3 ~/tools/dfir/volatility3/vol.py -f "$1" windows.malfind; }
volall() {
  local mem="$1"
  if [[ -z "$mem" ]]; then
    echo "Usage: volall <memory.dmp>"
    return 1
  fi
  echo "[*] Running full volatility analysis on $mem"
  local out="${mem%.dmp}_vol_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$out"
  echo "[*] pslist..."    && volps    "$mem" > "$out/pslist.txt"
  echo "[*] netstat..."   && volnet   "$mem" > "$out/netstat.txt"
  echo "[*] cmdline..."   && volcmd   "$mem" > "$out/cmdline.txt"
  echo "[*] hashdump..."  && volhash  "$mem" > "$out/hashdump.txt"
  echo "[*] malfind..."   && volmalfind "$mem" > "$out/malfind.txt"
  echo "[+] Done — results in $out/"
}

# === Disk forensics ===
alias autopsy='autopsy &>/dev/null &'

mountimg() {
  local img="$1"
  local mnt="${2:-/mnt/forensic}"
  if [[ -z "$img" ]]; then
    echo "Usage: mountimg <image> [mountpoint]"
    return 1
  fi
  sudo mkdir -p "$mnt"
  sudo mount -o ro,loop "$img" "$mnt"
  echo "[+] Mounted $img at $mnt (read-only)"
}

umountimg() {
  local mnt="${1:-/mnt/forensic}"
  sudo umount "$mnt"
  echo "[+] Unmounted $mnt"
}

mkimage() {
  local src="$1"
  local dst="$2"
  if [[ -z "$src" || -z "$dst" ]]; then
    echo "Usage: mkimage <source_device> <output.img>"
    return 1
  fi
  sudo dc3dd if="$src" of="$dst" hash=sha256 log="${dst}.log"
  echo "[+] Image created: $dst"
  echo "[+] Log: ${dst}.log"
}

# === File analysis ===
triage() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo "Usage: triage <file>"
    return 1
  fi
  echo "=== FILE INFO ==="
  file "$file"
  echo -e "\n=== HASHES ==="
  md5sum "$file"
  sha1sum "$file"
  sha256sum "$file"
  echo -e "\n=== EXIF ==="
  exiftool "$file" 2>/dev/null | head -30
  echo -e "\n=== STRINGS (top 20) ==="
  strings "$file" | head -20
  echo -e "\n=== ENTROPY ==="
  binwalk -E "$file" 2>/dev/null | tail -5
}

alias magic='file -b'
alias oleid='oleid'
alias olemeta='olemeta'
