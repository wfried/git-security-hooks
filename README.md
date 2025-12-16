# Git Security Hooks

A collection of Git pre-commit hooks to prevent accidental commits of sensitive data, credentials, and build artifacts.

## Features

The pre-commit hook checks for:

| Check | Examples |
|-------|----------|
| **Build Artifacts** | `.aws-sam/`, `node_modules/`, `DerivedData/`, `__pycache__/`, `.DS_Store` |
| **Local File Paths** | `/Users/username`, `/home/username`, `C:\Users\username` |
| **AWS Credentials** | Access keys (`AKIA...`), secret keys |
| **API Keys & Secrets** | `api_key=`, `secret=`, `token=` patterns |
| **Secret Files** | `.env`, `.pem`, `.key`, `credentials.json`, `Secrets.plist` |
| **Embedded Credentials** | `https://user:password@host.com` |
| **Private Keys** | RSA, DSA, EC, OpenSSH, PGP private key blocks |

## Installation

### Quick Install (in your repository)

```bash
# From this repository
./install.sh

# Or download and run
curl -sSL https://raw.githubusercontent.com/wfried/git-security-hooks/main/install.sh | bash
```

### Manual Install

```bash
# Copy the hook to your repository
cp hooks/pre-commit /path/to/your/repo/.git/hooks/pre-commit
chmod +x /path/to/your/repo/.git/hooks/pre-commit
```

## Usage

Once installed, the hook runs automatically on every `git commit`. If issues are detected:

```
🔍 Running pre-commit security checks...
  → Checking for build artifacts...
  → Checking for local file paths...
✗ ERROR: Local file path detected (e.g., /Users/username)
  Use relative paths or environment variables instead

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COMMIT BLOCKED: Security issues detected
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Bypassing (Not Recommended)

If you need to bypass the hook (e.g., for a false positive):

```bash
git commit --no-verify -m "Your message"
```

> ⚠️ **Warning**: Only bypass if you're certain the flagged content is safe.

## Customization

Edit `.git/hooks/pre-commit` to customize:

- **BLOCKED_PATHS**: Add/remove build artifact patterns
- **SECRET_FILES**: Add/remove secret file patterns

## Uninstall

```bash
rm .git/hooks/pre-commit
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

MIT License - See [LICENSE](LICENSE) for details.
