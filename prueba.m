<<<<<<< HEAD
<<<<<<< HEAD
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
=======
=======
>>>>>>> parent of e7c36ea... Separación de proyecciones globales, no encuentro el problema, desarrollar una técnica para encontrarlo es primordial.
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
<<<<<<< HEAD
grid on
>>>>>>> parent of e7c36ea... Separación de proyecciones globales, no encuentro el problema, desarrollar una técnica para encontrarlo es primordial.
=======
grid on
>>>>>>> parent of e7c36ea... Separación de proyecciones globales, no encuentro el problema, desarrollar una técnica para encontrarlo es primordial.
