
require 'coffee-script'
converter = (require './clear').converter
fs = require 'fs'

source_name = process.argv[2]
source = fs.readFileSync source_name, 'utf-8'

filename = source_name.match /([a-z\-_]+\.)cl$/
newpath = filename[1]

converted = converter source
fs.writeFileSync "C/"+newpath+"c", converted, 'utf-8'