 Program ACS;
 {$N+}
 Const
   a=0.1;
   r=0.1;
   g=0.1;
 Var
   w:Longint;
   i,j,k,l,m,n,Ran,s,x : Byte;
   T0,T1,Max,Min,Opt,u,Lnn : Extended;
   D,T : Array[1..50,1..50] of Extended;      {Holds pheromone & distance information}
   Tour: Array[1..50,1..20,1..2] of Byte;     {Holds the sequence of visited & unvisited cities by each ant}
    Le : Array[1..20] of Extended;            {Holds tour length for each ant}
    gb : Array[1..50] of Byte;                {Holds global-best tour}
 Procedure Initial_City;         {Positions m ants on n cities randomly}
 Var
   Test:Boolean;
 Begin
    for k:=1 to m do
   Begin
     Test:=true;
     while Test do
     Begin
       Tour[1,k,1]:=Random(n)+1;
       for l:=2 to k do
         if Tour[1,l-1,1] = Tour[1,k,1] then
         Begin
           l:=100;
           Break;
         End;
       if l = 100 then
         Continue;
       Test:=False;
     End;
   End;
 End;
 Function Q_Learning(S:Byte):Real;
 Var
   Best:Real;
 Begin
 Best:=0;
   for l:=1 to n do
     if (T[s,l]>Best) then
       Best:=T[s,l];
   Q_Learning:=Best
 End;
 Begin
   Randomize;
   Writeln;
   Write('Enter the number of Cities:');
   Read(n);
   Write('Enter the number of Ants:');
   Read(m);
   Write('Enter a number greater than Optimum Tour-Length:');
   Read(Lnn);
   T0:=1/(n*Lnn);
   Opt:=Lnn;
   writeln('Enter the Distances between Cities:');
   for i:=1 to n do
     for j:=1 to n do
       if (i<j) then
       Begin
         Read(D[i,j]);
         D[j,i]:=D[i,j];
       End;
   for x:=1 to 10 do
   Begin
     w:=0;
   for i:=1 to n do
     for j:=1 to n do
       if (i<>j) then
         T[i,j]:=T0;
   Repeat
     for i:=1 to m do
       for j:=1 to n do
         Tour[j,i,2]:=j;
     for i:=1 to m do
       for j:=1 to n do
         Tour[i,j,1]:=0;
     for i:=1 to m do le[i]:=0;
     Initial_City;
     for k:=1 to m do           {Ants begin their tours}
     Begin
       Tour[n+1,k,1]:=Tour[1,k,1];
       Tour[Tour[1,k,1],k,2]:=0;
       for i:=1 to (n-1) do
       Begin
         Max:=0;
         for l:=1 to n do   {Choosing cities by exploitation rule}
           if (Tour[l,k,2]<>0) and (Tour[i,k,1]<>Tour[l,k,2]) then
           Begin
             u:=T[Tour[i,k,1],Tour[l,k,2]]/Sqr(D[Tour[i,k,1],Tour[l,k,2]]);
             if (u>Max) then
             Begin
               Max:=u;
               s:=Tour[l,k,2];
             End;
           End;
         Tour[i+1,k,1]:=s;
         Tour[s,k,2]:=0;
         Le[k]:=Le[k]+D[Tour[i,k,1],Tour[i+1,k,1]];
         T1:=T[Tour[i,k,1],Tour[i+1,k,1]];  {Local updating occurs according to Q-Learning algorithm}
         T[Tour[i,k,1],Tour[i+1,k,1]]:=R*g*Q_Learning(s)+(1-R)*T1;
         T[Tour[i+1,k,1],Tour[i,k,1]]:=T[Tour[i,k,1],Tour[i+1,k,1]];
       End;  {End of i}
       Le[k]:=Le[k]+D[Tour[i+1,k,1],Tour[i+2,k,1]];
     End;    {End of k}
     Min:=Le[1];
     l:=1;
     for i:=2 to m do
       if (Le[i]<Min) then
       Begin
         Min:=Le[i];
         l:=i;
       End;
     if (Min<Opt) then
     Begin
       Opt:=Min;
       for i:=1 to (n+1) do
         gb[i]:=Tour[i,l,1];
     End;
     for i:=1 to n do    {Global updating occurs}
       for j:=1 to n do
         if (i<>j) then
           T[i,j]:=(1-a)*T[i,j];
     for i:=1 to n do
       T[gb[i],gb[i+1]]:=T[gb[i],gb[i+1]]+(a/Opt);
     w:=w+1;
   Until (w>50000);
   Writeln('Solution = ',Opt:5:4);
   write('The Best Tour is :');
   for i:=1 to n+1 do
     write(' ',gb[i]);
 end.












