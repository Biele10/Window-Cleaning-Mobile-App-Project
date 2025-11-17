unsortedList = [1, 3, 7, 2, 4, 3, 4, 4, 9, 9, 90, 1]

l, r = 0, 1

finished = False
switchMade = True

while finished is False:

    if unsortedList[l] > unsortedList[r]:
        switchMade = True
        temp = unsortedList[r]
        unsortedList[r] = unsortedList[l]
        unsortedList[l] = temp

    if r >= len(unsortedList) - 1:

        if switchMade is False:

            finished = True

            break
        else:
            l, r = 0, 1
            switchMade = False

    l+=1
    r+=1

print(unsortedList)

