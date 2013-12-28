fs = require 'fs'

local = 

    recurse: (path) -> 

        console.log recurse: path 



module.exports = (opts) -> 

    if 'string' is typeof opts

        path = opts

        try 

            stat = fs.lstatSync path

            if stat.isDirectory()

                local.recurse path



        catch error

            console.log error


module.exports._testInstance = local