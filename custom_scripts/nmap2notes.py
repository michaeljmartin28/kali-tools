import sys

output = []

with open(sys.argv[1], "r") as file:
    lines = file.readlines()
    i = 0
    while i < len(lines):
        index = lines[i].find("Ports: ")
        if index > 0:
            print(lines[i][0:index])
            print(lines[i][index:index+6])
            for service in lines[i][index+6:].split(","):
                print(" - " + service.replace("/"," "))
        i += 1

