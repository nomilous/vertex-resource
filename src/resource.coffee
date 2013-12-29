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

                       

                        ### establish type is [file|dir] ###

                        if fs.lstatSync( path ).isDirectory()

                            vertex[next] ||= {}

                            vertex[next].meta = 

                                type: 'dir'
                                path: path

                            recursing path, fs.readdirSync(path), vertex[next], stack

                            path = dirname path
                            return stack.pop()




                        ### files get a handler ###

                        content = path.split('.').pop()
                        content = null if path is content

                        meta = type: 'file', path: path, content: content

                        vertex[next] = (opts, callback) -> 

                            switch meta.content

                                when 'js' 

                                    body = fs.readFileSync meta.path, 'utf8'

                                    return callback null, 

                                        headers: 

                                            'Content-Type': 'text/javascript'

                                        body: body



                            return callback null, 
                                statusCode: 500
                                body: error: 'unsupported'



                        vertex[next].$www = {}
                        vertex[next].meta = meta

                        path = dirname path
                        return stack.pop()


                catch error

                    console.log e2: error



            recursing path, fs.readdirSync(path), local.sources
            return local.sources


        catch error

            console.log e1: error

        




module.exports = (opts) -> 

    if 'string' is typeof opts

        path = opts

        try 

            stat = fs.lstatSync path

            if stat.isDirectory()

                return local.recurse path



        catch error

            console.log error


module.exports._testInstance = local