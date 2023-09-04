# Script Name: generate-csv-for-creating-aad-users.py
# Usage: python generate-csv-for-creating-aad-users.py
# Description: This script generates a CSV file that can be used to create users in Azure Active Directory.
#              The script asks for the number of teams, number of users per team, domain name, and password length.
#              It then generates a CSV file with the required information to create users in Azure Active Directory.
#              The password is generated randomly and is of the length specified by the user.
#              The script can be modified to use the same password for all users.
import sys
import random
import string

no_of_teams = int(input("Enter number of teams (int): ") or "4")
no_of_users_per_team = int(input("Enter number of users per team (int): ") or "5")
domain = input("Enter domain name (string): ") or "MngEnvMCAP040685.onmicrosoft.com"
password_length = int(input("Enter the desired password length (int): ") or "12")

# Generate Template for AAD User Creation
writer = open("create-aad-participants.csv", "w")

writer.writelines("version:v1.0\n")
writer.writelines(
    "Name [displayName] Required,User name [userPrincipalName] Required,Initial password [passwordProfile] Required,Block sign in (Yes/No) [accountEnabled] Required,First name [givenName],Last name [surname],Job title [jobTitle],Department [department],Usage location [usageLocation],Street address [streetAddress],State or province [state],Country or region [country],Office [physicalDeliveryOfficeName],City [city],ZIP or postal code [postalCode],Office phone [telephoneNumber],Mobile phone [mobile]\n"
)

def generate_password():
    chars = string.ascii_letters + string.digits
    return (
        "".join(random.choice(chars) for x in range(password_length - 4))
        + random.choice(["#", "$", "%", "&", "@", "!", "*"])
        + random.choice(string.ascii_lowercase)
        + random.choice(string.digits)
        + random.choice(string.ascii_uppercase)
    )

for i in range(1, no_of_teams+1):
    for j in range(1, no_of_users_per_team+1):
        if (i < 10):
            i_str = "0" + str(i)
        else:
            i_str = str(i)
        if (j < 10):
            j_str = "0" + str(j)
        else:
            j_str = str(j)
        password = generate_password()
        # If you want to use the same password for everyone, uncomment the line below, comment the line above, and mention your desired password.
        # password = ""
        writer.writelines(f"Team{i_str} - User{j_str},team{i_str}.user{j_str}@{domain},{password},No,User{j_str}, Team{i_str},,,,,,,,,,,\n")
