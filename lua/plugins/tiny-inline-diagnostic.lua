return {
	'rachartier/tiny-inline-diagnostic.nvim',
	event = 'LspAttach',
	priority = 1000,
	config = function()
		require('tiny-inline-diagnostic').setup({
			preset = 'modern', -- can be 'modern', 'classic', 'minimal', 'powerline', 'ghost', 'simple', 'nonerdfont', 'amongus'
			hi = {
				error = 'DiagnosticError',
				warn = 'DiagnosticWarn',
				info = 'DiagnosticInfo',
				hint = 'DiagnosticHint',
				arrow = 'NonText',
				background = 'CursorLine', -- can be a highlight or a hexadecimal color (#RRGGBB)
				mixing_color = 'None', -- can be None or a hexadecimal color (#RRGGBB)
			},
			options = {
				-- Show the source of the diagnostic
				show_source = true,

				-- Use your defined signs in the diagnostic config table
				use_icons_from_diagnostic = false,

					-- Add messages to the diagnostic when multilines is enabled
					add_messages = true,

				-- Throttle the update of the diagnostic when moving cursor, in milliseconds
				-- You can increase it if you have performance issues.
				-- Or set it to 0 to have better visuals.
				throttle = 20,

				-- The minimum length of the message, otherwise it will be on a new line
				softwrap = 30,

				-- If multiple diagnostics are under the cursor, display all of them.
				multiple_diag_under_cursor = true,

				-- Enable diagnostic message on all lines
				multilines = true,

				-- Show all diagnostics on the cursor line.
				show_all_diags_on_cursorline = true,

				-- Enable diagnostics on insert mode. You should also set the 'throttle' option to 
				-- 0, as some artifacts may appear.
				enable_on_insert = false,

				overflow = {
					-- Manage the overflow of the message.
					--	- wrap: when the message is too long, it is then displayed on multiple lines
					--	- none: the message will not be truncated
					--	- oneline: message will be displayed entirely on one line
					mode = 'wrap',
				},

				-- Format the diagnostic message.
				-- Example:
				-- format = function(diagnostic)
				--	return diagnostic.message .. " [" .. diagnostic.source .. "]"
				-- end
				format = nil,

				-- Enable if you want to always have message with 'after' characters length.
				break_line = {
					enabled = true,
					after = 30,
				},

				virt_texts = {
					priority = 2048,
				},

				-- Filter by severity
				severity = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},

				-- Overflow events to attach to a buffer, You should not change it, but if the 
				-- plugin does not work in your configuration, you may try to tweak it.
				overwrite_events = nil,
			},
		})
	end
}
