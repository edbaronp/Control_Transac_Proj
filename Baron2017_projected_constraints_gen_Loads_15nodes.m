%%%% Economic Dispatch with Projections
%%%% Baron-Prada2017

clc
clear all

%%%% Inputs %%%%
%Graph Declaration%
nodes=4;
Edges=[ 1 2; 1 3; 2 4; 3 4];
power=ones(nodes,1);
%%%%% System global values%%%%%%%
Function_prom=zeros(1,nodes);
Function_prom_consumers=zeros(1,nodes);
Global_cost=zeros(nodes,1);
Power_demanded=zeros(nodes,1);
Power_generated=zeros(nodes,1);
%%%%% Número de nodos
Number_generators=zeros(nodes,1);%Numero de generadores
<<<<<<< HEAD
Choose_gen=[1;1;1;1];%1=gen o 0=consumidores
=======
Choose_gen=[1;1;1;1;1;0;0;0;0;1;0;0;0;0;0];%1=gen o 0=consumidores
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
%%%%%Separación vectores
xg=zeros(nodes,1);
power_aux=zeros(nodes,1);
%%%% Parametros simulación
iterations=90000;
<<<<<<< HEAD
alpha=0.5;
%Generator Charateristics
generation_cost=[1;2;3;4] ;
%Generation Constraints
Pmin=[1;1;1;1];
Pmax=[2000;3000;4000;5000];
=======
alpha=0.8;
%Generator Charateristics
generation_cost=[0.2;0.3;0.4;0.5;0.6;0;0;0;0;0.5;0;0;0;0;0] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
Pmax=[2000;3000;4000;5000;6000;500;500;500;500;3000;500;1;1;1;1];
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
%Rate of change
Rate_change=[0.3;0.3;0.3;0.3];
%Load
<<<<<<< HEAD
Load_1=[0;0;0;8000];
=======
Load_1=[0;0;0;0;0;1000;1000;1000;1000;1000;1000;1000;1000;1000;1000];
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
Load=Load_1;
asd=0;
%Projection auxiliar variable
full_generators=zeros(nodes,1);

for k=1:iterations
<<<<<<< HEAD
    
 projection_generation=zeros(nodes,1);
 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         Load=[0;0;0;14000];
     end    
    if (k==60000)
       Load=[0;0;0;10000];
=======
%Function_prom=ones(1,nodes);

 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         Load=[0;0;0;0;0;1600;1600;1600;1600;1600;1600;1600;1600;1600;1600];
     end    
    if (k==60000)
         Load=[0;0;0;0;0;1300;1300;1300;1300;1300;1300;1300;1300;1300;1300];
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
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
<<<<<<< HEAD
          1/generation_cost(4)*(1-power(4,k)/Pmax(4))];
=======
          1/generation_cost(4)*(1-power(4,k)/Pmax(4));
          1/generation_cost(5)*(1-power(5,k)/Pmax(5));
          1/Global_cost(6,k)*(1-(power(6,k))/Pmax(6));
          1/Global_cost(7,k)*(1-(power(7,k))/Pmax(7));
          1/Global_cost(8,k)*(1-(power(8,k))/Pmax(8));
          1/Global_cost(9,k)*(1-(power(9,k))/Pmax(9));
          1/generation_cost(10)*(1-(power(10,k))/Pmax(10));
          1/Global_cost(11,k)*(1-(power(11,k))/Pmax(11));
          1/Global_cost(12,k)*(1-(power(12,k))/Pmax(12));
          1/Global_cost(13,k)*(1-(power(13,k))/Pmax(13));
          1/Global_cost(14,k)*(1-(power(14,k))/Pmax(14));
          1/Global_cost(15,k)*(1-(power(15,k))/Pmax(15))];
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514


for i=1:nodes
if(Choose_gen(i)~=1)
<<<<<<< HEAD
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
=======
    power(i,k+1)=power(i,k)-(Function_prom(i)-alpha*Gradient(i));
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
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
%%Global Constraint%%
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

Anita(1,k)= power(2,k+1);

%%Global Constraint with generators with maximum capacity%%
for c=1:nodes
    if (isequal(power(c,k+1),Pmax(c)))
        projection_generation(c)=projection_generation(c)+1;
    end
end

if(~isequal(projection_generation(:),zeros(1,nodes)))
    full_generators(:,k)=DistCons(projection_generation,Adjacency_MST);
        for j=1:nodes
            if (power(j,k+1)~=Pmax(j))
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
end

for w=1:nodes
  if(power(w,k+1)>Pmax(w))
       power(w,k+1)=Pmax(w);
  end
end

%v(:,k)=((ones(1,nodes)*power(:,k+1))*ones(nodes,1)-Power_demanded(:,k)-(ones(1,nodes)*power_aux(:,k+1))*ones(nodes,1))./Power_demanded(:,k)*100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Power_demanded(:,k+1)=Power_demanded(:,k);
subplot(2,2,1)
plot(transpose(power))
<<<<<<< HEAD
=======
%plot(transpose(Aux))
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
grid on
subplot(2,2,2)
plot(transpose(Global_cost))
grid on
subplot(2,2,3)
p=plot(graph(Edges(:,1),Edges(:,2)));
highlight(p,minspantree(graph(Edges(:,1),Edges(:,2))))
<<<<<<< HEAD
grid on
subplot(2,2,4)
=======
%plot(transpose(Power_demanded))
%plot(transpose(Global_cost))
grid on
subplot(2,2,4)
%plot(transpose(power))
>>>>>>> b0397759f33ec12db3324f7d8079b634377a5514
plot(transpose(Power_demanded))
grid on

(sum(power(:,20000))-Power_demanded(1,20000))/Power_demanded(1,20000)*100
(sum(power(:,40000))-Power_demanded(1,40000))/Power_demanded(1,40000)*100
(sum(power(:,k+1))-Power_demanded(1,k))/Power_demanded(1,k)*100