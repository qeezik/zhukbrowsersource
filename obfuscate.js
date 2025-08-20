const JavaScriptObfuscator = require('javascript-obfuscator');
const fs = require('fs');
const path = require('path');
const config = require('./obfuscator.config.js');

// Файлы для обфускации
const filesToObfuscate = [
    'main.js',
    'renderer.js',
    'preload.js',
    'updater.js',
    'proxy-fixes.js',
    'temp-proxies.js'
];

// Функция для обфускации файла
function obfuscateFile(filePath) {
    try {
        console.log(`Обфускация файла: ${filePath}`);
        
        // Читаем исходный файл
        const sourceCode = fs.readFileSync(filePath, 'utf8');
        
        // Обфусцируем код
        const obfuscationResult = JavaScriptObfuscator.obfuscate(sourceCode, config);
        
        // Создаем резервную копию
        const backupPath = filePath + '.backup';
        if (!fs.existsSync(backupPath)) {
            fs.writeFileSync(backupPath, sourceCode, 'utf8');
            console.log(`Создана резервная копия: ${backupPath}`);
        }
        
        // Записываем обфусцированный код
        fs.writeFileSync(filePath, obfuscationResult.getObfuscatedCode(), 'utf8');
        console.log(`Файл обфусцирован: ${filePath}`);
        
    } catch (error) {
        console.error(`Ошибка при обфускации ${filePath}:`, error.message);
    }
}

// Обфусцируем все файлы
console.log('Начинаем обфускацию...');
filesToObfuscate.forEach(file => {
    if (fs.existsSync(file)) {
        obfuscateFile(file);
    } else {
        console.log(`Файл не найден: ${file}`);
    }
});

console.log('Обфускация завершена!'); 