###

  _____                  _          _           _             _____                    _ _
 / ____|                | |        | |         | |           |  __ \                  (_) |
| |  __ _ __ _   _ _ __ | |_       | | __ _  __| | ___ ______| |__) |_____      ___ __ _| |_ ___
| | |_ | '__| | | | '_ \| __|  _   | |/ _` |/ _` |/ _ \______|  _  // _ \ \ /\ / / '__| | __/ _ \
| |__| | |  | |_| | | | | |_  | |__| | (_| | (_| |  __/      | | \ \  __/\ V  V /| |  | | ||  __/
 \_____|_|   \__,_|_| |_|\__|  \____/ \__,_|\__,_|\___|      |_|  \_\___| \_/\_/ |_|  |_|\__\___| @coffee

###

module.exports = ( grunt ) ->

    grunt.registerTask 'jade-rewrite', ->

        fs = require 'fs'
        path = require 'path'

        base = path.join path.dirname( __filename ), '../../../../'

        page_sources = base + 'src/views/pages/'
        page_files = fs.readdirSync page_sources

        output = []

        for page in page_files

            view_name = path.basename page, '.jade'
            need_auth = '1'
            uri_rule = ''

            lines = fs.readFileSync( page_sources + page ).toString().split '\n'

            uri_rule_reg = new RegExp /- url = '([^']+)'/
            uri_auth_reg = new RegExp /- auth = '([^']+)'/

            for line in lines

                if uri_rule_reg.test line
                    uri_rule = line.match( uri_rule_reg )[1]

                if uri_auth_reg.test line
                    need_auth = 0


            output.push '\n\t"/' + uri_rule + '": { "view": "' + view_name + '", "auth": "' + need_auth + '"}'

        fs.writeFileSync base + 'bin/controllers/routers.json', '{' + output.join() + '\n}'
