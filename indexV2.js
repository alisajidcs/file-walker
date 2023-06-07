const fs = require('fs')
const { join, basename, resolve } = require('path')

const ROOT = resolve('.')

const getFileData = (filePath) => {
  const { size, isDirectory, birthtime: createdAt } = fs.statSync(filePath)
  const formattedCreatedAt = createdAt
    .toLocaleDateString('en-GB')
    .replace(/\//g, '-')
  return {
    fileName: basename(filePath),
    filePath: filePath.replace(ROOT, ''),
    size,
    isDirectory: isDirectory.call(fs.statSync(filePath)),
    createdAt: formattedCreatedAt,
  }
}

const main = (argPath) => {
  return new Promise((resolve, reject) => {
    try {
      const isDirectory = fs.statSync(argPath).isDirectory()
      if (isDirectory) {
        const files = fs.readdirSync(argPath)
        const data = []
        files.forEach(async (file) => {
          const filePath = join(argPath, file)
          data.push(getFileData(filePath))
        })
        data.sort((a, b) => a.fileName.localeCompare(b.fileName))
        resolve(data)
      } else {
        resolve([getFileData(argPath)])
      }
    } catch (err) {
      reject(new Error('Invalid Path'))
    }
  })
}

module.exports = main
