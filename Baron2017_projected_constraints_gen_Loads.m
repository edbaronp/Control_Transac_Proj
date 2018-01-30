%%%% Economic Dispatch with Projections
%%%% Baron-Prada2017

clc
clear all

%%%% Inputs %%%%
%Graph Declaration%
nodes=6;
Ed=[1 3;3 4;2 1; 2 6; 1 5; 4 5;5 6; 3 2; 1 4];
x=ones(nodes,1);
%%%%% Valores globales del sistema
Fprom=zeros(1,nodes);
Cg=zeros(nodes,1);
Pd=zeros(nodes,1);
XT=zeros(nodes,1);
%%%%% Número de nodos
N=zeros(nodes,1);
Z=[1;1;1;1;1;0];% Cuales nodos serán Generadores, 1=Generador, 0= Consumidor
%%%%%Separación vectores
xg=zeros(nodes,1);
xd=zeros(nodes,1);
%%%% Parametros simulación
iter=90000;
alpha=0.4;
%Generator Charateristics
c=[0.1;0.15;0.2;0.25;0.3;5] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1];
Pmax=[4000;4000;5000;6000;4000;10];
%Rate of change
TC=[1;1;1;1;1;1];
%Load
L=[0;0;0;0;0;15000];
U=L;
asd=0;

for k=1:iter
 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         U=[0;0;0;0;0;12000];
     end    
    if (k==60000)
       U=[0;0;0;0;0;18000];
     end 
%%%%%%%%%%%% Spanning Tree %%%%%%%%%%
if(asd==0)
Adj=Adjacency(Ed);
mst=Adjacency(MST(Ed));
asd=1;
end
%%%%%%%%%%% Finite- Time Distributed Averaging %%%%%%%%
    %%%%%%%%%%PD%%%%%%%%%%%
    Pd(:,k)=DistCons(U,mst);   
    %%%%%%%%%%Cg%%%%%%%%
    if (mod(k,100)==0 || k==1)
    Cg(:,k)=DistCons(c(:).*x(:,k),mst)./Pd(:,k);
    else
    Cg(:,k)=Cg(:,k-1);
    end
    %%%%%%%%%%PG%%%%%%%%%%%
    XT(:,k)=DistCons(x(:,k),mst);
    %%%%%%%%%%Nodes Generation%%%%%%%%
    if (mod(k,10000)==0 || k==1)
        N(:,k)=DistCons(Z,mst);
    else
        N(:,k)=N(:,k-1);
    end
%%%%%%%%%%%%%%%%Gradient variable algorithm%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Consensus%%%%
for j=1:nodes
t=0;
for i=1:nodes
    if(Adj(i,j)==1)
       Fprom(1,j)=Fprom(1,j)+x(i);
       t=t+1;
    end
end
Fprom(1,j)=Fprom(1,j)/t;
end

%%%%%%%%%Update variables%%%%%%%%%%%
der=[1/c(1)*(1-x(1,k)/Pmax(1));
     1/c(2)*(1-x(2,k)/Pmax(2)); 
     1/c(3)*(1-x(3,k)/Pmax(3));
     1/c(4)*(1-x(4,k)/Pmax(4));
     1/c(5)*(1-x(5,k)/Pmax(5));
     1/Cg(6)*(1-(x(6,k)*Cg(6))/Pmax(6))];

x(:,k+1)=x(:,k)-(Fprom(:)-alpha*der(:));

%%%%Separación vectores consumidores y productores%%%
for i=1:length(Z)
if(Z(i)~=1)
    xd(i,k+1)=x(i,k+1);%consumidores
    Pd(:,k)=Pd(:,k)+ones(nodes,1)*xd(i,k+1);
    XT(:,k)=XT(:,k)-ones(nodes,1)*xd(i,k+1);
end
end

%%%%%Projected Constrains%%%%%
%%%%%Virtual Agent Global Constraint%%%%%%%%
x(:,k+1)= x(:,k+1)-(XT(:,k)-Pd(:,k))./N(:,k);


%%%%% Local Rate of change constraint%%%%
for e=1:nodes
  if(x(e,k+1)-x(e,k)>TC(e))
       x(e,k+1)=x(e,k)+TC(e);
  end
  if(x(e,k+1)-x(e,k)<-TC(e))
       x(e,k+1)=x(e,k)-TC(e);
  end
end
%%%%% Local Generation constraints%%%%
for q=1:nodes
  if(x(q,k+1)<Pmin(q))
       x(q,k+1)=Pmin(q);
  end
end

for w=1:nodes
  if(x(w,k+1)>Pmax(w))
       x(w,k+1)=Pmax(w);
  end
end

v(:,k)=((ones(1,nodes)*x(:,k+1))*ones(nodes,1)-Pd(:,k)-(ones(1,nodes)*xd(:,k+1))*ones(nodes,1))./Pd(:,k)*100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pd(:,k+1)=Pd(:,k);
subplot(2,2,1)
plot(transpose(xd))
grid on
subplot(2,2,2)
plot(transpose(x))
grid on
subplot(2,2,3)
p=plot(graph(Ed(:,1),Ed(:,2)))
highlight(p,minspantree(graph(Ed(:,1),Ed(:,2))))
grid on
subplot(2,2,4)
plot(transpose(XT))
grid on

sum(x(:,30000))
sum(x(:,60000))
sum(x(:,k+1))