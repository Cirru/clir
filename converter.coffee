
require 'coffee-script'
converter = (require './clear').converter
fs = require 'fs'

source_name = process.argv[2]
source = fs.readFileSync source_name, 'utf-8'

filename = source_name.match /([a-z\-_]+\.)clr$/
newpath = filename[1]

converted = converter source
fs.writeFileSync "target.c", converted, 'utf-8'