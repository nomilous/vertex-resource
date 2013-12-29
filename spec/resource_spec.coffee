#
# {ipso, mock, tag, define} = require('vertex').then (i,o) -> 
# 

{ipso, mock, tag, define, original} = require 'ipso'

describe 'Resource', -> 

    context 'with opts as string', -> 


        before ipso (Resource) -> 

            mock 'lstatResult'
            tag Resource

        

        it 'determines if the string is a directory path', 

            ipso (Resource, lstatResult, fs) -> 

                fs.does lstatSync: (path) -> 

                    path.should.equal '/resource/directory'
                    lstatResult.does isDirectory: ->


                Resource '/resource/directory'



        it 'recurses the directory for resources', 

            ipso (Resource, _testInstance, lstatResult, fs) -> 

                fs.does lstatSync: (path) -> 

                    lstatResult.does isDirectory: -> true

                _testInstance.does recurse: (path) -> 

                    path.should.equal 'src/core'


                Resource 'src/core'


    context 'recurse', ipso -> 

        it 'creates a reference for each resource', 

            ipso (Resource, _testInstance, fs) -> 

                fs.does 


                    lstatSync: (path) -> 

                        switch path.split('/').pop() 

                            when 'dir' then return isDirectory: -> true

                            when 'file' then return isDirectory: -> false

                            when 'filetoo' then return isDirectory: -> false

                        original arguments



                    readdirSync: (path) -> 

                        switch path 

                            when 'path/to/resource' 

                                return ['dir', 'filetoo']

                            when 'path/to/resource/dir' 

                                return ['file']

                            when 'path/to/resource/dir/file' 

                                return ['TODO']

                            when 'path/to/resource/filetoo'

                                return ['TODO']

                        original arguments



                _testInstance.recurse 'path/to/resource'

                # console.log JSON.stringify _testInstance.sources, null, 2

                _testInstance.sources.should.eql 

                    dir:  

                        meta: 
                            type: 'dir', 
                            path: 'path/to/resource/dir'


                        file: 
                            meta: 
                                type: 'file', 
                                path: 'path/to/resource/dir/file'

                    filetoo: 

                        meta: 
                            type: 'file', 
                            path: 'path/to/resource/filetoo'







