require("custom.commands")
require("custom.autocmds")

return {
  unpack(require("custom.plugins.themes")),
  unpack(require("custom.plugins.image-stuff")),
  unpack(require("custom.plugins.git-stuff")),
  unpack(require("custom.plugins.buffer-stuff")),
}
