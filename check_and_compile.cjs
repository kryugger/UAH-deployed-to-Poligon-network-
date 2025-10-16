const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const folders = ['artifacts', 'typechain-types'];
const configFiles = ['hardhat.config.cjs', 'hardhat.config.js'];

// 🔍 Проверка наличия конфигурационного файла
const configPath = configFiles.find(file => fs.existsSync(path.join(process.cwd(), file)));

if (!configPath) {
  console.log('❌ Не найден файл конфигурации: hardhat.config.cjs или hardhat.config.js');
  process.exit(1);
}

// 📁 Проверка наличия папок
function checkFolder(folder) {
  const fullPath = path.join(process.cwd(), folder);
  return fs.existsSync(fullPath) && fs.lstatSync(fullPath).isDirectory();
}

const missingFolders = folders.filter(folder => !checkFolder(folder));

if (missingFolders.length === 0) {
  console.log('✅ Все папки уже существуют: ' + folders.join(', '));
  process.exit(0);
}

console.log('⚠️ Не найдены папки:', missingFolders.join(', '));
console.log('🚀 Запускаем компиляцию Hardhat...');

const compile = exec('npx hardhat compile');

compile.stdout.on('data', data => process.stdout.write(data));
compile.stderr.on('data', data => process.stderr.write(data));

compile.on('close', code => {
  if (code === 0) {
    console.log('✅ Компиляция завершена успешно!');
    folders.forEach(folder => {
      if (checkFolder(folder)) {
        console.log(`📦 Папка создана: ${folder}/`);
      } else {
        console.log(`❌ Папка не создана: ${folder}/`);
      }
    });

    // 🔧 Запуск TypeChain
    console.log('🔧 Генерация TypeChain...');
    const typechain = exec('npx typechain --target ethers-v6 --out-dir typechain-types');

    typechain.stdout.on('data', data => process.stdout.write(data));
    typechain.stderr.on('data', data => process.stderr.write(data));

    typechain.on('close', tcCode => {
      if (tcCode === 0) {
        console.log('✅ TypeChain завершён успешно!');
      } else {
        console.log(`❌ TypeChain завершился с ошибкой, код: ${tcCode}`);
      }
    });

  } else {
    console.log(`❌ Компиляция завершилась с ошибкой, код: ${code}`);
  }
});