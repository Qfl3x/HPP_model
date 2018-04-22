

#=
	This is the main function, it takes as input a starting array, and the number of steps.
	Randomizing the initial grid is also built-in through the function arguments.
												=#
include(mapping_functions.jl)
using Plots
using Progress

function GasLattice_visual(steps=50,startarr=0,randomize=true,dim=(1000,1000))
    randomize ? Grid=rand([1 2 3 5 6],dim) : Grid=startarr           #2:up 3:left 5:down 7:right 1:none
    filtertop  =   [0 1 0;0 0 0;0 0 0]		#Filter of top cells
    filterbot  =   [0 0 0;0 0 0;0 1 0]		#Filter of bottom cells
    filterleft =   [0 0 0;1 0 0;0 0 0]		#Filter of left cells
    filterright=   [0 0 0;0 0 1;0 0 0]		#Filter of right cells
    rang=2:dim[1]+1				#Range for limiting the convolution product result
    
    heatmap(map(countt,Grid))			#Initializer for the heatmap
    
    p1=Progress(10)				#Progress bar initializer
    anim=  @animate for k=1:steps
    	##==The following are mapping each cell to the incoming particle.==#
        Grid_top=map(hasbot,conv2(Grid,filtertop)[rang,rang])
        
        Grid_left=map(hasright,conv2(Grid,filterleft)[rang,rang])
        Grid_bot=map(hastop,conv2(Grid,filterbot)[rang,rang])
        Grid_right=map(hasleft,conv2(Grid,filterright)[rang,rang])
    
        Grid_post_filter=Grid_top .* Grid_left .* Grid_right .* Grid_bot	#The product of the different maps

	Grid_pre_collision=mapzeroes(Grid,Grid_post_filter)	#This line maps the zeros of the initial grid
								#to their corresponding cells in the product
								#It is necessary to support inert objects in the box

	Grid_pre_wall=map(collision,Grid_pre_collision)		#Mapping particle-particle collisions.
        
        Grid=map(bordercollisions,Grid_pre_wall)		#Mapping particle-border collisions.
                
        Grid_count=map(countt,Grid)				#Counting the number of particles in a cell 
								#For the heatmap,.
        heatmap(Grid_count)					#Next frame.
	next!(p1)						#Next step in the progress bar.
        
    end
    gif(anim,"randomgaslattice.gif",fps=3)			#Create the gif.
    
end
