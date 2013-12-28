fs = require 'fs'

module.exports = (opts) -> 

    if 'string' is typeof opts

        path = opts

        try 

            stat = fs.lstatSync path

            if stat.isDirectory() 

                -> 

        catch error

            console.log error
