

#=
	This is the main function, it takes as input a starting array, and the number of steps.
	Randomizing the initial grid is also built-in through the function arguments.
=#
using Base
using Distributed
include("mapping_functions.jl")
@everywhere Base.MainInclude.include("mapping_functions.jl")
using Plots
#using ProgressMeter
#TODO: Transfer to Images package instead of built-in imfilter
import Plots.@animate
@everywhere using ImageFiltering



#clibrary(:cmocean)

#module GasLattice

function GasLattice_visual(steps=50,startarr=0,dim=(1000,1000))
	if startarr == 0
		randomize = true
		
	else
		randomize = false
		dim = size(startarr)
	end
    randomize ? Grid=rand([1 2 3 5 6],dim) : Grid=startarr           #2:up 3:left 5:down 7:right 1:none
    filtertop  =   centered([0 0 0;0 0 0;0 1 0])		#Filter of top cells
    filterbot  =   centered([0 1 0;0 0 0;0 0 0])		#Filter of bottom cells
    filterleft =   centered([0 0 0;0 0 1;0 0 0])		#Filter of left cells
    filterright=   centered([0 0 0;1 0 0;0 0 0])		#Filter of right cells
    rang=1:dim[1]				#Range for limiting the convolution product result
    
    heatmap(map(countt,Grid),c=:grayC)			#Initializer for the heatmap
    
    #p1=Progress(steps)				#Progress bar initializer
    anim=  @animate for k=1:steps
    #for k=1:steps
        Grid=padarray(Grid,Fill(0,(1,1),(1,1)))
    	  ##==The following are mapping each cell to the incoming particle.==#
        # @sync begin
        #     top_=@spawnat 1 imfilter(Grid,filtertop)[rang,rang]
        #     bot_=@spawnat 2 imfilter(Grid,filterbot)[rang,rang]
        #     rig_=@spawnat 3 imfilter(Grid,filterright)[rang,rang]
        #     lef_=@spawnat 4 imfilter(Grid,filterleft)[rang,rang]
        # end


        Grid_top=@spawnat 1 map(hasbot,imfilter(Grid,filtertop)[rang,rang])
        Grid_left=@spawnat 2 map(hasright,imfilter(Grid,filterleft)[rang,rang])
        Grid_bot=@spawnat 3 map(hastop,imfilter(Grid,filterbot)[rang,rang])
        Grid_right=@spawnat 4 map(hasleft,imfilter(Grid,filterright)[rang,rang])
        ###
        Grid_post_filter=fetch(Grid_top) .* fetch(Grid_left) .* fetch(Grid_right) .* fetch(Grid_bot)
        #Grid_post_filter=fetch(Grid_top) .* fetch(Grid_left) .* fetch(Grid_right) .* fetch(Grid_bot)	#The product of the different maps
        Grid_post_filter=Grid_post_filter[rang,rang]
	    Grid_pre_collision=mapzeroes(Grid[rang,rang],Grid_post_filter)	#This line maps the zeros of the initial grid
								#to their corresponding cells in the product
								#It is necessary to support inert objects in the box

	    Grid_pre_wall=map(collision,Grid_pre_collision)		#Mapping particle-particle collisions.
        ###
        Grid=map(bordercollisions,Grid_pre_wall)		#Mapping particle-border collisions.

        Grid_count=map(countt,Grid)				#Counting the number of particles in a cell
				#For the heatmap,.
        heatmap(Grid_count,c=:grayC)					#Next frame.
	      #next!(p1)		
	#end
	      				#Next step in the progress bar.
    end
    gif(anim,"randomgaslattice.gif",fps=3)			#Create the gif.
    
end
#export GasLattice_visual
#end
