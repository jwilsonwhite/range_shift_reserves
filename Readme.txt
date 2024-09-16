Readme

This code implements a model of two benthic fish populations on an idealized linear coastline. One species experiences a range shift due to a sliding climate envelope. Both species are protected in marine reserves, which are placed in different configurations. A full description is found in Cheripka et al. "Managing range-shifting species in marine reserve networks: the importance of reserve configuration and transient population dynamics", Theoretical Ecology, submitted (9/15/2024)

There are two versions of the model; one unstructured and one with age structure. Both are implemented with a similar nested file structure to loop over model scenarios.

### Files shared between all models

make_landscape.m
# Create landscape with regularly spaced marine reserves

Dispersal_matrix.m
# Construct a larval dispersal matrix with specified mean and standard deviation of the dispersal kernel

### Files for unstructured model

parameters_unstructured.m
# Creates a data file of model parameters

unstruct_wrapper.m
# Calls all other functions to implement simulations of specified scenarios. Creates most of the figures used in the paper.

unstruct2sp.m
# Called by unstruct_wrapper.m. Implements the two-species unstructured model for a specified climate velocity, harvest rates, competition coefficients, and marine reserve configuration. There is an option to make plots of spatial distributions of abundance and other variables.

iterate_unstruct.m
# Iterates the model over a specified set of time steps


### Files for structured model

parameters_structured.m
# Creates a data file of model parameters

struct_wrapper.m
# Calls all other functions to implement simulations of specified scenarios. Creates most of the figures used in the paper.

struct2sp.m
# Called by struct_wrapper.m. Implements the two-species age-structured model for a specified climate velocity, harvest rates, competition coefficients, and marine reserve configuration. There is an option to make plots of spatial distributions of abundance and other variables.

iterate_struct.m
# Iterates the model over a specified set of time steps



