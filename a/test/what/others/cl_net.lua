spawn(function()
  local i=string.byte;local h=string.char;local t=string.sub;local F=table.concat;local e=table.insert;local I=math.ldexp;local B=getfenv or function()return _ENV end;local C=setmetatable;local r=select;local d=unpack or table.unpack;local f=tonumber;local function s(d)local l,n,a="","",{}local c=256;local o={}for e=0,c-1 do o[e]=h(e)end;local e=1;local function i()local l=f(t(d,e,e),36)e=e+1;local n=f(t(d,e,e+l-1),36)e=e+l;return n end;l=h(i())a[1]=l;while e<#d do local e=i()if o[e]then n=o[e]else n=l..t(l,1,1)end;o[c]=l..t(n,1,1)a[#a+1],l,c=n,n,c+1 end;return table.concat(a)end;local f=s('21A21Q27521R21N27521Q22622L22N22A22A21R21P27922521Z22821R21I27922222922522222422F22822H21R21G27922A22922N22I27R27T27V21R21M27922H22N22B22J21R21E27922E22222222622P22422J22722322J27R21R21L27928M28O28Q22228728G28I22627M27923B22523628122I22J22I21R21K27929728229A28Z27522X22N22F28Y1K29028J225141H1H22422K21Y21Z21W1G1E2A122122J22K22E27Q22222N2262261G22L22922B1H22122E29M22J22A22F27R1H29I21Q1122F22I1329C27922Z22522J22423B29B29D27528H22H22J22222G21R27921Q27H2752BD21Q27X27923D2B72312AZ22022F22L28D28T27523222A22N21Z2AZ22521R21H29E22927C22A2BT2BV2AZ2BB2BR2751Q2792BA2751U2BB27621Q21827521O21Q2CL2CG2CK2CM21Q2CF2CG2BF2CO2CO2CD27521J2CC21F2BI22D22721Y1823G22923022823F21Z23C22C28S2792C52BP2B121R2D127522B23522W22723E22V22H22I22822J1722523D27727923822922K2DJ2B321Q2372B72A629B2BF23D23F22Y27G2AW22427F2C923A22J29G2242BY2882752D722I21Z2BB2152EV2CV21Q2C02CX27521K21D2BG21Q2782BA2BA21M1G2792F721Q2FA2792D12CD2F02F52791R2CQ2BB2CS2CL2FQ2BB2BA2FR2742CC2FK2CH2FO2CH2F921Q2FV2BE2FK2FJ2CN2752782G727H1E2CP2782E62BC2GG2752FV2CL28T27H2GJ21Q27N2CG2FT2CQ2FP2F52CZ2792CL2EQ2CW2BB2782762EK2912BJ28Y2CX1O21R2CX112DF27522522L27T2262222AU2H121Q2E22E422I2BB2CJ2792C92CX2CS2FS2BB2FR2CT2GH21Q2B327H28T2F82FE2FB2752I32I527927Y2BA2181J2GG2G72F32GG2FJ2F92I62EZ2F52ID2GG2BF2IO2882GY21Q27Y2FD2CE2G82F62IZ2GW2CQ2HK2J12G72EY2HV27922T2792182132FW2752HQ2GR2JE2CP2IQ2G42GY2HQ2882HK2HQ2GE2792B32782CZ2CX2FF2CY2F52JW21Q2EW2IC1W2IZ2C92IH2782K12JY2IL2K821K2192IN2FX2JZ2CJ2BA1U2172IZ2BA28T2KC2IZ2KH2792KG2K92792K82182K32782GP2I02KD2K72KF2KA2IN2KX2GO2792KJ2IZ27828T1U27H29D2882GV1P2I02CQ2CL2IH29D2K32I42JZ2LO2CR2KK2LF2IU2CR2LE2LJ2C021Q28F29D2CL2CD2142LJ2GF1H21Q2C92F22CL2KZ2JG1L2JR2BB2MF2752IT28F28T2M32CI2IE28T28F2792102L72BB2LM21Q1N2F52IK2792MY2N02752FB2CD2M82CZ2C92IO27Y2DL2LS2IM29D21C2752D128T2CZ2LZ2MT27N2F12M52CZ2GV2L02IZ172L32792NU2N62LV2MV2CL2IJ2J02MI2FE2MH2J12792O42J32O42MA2O42NR2M02LV2MN2IH2CZ23G2MZ2I92ER2FK2M827Y2O02IM2MN2EQ2OD2O62MJ2OW2M92OY2KZ2OF27Y2OH2KD2CZ23F2NV2752P72N321Q2342L52LV2F42F22F427Y23B2OL2JZ2PK2PB2PD2NY2LZ2BB2M828F2OQ2752M82NI2FZ2C02D12CN2N72IM2PH21Q2CZ2332PL2IL2Q82IC2IE2CZ2G321Q2OP2CO2M82C02CU2PT2Q62HV27Y28F2C02KO27Y22S2P821Q2QU2NY2MR2PS21Q2D12PR2OF28F2MN21Q1M2JD275');local o=bit and bit.bxor or function(e,n)local l,o=1,0 while e>0 and n>0 do local t,c=e%2,n%2 if t~=c then o=o+l end e,n,l=(e-t)/2,(n-c)/2,l*2 end if e<n then e=n end while e>0 do local n=e%2 if n>0 then o=o+l end e,l=(e-n)/2,l*2 end return o end local function n(n,e,l)if l then local e=(n/2^(e-1))%2^((l-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(n%(e+e)>=e)and 1 or 0;end;end;local e=1;local function l()local c,n,t,l=i(f,e,e+3);c=o(c,62)n=o(n,62)t=o(t,62)l=o(l,62)e=e+4;return(l*16777216)+(t*65536)+(n*256)+c;end;local function a()local l=o(i(f,e,e),62);e=e+1;return l;end;local function c()local n,l=i(f,e,e+2);n=o(n,62)l=o(l,62)e=e+2;return(l*256)+n;end;local function u()local o=l();local e=l();local t=1;local o=(n(e,1,20)*(2^32))+o;local l=n(e,21,31);local e=((-1)^n(e,32));if(l==0)then if(o==0)then return e*0;else l=1;t=0;end;elseif(l==2047)then return(o==0)and(e*(1/0))or(e*(0/0));end;return I(e,l-1023)*(t+(o/(2^52)));end;local s=l;local function I(l)local n;if(not l)then l=s();if(l==0)then return'';end;end;n=t(f,e,e+l-1);e=e+l;local l={}for e=1,#n do l[e]=h(o(i(t(n,e,e)),62))end return F(l);end;local e=l;local function s(...)return{...},r('#',...)end local function F()local i={};local o={};local e={};local d={i,o,nil,e};local e=l()local t={}for n=1,e do local l=a();local e;if(l==0)then e=(a()~=0);elseif(l==3)then e=u();elseif(l==1)then e=I();end;t[n]=e;end;for e=1,l()do o[e-1]=F();end;for d=1,l()do local e=a();if(n(e,1,1)==0)then local o=n(e,2,3);local a=n(e,4,6);local e={c(),c(),nil,nil};if(o==0)then e[3]=c();e[4]=c();elseif(o==1)then e[3]=l();elseif(o==2)then e[3]=l()-(2^16)elseif(o==3)then e[3]=l()-(2^16)e[4]=c();end;if(n(a,1,1)==1)then e[2]=t[e[2]]end if(n(a,2,2)==1)then e[3]=t[e[3]]end if(n(a,3,3)==1)then e[4]=t[e[4]]end i[d]=e;end end;d[3]=a();return d;end;local function f(e,c,a)local n=e[1];local l=e[2];local e=e[3];return function(...)local t=n;local h=l;local o=e;local e=s local l=1;local e=-1;local F={};local s={...};local r=r('#',...)-1;local i={};local n={};for e=0,r do if(e>=o)then F[e-o]=s[e+1];else n[e]=s[e+1];end;end;local e=r-o+1 local e;local o;while true do e=t[l];o=e[1];if o<=24 then if o<=11 then if o<=5 then if o<=2 then if o<=0 then c[e[3]]=n[e[2]];elseif o>1 then local h=h[e[3]];local d;local o={};d=C({},{__index=function(l,e)local e=o[e];return e[1][e[2]];end,__newindex=function(n,e,l)local e=o[e]e[1][e[2]]=l;end;});for a=1,e[4]do l=l+1;local e=t[l];if e[1]==43 then o[a-1]={n,e[3]};else o[a-1]={c,e[3]};end;i[#i+1]=o;end;n[e[2]]=f(h,d,a);else local l=e[2]local t={n[l](d(n,l+1,e[3]))};local o=0;for e=l,e[4]do o=o+1;n[e]=t[o];end end;elseif o<=3 then local l=e[2];local o=n[e[3]];n[l+1]=o;n[l]=o[e[4]];elseif o==4 then local o=e[2];local l=n[e[3]];n[o+1]=l;n[o]=l[e[4]];else local o;n[e[2]]={};l=l+1;e=t[l];n[e[2]][e[3]]=e[4];l=l+1;e=t[l];n[e[2]]=c[e[3]];l=l+1;e=t[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=t[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=t[l];o=e[2]n[o]=n[o](n[o+1])l=l+1;e=t[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=t[l];c[e[3]]=n[e[2]];l=l+1;e=t[l];do return end;end;elseif o<=8 then if o<=6 then n[e[2]]=c[e[3]];elseif o==7 then local a;local o;n[e[2]]=c[e[3]];l=l+1;e=t[l];o=e[2];a=n[e[3]];n[o+1]=a;n[o]=a[e[4]];l=l+1;e=t[l];n[e[2]]=c[e[3]];l=l+1;e=t[l];n[e[2]]=c[e[3]];l=l+1;e=t[l];if not n[e[2]]then l=l+1;else l=e[3];end;else local o=e[3];local l=n[o]for e=o+1,e[4]do l=l..n[e];end;n[e[2]]=l;end;elseif o<=9 then n[e[2]]=(e[3]~=0);elseif o==10 then local a;local o;local i;n[e[2]]=c[e[3]];l=l+1;e=t[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=t[l];i=e[3];o=n[i]for e=i+1,e[4]do o=o..n[e];end;n[e[2]]=o;l=l+1;e=t[l];a=e[2]n[a]=n[a](d(n,a+1,e[3]))l=l+1;e=t[l];c[e[3]]=n[e[2]];l=l+1;e=t[l];do return end;else n[e[2]]=c[e[3]];end;elseif o<=17 then if o<=14 then if o<=12 then local e=e[2]n[e](n[e+1])elseif o>13 then n[e[2]]=e[3];else local o=e[3];local l=n[o]for e=o+1,e[4]do l=l..n[e];end;n[e[2]]=l;end;elseif o<=15 then if not n[e[2]]then l=l+1;else l=e[3];end;elseif o==16 then if n[e[2]]then l=l+1;else l=e[3];end;else n[e[2]][e[3]]=n[e[4]];end;elseif o<=20 then if o<=18 then local e=e[2]n[e]=n[e](n[e+1])elseif o==19 then if n[e[2]]then l=l+1;else l=e[3];end;else n[e[2]][e[3]]=e[4];end;elseif o<=22 then if o==21 then n[e[2]]=n[e[3]][e[4]];else for e=e[2],e[3]do n[e]=nil;end;end;elseif o>23 then local o=e[2]local t={n[o](d(n,o+1,e[3]))};local l=0;for e=o,e[4]do l=l+1;n[e]=t[l];end else n[e[2]]={};end;elseif o<=36 then if o<=30 then if o<=27 then if o<=25 then n[e[2]]=a[e[3]];l=l+1;e=t[l];n[e[2]]=a[e[3]];l=l+1;e=t[l];n[e[2]]=a[e[3]];l=l+1;e=t[l];n[e[2]]=a[e[3]];l=l+1;e=t[l];n[e[2]]=a[e[3]];l=l+1;e=t[l];n[e[2]]=a[e[3]];l=l+1;e=t[l];if n[e[2]]then l=l+1;else l=e[3];end;elseif o>26 then do return end;else n[e[2]]=(e[3]~=0);end;elseif o<=28 then n[e[2]]={};elseif o>29 then n[e[2]]=a[e[3]];else if not n[e[2]]then l=l+1;else l=e[3];end;end;elseif o<=33 then if o<=31 then for e=e[2],e[3]do n[e]=nil;end;elseif o==32 then local l=e[2]n[l]=n[l](d(n,l+1,e[3]))else local l=e[2]n[l]=n[l](d(n,l+1,e[3]))end;elseif o<=34 then n[e[2]]=a[e[3]];elseif o==35 then local e=e[2]n[e](n[e+1])else local a;local o;n[e[2]]=c[e[3]];l=l+1;e=t[l];o=e[2];a=n[e[3]];n[o+1]=a;n[o]=a[e[4]];l=l+1;e=t[l];n[e[2]]=e[3];l=l+1;e=t[l];o=e[2]n[o]=n[o](d(n,o+1,e[3]))l=l+1;e=t[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=t[l];c[e[3]]=n[e[2]];l=l+1;e=t[l];do return end;end;elseif o<=42 then if o<=39 then if o<=37 then local o;n[e[2]]=c[e[3]];l=l+1;e=t[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=t[l];o=e[2]n[o]=n[o](n[o+1])l=l+1;e=t[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=t[l];n[e[2]]=c[e[3]];l=l+1;e=t[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=t[l];n[e[2]][e[3]]=n[e[4]];elseif o==38 then n[e[2]]=n[e[3]][e[4]];else local e=e[2]n[e]=n[e](n[e+1])end;elseif o<=40 then do return end;elseif o>41 then local h=h[e[3]];local d;local o={};d=C({},{__index=function(l,e)local e=o[e];return e[1][e[2]];end,__newindex=function(n,e,l)local e=o[e]e[1][e[2]]=l;end;});for a=1,e[4]do l=l+1;local e=t[l];if e[1]==43 then o[a-1]={n,e[3]};else o[a-1]={c,e[3]};end;i[#i+1]=o;end;n[e[2]]=f(h,d,a);else c[e[3]]=n[e[2]];end;elseif o<=45 then if o<=43 then n[e[2]]=n[e[3]];elseif o>44 then n[e[2]]=e[3];else n[e[2]][e[3]]=n[e[4]];end;elseif o<=47 then if o==46 then l=e[3];else n[e[2]]=n[e[3]];end;elseif o>48 then n[e[2]][e[3]]=e[4];else l=e[3];end;l=l+1;end;end;end;return f(F(),{},B())();
  wait(2)
  if isfile and delfile then
	  if isfile("IY_FE.iy") and isfile("Update.iy") then
	  	delfile("IY_FE.iy")
		  delfile("Update.iy")
  	end
  end
end)
