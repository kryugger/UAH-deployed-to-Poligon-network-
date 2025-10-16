const fs = require("fs");
const path = require("path");

const artifactsDir = path.join(__dirname, "artifacts", "contracts");
const deployDir = __dirname; // ищем скрипты деплоя в корне проекта

// 1. Собираем ABI с конструкторами
function getConstructors() {
  const result = {};
  function walk(dir) {
    fs.readdirSync(dir).forEach(file => {
      const full = path.join(dir, file);
      if (fs.statSync(full).isDirectory()) {
        walk(full);
      } else if (file.endsWith(".json")) {
        const artifact = JSON.parse(fs.readFileSync(full, "utf8"));
        if (artifact.abi) {
          const ctor = artifact.abi.find(x => x.type === "constructor");
          const args = ctor ? ctor.inputs.length : 0;
          result[artifact.contractName] = args;
        }
      }
    });
  }
  walk(artifactsDir);
  return result;
}

// 2. Ищем вызовы deploy(...) в скриптах
function checkDeployScripts(ctors) {
  const files = fs.readdirSync(deployDir).filter(f => f.startsWith("deploy") && f.endsWith(".cjs"));
  files.forEach(file => {
    const code = fs.readFileSync(path.join(deployDir, file), "utf8");

    for (const [name, argsCount] of Object.entries(ctors)) {
      const regex = new RegExp(`\\.deploy\\(([^)]*)\\)`, "g");
      let match;
      while ((match = regex.exec(code)) !== null) {
        const inside = match[1].trim();
        const passedArgs = inside.length ? inside.split(",").length : 0;
        if (passedArgs !== argsCount) {
          console.log(
            `⚠️ Несостыковка в ${file} для ${name}: ожидает ${argsCount} арг., а передано ${passedArgs} → ${inside}`
          );
        }
      }
    }
  });
}

const ctors = getConstructors();
console.log("📦 Конструкторы контрактов:", ctors);
checkDeployScripts(ctors);
