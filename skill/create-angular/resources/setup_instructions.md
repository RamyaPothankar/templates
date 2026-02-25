# Angular Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Node.js)

This skill requires:
- Node.js (recommended 18.x+ or 20.x+)
- npm (bundled with Node)

### 1.1 Install Node.js using nvm

If a compatible version of Node.js is not installed, use the Node Version Manager (nvm) to install and manage it.

1.  **Install nvm:**
    ```bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    ```
2.  **Activate nvm:**
    ```bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    ```
3.  **Install and use the latest LTS Node.js version:**
    ```bash
    nvm install --lts
    nvm use --lts
    ```

### 1.2 Verify Installation
After installing, run the following commands to confirm that Node.js and npm are installed and correctly configured:
```bash
node -v
npm -v
```
If both commands return a version number, you can proceed to **Step 2**.

---

## 2. Create the project

This skill uses `npx` to run the Angular CLI without needing a global installation. This ensures the correct version of the CLI is used.

Set the workspace name:
- `WS_NAME="my-angular-app"`

Then scaffold the Angular application:

```bash
# This command uses a specific version of the Angular CLI to ensure Node.js compatibility
npx @angular/cli@17 new "$WS_NAME" \
  --routing \
  --style=scss \
  --standalone \
  --skip-install
```

## 3. Install dependencies
```bash
cd "$WS_NAME"
npm install
```

## 4. Configure Agent Rules

Create a file named `.agent/rules.md` inside the new workspace directory (`$WS_NAME`).

Copy the content from `skills/create-angular copy/agent/rules/angular.md` into the new `.agent/rules.md` file.

## 5. Run server
```bash
npx ng serve
```
