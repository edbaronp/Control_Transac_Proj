for k=1:90000
Function_prom_generators=zeros(1,nodes);
Function_prom_consumers=zeros(1,nodes);

for j=1:nodes
t=0;g=0;c=0;
for i=1:nodes
    if(Adjacency_Graph(i,j)==1)
        if(Choose_gen(j)==1)
            if(Choose_gen(i)==1)
                Function_prom_generators(1,j)=Function_prom_generators(1,j)+power(i,k);
                Function_prom_consumers(1,j)=Function_prom_consumers(1,j)+Function_prom_consumers(1,i);
                g=g+1;
            else    
                Function_prom_generators(1,j)=Function_prom_generators(1,j)+Function_prom_generators(1,i);
                Function_prom_consumers(1,j)=Function_prom_consumers(1,j)+power(i,k);
                c=c+1;
            end
                t=t+1;
        else
            if(Choose_gen(i)==1)    
                Function_prom_generators(1,j)=Function_prom_generators(1,j)+Function_prom_generators(1,i);
                Function_prom_consumers(1,j)=Function_prom_consumers(1,j)+power(i,k);
                c=c+1;
            else    
                Function_prom_generators(1,j)=Function_prom_generators(1,j)+power(i,k);
                Function_prom_consumers(1,j)=Function_prom_consumers(1,j)+Function_prom_consumers(1,i);
                g=g+1;
            end
                t=t+1;   
        end
    end
end
Function_prom_generators(1,j)=Function_prom_generators(1,j)/g;
Function_prom_consumers(1,j)=Function_prom_consumers(1,j)/c;
end
end

subplot(2,1,1)
plot(Function_prom_generators)
grid on
subplot(2,1,2)
plot(Function_prom_consumers)
grid on