#This function computes the pressure.

include(mapping_functions.jl)
include(pressure_functions.jl)


function GasLatticePressure(steps=20,startarr=0,randomize=true,dim=(100,100))
    randomize ? Grid=rand([1 2 3 5 7],dim) : Grid=startarr   


    filtertop  =   [0 1 0;0 0 0;0 0 0]
    filterbot  =   [0 0 0;0 0 0;0 1 0]
    filterleft =   [0 0 0;1 0 0;0 0 0]
    filterright=   [0 0 0;0 0 1;0 0 0]
    rang=2:dim[1]+1
    
    
    p1=Progress(400)
    collisionscount=[]   #Array for storing the number of collision counts per n. The returned array.
    for number=100:600
        pressurearray=[]     #Array for storing the number of collision counts per iterations for fixed n.
        for iterations=1:10
            iteration_pressure_array=[]  #Array for storing the number of collisions per step for an iteration.
            Grid=arraygenerator(number,dim)
            for k=1:steps
                    Grid_top=map(hasbot,conv2(Grid,filtertop)[rang,rang])
        
                    Grid_left=map(hasright,conv2(Grid,filterleft)[rang,rang])
                    Grid_bot=map(hastop,conv2(Grid,filterbot)[rang,rang])
                    Grid_right=map(hasleft,conv2(Grid,filterright)[rang,rang])
        
    
                    Grid_post_filter=Grid_top .* Grid_left .* Grid_right .* Grid_bot
                    Grid_pre_collision=mapzeroes(Grid,Grid_post_filter)
                    Grid_pre_wall=map(collision,Grid_pre_collision)
                
                    #This is the function for calling the collisions per frame/step. It has to be called before
                    #the border collisions function.
                    iteration_pressure_array=push!(iteration_pressure_array,countcollisions(Grid_pre_wall)) 
                    Grid=map(bordercollisions,Grid_pre_wall)
                
        
        
            end
            #The average of the collisions per step is taken.
            pressurearray=push!(pressurearray,average_of_array(iteration_pressure_array))
        end
        #The average of the collisions per iteration is taken.
        collisionscount=push!(collisionscount,average_of_array(pressurearray))
        next!(p1)
    end
    
    return collisionscount
end
