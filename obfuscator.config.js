module.exports = {
    compact: true,
    controlFlowFlattening: false, // Отключаем для стабильности
    controlFlowFlatteningThreshold: 0.75,
    deadCodeInjection: false, // Отключаем для стабильности
    deadCodeInjectionThreshold: 0.4,
    debugProtection: false, // Отключаем для стабильности
    debugProtectionInterval: 2000,
    disableConsoleOutput: false, // Оставляем консоль для отладки
    identifierNamesGenerator: 'hexadecimal',
    log: false,
    numbersToExpressions: true,
    renameGlobals: false,
    selfDefending: false, // Отключаем для стабильности
    simplify: true,
    splitStrings: true,
    splitStringsChunkLength: 10,
    stringArray: true,
    stringArrayEncoding: ['base64'],
    stringArrayThreshold: 0.75,
    transformObjectKeys: true,
    unicodeEscapeSequence: false
}; 