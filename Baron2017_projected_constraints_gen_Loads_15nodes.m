%%%% Economic Dispatch with Projections
%%%% Baron-Prada2017

clc
clear all

%%%% Inputs %%%%
%Graph Declaration%
nodes=15;
Edges=[5 15;5 3;5 4;2 3; 2 6; 3 1; 4 1; 4 15;
    4 10;1 6;1 9;1 8;6 7;1 13;7 13;8 11;
    8 12;9 10;9 11;10 14;10 11;11 12;12 13;
    14 15];
power=ones(nodes,1);
%%%%% System global values%%%%%%%
Function_prom=zeros(1,nodes);
Function_prom_consumers=zeros(1,nodes);
Global_cost=zeros(nodes,1);
Power_demanded=zeros(nodes,1);
Power_generated=zeros(nodes,1);
%%%%% Número de nodos
Number_generators=zeros(nodes,1);%Numero de generadores
Choose_gen=[1;1;1;1;1;0;0;0;0;0;0;0;0;0;0];%1=gen o 0=consumidores
%%%%%Separación vectores
xg=zeros(nodes,1);
power_aux=zeros(nodes,1);
%%%% Parametros simulación
iterations=90000;
alpha=0.1;
%Generator Charateristics
generation_cost=[0.2;0.25;0.27;0.29;0.23;0;0;0;0;0;0;0;0;0;0] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
Pmax=[5000;5000;5000;5000;5000;1;1;1;1;1;1;1;1;1;1];
%Rate of change
Rate_change=[1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
%Load
Load_1=[0;0;0;0;0;1000;1000;1000;1000;1000;1000;1000;1000;1000;1000];
Load=Load_1;
asd=0;

for k=1:iterations
%Function_prom=ones(1,nodes);

 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         Load=[0;0;0;0;0;1300;1300;1300;1300;1300;1300;1300;1300;1300;1300];
     end    
    if (k==60000)
       Load=[0;0;0;0;0;1600;1600;1600;1600;1600;1600;1600;1600;1600;1600];
     end 
%%%%%%%%%%%% Spanning Tree %%%%%%%%%%
if(asd==0)
Adjacency_Graph=Adjacency(Edges);
Adjacency_MST=Adjacency(MST(Edges));
asd=1;
end
%%%%%%%%%%% Finite- Time Distributed Averaging %%%%%%%%
    %%%%%%%%%%PD%%%%%%%%%%%
    Power_demanded(:,k)=DistCons(Load,Adjacency_MST);
    %%%%%%%%%%PG%%%%%%%%%%%
    Power_generated(:,k)=DistCons(power(:,k),Adjacency_MST);
    %%%%%%%%%%Cg%%%%%%%%
    if (mod(k,100)==0 || k==1)
    Global_cost(:,k)=DistCons(generation_cost(:).*power(:,k),Adjacency_MST)./Power_generated(:,k);
    else
    Global_cost(:,k)=Global_cost(:,k-1);
    end
    %%%%%%%%%%Nodes%%%%%%%%
    if (asd==0 || k==1)
        Number_generators(:,k)=DistCons(Choose_gen,Adjacency_MST);
    else
        Number_generators(:,k)=Number_generators(:,k-1);
    end
%%%%%%%%%%%%%%%%Gradient variable algorithm%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Consensus Step%%%%
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

%%%%%%%%%Update variables%%%%%%%%%%%
Gradient=[(1/generation_cost(1))*(1-power(1,k)/Pmax(1));
          1/generation_cost(2)*(1-power(2,k)/Pmax(2)); 
          1/generation_cost(3)*(1-power(3,k)/Pmax(3));
          1/generation_cost(4)*(1-power(4,k)/Pmax(4));
          1/generation_cost(5)*(1-power(5,k)/Pmax(5));
          1/Global_cost(6,k)*(0.8-(power(6,k))/Pmax(6));
          1/Global_cost(7,k)*(1-(power(7,k))/Pmax(7));
          0;0;0;0;0;0;0;0];

Anita(k)=1/Global_cost(7,k)*(1-(power(7,k))/Pmax(7));
Eder(k) =Function_prom(1);


for i=1:nodes
if(Choose_gen(i)~=1)
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
else
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
end
end

%%%%Separación vectores consumidores y productores%%%
for i=1:length(Choose_gen)
if(Choose_gen(i)~=1)
    power_aux(i,k+1)=power(i,k+1);%consumidores
    Power_demanded(:,k)=Power_demanded(:,k)+ones(nodes,1)*power_aux(i,k+1);
    Power_generated(:,k)=Power_generated(:,k)-ones(nodes,1)*power_aux(i,k+1);
end
end

%%%%%Projected Constrains%%%%%
%%%%%Virtual Agent Global Constraint%%%%%%%%
power(:,k+1)= power(:,k+1)-(Power_generated(:,k)-Power_demanded(:,k))./Number_generators(:,k);


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

v(:,k)=((ones(1,nodes)*power(:,k+1))*ones(nodes,1)-Power_demanded(:,k)-(ones(1,nodes)*power_aux(:,k+1))*ones(nodes,1))./Power_demanded(:,k)*100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Power_demanded(:,k+1)=Power_demanded(:,k);
subplot(2,2,1)
plot(transpose(Anita))
%plot(transpose(power))
%plot(transpose(Aux))
grid on
subplot(2,2,2)
%plot(transpose(Global_cost))
plot(transpose(Eder))
grid on
subplot(2,2,3)
%p=plot(graph(Edges(:,1),Edges(:,2)));
%highlight(p,minspantree(graph(Edges(:,1),Edges(:,2))))
%plot(transpose(Power_demanded))
plot(transpose(Global_cost))
grid on
subplot(2,2,4)
plot(transpose(power))
%plot(transpose(Power_demanded))
grid on

sum(power(:,30000))
sum(power(:,60000))
sum(power(:,k+1))