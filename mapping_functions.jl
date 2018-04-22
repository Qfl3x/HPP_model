
function countt(x)	#Counting function, counts the number of particles in a cell be performing integer
			#Division of it's number and the particle direction primes.
    count=0
    if x==1		#1 Corresponds to an empty cell.
        return 0
    end
    for k in [2,3,5,7]
        if x%k==0
            count+=1
        end
    end
    return count
end
function collision(x)	#This function computes the result of a particle-particle collision.
    if (x==1) | (x==0)	#x=1 corresponds to an empty cell, x=0 corresponds to an inert object.
        return x
    end
    if x%10==0 	 	#10=2 x 5
        return 21
    if x%21==0		#21=7 x 3
        return 10
    else
        return x
    end
end

        
function bordercollisions(x)		#This function computes the result of a particle-wall collision.
    if ((x%11!=0) & (x%13!=0) & (x%17!=0) & (x%19!=0)) | (x==0)
        return x
    end
    R=x
    if x%22==0			#22=11 x 2	55=11 x 5
        R=(R/22)*55
    end
    if x%39==0			#39=13 x 3	91=13 x 7
        R=(R/39)*91
    end
    if x%85==0             	#85=17 x 5	34=17 x 2
        R=R/(85)*34
    end
    if x%133==0            	#133=19 x 7	57= 19 x 3
        #print("BOOM")
        R=R/(133)*57
        
    end
    return Int(R)		#R is turned into an integer to accomodate it within the integer array.
end

#=========== Checking  functions ===================#

function hasleft(x)	#This function checks the right cell, for an incoming particle, or for a wall.
    if x==0		#If the right cell contains a 0 ( i.e it's a wall ) the current cell is multiplied by 19.
			#Which means a right border. This is useful for the bordercollisions function.
        return 19
    end
    X=x%3		#The value is divided by 3. which is an incoming particle. If the remainder is 0, the cell is 			      # multiplied by 3, as there's a particle heading towards it.
    ret=1
    if X==0
        return ret*3
    else
        return 1	#1 Is used as the neutral element for multiplication and division.
    end
end
function hastop(x)	#This function does the same for the bottom cell, with 2 as the incoming cell ( reversed ),
			# and 17 as a border value.
    X=x%2
    ret=1
    if x==0
        return 17
    end
    
    if X==0
        return ret*2
    else
        return 1
    end
end
function hasright(x)	#Right cell, 7 for incoming particle, 13 for border.
    X=x%7
    ret=1
    if x==0
        return 13
    end
    if X==0
        return ret*7
    else
        return 1
    end
end
function hasbot(x)	#Top cell, 5 for incoming particle, 11 for border.
    X=x%5
    ret=1
    if x==0
        return 11
    end
    if X==0
        return ret*5
    else
        return 1
    end
end

#=================================================================#

function mapzeroes(A1,A2)	#This function maps the zeroes of an array into another array.
				#Necessary for the functioning of intert objects. Otherwise the particles
				#Will just ignore the object.
    
    for i in enumerate(A1)
     
        if A1[i[1]]==0
            A2[i[1]]=0
            
        end
    end
    return A2
end
