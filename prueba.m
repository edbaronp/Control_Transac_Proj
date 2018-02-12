Function_prom_generators=zeros(1,nodes);
Function_prom_consumers=zeros(1,nodes);

for k=1:iterations
for j=1:nodes
t=0;
for i=1:nodes
    if(Adjacency_Graph(i,j)==1)
        if(Choose_gen(j)==1)
            if(Choose_gen(i)==1)
                Function_prom_generators(k,j)=Function_prom_generators(k,j)+power(i,k);
                Function_prom_consumers(k,j)=Function_prom_consumers(k,j)+Function_prom_consumers(k,i);
            else    
                Function_prom_generators(k,j)=Function_prom_generators(k,j)+Function_prom_generators(k,i);
                Function_prom_consumers(k,j)=Function_prom_consumers(k,j)+power(i,k);
            end
                t=t+1;
        else
            if(Choose_gen(i)==1)
                Function_prom_generators(k,j)=Function_prom_generators(k,j)+Function_prom_generators(k,i);
                Function_prom_consumers(k,j)=Function_prom_consumers(k,j)+power(i,k);
                
            else    
                Function_prom_generators(k+1,j)=Function_prom_generators(k,j)+power(i,k);
                Function_prom_consumers(k+1,j)=Function_prom_consumers(k,j)+Function_prom_consumers(k,i);
            end
                t=t+1;    
        end
    end
end
     Function_prom_generators(k+1,j)=Function_prom_generators(k,j)/t;
     Function_prom_consumers(k+1,j)=Function_prom_consumers(k,j)/t;
end

end
subplot(2,1,1)
plot(Function_prom_generators)
grid on

subplot(2,1,2)
plot(Function_prom_consumers)
grid on
