data:(); me:0
dist:{sqrt sum(x-y)xexp 2}
connect:{(`$":ws://localhost:8080")"GET / HTTP/1.1\r\nHost: localhost:8080\r\n\r\n"}
send:{neg[r 0]raze string x}
.z.pg:.z.ps:.z.ph:{}; .z.pc:{me::0;system"sleep 1";r::connect[]} / Windows-specific sleep command
.z.ws:{$[me~0;[me::"J"$x;send"promote 2 1"];
  [data::.j.k x;$[(not null first b:value first`d xasc select lx,ly,hp,d:dist[2#a;]each(lx,'ly)from data where team<>a 2,conn<>me,not cla like enlist"W")&not null first first a:raze exec lx,ly,team,hp from data where conn=me;
    $[(10>b 2)&((b 3)within 1 1.5)&10<a 3;send"grabthrow "," "sv string(2#b),2#a;
    send$[null first exec i from data where lx=d 0,ly=d 1,team<>a 2;"move ";"runover "]," "sv string d:(2#a)+$[first rank abs c:(2#b)-2#a;(signum c 0),0;0,signum c 1]];]]]}
r:connect[]
