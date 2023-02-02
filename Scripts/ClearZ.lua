-- Hack to clear the z-buffer AFTER the mask destination, since clearzbuffer will
-- clear it BEFORE the current object is rendered.
ClearZ = Def.Quad {
	InitCommand = cmd(stretchto,-2,-2,-1,-1;clearzbuffer,true),
}
