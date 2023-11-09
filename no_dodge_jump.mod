return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`no_dodge_jump` encountered an error loading the Darktide Mod Framework.")

		new_mod("no_dodge_jump", {
			mod_script       = "no_dodge_jump/scripts/mods/no_dodge_jump/no_dodge_jump",
			mod_data         = "no_dodge_jump/scripts/mods/no_dodge_jump/no_dodge_jump_data",
			mod_localization = "no_dodge_jump/scripts/mods/no_dodge_jump/no_dodge_jump_localization",
		})
	end,
	packages = {},
}
