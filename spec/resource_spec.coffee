{ipso, mock, tag, define} = require 'ipso'

define so:                          -> ->
define world:                      -> ->
#define is:                       -> -> ->
define a:                          -> ->
define leaf:                        -> -> 


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


    context 'recurse', ipso (a, leaf) -> 

        context 'reveal', ipso (so, world) -> 

            so world is a leaf -> 
            so tree: is: -> a ->

