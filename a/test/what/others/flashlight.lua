local a=1;local b=.75;local c=32;local d=60;local e=game:GetService("Players")local f=e.LocalPlayer;local g=f.Backpack;local h=game:GetService("StarterGui")local i=Instance.new("Tool",g)i.GripPos=Vector3.new(0.1,-0.4,0)i.Name="Flashlight"i.TextureId="http://www.roblox.com/asset/?id=115955232"local j=Instance.new("Part",i)j.BrickColor=BrickColor.new("Bright yellow")j.Color=Color3.fromRGB(245,205,48)j.Name="Handle"j.Locked=true;j.Size=Vector3.new(0.5,0.5,2)j.CanCollide=true;local k=Instance.new("Part",i)k.BrickColor=BrickColor.new("Mid gray")k.Color=Color3.fromRGB(205,205,205)k.Transparency=1;k.Name="LightPart"k.CanCollide=false;k.Locked=true;k.Size=Vector3.new(0.2,0.2,0.2)local l=Instance.new("Motor",i)l.Part0=j;l.Part1=k;local m=Instance.new("Sound",j)m.SoundId="http://www.roblox.com/asset/?id=115959318"m.Volume=1;local n=Instance.new("SpecialMesh",j)n.Name="Mesh"n.MeshId="http://www.roblox.com/asset/?id=115955313"n.MeshType="FileMesh"n.Scale=Vector3.new(0.7,0.7,0.7)n.TextureId="http://www.roblox.com/asset?id=115955343"local o=Instance.new("SpotLight",k)o.Name="SpotLight"o.Angle=70;o.Brightness=a;o.Color=Color3.fromRGB(244,255,233)o.Enabled=false;o.Face="Front"o.Range=c;local p=Instance.new("SpotLight",k)p.Name="SpotLight2"p.Angle=70;p.Brightness=b;p.Color=Color3.fromRGB(244,255,233)p.Enabled=false;p.Range=d;local q=i;local r=.35;local s=115984370;local t=115955343;local u=q:WaitForChild("Motor")local v=q:WaitForChild("LightPart")local w=q:WaitForChild("Handle")local x=v:WaitForChild("SpotLight")local y=v:WaitForChild("SpotLight2")local z=w:WaitForChild("Mesh")local A=w:WaitForChild("Sound")local B=0;q.Equipped:connect(function(C)equipped=true;if C~=nil then themouse=C;C.Button1Down:connect(function()if B+r<tick()then x.Enabled=not x.Enabled;y.Enabled=x.Enabled;z.TextureId="http://www.roblox.com/asset?id="..tostring(x.Enabled and s or t)A:Play()B=tick()end end)end;if u~=nil then u.Parent=q end;while equipped and q.Parent~=nil do local D=q.Parent:FindFirstChild("Head")if x.Enabled and themouse and w and u and D then local E=themouse.Hit.p-D.Position;local F=(w.CFrame*CFrame.new(0,0,-1)).p;local G=CFrame.new(F,F+E)u.C0=w.CFrame:toObjectSpace(G)end;wait()end end)q.Unequipped:connect(function()if u~=nil then u.Parent=q end;equipped=false end)local H=i:clone()H.Parent=h
