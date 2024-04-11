from datetime import date
import pandas as pd


class house_data:
    def __init__(self, filepath, data_in):
        self.filepath = filepath
        self.name = data_in.house
        self.occupants = data_in.occupants
        self.age = data_in.age
        self.size_meter = data_in.sizem2
        self.size_feet = self.size_meter*10.7639
        self.buildtype = data_in.type
        self.annual_total = data_in.totalGJ
        self.annual_nonhvac = data_in.nonhvacGJ
        # Define the Appliances.
        self.stove = data_in.stove
        self.fridge = data_in.fridge
        self.washer = data_in.washer
        self.dryer = data_in.dryer
        self.dishwasher = data_in.dishwasher
        self.microwave = data_in.microwave
        self.freezer = data_in.freezer
        # Variables to be calculated later.
        self.seasonal_total = [[1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0]]
        self.seasonal_nonhvac = [[1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0]]
        self.kmeans_class = "NoClass"

    def __str__(self):
        return f"\n{self.name} Details \nOccupants: {self.occupants} \nHouse Age: {self.age} \nFloorspace (m^2): " \
               f"{self.size_meter} \nBuilding Type: {self.buildtype} \nUse function appliance_info to get details on " \
               f"what household appliances are present."

    def appliance_info(self):
        return f"\n{self.name} Appliance Details \n" \
                f"| Stove\t\t| Fridge\t| Washer\t| Dryer\t\t| Dishwasher\t| Microwave\t| Freezer\t|\n" \
                f"| {self.stove}\t\t\t| {self.fridge}\t\t\t| {self.washer}\t\t\t| {self.dryer}\t\t\t"\
                f"| {self.dishwasher}\t\t\t\t| {self.microwave}\t\t\t| {self.freezer}\t\t\t|\n"

    def getannual(self):
        data = pd.read_csv(self.filepath)
        tot = 0
        if (len(data)/(60*24)) == 365:
            tot = sum(data)
        print(tot)
        return

    def readdata(self):
        data = pd.read_csv(self.filepath)
        print(len(data)/(60*24))
        print(data.head())
        return

