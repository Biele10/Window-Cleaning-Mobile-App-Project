def ValidationCheck(details) -> bool:    # returns true or false depending on if name is fine

    for info in details:
        print(info)
        if len(info) > 255:         # values cannot exceed length of 255 characters
            return False
    return True



values = ("nice","fsdfsdfsdfsdf", "casdjkduasidasuijbduasihdxbasd")

out = ValidationCheck(values)

print(out)