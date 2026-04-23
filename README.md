# parrot-blueteam-setup
Ansible playbook to automate a Parrot OS Blue Team / SOC &amp; DFIR lab setup

## Manual installations

### Plaso (log2timeline)
Plaso was excluded from the Ansible role due to long install time.
Install manually when needed:
```bash
pip install plaso --break-system-packages
```

## Manual installations

### Plaso (log2timeline)
Excluded from Ansible role due to long install time. Install manually when needed:
\`\`\`bash
pip install plaso --break-system-packages
\`\`\`

### python-dfvfs / artifacts
Same reason — install manually:
\`\`\`bash
pip install dfvfs artifacts --break-system-packages
\`\`\`
