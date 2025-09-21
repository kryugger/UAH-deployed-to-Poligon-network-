Write-Host "📁 Current directory: $PWD"

# 1. Use Node.js 18 via nvm if available
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "🔄 Switching to Node.js 18 via nvm..."
    nvm install 18
    nvm use 18
} else {
    Write-Host "⚠️ nvm not found. Please install Node.js 18 manually: https://nodejs.org/en/download"
}

# 2. Initialize Git if not already initialized
if (-not (Test-Path ".git")) {
    Write-Host "🔧 Initializing Git repository..."
    git init
}

# 3. Create .gitignore and add .env
$gitignorePath = ".gitignore"
if (-not (Test-Path $gitignorePath)) {
    Write-Host "📄 Creating .gitignore..."
    New-Item $gitignorePath -ItemType File
}
Add-Content $gitignorePath "`n.env"

# 4. Remove .env from Git index if previously added
git rm --cached .env 2>$null

# 5. Clean up dependencies
Write-Host "🧹 Removing node_modules and package-lock.json..."
Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
Remove-Item "package-lock.json" -ErrorAction SilentlyContinue

# 6. Install Hardhat and dependencies
Write-Host "📦 Installing Hardhat and project dependencies..."
npm install --save-dev hardhat@2.12.7
npm install

# 7. Compile project
Write-Host "🛠️ Compiling project..."
npx hardhat compile --config ./hardhat.config.cjs

Write-Host "`n✅ Setup complete! Project is compiled and ready."