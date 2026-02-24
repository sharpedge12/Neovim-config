return {
	{
		"SirVer/ultisnips",
		dependencies = {
			"honza/vim-snippets", -- Optional: a collection of useful snippets
		},
		config = function()
			-- Optional: Set UltiSnips directories or other settings here
			vim.g.UltiSnipsExpandTrigger = "<tab>"
			vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
			vim.g.UltiSnipsSnippetDirectories = { "UltiSnips"}
		end,
	},
}
