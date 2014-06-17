# This function was designed to assign color gradient to a hierachical variable
    # Base colors are assigned to the level_1 variable of the dataframe
    # A gradient is generated from the base color to white for each assigned base color for all level_2 variables

# Version: 1.0 Last modified: 2014.06.17
    # Color gradient can be sequential, when the values are not considered
        # and scaled, when the intensity of the color is proportional to the value 
    # Only 5 base colors are provided. If needed more can be added.
    # Totally no error handling. 

# Input:
    # df - dataframe
    # level_1 - name of the enclosing variable
    # level_2 - name of the lower order variable
    # values - name of the value variable that assign to each level_2 variable (optionally it can be level_2 directly)
    # scale - the color gradient can be weighted based on the value variable. (Not yet implemented)

# Output:
    # Vector with hexa colors.
    # Length of the vector is equal to the number of rows of the input dataframe
    # The output vector can be added to the dataframe as a new column that can be used as a coloring scheme

coloring <- function(df, level_1 = names(df)[1], level_2 = names(df)[2], values = names(df)[3], scale=F){
    
    # These are the colors for the main categories
    base_colors  <- c("#C6A856", "#BE9CEA", "#5CBE7D", "#EE8FAB", "#00BCD2")  
    
    # Color vector as long as the input dataframe:
    color_vect   <- c()   
    
    # Index for refering to position of line in the original dataframe:
    i <- c(1)
    
    # Breaking down the dataframe to the first level:
    for ( Upper_level in levels(df[,level_1])){
        
        # Resticted dataframe:
        df_level_1  <- df[df[,level_1] == Upper_level, ]        
       
        ### Creating a color gradients:
        # If scaling is turned off:
        if (scale == F){

            # the steepness of the gradient varies: number of steps are equal to the number of second levels 
            palette_gradient <- colorRampPalette(c( base_colors[i],"#FFFFFF"))(nrow(df_level_1))
            
            # Assignment assumes the values of the second level is ordered
            color_vect       <- append(color_vect, palette_gradient) 
        }
        
        # If scaling is turned on: (This is a normalized scaling.)
        if (scale == T){
            
            # Extracting values from dataframe
            df_values <- df_level_1[,values]
            
            # getting the min and the max of the values:
            extremes <- c(min(df_values), max(df_values))

            # Generating the color gradient. Always 200 steps:
            palette_gradient <- colorRampPalette(c( base_colors[i],"#FFFFFF"))(201)
            
            # Assignment is based on where is a particule value between the two extremes  
            for (value in df_values){
                rank  <- floor(200 * (extremes[2] - value)/(extremes[2] - extremes[1])) + 1
                color_vect <- append(color_vect, palette_gradient[rank])
            }   
        }
        i <- i + 1
    }
    return(color_vect)
}