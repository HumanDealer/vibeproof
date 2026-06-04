# Security & Secrets — Never Commit a Secret

Secrets in git history are a permanent leak — rewriting history rarely fully
removes them, and bots scrape public pushes within seconds. Prevention is the
only reliable control.

---

## 1. What is a secret

API keys, tokens, passwords, private keys, connection strings, OAuth client
secrets, webhook signing keys, session secrets, cloud credentials. Common
shapes to recognize:

```
sk-[a-z0-9]{20,}          # generic API key
ghp_[a-z0-9]{30,}         # GitHub personal access token
xox[baprs]-...            # Slack token
AKIA[0-9A-Z]{16}          # AWS access key id
-----BEGIN ... PRIVATE KEY-----
Bearer [a-z0-9._-]{20,}   # bearer token
postgres://user:pass@host # connection string with inline password
```

---

## 2. Where secrets live (never in git)

- Local dev → a `.env` file that is **git-ignored**.
- CI / production → the platform's secret store (GitHub Actions secrets,
  your cloud's secret manager, a vault).
- Never hardcode. Never paste into a commit, a comment, an issue, or a PR.

Add to `.gitignore` from day one:

```
.env
.env.*
*.pem
*.key
secrets/
```

---

## 3. The scan (run before every commit)

```bash
# Preferred:
gitleaks detect --staged --no-git --verbose

# Fallback:
git diff --staged | grep -iE \
  'api[_-]?key|secret|password|token|bearer [a-z0-9]|sk-[a-z0-9]{20}|ghp_[a-z0-9]{30}'
```

**A hit → STOP.** Do not "just this once." Steps:

1. Unstage the change.
2. Move the value into `.env` / the secret manager.
3. If it was ever committed or pushed → **rotate the secret immediately**
   (assume it is compromised).
4. Reference it from code via an environment variable.

---

## 4. Input is hostile until proven safe

When handling anything that comes from a user, a file, or the network:

- **Validate and sanitize** before use. Assume it's malformed or malicious.
- **Never build SQL / shell / HTML by string concatenation** with untrusted
  input → use parameterized queries, safe APIs, proper escaping.
- **Least privilege** — credentials and tokens get the narrowest scope that works.
- **Don't log secrets** — redact tokens and keys before they hit logs.

---

## 5. Sharing work publicly (open source, demos, screenshots)

Before publishing anything outside your team:

- [ ] No real keys, tokens, internal hostnames, or IPs.
- [ ] No proprietary business logic, formulas, or customer data.
- [ ] No internal URLs, dashboards, or org-specific identifiers.
- [ ] Replace real values with obvious placeholders (`<YOUR_API_KEY>`).

When in doubt, leave it out. A leak can't be un-leaked.
