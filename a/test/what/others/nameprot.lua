local a={ProtectedName="User",OtherPlayers=false,OtherPlayersTemplate="NameProtect",RenameTextBoxes=false,UseFilterPadding=true,FilterPad=" ",UseMetatableHook=true,UseAggressiveFiltering=false}local b={}local c=1;if a.OtherPlayers then for d,V in pairs(game:GetService("Players"):GetPlayers())do local e=a.OtherPlayersTemplate..tostring(c)if a.UseFilterPadding then if string.len(e)>string.len(V.Name)then e=string.sub(e,1,string.len(V.Name))elseif string.len(e)<string.len(V.Name)then local f=string.len(V.Name)-string.len(e)for d=1,f do e=e..a.FilterPad end end end;b[V.Name]=e;c=c+1 end;game:GetService("Players").PlayerAdded:connect(function(g)local e=a.OtherPlayersTemplate..tostring(c)if a.UseFilterPadding then if string.len(e)>string.len(V.Name)then e=string.sub(e,1,string.len(V.Name))elseif string.len(e)<string.len(V.Name)then local f=string.len(V.Name)-string.len(e)for d=1,f do e=e..a.FilterPad end end end;b[g.Name]=e;c=c+1 end)end;local h=game:GetService("Players").LocalPlayer.Name;local i=game.IsA;if a.UseFilterPadding then if string.len(a.ProtectedName)>string.len(h)then a.ProtectedName=string.sub(a.ProtectedName,1,string.len(h))elseif string.len(a.ProtectedName)<string.len(h)then local f=string.len(h)-string.len(a.ProtectedName)for d=1,f do a.ProtectedName=a.ProtectedName..a.FilterPad end end end;local function j(k)local l=k;if a.OtherPlayers then for d,V in pairs(b)do l=string.gsub(l,d,V)end end;l=string.gsub(l,h,a.ProtectedName)return l end;for d,V in pairs(game:GetDescendants())do if a.RenameTextBoxes then if i(V,"TextLabel")or i(V,"TextButton")or i(V,"TextBox")then V.Text=j(V.Text)if a.UseAggressiveFiltering then V:GetPropertyChangedSignal("Text"):connect(function()V.Text=j(V.Text)end)end end else if i(V,"TextLabel")or i(V,"TextButton")then V.Text=j(V.Text)if a.UseAggressiveFiltering then V:GetPropertyChangedSignal("Text"):connect(function()V.Text=j(V.Text)end)end end end end;if a.UseAggressiveFiltering then game.DescendantAdded:connect(function(V)if a.RenameTextBoxes then if i(V,"TextLabel")or i(V,"TextButton")or i(V,"TextBox")then V:GetPropertyChangedSignal("Text"):connect(function()V.Text=j(V.Text)end)end else if i(V,"TextLabel")or i(V,"TextButton")then V:GetPropertyChangedSignal("Text"):connect(function()V.Text=j(V.Text)end)end end end)end;if a.UseMetatableHook then if not getrawmetatable then error("GetRawMetaTable not found")end;local m=function(n)if newcclosure then return newcclosure(n)end;return n end;local o=function(p,V)if setreadonly then return setreadonly(p,V)end;if not V and make_writeable then return make_writeable(p)end;if V and make_readonly then return make_readonly(p)end;error("No setreadonly found")end;local p=getrawmetatable(game)local q=p.__newindex;o(p,false)p.__newindex=m(function(r,s,V)if a.RenameTextBoxes then if(i(r,"TextLabel")or i(r,"TextButton")or i(r,"TextBox"))and s=="Text"and type(V)=="string"then return q(r,s,j(V))end else if(i(r,"TextLabel")or i(r,"TextButton"))and s=="Text"and type(V)=="string"then return q(r,s,j(V))end end;return q(r,s,V)end)o(p,true)end
