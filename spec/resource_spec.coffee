{ipso} = require 'ipso'

describe 'Resource', -> 

    context 'with opts as string', -> 

        it 'determines if the string is a directory path', 

            ipso (Resource, fs) -> 

                fs.does 

                    lstatSync: (path) -> 

                        path.should.equal '/resource/directory'
                        isDirectory: -> false

                Resource '/resource/directory'

