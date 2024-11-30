return {
	"nvim-neorg/neorg",
		load = {
			["core.defaults"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = "~/notes",
					},
				},
			},
		},
}