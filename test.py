foo = "433221"

res = "".join(dict.fromkeys(foo))

print(res == "4321")