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
<<<<<<< HEAD
c=[0.1;0.15;0.2;0.25;0.3;5] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1];
Pmax=[4000;4000;5000;6000;4000;10];
=======
generation_cost=[1;2;3;4;3;3;3;1] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1;1;1];
Pmax=[2000;3000;4000;5000;1;1;1;1];
>>>>>>> parent of e7c36ea... SeparaciÃ³n de proyecciones globales, no encuentro el problema, desarrollar una tÃ©cnica para encontrarlo es primordial.
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
<<<<<<< HEAD
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
=======
        Number_generators(:,k)=Number_generators(:,k-1);
    end
    
    %%%%%%%%%%%%%%%%Gradient variable algorithm%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%Consensus%%%%
    for j=1:nodes
        t=0;
        for i=1:nodes
            if(Adjacency_Graph(i,j)==1)
                Function_prom(1,j)=Function_prom(1,j)+power(i,k);
                t=t+1;
            end
        end
        Function_prom(1,j)=Function_prom(1,j)/t;
    end
    
    Anita(:,k)=Function_prom;
    
    
    %%%%%%%%%Update variables%%%%%%%%%%%
    for j=1:nodes
        if (Choose_gen(j)==0)
            Gradient(j)=1/Global_cost(j,k)*(1-power(j,k)/Pmax(j));
        else
            Gradient(j)= 1/generation_cost(j)*(1-power(j,k)/Pmax(j));
        end
    end
    
    
    %Falta cambiar cada función promedio por el correspondiente de cada una
    for i=1:nodes
        if(Choose_gen(i)==0)
            power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
        else
            power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
        end
    end
    
    %%%%Separación vectores consumidores y productores%%%
    for i=1:nodes
        if(Choose_gen(i)==0)
            power_aux(i,k+1)=power(i,k+1);%consumidores
            Power_demanded(:,k)=Power_demanded(:,k)+ones(nodes,1)*power_aux(i,k+1);
            Power_generated(:,k)=Power_generated(:,k)-ones(nodes,1)*power_aux(i,k+1);
        end
    end
    
    %%%%%Projected Constrains%%%%%
    
        %%%%% Local Rate of change constraint___For everyone%%%%
    for e=1:nodes
        if(power(e,k+1)-power(e,k)>Rate_change(e))
            power(e,k+1)=power(e,k)+Rate_change(e);
        end
        if(power(e,k+1)-power(e,k)<-Rate_change(e))
            power(e,k+1)=power(e,k)-Rate_change(e);
        end
    end
    %%%%% Local Generation constraints%%%%
    for q=1:nodes
        if(power(q,k+1)<Pmin(q))
            power(q,k+1)=Pmin(q);
        end
    end
    
    for w=1:nodes
        if(power(w,k+1)>Pmax(w))
            power(w,k+1)=Pmax(w);
        end
    end
    
    
    
    %%Global Constraint____Only for generators%%
    
    
    for c=1:nodes
        if (Choose_gen(c)==1)
            power(c,k+1)= power(c,k+1)-(Power_generated(c,k)-Power_demanded(c,k))./Number_generators(c,k);
        end
    end
    
    %%%%% Local Rate of change constraint%%%%
    for e=1:nodes
        if(power(e,k+1)-power(e,k)>Rate_change(e))
            power(e,k+1)=power(e,k)+Rate_change(e);
        end
        if(power(e,k+1)-power(e,k)<-Rate_change(e))
            power(e,k+1)=power(e,k)-Rate_change(e);
        end
    end
    %%%%% Local Generation constraints%%%%
    for q=1:nodes
        if(power(q,k+1)<Pmin(q))
            power(q,k+1)=Pmin(q);
        end
    end
    
    for w=1:nodes
        if(power(w,k+1)>Pmax(w))
            power(w,k+1)=Pmax(w);
        end
    end
    
    
    %%Global Constraint with generators with maximum capacity%%
    for c=1:nodes
        if (isequal(power(c,k+1),Pmax(c))&& Choose_gen(c)==1)
            projection_generation(c)=projection_generation(c)+1;
        end
    end
    
    if(~isequal(projection_generation(:),zeros(1,nodes)))
        full_generators(:,k)=DistCons(projection_generation,Adjacency_MST);
        for j=1:nodes
            if (~isequal(power(j,k+1),Pmax(j))&& Choose_gen(j)==1)
                power(j,k+1)= power(j,k+1)-(Power_generated(j,k)-Power_demanded(j,k))./(Number_generators(j,k)-full_generators(j,k));
            end
        end
    end
    
    
    
    %%%%% Local Rate of change constraint%%%%
    for e=1:nodes
        if(power(e,k+1)-power(e,k)>Rate_change(e))
            power(e,k+1)=power(e,k)+Rate_change(e);
        end
        if(power(e,k+1)-power(e,k)<-Rate_change(e))
            power(e,k+1)=power(e,k)-Rate_change(e);
        end
    end
    %%%%% Local Generation constraints%%%%
    for q=1:nodes
        if(power(q,k+1)<Pmin(q))
            power(q,k+1)=Pmin(q);
        end
>>>>>>> parent of e7c36ea... SeparaciÃ³n de proyecciones globales, no encuentro el problema, desarrollar una tÃ©cnica para encontrarlo es primordial.
    end
    
    for w=1:nodes
        if(power(w,k+1)>Pmax(w))
            power(w,k+1)=Pmax(w);
        end
    end
    
    %v(:,k)=((ones(1,nodes)*power(:,k+1))*ones(nodes,1)-Power_demanded(:,k)-(ones(1,nodes)*power_aux(:,k+1))*ones(nodes,1))./Power_demanded(:,k)*100;
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

%sum(x(:,30000))
sum(x(:,60000))
sum(x(:,k+1))
%=======
(sum(power(:,20000))-Power_demanded(1,20000))/Power_demanded(1,20000)*100
(sum(power(:,40000))-Power_demanded(1,40000))/Power_demanded(1,40000)*100
(sum(power(:,k+1))-Power_demanded(1,k))/Power_demanded(1,k)*100
a
