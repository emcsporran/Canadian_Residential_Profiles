# Module imports
import os
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.cluster import KMeans

# Creation Info
from src.lib.house_data import house_data
from src.lib.time_line import time_line

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


def get_kmeans(house_arr):
    data = list(zip(house_arr.annual_total))
    inertias = []
    for i in range(len(house_arr) - 1):
        kmeans = KMeans(n_clusters=i)
        kmeans.fit(data)
        inertias.append(kmeans.inertia_)
    plt.plot(range(len(house_arr) - 1), inertias, marker='o')
    plt.title('Elbow method')
    plt.xlabel('Number of clusters')
    plt.ylabel('Inertia')
    plt.show()


def sort_houses(filename):
    file_temp = pd.read_csv(filename)
    house_arr = []
    for i in range(len(file_temp)):
        path_temp = os.path.join(path_in, (file_temp.loc[i].house + ".csv"))
        house_arr.append(house_data(path_temp, file_temp.loc[i]))
    return house_arr


# Main Script
houses = sort_houses(os.path.join(path_in, "housestat.csv"))
criteria = list()
criteria.append("H")
criteria.append("DHW")
house_num = get_num(filenames, criteria)

print("There are {house} data files in the path: \n{path}".format(house=house_num, path=path_in))
quick_file_check = get_num(filenames, "quick_access")
# This will be used later to help skip processing to display previous results.
run_old_bool = 0
if quick_file_check > 0:
    print("\nYou have an existing data file with the compiled values of household consumption.\n"
          "Running the data compilation from scratch will take some time.\n"
          "Would you like to continue with the existing file (Y/N)?\n")
    if input() == "Y":
        run_old_bool = 1
        print("The process will continue with the existing data file.")
    else:
        run_old_bool = 0
        print("The process will start from scratch.")
else:
    run_old_bool = 0
    print("\nNo previous data file detected.")
    print("The process will start from scratch.")

# Leaving these for the development.
print(houses[1].__str__())
print(houses[1].appliance_info())
houses[1].data_init()

# Setting up the date object.
date_obj = time_line(path_in)
#date_files = ["season.csv"]
criteria = list()
criteria.append("holiday.csv")
print(get_num(filenames, criteria))
if get_num(filenames, criteria) == 1:
    date_obj.setup_holiday("holiday.csv")

