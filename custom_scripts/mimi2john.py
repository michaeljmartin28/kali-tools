

output = []

with open("hash.txt", "r") as file:
    lines = file.readlines()
    i = 0
    while i < len(lines):
        if 'User' in lines[i]:
            if 'Hash' in lines[i+1]:
                output.append(lines[i].split(" ")[2].strip() + ":" + lines[i+1].split(" ")[4].strip() + "\n")
                i += 1
        i += 1

with open("hashes-john.txt", "w") as out:
    for i in output:
        out.write(i)
            

