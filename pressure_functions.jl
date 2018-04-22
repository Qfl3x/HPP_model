#Assistant functions for calculating the number of particles hitting the wall per frame



function countcollisions(A)         #This function counts collisions, uses same principle as the particle-wall
                                    #function.
    count=0 #Counter.
    for x in A
        if x==0
            return 0
        end
        
        if x%22==0
            count+=1
        end
        if x%39==0
            count+=1
        end
        if x%85==0
            count+=1
        end
        if x%133=0 
            count+=1
        end
    
    end
    return count
end
function arraygenerator(n,dim)     #This function generates a Grid with a fixed number of randomly placed particles.
    A=Array{Int64,2}(ones(dim))
    lengthA=length(A)
    for k=1:n
        randint=rand(1:lengthA)
        
        while A[randint]!=1
            randint=rand(1:lengthA)
        end
        A[randint]=rand([2 3 4 5])
        
            
    end
    return A
end
function average_of_array(A)      #Average function.
    return (sum(A))/length(A)
end

