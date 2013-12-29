fs    = require 'fs'
{dirname}  = require 'path'

local = 

    sources: {}

    recurse: (opts) -> 

        if 'string' is typeof opts

            path = opts

        try 



            recursing = (path, array, vertex, stack = []) -> 

                try 

                    array.map (next) ->
                    
                        path += '/' + next

                        stack.push next

                        vertex[next] ||= {}


                        #
                        # establish type is [file|dir] 
                        #



                        if fs.lstatSync( path ).isDirectory()

                            vertex[next].meta = 
                            
                                type: 'dir'
                                path: path

                            recursing path, fs.readdirSync(path), vertex[next], stack

                            path = dirname path
                            
                            return stack.pop()




                        vertex[next].meta = 

                            type: 'file'
                            path: path

                        return stack.pop()


                catch error

                    console.log e2: error




            recursing path, fs.readdirSync(path), local.sources

            


        catch error

            console.log e1: error

        




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