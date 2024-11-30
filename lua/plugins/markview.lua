return {
    "OXY2DEV/markview.nvim",
			opts = {
        injections = {
            languages = {
                markdown = {
                    --- This disables other
                    --- injected queries!
                    overwrite = true,
                    query = [[
                        (section
                            (atx_headng) @injections.mkv.fold
                            (#set! @fold))
                    ]]
                }
            }
        }
			}
}
