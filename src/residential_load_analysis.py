# Module imports
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Creation Info
author_init = "ECM"

# Path generation
path = os.getcwd()
path_lib = os.path.join(path, 'lib')
path_in = os.path.join(path, 'input_data')
filenames = os.listdir(path_in)


# Functions
def get_num(filenames, criteria):
    num = 0
    for i in range(len(filenames) - 1):
        if len(criteria) > 1:
            if filenames[i].__contains__(criteria[0]) and not filenames[i].__contains__(criteria[1]):
                num = num + 1
        else:
            if filenames[i].__contains__(criteria[0]):
                num = num + 1

    return num


# Main Script
criteria = list()
criteria.append("H")
criteria.append("DHW")
house_num = get_num(filenames, criteria)
print("There are {house} data files in the path: \n{path}".format(house=house_num,path=path_in))

#file_temp = pd.read_csv(os.path.join(path_in, filenames[i]))