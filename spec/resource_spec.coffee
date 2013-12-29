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

        it 'creates a reference, with handler, for each file resource', 

            ipso (facto, Resource, _testInstance, fs) -> 

                fs.does 


                    lstatSync: (path) -> 

                        switch path.split('/').pop() 

                            when 'dir' then return isDirectory: -> true

                            when 'file' then return isDirectory: -> false

                            when 'file.png' then return isDirectory: -> false

                        original arguments



                    readdirSync: (path) -> 

                        switch path 

                            when 'path/to/resource' 

                                return ['dir', 'file.png']

                            when 'path/to/resource/dir' 

                                return ['file']

                            when 'path/to/resource/dir/file' 

                                return ['TODO']

                            when 'path/to/resource/file.png'

                                return ['TODO']

                        original arguments



                _testInstance.recurse 'path/to/resource'

                # console.log JSON.stringify _testInstance.sources, null, 2

                _testInstance.sources['dir']['file'].meta.should.eql 

                    type: 'file'
                    path: 'path/to/resource/dir/file'


                _testInstance.sources['file.png'].meta.should.eql 

                    type: 'file'
                    path: 'path/to/resource/file.png'


                #
                # handler
                #

                _testInstance.sources['file.png'] {}, (err, res) -> 

                    res.should.eql result: {}
                    facto()







