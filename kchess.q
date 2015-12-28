ent:([]conn:();cla:();hp:();e:();lx:();ly:();chan:();team:();stat:()); class:([cla:`N`B`R`K`P`Q`W`U]mhp:20 10 40 15 15 10 50 10); teams:(0 5;10 5); lt:turns:()()!""""; effects:()
dist:{sqrt sum(x-y)xexp 2}; intersect:{0=((y 0)*(x 1)%x 0)-y 1}; inrange:{dist[y;raze value exec lx,ly from ent where conn=x]<=z}; emptyxy:{null first exec i from ent where lx=x 0,ly=x 1}
intersect:{$[(x 0)=y 0;1b;0=((y 0)*(x 1)%x 0)-y 1]} / Requires origin-based input; e.g., intersect[target-me;unit-me]
dt:{turns _:x} / Delete turn - used when usage conditions not met
xy:{value exec lx,ly from ent where conn=x 0,e>=x 1,cla=x 2}
de0:{update e:e-x 1,chan:(chan*x 3)+x 2 from `ent where conn=x 0}; de:{de0[x,0]}; dec:{de0[x,1]}
dh:{update hp:hp-x 1,chan:0 from `ent where lx=x 2,ly=x 3,conn<>x 0}; dhw:{update hp:hp-x 0,chan:0 from `ent where lx within x 1,ly within x 2}
mv:{update chan:0,lx:x 1,ly:x 2 from `ent where conn=x 0}; move:{$[inrange[x 0;a;1]&emptyxy a:2#x 1;mv(x 0;a 0;a 1);dt x 0]}
attmove:{$[inrange[z 0;a:2#z 1;1]&first x=exec cla from ent where conn=z 0;$[emptyxy a;mv(z 0;a 0;a 1);dh(z 0;y;a 0;a 1)];dt z 0]}; pawnattmove:attmove[`P;5]; runover:attmove[`R;10]
sidestep:{$[inrange[x 0;a;1.5]&emptyxy a:2#x 1;update e:e-1,chan:0,lx:a 0,ly:a 1 from `ent where conn=x 0,e>=1,cla=`B;dt x 0]}
att:{$[first dist[a:2#y 1;xy(y 0;x 2;x 0)]<=x 3;[dh(-1;x 1;a 0;a 1);de(y 0;x 2;0)];dt y 0]}; sword:att[(`N;10;2;1.5)]; backstab:att[(`Q;50;5;1)]
meditate:{update chan:0,e:min(10;e+2) from `ent where conn=x 0,e<10,cla=`B}
ln:{`d xasc select i,d:dist[x 2;]each(lx,'ly),is:intersect[(x 2)-x 1;]each (x 2)-/:(lx,'ly) from ent where lx within asc(x[1;0];x[3;0]),ly within asc(x[1;1];x[3;1]),conn<>x 0}
arrow:{$[(first dist[a:2#x 1;b]<=4)&not null first raze b:xy(x 0;3;`N);[b:raze b;$[c:first first ln(x 0;a;b;b);update hp:hp-8,chan:0 from `ent where i=c;];de(x 0;3;0)];dt x 0]} / Hits first unit in a line
lance:{$[first dist[a:2#x 1;b:xy(x 0;4;`N)]within 1.1 2;[b:raze b;$[null first first ln(x 0;a;b;b);[l:b+2*a-b;$[first first c:ln(x 0;a;b;l);update hp:hp-15,chan:0 from `ent where i in c[`x];];update lx:a 0,ly:a 1,e:e-4 from `ent where conn=x 0];dt x 0]];dt x 0]} / Minimum distance, line damage; input should specify the spot to move to; do not burn energy or move if charge blocked
cc:{first exec chan from ent where conn=x}
cu:{$[(first dist[a;xy(y 0;x 0;`K)]<=1.5)&emptyxy a:2#y 1;[$[lt[y 0]~turns[y 0];dec;de](y 0;x 0;x 1);$[199<cc y 0;[`ent upsert(1;x 2;10;0f;a 0;a 1;0;(first exec team from ent where conn=y 0);`);de(y 0;0;0);turns[y 0],:" 1"];]];dt y 0]} / Prevent retargeting
spawn:cu[(3;140;`P)]; wall:cu[(2;150;`W)]
meteor:{$[first dist[a:2#x 1;xy(x 0;2;`B)]<=4;[$[lt[x 0]~turns[x 0];dec;de](x 0;2;140);$[199<cc x 0;[b:-1 1+/:a;dhw(50;b 0;b 1);de(x 0;0;0);effects,:enlist("dhw(5;",(" "sv first string -1 1+/:a),";",(" "sv last string -1 1+/:a),")";3);turns[x 0],:" 1"];]];dt x 0]} / Prevent retargeting
smash:{$[first dist[a:2#x 1;b:xy(x 0;2;`R)]<=1;[$[lt[x 0]~turns[x 0];dec;de](x 0;2;150);$[199<cc x 0;[l:b+{$[x=0;-1 1+x;x,x]}each a-b:raze b;dhw(30;l 0;l 1);de(x 0;0;0);turns[x 0],:" 1"];]];dt x 0]} / Prevent retargeting
fm:{$[null c:first exec i from ent where lx=x[1;0],ly=x[1;1];update lx:x[1;0],ly:x[1;1],chan:0 from `ent where lx=x[0;0],ly=x[0;1];update hp:hp-x 2,chan:0 from `ent where ((lx=x[0;0])&(ly=x[0;1])&x 3)|i=c]} / Damage or move
push:{$[(not emptyxy a)&(first dist[a:2#x 1;b]<=1.5)&not null first raze b:xy(x 0;3;`R);[l:raze b+2*a-b;fm(a;l;10;1b);de(x 0;3;0)];dt x 0]}
grabthrow:{$[(not all(a 0)=a 1)&(first dist[a 0;b]within 1 1.5)&(not emptyxy a 0)&(first dist[first 1_a:2 2#x 1;b]<=1.5)&not null first raze b:xy(x 0;3;`R);[fm(a 0;a 1;10;1b);de(x 0;3;0)];dt x 0]} / Stop self-grab movement
cmdpawn:{$[(not null c:first exec conn from ent where lx=a[0;0],ly=a[0;1],cla=`P,team=first exec team from ent where conn=x 0,cla=`K)&first dist[a 0;first 1_a:2 2#x 1]<=1;fm(a 0;a 1;5;0b);dt x 0]}
qe:{$[(first dist[a;xy(y 0;x 0;`Q)]<=x 1)&not emptyxy a:2#y 1;[b:value exec i,conn from ent where lx=a 0,ly=a 1;effects,:enlist(raze string"update ",(x 2),",chan:0 from `ent where i=",b[0;0],",conn=",b[1;0],",cla<>`W";x 0);de(y 0;x 0;0)];dt y 0]}; blind:qe[(3;4;"stat:`blind")]; poison:qe[(4;1.5;"hp:hp-5")]
promote:{$[$[b in`K`Q;null first exec i from ent where cla=b,team=x[1;1];1b]&(not null b:first exec cla from class where i=x[1;0])&not null first a:teams x[1;1];update cla:b,team:x[1;1],lx:a 0,ly:a 1 from `ent where conn=x 0,cla=`U;dt x 0]}
actions:`move`sword`arrow`sidestep`runover`lance`meteor`meditate`push`grabthrow`smash`promote`pawnattmove`backstab`poison`blind`wall`cmdpawn`spawn / Client-permitted actions
execute:{$[((c:`$a 0)in actions)&not any null b:"J"$1_a:" "vs turns x;@[c;(x;b)];]} / Validate and execute action with connection key and coordinates
fog:{a:raze value exec lx,ly,stat from y where conn=x;b:$[`blind=a 2;0 0;-4 4]+/:2#a;select from y where lx within b 0,ly within b 1} / Multiple statements required
.z.po:{neg[x].j.j x;`ent upsert(.z.w;`U;10;10f;100;100;0;0;`)}; .z.pc:{delete from `ent where conn=x} / Create/remove unit on connect/disconnect
.z.ws:{turns[.z.w]:x}; .z.ph:z.pg:.z.ps:{} / Set player input for the turn from ws; silence non-ws handlers
.z.ts:{execute each key turns;update stat:` from `ent where stat=`blind;effects[;1]-:1;value each effects[;0];effects::effects where effects[;1]<>0;update chan:max(0;chan-100) from `ent where chan>0; / Do turns/effects, clear disables, channel draining to prevent pre-charge
  {neg[x].j.j fog[x;y]}\:[key .z.W;select conn,cla,hp,e,lx,ly,chan,team,stat,t:turns[conn] from ent];
  $[not null a:first exec team from ent where cla=`K,hp<=0;update hp:0 from `ent where team=a,cla<>`W;]; / Leave walls up on king death
  hclose each exec conn from ent where hp<=0;delete from `ent where hp<=0;update hp:hp+1 from `ent where i in exec i from ent lj class where hp<mhp;update e:e+.5 from `ent where e<10;lt::turns;turns::()()!""""} / Disconnect/delete dead units, regen live units
{`ent upsert(1;`W;50;0f;x 0;x 1;0;9;`)}each raze -5+(20,'til 20;0,'til 20;(til 20),'0;(til 20),'20) / Insert boundary walls
\t 1000
