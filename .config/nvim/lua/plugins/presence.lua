local _2afile_2a = "/home/auscyber/.config/nvim/fnl/plugins/presence.fnl"
local _0_0
do
  local name_0_ = "plugins.presence"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local autoload = (require("aniseed.autoload")).autoload
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {autoload("presence")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {autoload = {presence = "presence"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local presence = _local_0_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "plugins.presence"
do local _ = ({nil, _0_0, nil, {{}, nil, nil, nil}})[2] end
return presence:setup({main_image = "file"})